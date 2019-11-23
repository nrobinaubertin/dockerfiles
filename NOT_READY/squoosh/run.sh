#!/bin/sh

export NODE_ENV=production
chown -R "${UID}:${GID}" /squoosh /etc/s6.d
exec su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
