# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
curl -s -o /dev/null -w 'A1 LAN page -> %{http_code}\n' -H 'Host: your-nas.local' http://127.0.0.1/
echo '--- A2 injection (expect 400 + JSON) ---'
curl -s -H 'Host: your-nas.local' 'http://127.0.0.1/api/download?album_id=..%2F..%2Fetc%2Fpasswd'; echo ' <- inj1'
curl -s -H 'Host: your-nas.local' 'http://127.0.0.1/api/download?album_id=abc;rm%20-rf'; echo ' <- inj2'
echo '--- A3 public no token (expect 401) ---'
curl -s -H 'Host: your-device.tailnet.ts.net' 'http://127.0.0.1/api/download?album_id=422866'; echo
echo '--- A4 public wrong token (expect 401) ---'
curl -s -o /dev/null -w '%{http_code}\n' -H 'Host: your-device.tailnet.ts.net' -H 'X-DL-Token: wrong' 'http://127.0.0.1/api/download?album_id=422866'
echo '--- A5 funnel public page (expect 200) ---'
curl -sk -o /dev/null -w 'FUNNEL page -> %{http_code}\n' --max-time 20 https://your-device.tailnet.ts.net/
echo '--- A6 LAN real download 422866 (no token) ---'
curl -s -H 'Host: your-nas.local' -o /tmp/test-lan.zip -w 'LAN dl -> %{http_code}, %{size_download}B, %{time_total}s\n' --max-time 260 'http://127.0.0.1/api/download?album_id=422866'
ls -la /tmp/test-lan.zip 2>/dev/null && head -c 4 /tmp/test-lan.zip | od -c | head -1