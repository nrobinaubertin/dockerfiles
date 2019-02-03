FROM alpine:3.9
RUN apk add --no-cache -U su-exec s6 tini
ENTRYPOINT ["/sbin/tini", "--"]

ARG WALLABAG_VERSION=2.3.6
ENV DOMAIN=https://wallabag.example.com
ENV UID=791 GID=791
EXPOSE 8080

WORKDIR /wallabag

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh
COPY parameters.yml /wallabag/parameters.yml

RUN set -xe \
    && apk add --no-cache nginx sqlite \
    && apk add --no-cache php7-fpm php7-session php7-ctype php7-dom php7-simplexml php7-json php7-gd php7-mbstring php7-xml php7-tidy php7-iconv php7-curl php7-gettext php7-tokenizer php7-bcmath php7-pdo_sqlite php7-phar php7-openssl php7-zlib \
    && apk add --no-cache --virtual .build-deps tar openssl ca-certificates wget make php7 bash php7-xmlreader php7-amqp php7-sockets \
    && wget -qO- https://github.com/wallabag/wallabag/archive/${WALLABAG_VERSION}.tar.gz | tar xz --strip 1 \
    && wget -qO- http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && echo "    secret : $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 50 | head -n1)" >> /wallabag/parameters.yml \
    && mv parameters.yml /wallabag/app/config/parameters.yml \
    && composer install \
    && sed -i 's|IGNORE_ROOT=0|IGNORE_ROOT=1|g' scripts/install.sh \
    && yes | make install \
    && mkdir -p /run/nginx \
    && mv /wallabag/data/db /wallabag/db \
    && apk del .build-deps \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

VOLUME ["/wallabag/data"]
CMD ["run.sh"]
