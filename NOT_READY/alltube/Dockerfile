FROM alpine:3.6

ARG ALLTUBE_VERSION=0.10.0

ENV UID=791 GID=791

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY run.sh /usr/local/bin/run.sh 
COPY nginx /etc/nginx

WORKDIR /alltube

RUN set -xe \
    && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache -U s6 su-exec nginx php7-fpm php7-fileinfo php7-intl php7-mbstring php7-curl libavc1394 rtmpdump ffmpeg composer@testing python2 php7-session php7-zip php7-ctype icu-libs zlib gettext \
    # && apk add --no-cache --virtual .build-deps git tar nodejs-npm ca-certificates openssl nodejs-npm php5-openssl php5-gmp php5-gettext php5-intl php5-dom php5-xml xz curl gettext unzip zlib \
    && apk add --no-cache --virtual .build-deps ca-certificates openssl unzip \
    # && ln -s /usr/bin/php5 /usr/bin/php \
    # && wget -qO- https://github.com/Rudloff/alltube/archive/${ALLTUBE_VERSION}.tar.gz | tar xz --strip 1 \
    && wget -qO alltube.zip https://github.com/Rudloff/alltube/releases/download/${ALLTUBE_VERSION}/alltube-${ALLTUBE_VERSION}.zip \
    && unzip alltube.zip \
    && rm alltube.zip \
    # && composer install --prefer-dist \
    # && npm install \
    # && ./node_modules/.bin/bower --allow-root install \
    # && ./node_modules/.bin/grunt \
    && chmod 777 templates_c \
    && mkdir -p /php/logs /nginx/logs /nginx/tmp \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

COPY index2.php /alltube/index2.php
COPY config.yml /alltube/config/config.yml

EXPOSE 8080

CMD ["run.sh"]
