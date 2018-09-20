#!/bin/sh
mkdir -p /syncthing/config
chown -R "${UID}:${GID}" /syncthing /etc/s6.d
exec su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
