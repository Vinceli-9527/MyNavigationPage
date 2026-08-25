# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== re-run tailscale up (reset, hostname=your-nas) ==='
nohup sudo -n docker exec holy-ts tailscale up --reset --hostname=your-nas --accept-dns=false > /tmp/ts-up.log 2>&1 &
sleep 6
echo '--- ts-up.log ---'
cat /tmp/ts-up.log 2>/dev/null
echo '--- status ---'
sudo -n docker exec holy-ts tailscale status 2>&1 | head -8
echo '=== done ==='