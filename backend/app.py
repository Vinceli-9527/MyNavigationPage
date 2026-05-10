from flask import Flask, send_from_directory, request, jsonify
from flask_cors import CORS
import sys
import io
import os
import jmcomic
import requests as http_requests
from check_balance import parse_cookies

app = Flask(__name__)
CORS(app)

# 创建option对象
option = jmcomic.create_option_by_file(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'option.yml'))

@app.route('/')
def index():
    return send_from_directory('../frontend', 'index.html')

@app.route('/common/<path:path>')
def serve_common(path):
    return send_from_directory('../common', path)

@app.route('/run', methods=['POST'])
def run_script():
    album_id = request.form.get('album_id')
    if not album_id:
        return jsonify({'error': '请输入相册ID'}), 400
    
    # 执行实际的下载逻辑
    try:
        # 捕获标准输出和标准错误
        old_stdout = sys.stdout
        old_stderr = sys.stderr
        sys.stdout = io.StringIO()
        sys.stderr = io.StringIO()
        
        # 执行下载
        jmcomic.download_album(album_id, option)
        
        # 获取输出
        stdout = sys.stdout.getvalue()
        stderr = sys.stderr.getvalue()
        
        # 恢复标准输出和标准错误
        sys.stdout = old_stdout
        sys.stderr = old_stderr
        
        # 确定文件保存路径
        save_path = os.path.join(os.getcwd(), album_id)
        
        return jsonify({'message': '下载成功', 'output': stdout, 'path': save_path})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ========== Balance API ==========
# Credentials are stored in the browser (localStorage) and sent with each request.
# The server never persists them to disk — use, query, discard.

PROVIDER_IDS = ["deepseek", "claude", "gpt", "mimo", "gemini"]


# ---- per-provider balance checkers ----
# Each receives a dict: {"key": "..."}  or  {"cookies": "...", "org_id": "..."}

def _check_deepseek(creds: dict) -> dict | None:
    """DeepSeek: official balance API."""
    key = creds.get("key", "")
    headers = {"Accept": "application/json", "Authorization": f"Bearer {key}"}
    try:
        resp = http_requests.get(
            "https://api.deepseek.com/user/balance",
            headers=headers, timeout=15,
        )
        resp.raise_for_status()
        data = resp.json()
        infos = data.get("balance_infos", [])
        total = sum(float(b.get("total_balance", 0)) for b in infos)
        currency = infos[0].get("currency", "CNY") if infos else "CNY"
        return {
            "provider": "deepseek",
            "balance": total,
            "currency": "CNY" if currency == "CNY" else currency,
            "available": data.get("is_available", False),
        }
    except Exception:
        return None


def _check_gpt(creds: dict) -> dict | None:
    """OpenAI GPT — credit grants + subscription + recent costs."""
    key = creds.get("key", "")
    headers = {"Authorization": f"Bearer {key}"}
    result = {"provider": "gpt", "balance": None, "currency": "USD",
              "available": True, "note": None}
    notes = []

    # 1. credit grants
    try:
        resp = http_requests.get(
            "https://api.openai.com/v1/dashboard/billing/credit_grants",
            headers=headers, timeout=15,
        )
        if resp.status_code == 401:
            return None
        if resp.status_code == 200:
            data = resp.json()
            grants = data.get("grants", []) if isinstance(data, dict) else []
            total_granted = sum(float(g.get("grant_amount", 0)) for g in grants)
            total_used = sum(float(g.get("used_amount", 0)) for g in grants)
            if total_granted > 0:
                result["balance"] = round(total_granted - total_used, 2)
                notes.append(f"赠金: ${total_granted:.2f}, 已用: ${total_used:.2f}")
    except Exception:
        pass

    # 2. subscription
    try:
        resp = http_requests.get(
            "https://api.openai.com/v1/dashboard/billing/subscription",
            headers=headers, timeout=10,
        )
        if resp.status_code == 200:
            sd = resp.json()
            hard = sd.get("hard_limit_usd", 0)
            soft = sd.get("soft_limit_usd", 0)
            limit = hard or soft
            if limit and result["balance"] is None:
                result["balance"] = limit  # approximate
            notes.append(f"硬限额: ${hard}, 软限额: ${soft}")
    except Exception:
        pass

    # 3. recent costs (7 days)
    try:
        from datetime import datetime, timezone, timedelta
        end = datetime.now(timezone.utc)
        start = end - timedelta(days=7)
        resp = http_requests.get(
            "https://api.openai.com/v1/organization/costs",
            headers=headers,
            params={"start_time": int(start.timestamp()),
                    "end_time": int(end.timestamp())},
            timeout=15,
        )
        if resp.status_code == 200:
            cd = resp.json()
            total = 0.0
            for item in cd.get("data", []):
                for r in item.get("results", []):
                    total += float(r.get("amount", {}).get("value", 0) or 0)
            notes.append(f"近7天: ${total:.4f}")
    except Exception:
        pass

    if not notes:
        result["note"] = "需前往控制台查看余额"
    else:
        result["note"] = " | ".join(notes)
    return result


def _check_gemini(creds: dict) -> dict | None:
    """Gemini / Google AI — verify key + list available models."""
    key = creds.get("key", "")
    try:
        resp = http_requests.get(
            "https://generativelanguage.googleapis.com/v1beta/models",
            params={"key": key}, timeout=15,
        )
        if resp.status_code == 200:
            models = resp.json().get("models", [])
            gen_models = [m["name"].replace("models/", "")
                          for m in models
                          if "generateContent" in m.get("supportedGenerationMethods", [])]
            return {
                "provider": "gemini",
                "balance": None,
                "currency": "USD",
                "available": True,
                "note": f"有效 · {len(gen_models)} 个模型可用 · 按量计费",
            }
        elif resp.status_code == 400:
            return None
    except Exception:
        pass
    return None


