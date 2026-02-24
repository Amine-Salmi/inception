FROM debian:stable-slim

RUN apt-get update && apt-get install -y vsftpd

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY tools/ftp_script.sh /usr/local/bin/ftp_script.sh
RUN chmod +x /usr/local/bin/ftp_script.sh

EXPOSE 21  30000-30009

CMD ["/usr/local/bin/ftp_script.sh"]