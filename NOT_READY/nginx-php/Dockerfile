FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG PHP_EXT
ENV UID=791 GID=791
EXPOSE 8080
VOLUME /www

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache nginx php7-fpm php7-common \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

RUN apk add --no-cache $PHP_EXT

CMD ["run.sh"]
