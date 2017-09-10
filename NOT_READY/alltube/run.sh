#!/bin/sh
chown -R "${UID}:${GID}" /php /nginx /etc/s6.d /var/log/nginx /var/tmp/nginx /alltube
su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
