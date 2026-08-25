#!/bin/bash
set -u
echo '=== tailscale status ==='
sudo -n docker exec holy-ts tailscale status 2>&1 | head -8
echo; echo '=== DNSName ==='
sudo -n docker exec holy-ts tailscale status --json 2>/dev/null | grep -oE '\"(DNSName|BackendState|Online)\":[^,}]+' | head -6
echo; echo '=== enable funnel (bg) ==='
sudo -n docker exec holy-ts tailscale funnel --bg 8080 > /tmp/ts-funnel3.log 2>&1; echo exit=$?
head -12 /tmp/ts-funnel3.log; rm -f /tmp/ts-funnel3.log
echo; echo '=== funnel status ==='
sudo -n docker exec holy-ts tailscale funnel status 2>&1 | head -30
echo '=== done ==='