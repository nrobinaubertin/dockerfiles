FROM alpine:3.9
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG LUA_VERSION=5.2
ARG PROSODY_VERSION=0.11.2
ENV UID=791 GID=791
ENV DOMAIN=localhost
ENV HTTP_UPLOAD_FILE_SIZE_LIMIT=1024*1024*10
ENV HTTP_UPLOAD_EXPIRE_AFTER=60*60*24*14
ENV HTTP_UPLOAD_QUOTA=1024*1024*50

EXPOSE 5000 5222 5280 5281 5269
VOLUME ["/data"]

COPY s6.d /etc/s6.d

WORKDIR /prosody
RUN set -xe \
    && apk add --no-cache openssl busybox \
        libcrypto1.1 libidn \
        lua${LUA_VERSION} \
        lua${LUA_VERSION}-busted \
        lua${LUA_VERSION}-dbi-sqlite3 \
        lua${LUA_VERSION}-expat \
        lua${LUA_VERSION}-filesystem \
        lua${LUA_VERSION}-sec \
        lua${LUA_VERSION}-socket \
    && apk add --no-cache --virtual .build-deps \
        build-base \
        ca-certificates \
        libidn-dev \
        linux-headers \
        lua${LUA_VERSION}-dev \
        make \
        mercurial \
        openssl-dev \
    && wget -qO- https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz | tar xz --strip 1 \
    && rm -rf /prosody/certs/Makefile \
    && ./configure \
        --prefix=/prosody \
        --sysconfdir=/prosody \
        --ostype=linux \
        --with-lua-lib=/usr/lib \
        --with-lua-include=/usr/include \
        --lua-version=${LUA_VERSION} \
        --no-example-certs \
        --runwith=lua${LUA_VERSION} \
    && make \
    && hg clone https://hg.prosody.im/prosody-modules/ /prosody_modules \
    && rm -rf /prosody_modules/mod_captcha_registration \
    && find /prosody_modules -name "*.lua" -exec cp {} /prosody/plugins/ \; \
    && rm -rf /prosody_modules \
    && ln -s /usr/bin/lua${LUA_VERSION} /usr/bin/lua \
    && apk del .build-deps

COPY run.sh /usr/local/bin/run.sh
COPY prosody.cfg.lua /prosody/prosody.cfg.lua
RUN chmod -R +x /usr/local/bin /etc/s6.d /prosody/plugins

CMD ["run.sh"]
