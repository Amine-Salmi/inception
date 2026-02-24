#!/bin/bash
set -e

: "${FTP_USER:?FTP_USER not set}"
: "${FTP_PASS:?FTP_PASS not set}"

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -d /var/www/html -s /bin/bash "${FTP_USER}"
    echo "${FTP_USER}:${FTP_PASS}" | chpasswd
fi

chown -R "$FTP_USER":"$FTP_USER" /var/www/html

if [ -n "${PASV_ADDRESS}" ]; then
    if grep -q '^pasv_address=' /etc/vsftpd/vsftpd.conf; then
        sed -i "s/^pasv_address=.*/pasv_address=${PASV_ADDRESS}/" /etc/vsftpd/vsftpd.conf
    else
        echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf
    fi
fi

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf