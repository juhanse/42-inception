FROM alpine:3.22

RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-session \
    wget

RUN mkdir -p /var/www/adminer && \
    wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/adminer/index.php && \
    chown -R nobody:nobody /var/www/adminer

RUN sed -i 's|^listen = .*|listen = 9000|g' /etc/php82/php-fpm.d/www.conf && \
    sed -i 's|^;clear_env = .*|clear_env = no|g' /etc/php82/php-fpm.d/www.conf

EXPOSE 9000

CMD ["/usr/sbin/php-fpm82", "-F"]
