#!/bin/bash
set -u
echo '=== reload holy-proxy (new Caddyfile) ==='
sudo -n docker restart holy-proxy
sleep 2
sudo -n docker ps --filter name=holy-proxy --format '{{.Names}} {{.Status}}'
echo; echo '=== switch funnel 8080 -> 80 ==='
sudo -n docker exec -d holy-ts sh -c 'tailscale funnel off > /tmp/foff.log 2>&1'
sleep 5
sudo -n docker exec holy-ts cat /tmp/foff.log 2>&1 | head -5
sudo -n docker exec -d holy-ts sh -c 'tailscale funnel 80 > /tmp/fon.log 2>&1'
sleep 10
echo '--- fon.log ---'
sudo -n docker exec holy-ts cat /tmp/fon.log 2>&1 | head -8
echo; echo '=== funnel status ==='
sudo -n docker exec holy-ts tailscale funnel status 2>&1 | head -20
echo; echo '=== build log tail ==='
tail -5 /tmp/dl-build.log 2>/dev/null