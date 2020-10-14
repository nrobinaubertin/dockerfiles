#!/bin/sh

# create cron task
crontab -r
# everyday at 1:07 AM
echo "\
12 3 * * * php /jirafeau/admin.php clean_expired
16 3 * * * php /jirafeau/admin.php clean_async" | crontab -

sed -i -e "s|<TITLE>|${TITLE}|g" \
       -e "s|<DOMAIN>|${DOMAIN}|g" \
       -e "s|<ADMIN_PASSWORD>|${ADMIN_PASSWORD}|g" \
       -e "s|<ENABLE_CRYPT>|${ENABLE_CRYT}|g" \
       -e "s|<AVAIL_MINUTE>|${AVAIL_MINUTE}|g" \
       -e "s|<AVAIL_HOUR>|${AVAIL_HOUR}|g" \
       -e "s|<AVAIL_DAY>|${AVAIL_DAY}|g" \
       -e "s|<AVAIL_WEEK>|${AVAIL_WEEK}|g" \
       -e "s|<AVAIL_MONTH>|${AVAIL_MONTH}|g" \
       -e "s|<AVAIL_QUARTER>|${AVAIL_QUARTER}|g" \
       -e "s|<AVAIL_YEAR>|${AVAIL_YEAR}|g" \
       -e "s|<AVAIL_NONE>|${AVAIL_NONE}|g" \
       -e "s|<AVAIL_DEFAULT>|${AVAIL_DEFAULT}|g" \
       -e "s|<MAX_UPLOAD_SIZE>|${MAX_UPLOAD_SIZE}|g" \
    /jirafeau/lib/config.local.php

chmod 755 -R /jirafeau

exec /bin/s6-svscan /etc/s6.d
