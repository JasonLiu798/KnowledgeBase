#apache
---
#setup
use XAMP
```
yum install httpd
yum install php

/etc/httpd/conf/httpd.conf
找到AddType处，并添加以下2行：
AddType application/x-httpd-php .php .php3 .phtml .inc
AddType application/x-httpd-php-source .phps

vi /etc/php.ini
更改以下指令为：
register_globals = On

LoadModule php5_module
```

---
#配置
开机不启动
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
开机启动
sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist
unload之后，立刻就发现apache已经无法启动了。
##Virtual hosts
Include /private/etc/apache2/extra/httpd-vhosts.conf
/private/etc/apache2/extra/httpd-vhosts.conf
```
<VirtualHost *:80>
    DocumentRoot /Library/WebServer/Documents/lblog/public
    ServerName www.lblog.com
</VirtualHost>
```

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
#lamp
##setup
rpm -e  --nodeps --allmatches
libpng
##GD
./configure \  //配置命令
--prefix=/usr/local/gd \  //指定安装软件的位置
--with-jpeg=/usr/local/jpeg8/ \  //指定去哪找jpeg库文件
--with-png=/usr/local/libpng/ \  //指定去哪找png库文件
--with-freetype=/usr/local/freetype/   //指定去哪找freetype 2.x字体库的位置
configure.ac:64: error: possibly undefined macro: AM_ICONV，得到“But you need to have gettext”没有gettext这个包。（）
到http://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.1.1.tar.gz
tar xzfgettext-0.18.1.1.tar.gzcdgettext-0.17
./configure
make && make install

##usage
```bash
#启动 XAMPP
./lampp start
#停止 XAMPP
./lampp stop
#重启 XAMPP
./lampp restart
#安全设置
./lampp security
#卸载 XAMPP
rm -rf /opt/lampp
```
##远程访问
httpd-xampp.conf(/opt/lampp/etc/extra/httpd-xampp.conf)文件
```
# New XAMPP security concept
Order deny,allow
Deny from all
Allow from ::1 127.0.0.0/8 \
fc00::/7 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 \
81.196.40.94/32
ErrorDocument 403 /error/XAMPP_FORBIDDEN.html.var
```
把 Deny from all 注释掉     
PS：编辑配置文件时最好先备份，下载到本地用dw编辑保存上传！最好不要用leapFTP自带的内部编辑器，容易出错！！
完成之后保存退出，需要重启lampp (/opt/lampp/lampp restartapache)
重启后就可以远程登录xampp了，默认的管理员的用户名是lampp，密码是自己在security时设置的






---
#wamp
403错误
一，Apache部分：
路径：/wamp/bin/apache/Apache2.2.21/conf/httpd.conf
将所有Directory段内的deny条件都修改为allow from all
二，phpmyadmin部分：
路径：/wamp/alias/phpmyadmin.conf
同理，将deny条件修改为allow from all
最后重启所有服务，问题解决