def _check_claude(creds: dict) -> dict | None:
    """Claude / Anthropic — API admin key or web session cookies."""
    key = creds.get("key", "")
    cookies_raw = creds.get("cookies", "")
    org_id = creds.get("org_id", "")

    # --- admin API key mode ---
    if key:
        headers = {"x-api-key": key, "anthropic-version": "2023-06-01"}
        try:
            from datetime import datetime, timezone, timedelta
            end = datetime.now(timezone.utc)
            start = end - timedelta(days=7)
            resp = http_requests.get(
                "https://api.anthropic.com/v1/organizations/cost_report",
                headers=headers,
                params={"starting_at": start.strftime("%Y-%m-%dT%H:%M:%SZ"),
                        "ending_at": end.strftime("%Y-%m-%dT%H:%M:%SZ")},
                timeout=15,
            )
            if resp.status_code == 200:
                data = resp.json()
                total_cents = 0.0
                by_model: dict[str, float] = {}
                for bucket in data.get("data", []):
                    for r in bucket.get("results", []):
                        amt = float(r.get("amount", 0))
                        total_cents += amt
                        model = r.get("model", "unknown")
                        by_model[model] = by_model.get(model, 0) + amt
                detail = ", ".join(f"{m}: ${v:.2f}" for m, v in
                                   sorted(by_model.items(), key=lambda x: -x[1])[:3])
                return {
                    "provider": "claude",
                    "balance": None,
                    "currency": "USD",
                    "available": True,
                    "note": f"近7天: ${total_cents:.4f}" + (f" ({detail})" if detail else ""),
                }
            elif resp.status_code == 401:
                return None
        except Exception:
            pass
        return None

    # --- web session cookie mode ---
    if cookies_raw and org_id:
        try:
            cookies = parse_cookies(cookies_raw)
            session = http_requests.Session()
            for k, v in cookies.items():
                session.cookies.set(k, v, domain="platform.claude.com")
            resp = session.get(
                f"https://platform.claude.com/api/organizations/{org_id}/prepaid/credits",
                timeout=15,
            )
            if resp.status_code == 200:
                data = resp.json()
                amount_cents = data.get("amount", 0)
                currency = data.get("currency", "USD")
                auto = "自动充值:开" if data.get("auto_reload_settings") else "自动充值:关"
                return {
                    "provider": "claude",
                    "balance": amount_cents / 100.0,
                    "currency": currency,
                    "available": True,
                    "note": f"预付费余额 · {auto}",
                }
            elif resp.status_code in (401, 404):
                return None
        except Exception:
            pass
        return None

    return None


def _check_mimo(creds: dict) -> dict | None:
    """MiMo / 小米 — cookie-based session queries."""
    cookies_raw = creds.get("cookies", "")
    if not cookies_raw:
        return None
    try:
        cookies = parse_cookies(cookies_raw)
    except Exception:
        return None

    session = http_requests.Session()
    for k, v in cookies.items():
        session.cookies.set(k, v, domain="platform.xiaomimimo.com")

    notes = []
    balance = None
    available = False

    for endpoint in ["/api/v1/user/info", "/api/v1/billing", "/api/v1/usage"]:
        url = f"https://platform.xiaomimimo.com{endpoint}"
        try:
            resp = session.get(url, headers={"Accept": "application/json"},
                               timeout=15, allow_redirects=False)
            if resp.status_code == 401:
                notes.append(f"{endpoint}: Cookie 过期")
                continue
            resp.raise_for_status()
            data = resp.json()
            available = True
            # try to extract balance-like fields
            payload = data.get("data", data)
            if isinstance(payload, dict):
                for bk in ("balance", "total_balance", "credit", "quota", "remaining"):
                    if bk in payload:
                        balance = float(payload[bk])
                        break
                # collect human-readable fields
                for k, v in payload.items():
                    if isinstance(v, (str, int, float, bool)):
                        notes.append(f"{k}: {v}")
        except Exception:
            pass

    if not available:
        return None
    return {
        "provider": "mimo",
        "balance": balance,
        "currency": "CNY",
        "available": True,
        "note": " | ".join(notes[:6]) if notes else "Cookie 有效",
    }


_CHECKERS = {
    "deepseek": _check_deepseek,
    "claude": _check_claude,
    "gpt": _check_gpt,
    "mimo": _check_mimo,
    "gemini": _check_gemini,
}


# ---- route ----

@app.route("/api/balance/query", methods=["POST"])
def query_balance():
    """Query balance for a provider.  Credentials arrive in the request body
    and are NEVER written to disk — used only for this single request."""
    data = request.get_json()
    provider = data.get("provider")
    if not provider or provider not in PROVIDER_IDS:
        return jsonify({"error": f"Unknown provider: {provider}"}), 400

    creds = {}
    if data.get("key"):
        creds["key"] = data["key"].strip()
    if data.get("cookies"):
        creds["cookies"] = data["cookies"]
    if data.get("org_id"):
        creds["org_id"] = data["org_id"].strip()

    if not creds:
        return jsonify({"error": "Missing credentials (key or cookies)"}), 400

    checker = _CHECKERS.get(provider)
    if checker is None:
        return jsonify({"error": "Checker not implemented"}), 500

    result = checker(creds)
    if result is None:
        return jsonify({"error": "Failed to fetch balance or key invalid"}), 500

    return jsonify(result)


if __name__ == '__main__':
    app.run(debug=True, port=8000)