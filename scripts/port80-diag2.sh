# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== port 80 listener (plain ss) ==='
ss -tln | grep ':80 ' || echo '80 NOT listening'
echo; echo '=== holy-proxy container ==='
sudo -n docker ps -a --filter name=holy-proxy --format '{{.Names}}  {{.Status}}'
sudo -n docker logs holy-proxy 2>&1 | tail -10
echo; echo '=== port 80 with Host header ==='
curl -s -o /dev/null -w 'your-nas.local -> HTTP %{http_code}\n' --max-time 5 -H 'Host: your-nas.local' http://127.0.0.1/
curl -s -o /dev/null -w 'other host -> HTTP %{http_code}\n' --max-time 5 -H 'Host: test.local' http://127.0.0.1/
echo; echo '=== nginx.conf mtime ==='
ls -la /usr/trim/nginx/conf/nginx.conf
echo '=== done ==='