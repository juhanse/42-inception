FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget php8.2-fpm php8.2-mysql mariadb-client
RUN rm -rf /var/lib/apt/lists/*

COPY tools/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html
RUN chmod -R 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

WORKDIR /var/www/html

ENTRYPOINT ["bash", "/setup.sh"]
