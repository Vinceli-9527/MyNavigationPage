# backend/downloader/main.py
"""
holy-dl — JM 漫画「零落盘」流式下载服务 (FastAPI)

设计目标:
- 漫画字节流经内存直接打包 ZIP 推给浏览器, 不在 NAS 硬盘上写任何文件
- 高并发: 异步 I/O + 全局并发信号量 + 单 IP 限速
- 防注入: album_id 白名单校验(仅纯数字); 图片 URL 拒绝内网/回环地址(防 SSRF)\n- 访问域: LAN(http) 不限制; 公网(https) 需令牌 + 限速 (由 Caddy 注入 X-Access-Scope)
- 鉴权: 请求头 X-DL-Token 必须与 DOWNLOAD_TOKEN 一致
"""
import asyncio
import datetime
import ipaddress
import os
import re
import secrets
import time
import urllib.parse
import zlib
from collections import deque, defaultdict
from urllib.parse import urlparse

import jmcomic
from fastapi import FastAPI, Header, HTTPException, Request
from fastapi.responses import StreamingResponse

# ---------- 配置 (环境变量) ----------
TOKEN = os.environ.get("DOWNLOAD_TOKEN", "")
ALBUM_ID_RE = re.compile(r"^\d{1,12}$")
MAX_PAGES = int(os.environ.get("DL_MAX_PAGES", "500"))
MAX_BYTES = int(os.environ.get("DL_MAX_BYTES", str(2 * 1024 ** 3)))
MAX_CONCURRENCY = int(os.environ.get("DL_CONCURRENCY", "2"))
RATE_LIMIT_REQUESTS = int(os.environ.get("DL_RATE_REQUESTS", "6"))
RATE_LIMIT_WINDOW = int(os.environ.get("DL_RATE_WINDOW", "60"))
PREFLIGHT_TIMEOUT = int(os.environ.get("DL_PREFLIGHT_TIMEOUT", "240"))

app = FastAPI(title="holy-dl", version="1.0.0")

_album_sem = asyncio.Semaphore(MAX_CONCURRENCY)
_rate: dict[str, deque] = defaultdict(deque)
_rate_lock = asyncio.Lock()

try:
    jmcomic.disable_jm_log()
except Exception:
    pass


def _new_client() -> jmcomic.JmApiClient:
    return jmcomic.create_option_by_file("/app/option.yml").new_jm_client()


def _check_token(token: str) -> None:
    if not TOKEN or not secrets.compare_digest(TOKEN.encode(), (token or "").encode()):
        raise HTTPException(status_code=401, detail="无效的下载令牌")


async def _rate_limit(ip: str) -> None:
    now = time.monotonic()
    async with _rate_lock:
        q = _rate[ip]
        while q and now - q[0] > RATE_LIMIT_WINDOW:
            q.popleft()
        if len(q) >= RATE_LIMIT_REQUESTS:
            raise HTTPException(status_code=429, detail="请求过于频繁，请稍后再试")
        q.append(now)


def _assert_public_http_url(url: str) -> None:
    """防 SSRF: 只允许 https 且指向公网地址"""
    u = urlparse(url)
    if u.scheme != "https":
        raise HTTPException(status_code=400, detail="非法图片地址")
    host = u.hostname
    if not host:
        raise HTTPException(status_code=400, detail="非法图片地址")
    try:
        ip = ipaddress.ip_address(host)
        if ip.is_private or ip.is_loopback or ip.is_link_local or ip.is_reserved or ip.is_multicast or ip.is_unspecified:
            raise HTTPException(status_code=400, detail="非法图片地址(内网)")
    except ValueError:
        low = host.lower()
        if low in ("localhost", "localhost.localdomain") or low.endswith(".local") or low.endswith(".localhost"):
            raise HTTPException(status_code=400, detail="非法图片地址(内网)")


