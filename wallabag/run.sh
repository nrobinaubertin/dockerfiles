#!/bin/sh

if ! [ -d /wallabag/data/db ]
then
    mv /wallabag/db /wallabag/data/db
fi
php /wallabag/bin/console cache:clear --env=prod
chown -R "${UID}:${GID}" /wallabag/web /wallabag/app /wallabag/src /wallabag/data /wallabag/var /php /nginx /etc/s6.d /var/log/nginx /var/tmp/nginx
su-exec "$UID:$GID" /bin/s6-svscan /etc/s6.d
