FROM alpine:3.12
RUN apk add --no-cache -U su-exec s6 tini
ENTRYPOINT ["/sbin/tini", "--"]

ARG JIRAFEAU_VERSION=4.1.1
ENV TITLE=""
ENV DOMAIN="http://localhost"
ENV ADMIN_PASSWORD=""
ENV AVAIL_MINUTE="true"
ENV AVAIL_HOUR="true"
ENV AVAIL_DAY="true"
ENV AVAIL_WEEK="true"
ENV AVAIL_MONTH="true"
ENV AVAIL_QUARTER="false"
ENV AVAIL_YEAR="false"
ENV AVAIL_NONE="false"
ENV AVAIL_DEFAULT="month"
ENV MAX_UPLOAD_SIZE="0"
EXPOSE 8080

WORKDIR /jirafeau

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache nginx \
    && apk add --no-cache php7-fpm php7-session php7-json \
    && apk add --no-cache --virtual .build-deps tar openssl ca-certificates wget \
    && wget -qO- https://gitlab.com/mojo42/jirafeau/-/archive/${JIRAFEAU_VERSION}/jireafeau-${JIRAFEAU_VERSION}.tar.gz | tar xz --strip 1 \
    && rm -rf docker \
    && apk del .build-deps \
    && mkdir -p /var/run/nginx \
    && chmod -R +x /usr/local/bin /etc/s6.d

COPY config.local.php /jirafeau/lib/config.local.php

VOLUME ["/jirafeau/data"]
CMD ["run.sh"]