def _safe_entry_name(name: str) -> str:
    name = re.sub(r"[\x00-\x1f<>:\"/\\|?*]", "_", name).strip()
    return name[:120] or "img"


def _zip_datetime() -> tuple[int, int]:
    now = datetime.datetime.now()
    dos_date = ((now.year - 1980) << 9) | (now.month << 5) | now.day
    dos_time = (now.hour << 11) | (now.minute << 5) | (now.second // 2)
    return dos_time, dos_date


def _preflight(album_id: str):
    """预检(同步, 在 to_thread 中运行): 拉取元数据 + 章节页清单, 做全部校验"""
    client = _new_client()
    album = client.get_album_detail(album_id)
    episodes = list(getattr(album, "episode_list", None) or [])
    if not episodes:
        raise HTTPException(status_code=404, detail="专辑没有可下载的章节")

    specs = []  # (folder, filename, url, photo_id, scramble_id, index, query_params)
    total_pages = 0
    for ep in episodes:
        photo_id = str(ep[0])
        pd = client.get_photo_detail(photo_id)
        page_arr = list(getattr(pd, "page_arr", None) or [])
        total_pages += len(page_arr)
        if total_pages > MAX_PAGES:
            raise HTTPException(status_code=413, detail=f"专辑页数超过上限({MAX_PAGES}页)")
        folder = ""
        if len(episodes) > 1:
            folder = _safe_entry_name(f"{ep[1]} {getattr(album, 'name', photo_id)}") + "/"
        qp = pd.get_data_original_query_params(getattr(pd, "data_original_0", None))
        for idx, fname in enumerate(page_arr):
            url = pd.get_img_data_original(fname)
            if qp:
                url += "?" + qp
            _assert_public_http_url(url)
            specs.append((folder, str(fname), url, str(pd.photo_id),
                          str(getattr(pd, "scramble_id", "0")), idx, qp))
    return album, specs


def _stream_worker(specs, q: asyncio.Queue, loop) -> None:
    """同步线程中逐图拉取并放入 asyncio.Queue (队列背压=内存有界)"""
    def put(kind, name=None, data=None):
        loop.call_soon_threadsafe(q.put_nowait, (kind, name, data))
    try:
        client = _new_client()
        for folder, fname, url, photo_id, scramble_id, idx, qp in specs:
            resp = client.get_jm_image(url)  # 参数为图片直链, 返回 JmImageResp(.content)
            if not resp.is_success:
                raise RuntimeError(f"图片 {fname} 获取失败: {resp.error_msg()}")
            data = resp.content
            put("data", folder + _safe_entry_name(fname), bytes(data))
        put("done")
    except Exception as e:  # 中止整个流
        put("error", None, f"{type(e).__name__}: {str(e)[:200]}")


async def _stream_zip(entries):
    """手动流式 ZIP (data-descriptor 方式), 全程不落盘"""
    central = []
    offset = 0
    dos_time, dos_date = _zip_datetime()
    total = 0
    async for entry_name, data in entries:
        name_b = entry_name.encode("utf-8")
        crc = zlib.crc32(data)
        size = len(data)
        local = (
            b"PK\x03\x04"
            + (20).to_bytes(2, "little")            # version needed
            + (0x0808).to_bytes(2, "little")        # flags: UTF-8 + data descriptor
            + (0).to_bytes(2, "little")             # method: stored
            + dos_time.to_bytes(2, "little")
            + dos_date.to_bytes(2, "little")
            + (0).to_bytes(4, "little")             # crc (见 descriptor)
            + (0).to_bytes(4, "little")             # compressed size
            + (0).to_bytes(4, "little")             # uncompressed size
            + len(name_b).to_bytes(2, "little")
            + (0).to_bytes(2, "little")             # extra
            + name_b
        )
        descriptor = (
            b"PK\x07\x08"
            + crc.to_bytes(4, "little")
            + size.to_bytes(4, "little")
            + size.to_bytes(4, "little")
        )
        central.append(
            b"PK\x01\x02"
            + (20).to_bytes(2, "little")            # version made by
            + (20).to_bytes(2, "little")            # version needed
            + (0x0808).to_bytes(2, "little")
            + (0).to_bytes(2, "little")
            + dos_time.to_bytes(2, "little")
            + dos_date.to_bytes(2, "little")
            + crc.to_bytes(4, "little")
            + size.to_bytes(4, "little")
            + size.to_bytes(4, "little")
            + len(name_b).to_bytes(2, "little")
            + (0).to_bytes(2, "little")             # extra
            + (0).to_bytes(2, "little")             # comment
            + (0).to_bytes(2, "little")             # disk
            + (0).to_bytes(2, "little")             # internal attrs
            + (0o100644 << 16).to_bytes(4, "little")  # external attrs
            + offset.to_bytes(4, "little")          # local header offset
            + name_b
        )
        yield local
        yield data
        yield descriptor
        offset += len(local) + size + len(descriptor)
        total += size
        if total > MAX_BYTES:
            raise RuntimeError(f"下载体积超过上限({MAX_BYTES // (1024**2)}MB), 已中止")
    cd = b"".join(central)
    eocd = (
        b"PK\x05\x06"
        + (0).to_bytes(2, "little")
        + (0).to_bytes(2, "little")
        + len(central).to_bytes(2, "little")
        + len(central).to_bytes(2, "little")
        + len(cd).to_bytes(4, "little")
        + offset.to_bytes(4, "little")
        + (0).to_bytes(2, "little")
    )
    yield cd
    yield eocd


@app.get("/api/download")
async def download(album_id: str = "", request: Request = None,
                   x_dl_token: str = Header(default=""),
                   x_access_scope: str = Header(default="")):
    # 访问域判断: Caddy 按来源域名注入 X-Access-Scope
    # lan(http局域网) -> 不限制; public(https公网) -> 令牌 + 限速
    lan = x_access_scope.strip().lower() == "lan"
    if not lan:
        _check_token(x_dl_token)
    if not ALBUM_ID_RE.match(album_id or ""):
        raise HTTPException(status_code=400, detail="album_id 仅允许 1-12 位纯数字")
    ip = request.client.host if request and request.client else "unknown"
    if not lan:
        await _rate_limit(ip)

    try:
        album, specs = await asyncio.wait_for(
            asyncio.to_thread(_preflight, album_id), PREFLIGHT_TIMEOUT)
    except HTTPException:
        raise
    except asyncio.TimeoutError:
        raise HTTPException(status_code=504, detail="获取专辑信息超时，请稍后重试")
    except jmcomic.JmcomicException as e:
        raise HTTPException(status_code=404, detail=f"专辑不可用: {str(e)[:150]}")
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"预检失败: {str(e)[:150]}")

    title = getattr(album, "name", None) or album_id
    fname = urllib.parse.quote(f"JM-{album_id} {title}.zip")

    async def entries():
        async with _album_sem:  # 全局并发上限(流式期间持有)
            q: asyncio.Queue = asyncio.Queue(maxsize=2)
            loop = asyncio.get_running_loop()
            worker = asyncio.create_task(asyncio.to_thread(_stream_worker, specs, q, loop))
            try:
                while True:
                    kind, name, data = await q.get()
                    if kind == "data":
                        yield name, data
                    elif kind == "error":
                        raise RuntimeError(data)
                    else:
                        break
            finally:
                if not worker.done():
                    worker.cancel()
                try:
                    await worker
                except asyncio.CancelledError:
                    pass

    return StreamingResponse(
        _stream_zip(entries()),
        media_type="application/zip",
        headers={
            "Content-Disposition": f"attachment; filename=\"JM-{album_id}.zip\"; filename*=UTF-8''{fname}",
            "Cache-Control": "no-store",
        },
    )


@app.get("/api/download/health")
async def health():
    return {"ok": True, "version": "1.0.0"}