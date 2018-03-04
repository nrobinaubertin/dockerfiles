#!/bin/sh
chown -R "${UID}:${GID}" /keeweb
su-exec "${UID}:${GID}" thttpd -D -d /keeweb -p 8080
