FROM debian:buster

RUN apt -y update && apt install -y nginx && apt install openssl -y

COPY ./conf/nginx.sh /

CMD ["/nginx.sh"]
