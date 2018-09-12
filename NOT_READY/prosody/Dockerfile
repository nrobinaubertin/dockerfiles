FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG CONVERSE_VERSION=v4.0.0
ENV UID=791 GID=791
ENV DOMAIN=localhost
ENV SUBDOMAIN=im
ENV ADMIN=admin@localhost

EXPOSE 5000 5222 5280 5281
VOLUME ["/data"]

COPY s6.d /etc/s6.d
COPY index.html /www/index.html

RUN set -xe \
    && apk add --no-cache -U prosody openssl \
    && apk add --no-cache --virtual .build-deps nodejs nodejs-npm make ruby ruby-bundler ruby-rdoc ruby-irb git mercurial bash ca-certificates libffi-dev build-base ruby-dev \
    && hg clone https://hg.prosody.im/prosody-modules/ /prosody_modules \
    && find /prosody_modules -name "*.lua" -exec cp {} /usr/lib/prosody/modules/ \; \
	&& rm -rf /prosody_modules \
    && mkdir -p /converse /www/dist \
    && cd /converse \
    && wget -qO- https://github.com/jcbrand/converse.js/archive/${CONVERSE_VERSION}.tar.gz | tar xz --strip 1 \
    && make build \
    && cp /converse/dist/converse.min.js /www/dist/converse.min.js \
    && cp -r /converse/locale /www \
    && cp -r /converse/css /www \
    && cp -r /converse/fonticons /www \
    && rm -rf /converse /root/.bundle /root/.npm /root/.gem \
    && apk del .build-deps

COPY run.sh /usr/local/bin/run.sh
COPY prosody.cfg.lua /etc/prosody/prosody.cfg.lua
RUN chmod -R +x /usr/local/bin /etc/s6.d /usr/lib/prosody/modules

CMD ["run.sh"]
