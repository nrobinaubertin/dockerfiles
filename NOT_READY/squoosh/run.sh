#!/bin/sh

chown -R "${UID}:${GID}" /squoosh /etc/s6.d /etc/nginx /var/log/ /var/tmp/ /run/nginx /var/lib/nginx
exec su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
