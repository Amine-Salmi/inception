#!/bin/bash
set -e

ADMINER_DIR="/var/www/html"
ADMINER_FILE="${ADMINER_DIR}/index.php"

mkdir -p "${ADMINER_DIR}"

if [ ! -f "${ADMINER_FILE}" ]; then
    echo "Downloading Adminer..."
    wget -q -O "${ADMINER_FILE}" \
        "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php"
fi

echo "Starting Adminer on :8080"
exec php -S 0.0.0.0:8080 -t "${ADMINER_DIR}"