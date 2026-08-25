# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
PROJ=/path/to/your/project
echo '=== start holy-dl ==='
sudo -n docker rm -f holy-dl 2>/dev/null || true
sudo -n docker run -d --name holy-dl --restart unless-stopped -p 8001:8001 -v $PROJ:/app --env-file $PROJ/deploy/secret/dl.env mypersonalwebsite-web python3 -m uvicorn backend.downloader.main:app --host 0.0.0.0 --port 8001 --workers 1
echo '=== recreate holy-web (new image, no /run) ==='
sudo -n docker rm -f holy-web 2>/dev/null || true
sudo -n docker run -d --name holy-web --restart unless-stopped -p 8080:8000 -v $PROJ:/app -e PYTHONUNBUFFERED=1 mypersonalwebsite-web python3 backend/app.py
echo '=== reload holy-proxy ==='
sudo -n docker restart holy-proxy
sleep 4
echo '=== containers ==='
sudo -n docker ps --format 'table {{.Names}}	{{.Status}}	{{.Ports}}' | grep -E 'holy|NAMES'
echo '=== dl health ==='
curl -s --max-time 5 http://127.0.0.1:8001/api/download/health && echo
echo '=== web health ==='
curl -s -o /dev/null -w 'web 8080 -> %{http_code}\n' --max-time 5 http://127.0.0.1:8080/