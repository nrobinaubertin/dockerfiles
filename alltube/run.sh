#!/bin/sh
mkdir -p /run/nginx
chown -R "alltube:alltube" /etc/s6.d /var/tmp/nginx /alltube /etc/php7 /etc/nginx /var/log /run
su-exec "alltube:alltube" /bin/s6-svscan /etc/s6.d
