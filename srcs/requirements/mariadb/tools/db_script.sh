#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

mkdir -p "$DATADIR" /var/run/mysqld
chown -R mysql:mysql "$DATADIR"
chown -R mysql:mysql /var/run/mysqld

#check if database exists
if [ ! -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then
    mysql_install_db --user=mysql --datadir="$DATADIR" 2>/dev/null || echo "DB already initialized"

    # temporary startup of the MariaDB server
    mariadbd --user=mysql &
    mariadb_pid="$!"

    echo "Waiting for mariadb to start.."
    for i in {30..0}; do
        if mysqladmin ping --silent; then
            break;
        fi
        sleep 1
    done
    if [ "$i" = 0 ]; then
        echo "Unable to start server."
        exit 1
    fi
# init database
mariadb -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password USING PASSWORD('${MARIADB_ROOT_PASSWORD}');
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'localhost' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
    mysqladmin shutdown 2>/dev/null
    wait "$mariadb_pid"
fi

exec mariadbd --user=mysql