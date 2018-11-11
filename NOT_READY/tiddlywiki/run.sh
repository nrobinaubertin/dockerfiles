#!/bin/sh

if ! [ -f /data/tiddlywiki.info ]; then
    node /tiddlywiki/tiddlywiki.js /data --init server
fi

chown -R "${UID}:${GID}" /etc/s6.d /data /tiddlywiki
exec su-exec "${UID}:${GID}" /bin/s6-svscan /etc/s6.d
