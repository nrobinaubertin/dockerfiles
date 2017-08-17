FROM alpine:3.6

ARG PHP_EXT
ENV UID=791 GID=791

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY run.sh /usr/local/bin/run.sh 
COPY nginx /etc/nginx

RUN set -xe \
    && apk add --no-cache -U s6 su-exec ca-certificates nginx php7-fpm $PHP_EXT \
    && mkdir -p /php/logs /nginx/logs /nginx/tmp \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx \
    && mv /etc/nginx/nginx.conf /nginx

VOLUME /www /etc/nginx/nginx.conf
EXPOSE 8080

CMD ["run.sh"]
