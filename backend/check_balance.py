import os
import sys
import requests

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def load_config(filename: str, env_var: str) -> str:
    val = os.environ.get(env_var, "")
    if val:
        return val
    path = os.path.join(SCRIPT_DIR, filename)
    if os.path.exists(path):
        with open(path) as f:
            return f.read().strip()
    return ""


def parse_cookies(raw: str) -> dict[str, str]:
    """Netscape format or 'name=value; ...' string."""
    cookies = {}
    for line in raw.strip().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "\t" in line:
            parts = line.split("\t")
            if len(parts) >= 7:
                cookies[parts[5]] = parts[6]
        else:
            for part in line.split(";"):
                part = part.strip()
                if "=" in part:
                    k, v = part.split("=", 1)
                    cookies[k.strip()] = v.strip()
    return cookies


def prompt_input(prompt_text: str) -> str:
    print(prompt_text)
    lines = []
    while True:
        line = sys.stdin.readline()
        if not line or line.strip() == "":
            break
        lines.append(line)
    return "".join(lines)


# ============================================================
# DeepSeek
# ============================================================
def query_deepseek(api_key: str):
    print("[DeepSeek]")
    headers = {"Accept": "application/json", "Authorization": f"Bearer {api_key}"}
    try:
        resp = requests.get("https://api.deepseek.com/user/balance", headers=headers, timeout=15)
        resp.raise_for_status()
        data = resp.json()
        print(f"  可用状态: {'是' if data.get('is_available') else '否'}")
        for info in data.get("balance_infos", []):
            print(f"  币种:      {info.get('currency', 'N/A')}")
            print(f"  总余额:    {info.get('total_balance', 'N/A')}")
            print(f"  赠送余额:  {info.get('granted_balance', 'N/A')}")
            print(f"  充值余额:  {info.get('topped_up_balance', 'N/A')}")
    except requests.HTTPError as e:
        print(f"  HTTP {resp.status_code}: {e}")
    except requests.RequestException as e:
        print(f"  请求失败: {e}")


# ============================================================
# OpenAI (GPT)
# ============================================================
def query_openai(api_key: str):
    print("[OpenAI / GPT]")
    headers = {"Authorization": f"Bearer {api_key}"}

    # 1. Credit grants (free credits, expiring balances)
    try:
        resp = requests.get(
            "https://api.openai.com/v1/dashboard/billing/credit_grants",
            headers=headers, timeout=15,
        )
        if resp.status_code == 200:
            data = resp.json()
            grants = data.get("grants", []) if isinstance(data, dict) else []
            total_used = data.get("total_used", 0) if isinstance(data, dict) else 0
            print(f"  赠金已使用: ${total_used:.2f}")
            if grants:
                for g in grants:
                    print(f"    ID: {g.get('id')}, 金额: ${g.get('grant_amount', 0):.2f}, 已用: ${g.get('used_amount', 0):.2f}")
            else:
                print("  无可用赠金")
        elif resp.status_code == 401:
            print("  API Key 无效")
            return
        else:
            print(f"  credit_grants -> {resp.status_code} (可能需要 Session Key)")
    except requests.RequestException as e:
        print(f"  credit_grants -> {e}")

    # 2. Subscription info
    try:
        resp = requests.get(
            "https://api.openai.com/v1/dashboard/billing/subscription",
            headers=headers, timeout=15,
        )
        if resp.status_code == 200:
            data = resp.json()
            print(f"  计划: {data.get('plan', {}).get('title', 'N/A')}")
            print(f"  是否有付款方式: {data.get('has_payment_method', 'N/A')}")
            soft_limit = data.get("soft_limit_usd", "N/A")
            hard_limit = data.get("hard_limit_usd", "N/A")
            print(f"  软限额: ${soft_limit} / 硬限额: ${hard_limit}")
        elif resp.status_code != 401:
            print(f"  subscription -> {resp.status_code}")
    except requests.RequestException as e:
        print(f"  subscription -> {e}")

    # 3. Recent costs (last 7 days)
    try:
        from datetime import datetime, timezone, timedelta
        end = datetime.now(timezone.utc)
        start = end - timedelta(days=7)
        resp = requests.get(
            "https://api.openai.com/v1/organization/costs",
            headers=headers,
            params={
                "start_time": int(start.timestamp()),
                "end_time": int(end.timestamp()),
            },
            timeout=15,
        )
        if resp.status_code == 200:
            data = resp.json()
            total = 0.0
            results = data.get("data", []) if isinstance(data, dict) else []
            for item in results:
                for r in item.get("results", []):
                    total += float(r.get("amount", {}).get("value", 0) or 0)
            print(f"  近7天消费: ${total:.4f}")
        elif resp.status_code != 401:
            print(f"  costs -> {resp.status_code}")
    except requests.RequestException as e:
        print(f"  costs -> {e}")


