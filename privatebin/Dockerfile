FROM alpine:3.11
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG PRIVATEBIN_VERSION=1.3.4
ENV UID=791 GID=791

EXPOSE 8080

WORKDIR /privatebin

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache nginx php7-fpm php7-gd php7-json \
    && apk add --no-cache --virtual .build-deps wget ca-certificates \
    && wget -qO- https://github.com/PrivateBin/PrivateBin/archive/${PRIVATEBIN_VERSION}.tar.gz | tar xz --strip 1 \
    && apk del .build-deps \
    && mkdir -p /run/nginx \
    && chmod -R +x /usr/local/bin /etc/s6.d

VOLUME ["/privatebin/data"]
CMD ["run.sh"]
