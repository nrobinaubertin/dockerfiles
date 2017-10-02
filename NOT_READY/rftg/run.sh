#!/bin/bash

# cd /rftg
# rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld
# chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
# chmod 777 /var/run/mysqld

#chown root:root -R /var/lib/mysql
# /usr/bin/mysql_install_db --user=mysql
/etc/init.d/mysql start
# mysqld
# mysql < /rftg/server-schema.sql
# /etc/init.d/mysql stop
exec /rftg/rftgserver
