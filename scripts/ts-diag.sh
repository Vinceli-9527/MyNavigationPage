#!/bin/bash
set -u
echo '=== container state ==='
sudo -n docker inspect holy-ts --format 'StartedAt={{.State.StartedAt}} Restarts={{.RestartCount}} Status={{.State.Status}}'
echo; echo '=== state dir inside container ==='
sudo -n docker exec holy-ts sh -c 'ls -la /var/lib/tailscale/ && echo --- && wc -c /var/lib/tailscale/* 2>/dev/null | head' 2>&1 | head -15
echo; echo '=== tailscale processes in container ==='
sudo -n docker exec holy-ts ps aux 2>/dev/null | grep -E 'tailscale' | grep -v grep | head -8
echo; echo '=== recent daemon logs ==='
sudo -n docker logs holy-ts 2>&1 | tail -30