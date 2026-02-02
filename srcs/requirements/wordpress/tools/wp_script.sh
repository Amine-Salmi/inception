#!/bin/bash

set -e

echo "waiting for mariadb to be ready ..."

MAX_TRIES=30
COUNTER=0
until mysqladmin ping -h "${DB_HOST}" -u "${MARIADB_USER}" -p"${MARIADB_PASSWORD}"  --silent 2>/dev/null; do
    COUNTER=$((COUNTER + 1))
    if [ $COUNTER -gt $MAX_TRIES ]; then
        echo "ERROR: MariaDB is not responding."
        exit 1
    fi
    echo "MariaDB not ready yet, waiting... (attempt $COUNTER/$MAX_TRIES)"
    sleep 2
done
echo "MariaDB is ready!"

# ========= Wait for Redis ==============
echo "Waiting for Redis to be ready..."

COUNTER=0
until redis-cli -h redis -p 6379 ping 2>/dev/null | grep -q PONG; do
    COUNTER=$((COUNTER + 1))
    if [ $COUNTER -gt $MAX_TRIES ]; then
        echo "ERROR: Redis is not responding. Cannot continue."
        exit 1
    fi
    echo "Redis not ready yet, waiting... (attempt $COUNTER/$MAX_TRIES)"
    sleep 2
done
echo "Redis is ready!"
# ================== ======================

cd /var/www/html

if [ ! -f wp-cli.phar ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

if [ ! -f wp-settings.php ]; then
    ./wp-cli.phar core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    ./wp-cli.phar config create \
        --dbname="${MARIADB_DATABASE}" \
        --dbuser="${MARIADB_USER}" \
        --dbpass="${MARIADB_PASSWORD}" \
        --dbhost="${DB_HOST}" \
        --allow-root
fi


if ! ./wp-cli.phar core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    if echo "${WP_ADMIN_USER}" | grep -iE 'admin|administrator' 2>/dev/null; then
        echo "ERROR: Admin username cannot contain 'admin' or 'administrator"
        echo "Current username: ${WP_ADMIN_USER}"
        exit 1
    fi
    ./wp-cli.phar core install \
    --url="${DOMAIN_NAME}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
    
    echo "Creating additional user..."
    ./wp-cli.phar user create \
    "${WP_USER}" \
    "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role="${WP_USER_ROLE}" \
    --allow-root
else
    echo "WordPress already installed, skipping..."
fi

# ========= Redis Object cache ===============
echo "Configuring Redis cache..."

# Install & activate plugin
if ! ./wp-cli.phar plugin is-installed redis-cache --allow-root; then
    ./wp-cli.phar plugin install redis-cache --activate --allow-root
fi

# Ensure Redis config exists
if ! grep -q "WP_REDIS_HOST" wp-config.php; then
    ./wp-cli.phar config set WP_REDIS_HOST redis --allow-root
    ./wp-cli.phar config set WP_REDIS_PORT 6379 --raw --allow-root
    ./wp-cli.phar config set WP_REDIS_DATABASE 0 --raw --allow-root
fi
# Enable cache
./wp-cli.phar redis enable --allow-root 2>/dev/null || echo "Redis already enabled"

# ============================================

echo "=== WordPress Setup Complete ==="
echo "Starting PHP-FPM..."
exec php-fpm8.4 -F