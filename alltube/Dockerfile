FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG ALLTUBE_VERSION=1.1.2
EXPOSE 8080

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY run.sh /usr/local/bin/run.sh
COPY nginx /etc/nginx

WORKDIR /alltube

RUN set -xe \
    && adduser -D alltube \
    && apk add --no-cache nginx php7-fpm php7-fileinfo php7-intl php7-mbstring php7-curl libavc1394 ffmpeg python2 php7-session php7-zip php7-ctype icu-libs zlib gettext php7-gettext php7-json php7-openssl \
    && apk add --no-cache --virtual .build-deps ca-certificates openssl unzip \
    && wget -qO alltube.zip https://github.com/Rudloff/alltube/releases/download/${ALLTUBE_VERSION}/alltube-${ALLTUBE_VERSION}.zip \
    && unzip alltube.zip \
    && rm alltube.zip \
    && mkdir -p /php/logs /nginx/logs /nginx/tmp \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

COPY config.yml /alltube/config/config.yml

CMD ["run.sh"]
