# ⚠️ 本文件为一次性部署辅助脚本，含示例值/占位符（作者环境），真实使用请按你的环境修改。
#!/bin/bash
set -u
PW=/tmp/.your-nas-pw
echo '=== kill running build ==='
sudo -S -p '' pkill -f 'docker build -t mypersonalwebsite-web' < $PW 2>&1; sleep 2; echo killed
echo; echo '=== project dir sizes (top) ==='
du -sh --exclude=.venv --exclude=wheels /path/to/your/project/* 2>/dev/null | sort -rh | head -15
echo; echo '=== HACKING_GHOST total ==='
du -sh /path/to/your/project/HACKING_GHOST* 2>/dev/null | tail -1
echo; echo '=== disk free ==='
df -h /vol1 2>/dev/null | tail -2
rm -f $PW