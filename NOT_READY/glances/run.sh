#!/bin/sh
python3 /glances/setup.py install
chmod -R 755 /etc/s6.d /glances
exec /bin/s6-svscan /etc/s6.d
