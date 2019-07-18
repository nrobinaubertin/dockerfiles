#!/bin/sh

set -xe

sed -i "s/<MOTD>/$MOTD/g" /etc/ut2004/ut2004-server.ini
sed -i "s/<SERVER_NAME>/$SERVER_NAME/g" /etc/ut2004/ut2004-server.ini
sed -i "s/<ADMIN_NAME>/$ADMIN_NAME/g" /etc/ut2004/ut2004-server.ini

echo "* * * * * /usr/local/bin/fix-acl.sh" | crontab -

chown "$UID:$GID" -R /etc/ut2004 /etc/supervisor
chmod 755 -R /etc/ut2004
exec supervisord -c /etc/supervisor/supervisord.conf --nodaemon
