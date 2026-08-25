# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
PW=/tmp/.your-nas-pw
BK="/path/to/your/project/deploy/backup/nginx-conf-$(date +%Y%m%d-%H%M%S)"
echo '=== backup current nginx state ==='
sudo -S -p '' bash -c 'mkdir -p "$BK" && cp -r /usr/trim/nginx/conf "$BK/" && cp /usr/trim/etc/network_gateway_setting.conf "$BK/" && echo BACKUP_OK "$BK"' < $PW
echo '=== deploy holy-proxy (caddy) ==='
sudo -n docker rm -f holy-proxy 2>/dev/null || true
sudo -n docker run -d --name holy-proxy --restart unless-stopped --network host \
  -v /path/to/your/project/deploy/caddy/Caddyfile:/etc/caddy/Caddyfile:ro \
  caddy:2-alpine
sleep 3
sudo -n docker ps --filter name=holy-proxy --format '{{.Names}}  {{.Status}}  {{.Ports}}'
sudo -n docker logs holy-proxy 2>&1 | tail -8
echo '=== verify port 80 ==='
curl -s -o /dev/null -w 'Host=your-nas.local -> %{http_code}\n' -H 'Host: your-nas.local' http://127.0.0.1/
curl -s -o /dev/null -w 'other host -> %{http_code} (redirect to 5666)\n' -H 'Host: anything.local' http://127.0.0.1/
curl -s -o /dev/null -w 'fnOS 5666 -> %{http_code}\n' --max-time 3 http://127.0.0.1:5666/
echo '=== DNS still ok ==='
sudo -n docker run --rm --network host alpine:3.19 sh -c 'apk add --no-cache bind-tools >/dev/null 2>&1; dig +short your-nas.local @192.168.1.100'
rm -f $PW