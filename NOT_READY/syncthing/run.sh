#!/bin/sh
mkdir -p /data/syncthing
chown -R "${UID}:${GID}" /etc/s6.d /usr/local/bin /data
exec su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
