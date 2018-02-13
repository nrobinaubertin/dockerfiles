FROM alpine:3.7

ARG CONVERSE_VERSION=3.3.2

ENV UID=791 GID=791
ENV DOMAIN=localhost
ENV ADMIN=admin@localhost
ENV CERTIFICATE=fullchain.pem
ENV KEY=privkey.pem

EXPOSE 5000 5222 5280 5281
VOLUME ["/certs", "/data"]

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh
COPY index.html /www/index.html
COPY prosody.cfg.lua /etc/prosody/prosody.cfg.lua

RUN set -xe \
    && apk add --no-cache -U prosody su-exec s6 ca-certificates openssl \
    && apk add --no-cache --virtual .build-deps nodejs nodejs-npm make ruby ruby-bundler ruby-rdoc ruby-irb git mercurial bash \
    && hg clone https://hg.prosody.im/prosody-modules/ /prosody_modules \
    && mkdir -p /converse /www/dist \
    && cd /converse \
    && wget -qO- https://github.com/jcbrand/converse.js/archive/${CONVERSE_VERSION}.tar.gz | tar xz --strip 1 \
    && make build \
    && cp -r /converse/dist/converse.min.js /www/dist/converse.min.js \
    && cp -r /converse/locale /www/ \
    && cp -r /converse/css /www/ \
    && cp -r /converse/fonticons /www/ \
    && rm -rf /converse \
    && rm -rf /root/.bundle /root/.npm /root/.gem \
    && apk del .build-deps \
    && chmod -R +x /usr/local/bin/run.sh /etc/s6.d /prosody_modules

CMD ["run.sh"]
