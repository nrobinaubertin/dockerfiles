FROM debian:10.0-slim

ENV UID=1000
ENV GID=1000
ENV TINI_VERSION v0.18.0

ENV ADMIN_PASSWORD=
ENV ADMIN_NAME=admin
ENV MOTD=GLHF
ENV GAMESTATS=True
ENV SERVER_NAME=ut2004

RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends libstdc++5 gosu curl ca-certificates nginx supervisor cron dnsutils \
    && curl -Lso /usr/local/bin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    && chmod +x /usr/local/bin/tini \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/tini", "--"]
VOLUME /ut2004
EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 8080

COPY ut2004-server.ini /etc/ut2004/ut2004-server.ini
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY nginx /etc/nginx
COPY run-ut2004.sh /usr/local/bin/run-ut2004.sh
COPY publish_stats.sh /usr/local/bin/publish_stats.sh
COPY run.sh /usr/local/bin/run.sh
COPY public /public

RUN chmod +x -R /usr/local/bin /var/lib/nginx
CMD ["/usr/local/bin/run.sh"]
