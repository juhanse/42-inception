FROM debian:buster

RUN apt update -y 
RUN apt install php-fpm php-mysql -y
RUN apt install curl -y

COPY ./conf/wp-config.php /
COPY ./conf/script.sh /

CMD ["/script.sh"]
