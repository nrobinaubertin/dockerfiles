#!/bin/sh

if [ -z "$ADMIN_PASSWORD" ]; then
    ADMIN_PASSWORD="$(tr -dc a-z < /dev/urandom | head -c 8)"
fi

cd /ut2004/System || exit

exec gosu "$UID:$GID" sh -c "umask 022 && exec ./ucc-bin-linux-amd64 server \
    DM-Rankin?game=XGame.XDeathmatch?GameStats=$GAMESTATS?AdminName=$ADMIN_NAME?AdminPassword=$ADMIN_PASSWORD \
    ini=/etc/ut2004/ut2004-server.ini \
    log=/dev/stdout \
    -nohomedir"
