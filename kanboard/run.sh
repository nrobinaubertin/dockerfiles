#!/bin/sh
set -xe
mkdir -p /run/nginx
chown -R "${UID}:${GID}" /kanboard /etc/php7 /etc/nginx /etc/s6.d /var/log/ /var/tmp/ /run/nginx /var/run/ /var/lib/nginx
su-exec "$UID:$GID" /bin/s6-svscan /etc/s6.d
