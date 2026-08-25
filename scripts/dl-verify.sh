# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== A1 LAN page via Caddy ==='
curl -s -o /dev/null -w 'LAN page -> %{http_code}\n' -H 'Host: your-nas.local' http://127.0.0.1/
echo '=== A2 injection tests (expect 400) ==='
curl -s -w '\nINJ path-traversal -> %{http_code}\n' -H 'Host: your-nas.local' 'http://127.0.0.1/api/download?album_id=..%2F..%2Fetc%2Fpasswd'
curl -s -w '\nINJ non-numeric -> %{http_code}\n' -H 'Host: your-nas.local' 'http://127.0.0.1/api/download?album_id=abc%3Brm%20-rf'
echo '=== A3 public scope without token (expect 401) ==='
curl -s -w '\nPUB no-token -> %{http_code}\n' -H 'Host: your-device.tailnet.ts.net' 'http://127.0.0.1/api/download?album_id=422866'
echo '=== A4 public scope wrong token (expect 401) ==='
curl -s -o /dev/null -w 'PUB wrong-token -> %{http_code}\n' -H 'Host: your-device.tailnet.ts.net' -H 'X-DL-Token: wrongtoken' 'http://127.0.0.1/api/download?album_id=422866'
echo '=== A5 funnel public page (expect 200) ==='
curl -sk -o /dev/null -w 'FUNNEL page -> %{http_code}\n' --max-time 20 https://your-device.tailnet.ts.net/
echo '=== A6 LAN real download (no token, 422866 -> zip) ==='
curl -s -H 'Host: your-nas.local' -o /tmp/test-lan.zip -w 'LAN download -> %{http_code}, %{size_download} bytes, %{time_total}s\n' --max-time 260 'http://127.0.0.1/api/download?album_id=422866'
ls -la /tmp/test-lan.zip 2>/dev/null; head -c 4 /tmp/test-lan.zip 2>/dev/null | od -c | head -1