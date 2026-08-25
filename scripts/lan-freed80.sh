# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
PW=/tmp/.your-nas-pw
TS=$(date +%Y%m%d-%H%M%S)
BK=/path/to/your/project/deploy/backup/nginx-conf-$TS
echo '=== backup nginx conf + gateway setting ==='
sudo -S -p '' bash -c 'mkdir -p $BK && cp -r /usr/trim/nginx/conf $BK/ && cp /usr/trim/etc/network_gateway_setting.conf $BK/ && echo BACKUP_OK $BK' < $PW
echo '=== flip redirect to false ==='
sudo -S -p '' bash -c 'echo "{\"schema\":{\"http\":{\"port\":5666},\"https\":{\"port\":5667}},\"force_https\":false,\"redirect\":false}" > /usr/trim/etc/network_gateway_setting.conf && cat /usr/trim/etc/network_gateway_setting.conf' < $PW
echo '=== restart trim_nginx ==='
sudo -S -p '' systemctl restart trim_nginx < /dev/null 2>&1 || sudo -S -p '' systemctl restart trim_nginx < /dev/null
sleep 3
echo '=== nginx.conf mtime (regenerated?) ==='
ls -la /usr/trim/nginx/conf/nginx.conf
echo '=== still listening 80/443? ==='
grep -n 'listen 0.0.0.0:80\|listen 0.0.0.0:443' /usr/trim/nginx/conf/nginx.conf || echo 'no 80/443 listen in config!'
echo '=== ss ports ==='
ss -tlnp 2>/dev/null | grep -E ':(80|443|5666|5667) ' | head
echo '=== health ==='
curl -s -o /dev/null -w '5666 -> %{http_code}\n' --max-time 3 http://127.0.0.1:5666/
curl -s -o /dev/null -w '80 -> %{http_code}\n' --max-time 3 http://127.0.0.1/ || echo '80 no response (freed!)'
sudo -n docker ps --filter name=holy-dns --format '{{.Names}} {{.Status}}'
rm -f $PW