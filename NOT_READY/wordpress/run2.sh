#!/bin/sh
mysql_install_db
run3.sh &
exec /bin/s6-svscan /etc/s6.d
