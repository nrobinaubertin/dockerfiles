FROM alpine:3.6

ARG PHP_EXT
ENV UID=791 GID=791

VOLUME /www
EXPOSE 8080

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh 

RUN set -xe \
    && apk add --no-cache -U s6 su-exec ca-certificates nginx php7-fpm $PHP_EXT \
    && mkdir -p /php/logs /nginx/logs /nginx/tmp \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

CMD ["run.sh"]
