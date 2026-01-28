FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php && chmod 755 /run/php

COPY ./conf/wp-config.php /
COPY ./conf/script.sh /

RUN chmod +x /script.sh

CMD ["/script.sh"]
