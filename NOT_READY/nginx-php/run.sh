#!/bin/sh

mkdir -p /run/nginx
chown -R "${UID}:${GID}" \
    /etc/s6.d \
    /var/log/nginx \
    /var/tmp/nginx \
    /etc/nginx \
    /run/nginx \
    /var/log/php7 \
    /etc/php7

su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
