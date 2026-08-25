FROM alpine:3.19

# 缓存破坏标记：每次修改后更新此版本号，确保镜像强制重建
ARG AVAHI_BUILD_VERSION=v3

RUN apk add --no-cache avahi dbus

COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf
COPY services/ /etc/avahi/services/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
