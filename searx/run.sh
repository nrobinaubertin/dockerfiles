#!/bin/sh

SECRET=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 50 | head -n1)

sed -i -e "s|base_url : False|base_url : ${BASE_URL}|g" \
       -e "s/image_proxy : False/image_proxy : ${IMAGE_PROXY}/g" \
       -e "s/ultrasecretkey/${SECRET}/g" \
       /usr/local/searx/searx/settings.yml

su-exec $UID:$GID python /usr/local/searx/searx/webapp.py
