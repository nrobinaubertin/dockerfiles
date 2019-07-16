#!/bin/sh

set -xe

if [ -z "$ADMIN_PASSWORD" ]; then
    ADMIN_PASSWORD="$(tr -dc a-z < /dev/urandom | head -c 8)"
fi

sed -i "s/<MOTD>/$MOTD/g" /etc/ut2004/ut2004-server.ini
sed -i "s/<ADMIN_NAME>/$ADMIN_NAME/g" /etc/ut2004/ut2004-server.ini

chown "$UID:$GID" -R /etc/ut2004
chmod 755 -R /etc/ut2004
cd /ut2004/System || exit
exec gosu "$UID:$GID" ./ucc-bin-linux-amd64 server \
    "DM-Rankin?game=XGame.XDeathmatch?AdminName=admin?AdminPassword=$ADMIN_PASSWORD" \
    ini=/etc/ut2004/ut2004-server.ini \
    log=/dev/stdout \
    -nohomedir
