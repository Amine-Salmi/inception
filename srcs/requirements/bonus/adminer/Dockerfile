FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    wget \
    php \
    php-mysqli \
    && rm -rf /var/lib/apt/lists/*

COPY tools/adminer_script.sh /usr/local/bin/adminer_script.sh

RUN chmod +x /usr/local/bin/adminer_script.sh

EXPOSE 8080

CMD ["/usr/local/bin/adminer_script.sh"]