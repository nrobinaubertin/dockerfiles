#!/bin/sh

set -xe

sed -i "s/<MOTD>/$MOTD/g" /etc/ut2004/ut2004-server.ini
sed -i "s/<SERVER_NAME>/$SERVER_NAME/g" /etc/ut2004/ut2004-server.ini
sed -i "s/<ADMIN_NAME>/$ADMIN_NAME/g" /etc/ut2004/ut2004-server.ini
sed -i "s/<SERVER_NAME>/$SERVER_NAME/g" /public/index.html
sed -i "s/<SERVER_IP>/$(dig +short -4 myip.opendns.com @resolver1.opendns.com 2>/dev/null)/g" /public/index.html

echo "* * * * * /usr/local/bin/publish_stats.sh" | crontab -

publish_stats.sh

chown "$UID:$GID" -R /etc/ut2004 /etc/supervisor /public
chmod 755 -R /etc/ut2004 /public
exec supervisord -c /etc/supervisor/supervisord.conf --nodaemon
