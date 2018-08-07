#!/bin/sh

# create cron task
crontab -r
echo "* * * * * /usr/local/bin/watchContainers" | crontab -

# create lastStartEvent file
printf "0" > /tmp/lastStartEvent

# create some files for nginx
> /var/log/nginx/error.log
mkdir -p /run/nginx

chown -R "${UID}:${GID}" \
    /run/nginx \
    /var/log/nginx \
    /var/tmp/nginx \
    /etc/nginx

watchContainers
exec /bin/s6-svscan /etc/s6.d
