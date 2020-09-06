FROM alpine:3.11
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG WORDPRESS=5.3.2
ENV UID=791 GID=791
EXPOSE 8080
WORKDIR /wordpress

RUN set -xe \
    && apk add --no-cache -U nginx php7-fpm ca-certificates mariadb openssl mariadb-client phpmyadmin \
    && apk add --no-cache php7-curl php7-dom php7-ftp php7-gd php7-iconv php7-json php7-xml php7-mbstring php7-pdo_mysql php7-mysqli php7-openssl php7-tokenizer php7-zlib php7-session \
    && wget -qO- https://wordpress.org/wordpress-${WORDPRESS}.tar.gz | tar xz --strip 1 \
    && mv wp-content wp-content-original

VOLUME /wordpress/wp-content

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY wp-config.php /wordpress/wp-config.php
COPY run.sh /usr/local/bin/run.sh
RUN set -xe && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx
CMD ["run.sh"]
