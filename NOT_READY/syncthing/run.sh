#!/bin/sh
mkdir -p /data/syncthing
chown -R "${UID}:${GID}" /syncthing /etc/s6.d /usr/local/bin
exec su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
