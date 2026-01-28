FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install mariadb-server -y && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./conf/script.sh /

RUN chmod +x /script.sh

CMD ["/script.sh"]