# ============================================================
# Google Gemini
# ============================================================
def query_gemini(api_key: str):
    print("[Gemini / Google]")
    # Gemini 没有"余额"概念，按量计费到 GCP 账单
    # 通过 models 端点验证 API Key 并获取基本信息
    try:
        resp = requests.get(
            "https://generativelanguage.googleapis.com/v1beta/models",
            params={"key": api_key},
            timeout=15,
        )
        if resp.status_code == 200:
            models = resp.json().get("models", [])
            supported = [m["name"].replace("models/", "")
                         for m in models
                         if "generateContent" in m.get("supportedGenerationMethods", [])]
            print(f"  API Key 有效，可用模型: {len(supported)} 个")
            for m in supported[:8]:
                print(f"    - {m}")
            if len(supported) > 8:
                print(f"    ... 及其他 {len(supported) - 8} 个")
        elif resp.status_code == 400:
            print("  API Key 无效")
            return
        else:
            print(f"  models -> HTTP {resp.status_code}")
            return
    except requests.RequestException as e:
        print(f"  models -> {e}")
        return

    print("  注意: Gemini 按量计费至 GCP 账单，无'余额'概念。")
    print("  查看用量: https://ai.dev/usage?tab=rate-limit")
    print("  GCP 配额监控需配置 Service Account + Cloud Monitoring API")


# ============================================================
# Anthropic (Claude)
# ============================================================
def query_anthropic(api_key: str):
    print("[Claude / Anthropic]")
    admin_headers = {
        "x-api-key": api_key,
        "anthropic-version": "2023-06-01",
    }

    # Try cost report (requires admin key: sk-ant-admin...)
    from datetime import datetime, timezone, timedelta
    end = datetime.now(timezone.utc)
    start = end - timedelta(days=7)

    try:
        resp = requests.get(
            "https://api.anthropic.com/v1/organizations/cost_report",
            headers=admin_headers,
            params={
                "starting_at": start.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "ending_at": end.strftime("%Y-%m-%dT%H:%M:%SZ"),
            },
            timeout=15,
        )
        if resp.status_code == 200:
            data = resp.json()
            results = data.get("data", [])
            total_cents = 0.0
            summaries: dict[str, float] = {}
            for bucket in results:
                for r in bucket.get("results", []):
                    amt = float(r.get("amount", 0))
                    total_cents += amt
                    model = r.get("model", "unknown")
                    summaries[model] = summaries.get(model, 0) + amt
            print(f"  近7天总消费: ${total_cents:.4f} USD")
            if summaries:
                print("  按模型:")
                for model, amt in sorted(summaries.items(), key=lambda x: -x[1]):
                    print(f"    {model}: ${amt:.4f}")
        elif resp.status_code == 401:
            print(f"  cost_report -> 401 (需要 Admin API Key, 即以 sk-ant-admin 开头的 key)")
        else:
            print(f"  cost_report -> HTTP {resp.status_code}")
    except requests.RequestException as e:
        print(f"  cost_report -> {e}")


# ============================================================
# Anthropic (Claude) - Web Session Mode
# ============================================================
def query_anthropic_web(cookies: dict[str, str], org_id: str):
    print("[Claude / Anthropic - 控制台 Session 模式]")
    session = requests.Session()
    for k, v in cookies.items():
        session.cookies.set(k, v, domain="platform.claude.com")

    try:
        resp = session.get(
            f"https://platform.claude.com/api/organizations/{org_id}/prepaid/credits",
            timeout=15,
        )
        if resp.status_code == 200:
            data = resp.json()
            amount_cents = data.get("amount", 0)
            currency = data.get("currency", "USD")
            print(f"  预付费余额: {amount_cents / 100:.2f} {currency}")
            print(f"  自动充值: {'开启' if data.get('auto_reload_settings') else '关闭'}")
        elif resp.status_code == 404:
            print("  未找到组织或端点不存在，请检查 org_id")
        elif resp.status_code == 401:
            print("  Cookie 已过期，请重新登录 platform.claude.com")
        else:
            print(f"  响应: HTTP {resp.status_code}")
    except requests.RequestException as e:
        print(f"  请求失败: {e}")


# ============================================================
# MiMo (Xiaomi)
# ============================================================
MIMO_ENDPOINTS = ["/api/v1/user/info", "/api/v1/billing", "/api/v1/usage"]


