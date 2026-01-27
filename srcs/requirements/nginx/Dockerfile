FROM debian:stable-slim

RUN apt update && apt install -y nginx openssl

COPY conf/default /etc/nginx/sites-available/default

COPY tools/ssl_script.sh /usr/local/bin/ssl_script.sh
RUN chmod +x /usr/local/bin/ssl_script.sh

EXPOSE 443

CMD ["/usr/local/bin/ssl_script.sh"]