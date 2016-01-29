#php environment
---
#主机环境
vagrant+vbox
docker

#环境变量
export PATH="$(brew --prefix python3)/bin:$PATH"

for php
echo 'export PATH="$(brew --prefix php55)/bin:$PATH"' >> ~/.bash_profile

for php-fpm
echo 'export PATH="$(brew --prefix php55)/sbin:$PATH"' >> ~/.bash_profile 

for other brew install soft
echo 'export PATH="/usr/local/bin:/usr/local/sbib:$PATH"' >> ~/.bash_profile 



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



##php-fpm配置
测试配置
php-fpm -t
php-fpm -c /usr/local/etc/php/5.5/php.ini -y /usr/local/etc/php/5.5/php-fpm.conf -t
#启动php-fpm
php-fpm -D
php-fpm -c /usr/local/etc/php/5.5/php.ini -y /usr/local/etc/php/5.5/php-fpm.conf -D
#关闭php-fpm
kill -INT `cat /usr/local/var/run/php-fpm.pid`
#重启php-fpm
kill -USR2 `cat /usr/local/var/run/php-fpm.pid`

查看端口
lsof -Pni4 | grep LISTEN | grep php
开机启动
ln -sfv /usr/local/opt/php55/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php55.plist
状态查看
http://www.ttlsa.com/php/use-php-fpm-status-page-detail/

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





