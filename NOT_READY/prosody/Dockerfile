FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ENV UID=791 GID=791
ENV DOMAIN=localhost
ENV ADMIN=admin@localhost
ENV HTTP_UPLOAD_FILE_SIZE_LIMIT=1024*1024*10
ENV HTTP_UPLOAD_EXPIRE_AFTER=60*60*24*14
ENV HTTP_UPLOAD_QUOTA=1024*1024*50

EXPOSE 5000 5222
VOLUME ["/data"]

COPY s6.d /etc/s6.d

RUN apk add --no-cache prosody openssl lua5.2-dbi-sqlite3

RUN set -xe \
    && apk add --no-cache --virtual .build-deps mercurial ca-certificates \
    && hg clone https://hg.prosody.im/prosody-modules/ /prosody_modules \
    && find /prosody_modules -name "*.lua" -exec cp {} /usr/lib/prosody/modules/ \; \
	&& rm -rf /prosody_modules \
    && apk del .build-deps

COPY mod_register.lua /usr/lib/prosody/modules/mod_register.lua
COPY run.sh /usr/local/bin/run.sh
COPY prosody.cfg.lua /etc/prosody/prosody.cfg.lua
RUN chmod -R +x /usr/local/bin /etc/s6.d /usr/lib/prosody/modules

CMD ["run.sh"]
