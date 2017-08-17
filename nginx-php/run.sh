#!/bin/sh
mv -n /nginx/nginx.conf /etc/nginx/nginx.conf
chown -R "${UID}:${GID}" /php /nginx /etc/s6.d /var/log/nginx /var/tmp/nginx
su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
