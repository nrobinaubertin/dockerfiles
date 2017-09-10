FROM debian:stable-slim

ARG RFTG_VERSION=0.9.5

WORKDIR /rftg

COPY run.sh /bin/run.sh

RUN set -xe \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends make git wget tar ca-certificates openssl gtk+2.0 default-mysql-server default-mysql-client default-libmysqlclient-dev dh-autoreconf \
    && wget -qO- https://github.com/bnordli/rftg/archive/${RFTG_VERSION}.tar.gz | tar xz --strip 1 \
    && cd /rftg/src \
    && ./configure --enable-server \
    && make clean && make \
    && /etc/init.d/mysql start \
    && mysql < /rftg/sql/server-schema.sql \
    && /etc/init.d/mysql stop \
    && chmod +x /bin/run.sh \
    && mv -t /rftg /rftg/src/server /rftg/src/cards.txt /rftg/src/ai_client \
    && rm -rf /rftg/3rdparty /rftg/src \ 
    && apt-get remove -y --allow-remove-essential gtk+2.0 openssl gcc git wget default-mysql-client \
    && apt-get autoremove -y --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 16309

CMD ["run.sh"]
