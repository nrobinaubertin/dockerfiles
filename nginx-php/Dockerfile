FROM alpine:3.6

ARG PHP_EXT
ENV UID=791 GID=791

VOLUME /www
EXPOSE 8080

RUN apk update

# install core
RUN set -xe \
    && apk add --no-cache s6 su-exec ca-certificates

# set correct datetime
RUN set -xe \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && echo "Europe/Paris" >  /etc/timezone \
    && apk del tzdata

# install nginx & php-fpm
RUN set -xe \
    && apk add --no-cache nginx \
    && apk add --no-cache php7-fpm $PHP_EXT

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh 
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY nginx /etc/nginx

RUN set -xe \
    && mkdir /www \
    && mkdir -p /php/logs \
    && mkdir -p /nginx/logs \
    && mkdir -p /nginx/tmp/client_body \
    && mkdir -p /nginx/tmp/proxy \
    && mkdir -p /nginx/tmp/fastcgi \
    && mkdir -p /nginx/tmp/uwsgi \
    && mkdir -p /var/lib/nginx/logs \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

CMD ["run.sh"]
