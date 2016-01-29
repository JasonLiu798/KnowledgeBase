#tomcat
JAVA_HOME，CATALINA_HOME
## user & permission
tomcat-users.xml 
<tomcat-users>
  <role rolename="manager"/>
  <role rolename="admin"/>
  <user username="admin" password="xxzx2012" roles="admin,manager"/>
</tomcat-users>

##　虚拟目录配置
Server.xml中<Host>之上
<Context path="/demo" docBase="D:\">

## 中文乱码
Server.xml

    <Connector>添加URIEncoding="UTF-8"
    <Connector port="80" protocol="HTTP/1.1"
                   connectionTimeout="20000"
                   redirectPort="8443"
                   URIEncoding="UTF-8"/>

## 自动加载
context.xml
<Context>改为<Context reloadable="true">
目的：Tomcat识别新修改的文件，自动重新加载web应用
注：修改后对运行性能有影响，产品阶段改为
<Context reloadable="false">

## 列出目录下所有文件，开发阶段
web.xml
<init-param>
      <param-name>listings</param-name>
      <param-value>true</param-value>
</init-param>

---
#xampp
start&stop server
start   启动 XAMPP。
stop    停止 XAMPP。
restart     重新启动 XAMPP。
startapache     只启动 Apache。
startssl    启动 Apache 的 SSL 支持。该命令将持续激活 SSL 支持，例如：执行该命令后，如果您关闭并重新启动 XAMPP，SSL 仍将处于激活状态。
startmysql  只启动 MySQL 数据库。
startftp    启动 ProFTPD 服务器。通过 FTP，您可以上传文件到您的网络服务器中（用户名“nobody”，密码“lampp”）。该命令将持续激活 ProFTPD，例如：执行该命令后，如果您关闭并重新启动 XAMPP，FTP 仍将处于激活状态。
stopapache  停止 Apache。
stopssl     停止 Apache 的 SSL 支持。该命令将持续停止 SSL 支持，例如：执行该命令后，如果您关闭并重新启动 XAMPP，SSL 仍将处于停止状态。
stopmysql   停止 MySQL 数据库。
stopftp     停止 ProFTPD 服务器。该命令将持续停止 ProFTPD，例如：执行该命令后，如果您关闭并重新启动 XAMPP，FTP 仍将处于停止状态。
security    启动一个小型安全检查程序。

---
#mysql
sudo apt-get install mysql-server  mysql-client  libmysqlclient-dev
方式一：sudo /etc/init.d/mysql start 
方式二：sudo start mysql
方式三：sudo service mysql start

方式一：sudo /etc/init.d/mysql stop 
方式二：sudo stop mysql
方式san：sudo service mysql stop

方式一：sudo/etc/init.d/mysql restart
方式二：sudo restart mysql
方式三：sudo service mysql restart

###password
mysql -u root
use mysql
update user set password=PASSWORD('root') where user='root';
flush privileges;
quit
###root remote access
####a change table
mysql -h 10.185.3.239 -u root –p root
mysql -u root –p
mysql>use mysql;
mysql>update user set host = '%' where user = 'root';
mysql>select host, user from user;
####b grant privilage
mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.185.8.159' IDENTIFIED BY 'root' WITH GRANT OPTION;


---
#nginx
lnmp http://blog.csdn.net/mervyn1205/article/details/8054881
sudo apt-get install nginx
sudo /etc/init.d/nginx start(或者 service nginx start)
sudo service nginx restart

##/etc/nginx.conf


##/etc/nginx/sites-enabled
sudo vi /etc/nginx/sites-enabled
server{
    listen 80;
    root /var/www;
    index index.php index.html index.htm;
    server_name localhost;
    location / {
        try_files $uri $uri/ /index.html;
    }
    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /var/www$fastcgi_script_name;
        include /etc/nginx/fastcgi_params;
    }
}


---
#php
sudo apt-get install php5-cli php5-cgi php5-mysql
#fpm
sudo apt-get install php5-fpm
/etc/php5/fpm/pool.d/www.conf
/var/log/php5-fpm.log
sudo service php5-fpm start
sudo service php5-fpm restart

#curl
sudo apt-get install php5-curl
sudo apt-get install php-gettext
sudo apt-get install php5-gd
sudo apt-get install php5-mcrypt
sudo apt-get install memcached
$ memcached -d -m 50 -p 11211 -u root
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




---
#mysql
###password
mysql -u root
use mysql
update user set password=PASSWORD('root') where user='root';
flush privileges;
quit

###root remote access
####a change table
mysql -u root –p
mysql>use mysql;
mysql>update user set host = '%' where user = 'root';
mysql>select host, user from user;
####b grant privilage
mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
mysql>GRANT ALL PRIVILEGES ON *.* TO 'jack'@'10.10.50.127' IDENTIFIED BY '654321' WITH GRANT OPTION;

###charset
show variables like 'character%';
show variables like 'collation%';
character_set_client 
character_set_connection
character_set_database
character_set_results
character_set_server

SET NAMES 'utf8';
equals three below
SET character_set_client = utf8;
SET character_set_results = utf8;
SET character_set_connection = utf8;

###character_set_database
create database name character set utf8;
alter database name character set utf8;

###character table
CREATE TABLE `type` (
`id` int(10) unsigned NOT NULL auto_increment,
`flag_deleted` enum('Y','N') character set utf8 NOT NULL default 'N',
`flag_type` int(5) NOT NULL default '0',
`type_name` varchar(50) character set utf8 NOT NULL default '',
PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;
alter table type character set utf8;
#### change term
alter table type modify type_name varchar(50) CHARACTER SET utf8;


#域名
godaddy
https://www.godaddy.com/










