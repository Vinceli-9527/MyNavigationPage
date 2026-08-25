#!/bin/sh

HOSTNAME=${AVAHI_HOSTNAME:-home}

echo "[avahi] 启动脚本版本: v3"
echo "[avahi] 设置主机名为: ${HOSTNAME}"
sed -i "s/^#*host-name=.*/host-name=${HOSTNAME}/" /etc/avahi/avahi-daemon.conf
sed -i "s/^#*domain-name=.*/domain-name=local/" /etc/avahi/avahi-daemon.conf

echo "[avahi] 启动 dbus 系统总线..."
# 清理可能残留的 dbus pid 文件（容器重启时会遗留）
rm -f /run/dbus/dbus.pid /run/dbus/system_bus_socket
mkdir -p /run/dbus
if ! dbus-daemon --system --fork; then
    echo "[avahi] 错误: dbus 启动失败"
    sleep 3600
    exit 1
fi

echo "[avahi] 启动 avahi-daemon..."
exec avahi-daemon --no-drop-root
