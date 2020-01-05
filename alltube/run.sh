#!/bin/sh

set -x

# create cron task
crontab -r
# everyday at 1:22 AM
echo "22 1 * * * update_ytdl.sh" | crontab -

mkdir -p /run/nginx
/usr/local/bin/update_ytdl.sh

chown -R "alltube:alltube" /etc/s6.d /var/tmp/nginx /alltube /etc/php7 /etc/nginx /var/log /run /var/lib/nginx
exec su-exec "alltube:alltube" /bin/s6-svscan /etc/s6.d
