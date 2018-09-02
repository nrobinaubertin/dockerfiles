#!/bin/sh

sed -i -e "s|<EMAIL>|${EMAIL}|g" /config/traefik.toml

# create cron task
crontab -r
# every 5mn
echo "*/5 * * * * /usr/local/bin/dumpcerts.sh /data/acme.json /data/certs" | crontab -

exec /bin/s6-svscan /etc/s6.d
