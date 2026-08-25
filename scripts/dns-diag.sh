# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
echo '=== holy-dns status ==='
sudo -n docker ps --filter name=holy-dns --format '{{.Names}} {{.Status}}'
sudo -n docker logs holy-dns 2>&1 | tail -8
echo; echo '=== port 53 listeners ==='
ss -tlnup 2>/dev/null | grep ':53 ' || echo 'NO :53 listener!'
echo; echo '=== resolve via LAN IP ==='
sudo -n docker run --rm --network host alpine:3.19 sh -c 'apk add --no-cache bind-tools >/dev/null 2>&1; dig +short your-nas.local @192.168.1.100; echo ---; dig +short baidu.com @192.168.1.100 | head -1'
echo; echo '=== firewall rules mentioning 53/dns ==='
sudo -S -p '' iptables -L -n 2>/dev/null | grep -iE '53|dns' | head -10 || echo 'iptables not accessible'
sudo -S -p '' nft list ruleset 2>/dev/null | grep -iE '53|dns' | head -10 || echo 'nft not accessible'
echo; echo '=== can LAN peer reach 53? (tcp from NAS to own LAN ip) ==='
timeout 3 bash -c '</dev/tcp/192.168.1.100/53 && echo TCP53_OPEN' 2>&1 || echo TCP53_CLOSED