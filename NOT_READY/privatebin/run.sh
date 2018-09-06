#!/bin/sh

chown -R "${UID}:${GID}" /privatebin /etc/s6.d /etc/php7 /etc/nginx /var/log /var/tmp/nginx /var/lib/nginx /run/nginx
exec su-exec ${UID}:${GID} /bin/s6-svscan /etc/s6.d
