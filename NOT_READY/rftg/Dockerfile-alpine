FROM alpine:3.6

ARG RFTG_VERSION=0.9.5

EXPOSE 16309

WORKDIR /rftg

COPY server-schema.sql /rftg/server-schema.sql 
COPY run.sh /rftg/run.sh

RUN set -xe \
    && apk add --no-cache -U mysql mysql-client mariadb-client-libs \
    && apk add --no-cache --virtual .build-deps make git wget tar ca-certificates openssl gtk+2.0 gcc \
    && wget -qO- https://github.com/bnordli/rftg/archive/${RFTG_VERSION}.tar.gz | tar xz --strip 1 \
    && cd /rftg/src \
    && ./configure --enable-server \
    && make clean && make \
    && apk del .build-deps \
    && chmod +x /rftg/run.sh

CMD ["/rftg/run.sh"]
