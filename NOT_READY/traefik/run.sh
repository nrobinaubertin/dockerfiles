#!/bin/sh

sed -i -e "s|<EMAIL>|${EMAIL}|g" /config/traefik.toml

# create cron task
crontab -r
echo "\
0 * * * * /usr/local/bin/dumpcerts.sh /data/acme.json /data/certs\
0 * * * * logrotate /config/logrotate.conf\
" | crontab -

mkdir -p /data/certs /data/logs

exec /bin/s6-svscan /etc/s6.d
