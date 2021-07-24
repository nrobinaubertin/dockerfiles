#!/bin/sh

if [ -n ${CERTFILE} ]; then

  sed -i \
    -e "s|<CERTFILE>|${CERTFILE}|g" \
    -e "s|<KEYFILE>|${KEYFILE}|g" \
    /usr/local/apache2/conf/http-ssl.conf
  sed -i \
    -e "s|#Include conf/httpd-ssl.conf|Include conf/httpd-ssl.conf|g" \
    /usr/local/apache2/conf/http.conf
fi

exec httpd-foreground
