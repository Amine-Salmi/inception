FROM debian:stable-slim

RUN apt-get update && apt-get install -y nginx

COPY website/ /var/www/html/

RUN chmod -R 755 /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]