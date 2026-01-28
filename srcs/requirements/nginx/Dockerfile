FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.sh /

RUN chmod +x /nginx.sh

CMD ["/nginx.sh"]
