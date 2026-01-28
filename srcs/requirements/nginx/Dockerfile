FROM debian:buster

RUN apt -y update && apt install -y nginx && apt install openssl -y

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["/nginx.sh"]
