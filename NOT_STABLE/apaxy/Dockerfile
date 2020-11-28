FROM httpd:2.4-alpine
COPY theme /usr/local/apache2/theme
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
RUN set -xe \
    && chmod 755 -R /usr/local/apache2
