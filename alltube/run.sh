#!/bin/sh
chown -R "alltube:alltube" /php /nginx /etc/s6.d /var/log/nginx /var/tmp/nginx /alltube
su-exec "alltube:alltube" /bin/s6-svscan /etc/s6.d
