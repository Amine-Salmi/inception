FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client \
    php-redis \ 
    redis-tools

COPY conf/www.conf /etc/php/8.4/fpm/pool.d/www.conf

COPY tools/wp_script.sh /usr/local/bin/wp_script.sh
RUN chmod +x /usr/local/bin/wp_script.sh

EXPOSE 9000

CMD ["/usr/local/bin/wp_script.sh"]