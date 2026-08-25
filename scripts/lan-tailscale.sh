# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== tun device? ==='
ls -la /dev/net/tun 2>&1 || echo 'no tun (will use userspace)'
echo '=== pull tailscale image ==='
sudo -n docker pull tailscale/tailscale:latest 2>&1 | tail -3
echo '=== run holy-ts container ==='
sudo -n mkdir -p /var/lib/tailscale
sudo -n docker rm -f holy-ts 2>/dev/null || true
sudo -n docker run -d --name holy-ts --restart unless-stopped --network host -v /var/lib/tailscale:/var/lib/tailscale -e TS_STATE_DIR=/var/lib/tailscale -e TS_USERSPACE=true tailscale/tailscale:latest
sleep 4
sudo -n docker ps --filter name=holy-ts --format '{{.Names}} {{.Status}}'
echo '=== start tailscale up (login URL) ==='
nohup sudo -n docker exec holy-ts tailscale up --hostname=your-nas --timeout=120s > /tmp/ts-up.log 2>&1 &
sleep 8
echo '--- ts-up.log ---'
cat /tmp/ts-up.log 2>/dev/null
echo '--- container logs tail ---'
sudo -n docker logs holy-ts 2>&1 | tail -6
echo '=== done ==='