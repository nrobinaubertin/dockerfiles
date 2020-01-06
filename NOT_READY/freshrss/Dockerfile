FROM alpine:3.11
RUN apk add --no-cache -U su-exec s6 tini
ENTRYPOINT ["/sbin/tini", "--"]

ARG FRESHRSS_VERSION=1.15.3
ARG FRESHRSS_YOUTUBE=0.7
ENV UID=791 GID=791
EXPOSE 8080

WORKDIR /freshrss

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache php7 php7-fpm openssl unzip nginx bash ca-certificates curl wget \
        php7-curl php7-gmp php7-intl php7-mbstring \
        php7-xml php7-zip php7-ctype php7-dom php7-fileinfo php7-iconv \
        php7-json php7-session php7-simplexml php7-xmlreader php7-zlib php7-pdo_sqlite \
    && wget -qO- https://github.com/FreshRSS/FreshRSS/archive/${FRESHRSS_VERSION}.tar.gz | tar xz --strip 1 \
    && mv /freshrss/data /freshrss/data_default \
    && cd /freshrss/extensions \
    && wget -qO- https://github.com/kevinpapst/freshrss-youtube/archive/${FRESHRSS_YOUTUBE}.tar.gz | tar xz --strip 1 \
    && mkdir -p /var/lib/nginx \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

VOLUME ["/freshrss/data"]
CMD ["run.sh"]
