#!/bin/sh

if ! [ -d /wallabag/data/db ]; then
    mv /wallabag/db /wallabag/data/db
fi
sed -i -E "s|https://0.0.0.0|${DOMAIN}|g" /wallabag/app/config/parameters.yml
php /wallabag/bin/console cache:clear --env=prod
chown -R "${UID}:${GID}" /wallabag /etc/php7 /etc/nginx /etc/s6.d /var/log/ /var/tmp/ /run/nginx
su-exec "$UID:$GID" /bin/s6-svscan /etc/s6.d
