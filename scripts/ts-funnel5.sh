# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== start funnel on 8080 ==='
sudo -n docker exec -d holy-ts sh -c 'tailscale funnel 8080 > /tmp/funnel.log 2>&1'
sleep 20
echo '--- funnel.log ---'
sudo -n docker exec holy-ts cat /tmp/funnel.log 2>&1 | head -20
echo; echo '=== funnel status ==='
sudo -n docker exec holy-ts tailscale funnel status 2>&1 | head -30
echo; echo '=== public access test ==='
curl -s -o /dev/null -w 'https://your-device.tailnet.ts.net/ -> HTTP %{http_code} (%{time_total}s)\n' --max-time 15 https://your-device.tailnet.ts.net/
curl -s --max-time 15 https://your-device.tailnet.ts.net/ 2>/dev/null | head -c 200; echo
echo '=== done ==='