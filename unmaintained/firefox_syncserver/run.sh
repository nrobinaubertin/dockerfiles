#!/bin/sh

cd /sync || exit

SECRET=$(tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 50)

echo "\
[server:main]
use = egg:gunicorn
host = 0.0.0.0
port = 5000
workers = 1
timeout = 30
errorlog = -
loglevel = warning
forwarded_allow_ips = *

[app:main]
use = egg:syncserver

[syncserver]
public_url = ${URL}
secret = ${SECRET}
force_wsgi_environ = ${FORCE_WSGI}
" > /sync/syncserver.ini

chown -R "${UID}:${GID}" .

su-exec "${UID}:${GID}" make serve
