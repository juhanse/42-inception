FROM debian:bookworm

RUN apt-get update && apt-get install nginx -y
RUN apt-get install openssl -y
RUN rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -f /etc/nginx/sites-available/default

COPY tools/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 443

ENTRYPOINT ["bash", "/setup.sh"]
