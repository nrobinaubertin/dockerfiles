#!/bin/sh
chown -R "${UID}:${GID}" /keeweb/server.sh
su-exec "${UID}:${GID}" /keeweb/server.sh
