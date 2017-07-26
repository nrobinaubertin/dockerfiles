#!/bin/sh
chown -R ${UID}:${GID} /www /php /nginx /etc/s6.d /var/log/nginx /var/tmp/nginx
exec su-exec ${UID}:${GID} /bin/s6-svscan /etc/s6.d
