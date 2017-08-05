FROM alpine:3.6

ARG WALLABAG_VERSION=2.2.3
ENV UID=791 GID=791

EXPOSE 8080

WORKDIR /wallabag

COPY parameters.yml /wallabag/parameters.yml
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh
COPY php7 /etc/php7
COPY nginx /etc/nginx

RUN set -xe \
    && apk add --no-cache -U su-exec s6 nginx sqlite \
    && apk add --no-cache --virtual .build-deps tar openssl ca-certificates wget make php7 \
    && apk add --no-cache php7-fpm php7-session php7-ctype php7-dom php7-simplexml php7-json php7-gd php7-mbstring php7-xml php7-tidy php7-iconv php7-curl php7-gettext php7-tokenizer php7-bcmath php7-pdo_sqlite php7-phar php7-openssl php7-zlib \
    && wget -qO- http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && wget -qO- https://github.com/wallabag/wallabag/archive/${WALLABAG_VERSION}.tar.gz | tar xz --strip 1 \
    && mv /wallabag/parameters.yml /wallabag/app/config/parameters.yml \
    && echo "    secret : $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 50 | head -n1)" >> /wallabag/app/config/parameters.yml \
    && SYMFONY_ENV=prod composer install --no-dev --prefer-dist \
    && yes | make install \
    && mkdir -p /php/logs /nginx/logs /nginx/tmp \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx \
    && apk del .build-deps \
    && php /wallabag/bin/console cache:clear --env=prod \
    && mv /wallabag/data/db /wallabag/db

VOLUME /wallabag/data

CMD ["run.sh"]
