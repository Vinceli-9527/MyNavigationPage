# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== clean state ==='
sudo -n docker exec holy-ts tailscale logout 2>&1 | head -3 || true
sleep 2
echo '=== start ONE detached up ==='
sudo -n docker exec -d holy-ts tailscale up --reset --hostname=your-nas --accept-dns=false
sleep 6
echo '=== the ONE authoritative login url ==='
sudo -n docker exec holy-ts tailscale status 2>&1 | head -6
echo '=== done (do not run any other tailscale up after this) ==='