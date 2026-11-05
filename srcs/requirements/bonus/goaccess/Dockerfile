FROM alpine:3.23

RUN apk update && apk add --no-cache goaccess

COPY tools/run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
