#!/bin/bash
set -u
echo '=== start funnel detached inside container ==='
sudo -n docker exec -d holy-ts sh -c 'tailscale funnel 8080 > /tmp/funnel.log 2>&1'
sleep 15
echo '--- funnel.log (inside container) ---'
sudo -n docker exec holy-ts cat /tmp/funnel.log 2>&1 | head -15
echo; echo '=== funnel status ==='
sudo -n docker exec holy-ts tailscale funnel status 2>&1 | head -30
echo; echo '=== serve status ==='
sudo -n docker exec holy-ts tailscale serve status 2>&1 | head -20