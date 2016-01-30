#memcache
---
memcached -d -m 50 -p 11211 -u root


[在Mac OS X中完善PHP环境：memcache、mcrypt、igbinary](http://www.tuicool.com/articles/mIZzMz)


Installing shared extensions:     /usr/lib/php/extensions/no-debug-non-zts-20100525/
usr/lib/php/extensions/no-debug-non-zts-20100525/

memcached -d -m 512 -l localhost -p 12000 -u root
-p 指定端口号（默认11211）
-m 指定最大使用内存大小（默认64MB）
-t 线程数（默认4）
-l 连接的IP地址, 默认是本机
-d start 启动memcached服务
-d restart 重起memcached服务
-d stop|shutdown 关闭正在运行的memcached服务
-m 最大内存使用，单位MB。默认64MB
-M 内存耗尽时返回错误，而不是删除项
-c 最大同时连接数，默认是1024
-f 块大小增长因子，默认是1.25
-n 最小分配空间，key+value+flags默认是48

例如：/home/memcache/bin/memcached -d -m 1024 -u root -l 192.168.1.123 -p 1121 -c 512 -P /tmp/memcached.pid

重启：先kill -9 掉进程，再执行启动相关参数的memcache

memcached -d -m 512 -u root -l localhost -p 11211 -c 512
