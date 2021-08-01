FROM alpine:3.14
RUN apk add --no-cache -U su-exec s6 tini
ENTRYPOINT ["/sbin/tini", "--"]

ARG KANBOARD_VERSION=v1.2.20
ENV UID=791 GID=791
EXPOSE 8080

WORKDIR /kanboard

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache openssl unzip nginx ca-certificates curl \
        php7 php7-curl php7-gd php7-openssl php7-simplexml php7-pdo_sqlite php7-ctype \
        php7-fpm php7-json php7-xml php7-dom php7-zip php7-mbstring php7-session \
    && wget -qO- https://github.com/kanboard/kanboard/archive/${KANBOARD_VERSION}.tar.gz | tar xz --strip 1 \
    && rm -rf /kanboard/docker /kanboard/tests \
    && mkdir -p /var/lib/nginx \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

VOLUME ["/kanboard/data"]
CMD ["run.sh"]
