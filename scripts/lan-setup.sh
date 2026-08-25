# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
PROJ=/path/to/your/project
PW=/tmp/.your-nas-pw
echo '=== 1. start holy-dns ==='
sudo -n docker rm -f holy-dns 2>/dev/null
sudo -n docker run -d --name holy-dns --restart unless-stopped --network host \
  -v /path/to/your/project/deploy/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf:ro \
  alpine:3.19 sh -c 'apk add --no-cache dnsmasq >/dev/null 2>&1 && exec dnsmasq --no-daemon'
sleep 4
sudo -n docker ps -a --filter name=holy-dns --format '{{.Names}}  {{.Status}}'
echo '--- holy-dns logs ---'
sudo -n docker logs holy-dns 2>&1 | tail -5

echo '=== 2. install nginx vhost ==='
sudo -S -p '' bash -c 'cp /tmp/vincenavigation.conf /usr/trim/nginx/conf/conf.d/vincenavigation.conf && chmod 644 /usr/trim/nginx/conf/conf.d/vincenavigation.conf' < $PW
sudo -S -p '' bash -c 'grep -q "vincenavigation" /etc/sudoers.d/docker-nas 2>/dev/null || echo "your-nas ALL=(root) NOPASSWD: /usr/trim/nginx/sbin/nginx" >> /etc/sudoers.d/docker-nas' < $PW
sudo -S -p '' bash -c '/usr/trim/nginx/sbin/nginx -t && /usr/trim/nginx/sbin/nginx -s reload && echo NGINX_RELOAD_OK' < $PW
rm -f /tmp/vincenavigation.conf ${PW}

echo '=== 3. stop old avahi ==='
sudo -n docker stop holy-avahi 2>&1
sudo -n docker rm holy-avahi 2>&1

echo '=== 4. verify DNS via holy-dns ==='
sudo -n docker run --rm --network host alpine:3.19 sh -c 'apk add --no-cache bind-tools >/dev/null 2>&1; echo -n "your-nas.local -> "; dig +short your-nas.local @127.0.0.1; echo -n "upstream baidu.com -> "; dig +short baidu.com @127.0.0.1 | head -1'

echo '=== 5. verify nginx vhost ==='
curl -s -o /dev/null -w 'Host=your-nas.local -> HTTP %{http_code}\n' -H 'Host: your-nas.local' http://127.0.0.1/
curl -s -o /dev/null -w 'fnOS default (no host) -> HTTP %{http_code}\n' http://127.0.0.1/

echo '=== 6. port 53 ==='
ss -tlnup 2>/dev/null | grep ':53 ' || echo 'port 53 not visible (needs root)'

echo 'DONE'