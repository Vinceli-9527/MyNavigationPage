# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== old container exit info ==='
sudo -n docker inspect holy-ts --format 'ExitCode={{.State.ExitCode}} OOM={{.State.OOMKilled}} Error={{.State.Error}}' 2>/dev/null
echo '=== recreate with explicit tailscaled entrypoint (kernel tun) ==='
sudo -n docker rm -f holy-ts 2>/dev/null || true
sudo -n docker run -d --name holy-ts --restart unless-stopped --network host --cap-add NET_ADMIN --cap-add NET_RAW --device /dev/net/tun --entrypoint tailscaled -v /var/lib/tailscale:/var/lib/tailscale tailscale/tailscale:latest --statedir=/var/lib/tailscale
sleep 5
sudo -n docker ps --filter name=holy-ts --format '{{.Names}} {{.Status}} Restarts={{.RestartCount}}'
echo '=== start up detached ==='
sudo -n docker exec -d holy-ts tailscale up --reset --hostname=your-nas --accept-dns=false
sleep 6
echo '=== authoritative login url ==='
sudo -n docker exec holy-ts tailscale status 2>&1 | head -5
echo '=== container still stable? ==='
sudo -n docker inspect holy-ts --format 'Restarts={{.RestartCount}} Status={{.State.Status}}'