# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== state dir ==='
sudo -n ls -la /var/lib/tailscale/ 2>&1 | head -8
echo '=== restart up detached ==='
sudo -n docker exec -d holy-ts tailscale up --reset --hostname=your-nas --accept-dns=false
sleep 6
echo '--- container logs (auth url) ---'
sudo -n docker logs holy-ts 2>&1 | tail -12
echo '=== status ==='
sudo -n docker exec holy-ts tailscale status 2>&1 | head -5
echo '=== done ==='