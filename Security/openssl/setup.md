

配置找不到
set OPENSSL_CONF=c:/libs/openssl-0.9.8k/openssl.cnf


https://stackoverflow.com/questions/7360602/openssl-and-error-in-reading-openssl-conf-file


openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout nginx.key -out nginx.crt

openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
