FROM debian:buster

RUN apt update -y 
RUN apt install php-fpm php-mysql -y
RUN apt install curl -y

COPY './tools/wp-config.php'
COPY './tools/start.sh'

CMD ["/script.sh"]
