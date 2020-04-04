#!/bin/sh


sed -i -e "s|<MAX_EXPIRE_DAYS>|${MAX_EXPIRE_DAYS}|g" /send/server/config.js

export NODE_ENV=production
chown -R "${UID}:${GID}" /send /etc/s6.d
exec su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
