#!/bin/bash
set -u
echo '=== tailscale status ==='
sudo -n docker exec holy-ts tailscale status 2>&1 | head -10
echo; echo '=== node DNS name ==='
sudo -n docker exec holy-ts tailscale status --json 2>/dev/null | grep -oE '\"DNSName\":\"[^\"]+\"' | head -2
echo; echo '=== enable funnel (bg) ==='
nohup sudo -n docker exec holy-ts tailscale funnel --bg 8080 > /tmp/ts-funnel.log 2>&1 &
sleep 6
echo '--- ts-funnel.log ---'
cat /tmp/ts-funnel.log 2>/dev/null
echo; echo '=== funnel status ==='
sudo -n docker exec holy-ts tailscale funnel status 2>&1 | head -20
echo '=== done ==='