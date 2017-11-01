#!/bin/sh

mv -n /nginx/nginx.conf /etc/nginx/nginx.conf
chown -R "${UID}:${GID}" /php /nginx /etc/s6.d /var/log/nginx /var/tmp/nginx /var/lib/mysql /run /wordpress
su-exec "${UID}:${GID}" run2.sh
