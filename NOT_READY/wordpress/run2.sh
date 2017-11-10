#!/bin/sh
mysql_install_db --datadir="/wordpress/wp-content/mysql"
(
    sleep 10
    mysqladmin -u root password "root"
    mysqladmin -u root --password="root" create "wordpress"
) &
exec /bin/s6-svscan /etc/s6.d
