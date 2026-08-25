# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
TOKEN=$(grep "^DOWNLOAD_TOKEN=" /path/to/your/project/deploy/secret/dl.env | cut -d= -f2-)
echo '=== B1 public download WITH token (through ts.net scope) ==='
curl -s -H 'Host: your-device.tailnet.ts.net' -H "X-DL-Token: $TOKEN" -o /tmp/test-pub.zip -w 'PUB dl -> %{http_code}, %{size_download}B, %{time_total}s\n' --max-time 260 'http://127.0.0.1/api/download?album_id=422866'
head -c 4 /tmp/test-pub.zip 2>/dev/null | od -c | head -1
echo '=== B2 rate limit (public, valid token, 8 parallel) ==='
for i in $(seq 1 8); do curl -s -o /dev/null -w '%{http_code} ' --max-time 30 -H 'Host: your-device.tailnet.ts.net' -H "X-DL-Token: $TOKEN" 'http://127.0.0.1/api/download?album_id=1' & done; wait; echo
echo '=== B3 no writes to project dir during download? ==='
ls /path/to/your/project/ | grep -iE '^422866' || echo 'OK: no album dir created'
echo '=== cleanup test files ==='
rm -f /tmp/test-lan.zip /tmp/test-pub.zip /tmp/dl-build*.log
echo cleaned