def query_mimo(cookies: dict[str, str]):
    print("[MiMo / 小米]")
    session = requests.Session()
    for k, v in cookies.items():
        session.cookies.set(k, v, domain="platform.xiaomimimo.com")

    for endpoint in MIMO_ENDPOINTS:
        url = f"https://platform.xiaomimimo.com{endpoint}"
        try:
            resp = session.get(
                url, headers={"Accept": "application/json"},
                timeout=15, allow_redirects=False,
            )
            if resp.status_code == 401:
                print(f"  {endpoint} -> 401 (Cookie 过期)")
                continue
            resp.raise_for_status()
            data = resp.json()
            print(f"  [{endpoint}]")
            _print_flat_dict(data, indent=4)
        except requests.RequestException as e:
            print(f"  {endpoint} -> {e}")


def _print_flat_dict(data, indent: int = 2):
    if isinstance(data, dict):
        if "data" in data and isinstance(data["data"], dict):
            data = data["data"]
        for k, v in data.items():
            if isinstance(v, (str, int, float, bool)):
                print(f"{' ' * indent}{k}: {v}")
            elif isinstance(v, list):
                print(f"{' ' * indent}{k}:")
                for item in v:
                    if isinstance(item, dict):
                        for ik, iv in item.items():
                            print(f"{' ' * (indent + 2)}{ik}: {iv}")
                        print(f"{' ' * (indent + 2)}---")
                    else:
                        print(f"{' ' * (indent + 2)}- {item}")
            elif isinstance(v, dict):
                print(f"{' ' * indent}{k}:")
                for ik, iv in v.items():
                    print(f"{' ' * (indent + 2)}{ik}: {iv}")
    else:
        print(f"{' ' * indent}{data}")


# ============================================================
# Main
# ============================================================
def main():
    # --- DeepSeek ---
    print("=" * 50)
    print("DeepSeek")
    print("=" * 50)
    key = load_config("api_key_deepseek.txt", "DEEPSEEK_API_KEY")
    if not key:
        key = load_config("api_key.txt", "DEEPSEEK_API_KEY")  # legacy
    if not key:
        key = input("  DeepSeek API Key (回车跳过): ").strip()
    if key:
        query_deepseek(key)
    else:
        print("  已跳过")

    # --- OpenAI ---
    print()
    print("=" * 50)
    print("OpenAI / GPT")
    print("=" * 50)
    key = load_config("api_key_openai.txt", "OPENAI_API_KEY")
    if not key:
        key = input("  OpenAI API Key (回车跳过): ").strip()
    if key:
        query_openai(key)
    else:
        print("  已跳过")

    # --- Gemini ---
    print()
    print("=" * 50)
    print("Gemini / Google")
    print("=" * 50)
    key = load_config("api_key_gemini.txt", "GEMINI_API_KEY")
    if not key:
        key = input("  Gemini API Key (回车跳过): ").strip()
    if key:
        query_gemini(key)
    else:
        print("  已跳过")

    # --- Claude (API mode) ---
    print()
    print("=" * 50)
    print("Claude / Anthropic")
    print("=" * 50)
    key = load_config("api_key_anthropic.txt", "ANTHROPIC_API_KEY")
    if not key:
        key = input("  Anthropic Admin API Key (sk-ant-admin..., 回车跳过): ").strip()
    if key:
        query_anthropic(key)
    else:
        print("  已跳过")

    # --- Claude Web session mode ---
    cookies_raw = load_config("claude_cookies.txt", "CLAUDE_COOKIES")
    org_id = load_config("claude_org_id.txt", "CLAUDE_ORG_ID")
    if cookies_raw and org_id:
        print()
        print("-" * 50)
        cookies = parse_cookies(cookies_raw)
        if cookies:
            query_anthropic_web(cookies, org_id)
    elif cookies_raw and not org_id:
        oid = input("\n  Claude 组织 ID (查看 platform.claude.com URL 中 /organizations/ 后的部分, 回车跳过): ").strip()
        if oid:
            query_anthropic_web(parse_cookies(cookies_raw), oid)

    # --- MiMo ---
    print()
    print("=" * 50)
    print("MiMo / 小米")
    print("=" * 50)
    cookies_raw = load_config("mimo_cookies.txt", "MIMO_COOKIES")
    if not cookies_raw:
        print("  Cookie 获取方法: 浏览器登录 platform.xiaomimimo.com")
        print("  在 DevTools → Application → Cookies 复制全部")
        if input("  是否手动输入 Cookie? (y/n): ").strip().lower() == "y":
            cookies_raw = prompt_input("  粘贴 Cookie (空行结束):")
    if cookies_raw:
        cookies = parse_cookies(cookies_raw)
        if cookies:
            print(f"  已加载 {len(cookies)} 个 Cookie，正在查询...")
            query_mimo(cookies)
        else:
            print("  无法解析 Cookie")
    else:
        print("  已跳过")

    print()
    print("=" * 50)
    print("查询完毕")


if __name__ == "__main__":
    main()
