FROM debian:10.0

ENV UID=1000
ENV GID=1000
ENV TINI_VERSION v0.18.0
ENV ADMIN_PASSWORD=
ENV ADMIN_NAME=
ENV MOTD=

RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends libstdc++5 gosu curl ca-certificates \
    && curl -Lso /usr/local/bin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    && chmod +x /usr/local/bin/tini \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/tini", "--"]
VOLUME /ut2004
EXPOSE 7777 7778

COPY ut2004-server.ini /etc/ut2004/ut2004-server.ini

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
CMD ["/usr/local/bin/run.sh"]
