# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
PW=/tmp/.your-nas-pw
sudo -S -p '' bash -c 'cp /tmp/vincenavigation.conf /usr/trim/nginx/conf/conf.d/vincenavigation.conf && chmod 644 /usr/trim/nginx/conf/conf.d/vincenavigation.conf && echo VHOST_INSTALLED' < $PW
sudo -S -p '' bash -c 'grep -q "vincenavigation" /etc/sudoers.d/docker-nas 2>/dev/null || echo "your-nas ALL=(root) NOPASSWD: /usr/trim/nginx/sbin/nginx" >> /etc/sudoers.d/docker-nas' < $PW
sudo -S -p '' bash -c '/usr/trim/nginx/sbin/nginx -t && /usr/trim/nginx/sbin/nginx -s reload && echo NGINX_RELOAD_OK' < $PW
rm -f /tmp/vincenavigation.conf $PW
echo '--- verify ---'
curl -s -o /dev/null -w 'Host=your-nas.local -> HTTP %{http_code}\n' -H 'Host: your-nas.local' http://127.0.0.1/
curl -s -o /dev/null -w 'fnOS default -> HTTP %{http_code}\n' http://127.0.0.1/
sudo -n docker ps --filter name=holy-dns --format '{{.Names}} {{.Status}}'