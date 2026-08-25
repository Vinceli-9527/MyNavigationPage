#!/bin/bash
set -u
echo '=== tailscale status ==='
sudo -n docker exec holy-ts tailscale status 2>&1 | head -8
echo; echo '=== DNSName / state ==='
sudo -n docker exec holy-ts tailscale status --json 2>/dev/null | grep -oE '(DNSName|BackendState|Online)\":[^,]+' | head -6
echo; echo '=== enable funnel (try --bg) ==='
sudo -n docker exec holy-ts tailscale funnel --bg 8080 > /tmp/ts-funnel2.log 2>&1; echo "exit=$?"
cat /tmp/ts-funnel2.log | head -10
echo '=== funnel status ==='
sudo -n docker exec holy-ts tailscale funnel status 2>&1 | head -25
rm -f /tmp/ts-funnel2.log
echo '=== done ==='