FROM debian:stable-slim

RUN apt update && apt install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/db_script.sh /usr/local/bin/db_script.sh
RUN chmod +x /usr/local/bin/db_script.sh

EXPOSE 3306

CMD ["/usr/local/bin/db_script.sh"]