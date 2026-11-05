FROM alpine:3.23

RUN apk update && apk add --no-cache nodejs npm

WORKDIR /app

COPY conf/ /app/

RUN npm install && npm run build

EXPOSE 3000

CMD ["httpd", "-f", "-p", "3000", "-h", "/app/dist"]
