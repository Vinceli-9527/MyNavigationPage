# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== gateway setting (redirect flipped back?) ==='
cat /usr/trim/etc/network_gateway_setting.conf 2>&1
echo; echo '=== who owns port 80 now ==='
sudo -S -p '' ss -tlnp | grep ':80 ' 2>/dev/null || ss -tlnp | grep ':80 ' || echo '80 not listening'
echo; echo '=== holy-proxy container ==='
sudo -n docker ps -a --filter name=holy-proxy --format '{{.Names}} {{.Status}}'
sudo -n docker logs holy-proxy 2>&1 | tail -12
echo; echo '=== test port 80 with Host header ==='
curl -s -o /dev/null -w 'your-nas.local -> HTTP %{http_code}\n' --max-time 5 -H 'Host: your-nas.local' http://127.0.0.1/
curl -s -o /dev/null -w 'other host -> HTTP %{http_code}\n' --max-time 5 -H 'Host: test.local' http://127.0.0.1/
echo; echo '=== fnOS nginx mtime (regenerated recently?) ==='
ls -la /usr/trim/nginx/conf/nginx.conf
echo '=== done ==='