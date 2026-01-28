FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    curl php8.2-fpm php8.2-mysql mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/wp-config.php /
COPY ./conf/script.sh /

RUN chmod +x /script.sh

WORKDIR /var/www/html

CMD ["/script.sh"]
