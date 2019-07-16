FROM node:10 AS builder

ARG SEND_VERSION=v3.0.12
WORKDIR /send

RUN set -xe \
	&& apt install git openssl \
	&& adduser --disabled-password --gecos '' builder \
	&& chown -R builder: /send

USER builder

RUN set -xe \
	&& id \
    && git clone https://github.com/mozilla/send.git . \
    && git checkout tags/${SEND_VERSION} \
	&& sed -i '/puppeteer/d' package.json \
	&& rm package-lock.json \
	&& id \
    && npm install \
	&& /send/node_modules/.bin/webpack
RUN set -xe \
    && rm -rf /send/node_modules \
    && npm install --production

FROM node:10-alpine
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG SEND_VERSION=v3.0.12

ENV UID=791 GID=791

EXPOSE 1443
WORKDIR /send

COPY --from=builder /send .
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache -U redis \
    && chmod +x -R /usr/local/bin/run.sh /etc/s6.d

CMD ["run.sh"]
