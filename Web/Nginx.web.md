#nginx
---
#docs
lnmp http://blog.csdn.net/mervyn1205/article/details/8054881

---
#setup
##mac
brew install nginx --with-http_geoip_module
brew install nginx
/usr/local/bin/nginx
/usr/local/etc/nginx/nginx.conf
```
监听80需要root权限
sudo chown root:wheel /usr/local/Cellar/nginx/1.6.2/bin/nginx
sudo chmod u+s /usr/local/Cellar/nginx/1.6.2/bin/nginx
```
nginx -V 查看版本，以及配置文件地址
nginx -v 查看版本
nginx -c filename 指定配置文件
nginx -h 帮助
nginx -s [reload\reopen\stop\quit]


/usr/sbin/php-fpm
brew options homebrew/php/php55
/usr/local/etc/php/5.5/php.ini
/usr/local/etc/php/5.5/php-fpm.conf
php-fpm -p /private


##ubuntu
sudo apt-get install nginx
sudo /etc/init.d/nginx start(或者 service nginx start)
sudo service nginx restart
###fpm
sudo apt-get install php5-fpm
/etc/php5/fpm/pool.d/www.conf
/var/log/php5-fpm.log
sudo service php5-fpm start
sudo service php5-fpm restart
###curl
sudo apt-get install php5-curl
sudo apt-get install php-gettext
sudo apt-get install php5-gd
sudo apt-get install php5-mcrypt
sudo apt-get install memcached
###php
sudo apt-get install php5-cli php5-cgi php5-mysql
sudo apt-get install php5-memcache
sudo apt-get install php5-dev php-pear libpcre3-dev
sudo pecl install oauth
sudo vi /etc/php5/fpm/php.ini
extension=oauth.so
## ssh2
sudo apt-get install libssh2-php
## xdebug
sudo apt-get install php5-xdebug
sudo vi /etc/php5/fpm/php.ini 
将display_errors和html_errors都改为On

#cmd-nginx
* 测试配置是否有语法错误 校验
```
nginx -t
```
* 打开 nginx, 
```
sudo nginx
```
* 重新加载配置|重启|停止|退出
```
nginx -s reload|reopen|stop|quit
```

---
#配置
Nginx开机启动
```
ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist     #启动
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist   #关闭
```

##alias快捷启动命令
alias nginx.start='launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx.stop='launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx.restart='nginx.stop && nginx.start'


##目录
```
mkdir -p /usr/local/var/logs/nginx
mkdir -p /usr/local/etc/nginx/sites-available
mkdir -p /usr/local/etc/nginx/sites-enabled
mkdir -p /usr/local/etc/nginx/conf.d
mkdir -p /usr/local/etc/nginx/ssl
sudo mkdir -p /var/www
sudo chown :staff /var/www
sudo chmod 775 /var/www
```
##nginx.conf
```
vim /usr/local/etc/nginx/nginx.conf
worker_processes  1;
error_log  /usr/local/var/logs/nginx/error.log debug;
pid        /usr/local/var/run/nginx.pid;
events {
    worker_connections  256;
}
http {
    include      mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /usr/local/var/logs/access.log  main;

    sendfile        on;
    keepalive_timeout  65;
    port_in_redirect off;

    include /usr/local/etc/nginx/sites-enabled/*;
}
```

##php-fpm配置文件
```
vim /usr/local/etc/nginx/conf.d/php-fpm
location ~ \.php$ {
    try_files                  $uri = 404;
    fastcgi_pass                127.0.0.1:9000;
    fastcgi_index              index.php;
    fastcgi_intercept_errors    on;
    include /usr/local/etc/nginx/fastcgi.conf;
}
```



##虚拟主机
```
#创建 info.php index.html 404.html 403.html文件到 /var/www 下面
vi /var/www/info.php
vi /var/www/index.html
vi /var/www/403.html
vi /var/www/404.html
```
vim /usr/local/etc/nginx/sites-available/default
```
server {
    listen      80;
    server_name  localhost;
    root        /var/www/;

    access_log  /usr/local/var/logs/nginx/default.access.log  main;

    location / {
        index  index.html index.htm index.php;
        autoindex  on;
        include    /usr/local/etc/nginx/conf.d/php-fpm;
    }

    location = /info {
        allow  127.0.0.1;
        deny    all;
        rewrite (.*) /.info.php;
    }

    error_page  404    /404.html;
    error_page  403    /403.html;
}
```
vim /usr/local/etc/nginx/sites-available/default-ssl
```
server {
    listen      443;
    server_name  localhost;
    root      /var/www/;

    access_log  /usr/local/var/logs/nginx/default-ssl.access.log  main;

    ssl                  on;
    ssl_certificate      ssl/localhost.crt;
    ssl_certificate_key  ssl/localhost.key;

    ssl_session_timeout  5m;

    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    location / {
        include  /usr/local/etc/nginx/conf.d/php-fpm;
    }

    location = /info {
        allow  127.0.0.1;
        deny    all;
        rewrite (.*) /.info.php;
    }

    error_page  404    /404.html;
    error_page  403    /403.html;
}
```

##phpadmin
vim /usr/local/etc/nginx/sites-available/phpmyadmin #输入以下配置
```
server {
    listen      306;
    server_name  localhost;
    root    /usr/local/share/phpmyadmin;

    error_log  /usr/local/var/logs/nginx/phpmyadmin.error.log;
    access_log  /usr/local/var/logs/nginx/phpmyadmin.access.log main;

    ssl                  on;
    ssl_certificate      ssl/phpmyadmin.crt;
    ssl_certificate_key  ssl/phpmyadmin.key;

    ssl_session_timeout  5m;

    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    location / {
        index  index.html index.htm index.php;
        include  /usr/local/etc/nginx/conf.d/php-fpm;
    }
}
```

##ssl配置
```
mkdir -p /usr/local/etc/nginx/ssl
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=phpmyadmin" -keyout /usr/local/etc/nginx/ssl/phpmyadmin.key -out /usr/local/etc/nginx/ssl/phpmyadmin.crt
```

##rewrite配置
http://wiki.nginx.org/HttpRewriteModule

##增加虚拟主机
```
vim $NSITE/xxx
ln -sfv /usr/local/etc/nginx/sites-available/xxx /usr/local/etc/nginx/sites-enabled/xxx
ln -sfv /usr/local/etc/nginx/sites-available/lblog /usr/local/etc/nginx/sites-enabled/lblog
ln -sfv /usr/local/etc/nginx/sites-available/sport /usr/local/etc/nginx/sites-enabled/sport
nginx.restart
```






