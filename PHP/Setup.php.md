#php environment
---
#主机环境
vagrant+vbox
docker


php.ini
```bash
#超时时间
max_execution_time = 10

```
#环境变量
export PATH="$(brew --prefix python3)/bin:$PATH"

for php
echo 'export PATH="$(brew --prefix php55)/bin:$PATH"' >> ~/.bash_profile

for php-fpm
echo 'export PATH="$(brew --prefix php55)/sbin:$PATH"' >> ~/.bash_profile 

for other brew install soft
echo 'export PATH="/usr/local/bin:/usr/local/sbib:$PATH"' >> ~/.bash_profile 


#command
##ubuntu
```bash
service php5-fpm status
service php5-fpm start
service php5-fpm restart
service php5-fpm reload
```


#setup
##mac
mac os 官方 安装文档 http://php.net/manual/zh/install.macosx.php
手动编译问题列表 http://www.cnlvzi.com/index.php/Index/article/id/143
brew安装步骤：
brew update
brew tap homebrew/dupes
brew tap josegonzalez/homebrew-php
brew install php55 --with-fpm --with-gmp --with-imap --with-tidy --with-debug --with-apache --with-homebrew-curl --with-phpdbg

php扩展安装
brew install php55-apcu\
 php55-gearman\
 php55-geoip\
 php55-gmagick\
 php55-imagick\
 php55-mcrypt\
 php55-memcache\
 php55-memcached\
 php55-mongo\
 php55-pdo-pgsql\
 php55-phalcon\
 php55-redis\
 php55-sphinx\
 php55-swoole\
 php55-uuid\
 php55-xdebug;

php55-intl\
 php55-opcache\

##Q:
- --with-pgsql
Error: No such file or directory - pg_config
./configure --prefix=/usr/local/Cellar/php55/5.5.18 --localstatedir=/usr/local/var --sysconfdir=/usr/local/etc/php/5.5
- --with-mysql   --with-libmysql
configure: error: Cannot find MySQL header files under /usr/local.
Note that the MySQL client library is not bundled anymore!
完成  /usr/local/Cellar/php55/5.5.18


---
#php.ini
memory_limit = 1G

##错误显示
error_reporting(E_ALL ^ E_DEPRECATED);



#php-fpm配置
##测试配置
php-fpm -t
php-fpm -c /usr/local/etc/php/5.5/php.ini -y /usr/local/etc/php/5.5/php-fpm.conf -t
##启动php-fpm
php-fpm -D
php-fpm -c /usr/local/etc/php/5.5/php.ini -y /usr/local/etc/php/5.5/php-fpm.conf -D
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist
brew services restart php55
##关闭php-fpm
kill -INT `cat /usr/local/var/run/php-fpm.pid`
##重启php-fpm
kill -USR2 `cat /usr/local/var/run/php-fpm.pid`


##开机启动
ln -sfv /usr/local/opt/php55/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php55.plist


##Thread Safe 和 Non Thread Safe 版本
先从字面意思上理解，Thread Safe 是线程安全，执行时会进行线程（Thread）安全检查，以防止有新要求就启动新线程的 CGI 执行方式而耗尽系统资源。Non Thread Safe 是非线程安全，在执行时不进行线程（Thread）安全检查。

再来看 PHP 的两种执行方式：ISAPI 和 FastCGI。

ISAPI 执行方式是以 DLL 动态库的形式使用，可以在被用户请求后执行，在处理完一个用户请求后不会马上消失，所以需要进行线程安全检查，这样来提高程序的执行效率，所以如果是以 ISAPI 来执行 PHP，建议选择 Thread Safe 版本；

而 FastCGI 执行方式是以单一线程来执行操作，所以不需要进行线程的安全检查，除去线程安全检查的防护反而可以提高执行效率，所以，如果是以 FastCGI 来执行 PHP，建议选择 Non Thread Safe 版本。

再来看PHP的两种执行方式：ISAPI和FastCGI。

FastCGI执行方式是以单一线程来执行操作，所以不需要进行线程的安全检查，除去线程安全检查的防护反而可以提高执行效率，所以，如果是以 FastCGI（无论搭配 IIS 6 或 IIS 7）执行 PHP ，都建议下载、执行 non-thread safe 的 PHP （PHP 的二进位档有两种包装方式：msi 、zip ，请下载 zip 套件）。

而线程安全检查正是为ISAPI方式的PHP准备的，因为有许多php模块都不是线程安全的，所以需要使用Thread Safe的PHP。

所以，对于PHP5.2选择Thread Safe版本安装，而对于PHP5.3则下载None-Thread Safe，执行PHP比较有效率。



---
#php扩展安装
phpize
./configure
make
/usr/lib/php/extensions/no-debug-non-zts-20121212/ mcrypt.so

gd库安装
./configure --with-zlib-dir=/usr/local --with-jpeg-dir=/usr/local/lib --with-png-dir=/usr/local/lib --with-freetype-dir=/usr/local/lib
gd扩展编译
./configure  -with-jpeg=/usr/local --with-png=/usr/local --with-freetype=/usr/local --with-zlib=/usr/local --with-gd=/usr/local

---
#composer
brew install composer
composer —version
export PATH="$(brew --prefix composer)/bin:$PATH”





