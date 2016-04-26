#Redis
---
#文档
[JIMDB：一个大规模分布式内存存储的演进之路](http://www.infoq.com/cn/articles/JMDB-liuhaifeng)
[Redis GEO 特性简介](http://blog.huangz.me/diary/2015/redis-geo.html)

---
#setup


##mac环境
```bash
brew --prefix redis /
/usr/local/Cellar/redis/2.8.17
```
配置重启命令
```bash
alias redis.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias redis.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias redis.restart='redis.stop && redis.start'
```

##linux

---
#配置
Port           : 6379
Config file    : /etc/redis/6379.conf
Log file       : /var/log/redis_6379.log
Data dir       : /var/lib/redis/6379
Executable     : /usr/local/bin
Cli Executable : /usr/local/redis-cli

##redis.conf
```
daemonize yes

pidfile
pidfile /var/run/redis.pid        

logfile
logfile "/opt/logs/redis.log"       

数据库数量
databases 16                        

保存快照的频率，第一个*表示多长时间，第三个*表示执行多少次写操作。在一定时间内执行一定数量的写操作时，自动保存快照。可设置多个条件
save * *           
```

##自启动
```bash
To have launchd start redis at login:
ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
Then to load redis now:
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
```
Or, if you don't want/need launchctl, you can just run:
```bash
redis-server /usr/local/etc/redis.conf
```



---
#常用
##启动
redis-server /etc/redis/redis.conf
redis-cli -h [ip] -p [port]
auth    简单密码认证

## delete data
flushall
flushdb

---
#value 相关
exists(key)：确认一个key是否存在
del(key)：删除一个key
type(key)：返回值的类型
keys(pattern)：返回满足给定pattern的所有key
randomkey：随机返回key空间的一个key
rename(oldname, newname)：将key由oldname重命名为newname，若newname存在则删除newname表示的key
dbsize：返回当前数据库中key的数目
expire：设定一个key的活动时间（s）
ttl：获得一个key的活动时间
select(index)：按索引查询
move(key, dbindex)：将当前数据库中的key转移到有dbindex索引的数据库
flushdb：删除当前选择数据库中的所有key
flushall：删除所有数据库中的所有key

---
#String
set(key, value)：给数据库中名称为key的string赋予值value
get(key)：返回数据库中名称为key的string的value
getset(key, value)：给名称为key的string赋予上一次的value
mget(key1, key2,…, key N)：返回库中多个string（它们的名称为key1，key2…）的value
setnx(key, value)：如果不存在名称为key的string，则向库中添加string，名称为key，值为value
setex(key, time, value)：向库中添加string（名称为key，值为value）同时，设定过期时间time
mset(key1, value1, key2, value2,…key N, value N)：同时给多个string赋值，名称为key i的string赋值value i
msetnx(key1, value1, key2, value2,…key N, value N)：如果所有名称为key i的string都不存在，则向库中添加string，名称key i赋值为value i
incr(key)：名称为key的string增1操作
incrby(key, integer)：名称为key的string增加integer
decr(key)：名称为key的string减1操作
decrby(key, integer)：名称为key的string减少integer
append(key, value)：名称为key的string的值附加value
substr(key, start, end)：返回名称为key的string的value的子串

-----
#List
##查看
lrange(key, start, end)
返回名称为key的list中start至end之间的元素（下标从0开始，下同）
ltrim(key, start, end)
截取名称为key的list，保留start至end之间的元素
llen(key)
返回名称为key的list的长度
lindex(key, index)
返回名称为key的list中index位置的元素
##添加
rpush(key, value)：在名称为key的list尾添加一个值为value的元素
lpush(key, value)：在名称为key的list头添加一个值为value的 元素
##修改
lset(key, index, value)：给名称为key的list中index位置的元素赋值为value
##删除
lrem(key, count, value)
删除count个名称为key的list中值为value的元素。count为0，删除所有值为value的元素，count>0从头至尾删除count个值为value的元素，count<0从尾到头删除|count|个值为value的元素

lpop(key)
返回并删除名称为key的list中的首元素

rpop(key)
返回并删除名称为key的list中的尾元素

blpop(key1, key2,… key N, timeout)
lpop命令的block版本。即当timeout为0时，若遇到名称为key i的list不存在或该list为空，则命令结束。如果timeout>0，则遇到上述情况时，等待timeout秒，如果问题没有解决，则对keyi+1开始的list执行pop操作
brpop(key1, key2,… key N, timeout)
rpop的block版本。参考上一命令
rpoplpush(srckey, dstkey)
返回并删除名称为srckey的list的尾元素，并将该元素添加到名称为dstkey的list的头部

##Set操作的命令
sadd(key, member)：向名称为key的set中添加元素member
srem(key, member) ：删除名称为key的set中的元素member
spop(key) ：随机返回并删除名称为key的set中一个元素
smove(srckey, dstkey, member) ：将member元素从名称为srckey的集合移到名称为dstkey的集合
scard(key) ：返回名称为key的set的基数
sismember(key, member) ：测试member是否是名称为key的set的元素
sinter(key1, key2,…key N) ：求交集
sinterstore(dstkey, key1, key2,…key N) ：求交集并将交集保存到dstkey的集合
sunion(key1, key2,…key N) ：求并集
sunionstore(dstkey, key1, key2,…key N) ：求并集并将并集保存到dstkey的集合
sdiff(key1, key2,…key N) ：求差集
sdiffstore(dstkey, key1, key2,…key N) ：求差集并将差集保存到dstkey的集合
smembers(key) ：返回名称为key的set的所有元素
srandmember(key) ：随机返回名称为key的set的一个元素

---
##zset （sorted set）
###zadd(key, score, member)
向名称为key的zset中添加元素member，score用于排序。如果该元素已经存在，则根据score更新该元素的顺序。
###zrem(key, member)
删除名称为key的zset中的元素member
###zincrby(key, increment, member)
如果在名称为key的zset中已经存在元素member，则该元素的score增加increment；否则向集合中添加该元素，其score的值为increment
###zrank(key, member)
返回名称为key的zset（元素已按score从小到大排序）中member元素的rank（即index，从0开始），若没有member元素，返回“nil”
###zrevrank(key, member)
返回名称为key的zset（元素已按score从大到小排序）中member元素的rank（即index，从0开始），若没有member元素，返回“nil”
###zrange(key, start, end)
返回名称为key的zset（元素已按score从小到大排序）中的index从start到end的所有元素
###zrevrange(key, start, end)
返回名称为key的zset（元素已按score从大到小排序）中的index从start到end的所有元素
###zrangebyscore(key, min, max)
返回名称为key的zset中score >= min且score <= max的所有元素
###zcard(key)
返回名称为key的zset的基数 
###zscore(key, element)
返回名称为key的zset中元素element的score 
###zremrangebyrank(key, min, max)
删除名称为key的zset中rank >= min且rank <= max的所有元素 
###zremrangebyscore(key, min, max) 
删除名称为key的zset中score >= min且score <= max的所有元素
###zunionstore / zinterstore(dstkeyN, key1,…,keyN, WEIGHTS w1,…wN, AGGREGATE SUM|MIN|MAX)
对N个zset求并集和交集，并将最后的集合保存在dstkeyN中。对于集合中每一个元素的score，在进行AGGREGATE运算前，都要乘以对于的WEIGHT参数。如果没有提供WEIGHT，默认为1。默认的AGGREGATE是SUM，即结果集合中元素的score是所有集合对应元素进行SUM运算的值，而MIN和MAX是指，结果集合中元素的score是所有集合对应元素中最小值和最大值。


##Hash操作的命令
hset(key, field, value)：向名称为key的hash中添加元素field<—>value
hget(key, field)：返回名称为key的hash中field对应的value
hmget(key, field1, …,field N)：返回名称为key的hash中field i对应的value
hmset(key, field1, value1,…,field N, value N)：向名称为key的hash中添加元素field i<—>value i
hincrby(key, field, integer)：将名称为key的hash中field的value增加integer
hexists(key, field)：名称为key的hash中是否存在键为field的域
hdel(key, field)：删除名称为key的hash中键为field的域
hlen(key)：返回名称为key的hash中元素个数
hkeys(key)：返回名称为key的hash中所有键
hvals(key)：返回名称为key的hash中所有键对应的value
hgetall(key)：返回名称为key的hash中所有的键（field）及其对应的value


##二进制位数组
bitcount 实现方法：
遍历法O(n)
查表法，受限于表大小，cpu缓存限制
variable-precision SWAR算法


##持久化
save：将数据同步保存到磁盘
bgsave：将数据异步保存到磁盘
lastsave：返回上次成功将数据保存到磁盘的Unix时戳
shundown：将数据同步保存到磁盘，然后关闭服务

##远程服务控制
info        提供服务器的信息和统计
monitor     实时转储收到的请求
slaveof     改变复制策略设置
config      在运行时配置Redis服务器


---
#慢查询日志
showlog-log-slower-than 指定执行时间超过多少微妙会被记录到日志
showlog-max-len 循环写大小



---
#事务
[Redis学习手册(事务)](http://www.cnblogs.com/stephen-liu74/archive/2012/03/28/2357783.html)
[redis分布式锁-SETNX实现](http://my.oschina.net/u/1995545/blog/366381)
[Redis数据库高级实用特性：事务控制](http://tech.it168.com/a2012/0730/1378/000001378719_1.shtml)

命令原型   |时间复杂度|    命令描述       |    返回值
----------|--------|------------------|----------
MULTI     |  |  用于标记事务的开始，其后执行的命令都将被存入命令队列，直到执行EXEC时，这些命令才会被原子的执行。 | 始终返回OK
EXEC      |  |  执行在一个事务内命令队列中的所有命令，同时将当前连接的状态恢复为正常状态，即非事务状态。如果在事务中执行了WATCH命令，那么只有当WATCH所监控的Keys没有被修改的前提下，EXEC命令才能执行事务队列中的所有命令，否则EXEC将放弃当前事务中的所有命令。 | 原子性的返回事务中各条命令的返回结果。如果在事务中使用了WATCH，一旦事务被放弃，EXEC将返回NULL-multi-bulk回复。
DISCARD   |  |  回滚事务队列中的所有命令，同时再将当前连接的状态恢复为正常状态，即非事务状态。如果WATCH命令被使用，该命令将UNWATCH所有的Keys。 | 始终返回OK。
WATCH key [key ...] | O(1) |   在MULTI命令执行之前，可以指定待监控的Keys，然而在执行EXEC之前，如果被监控的Keys发生修改，EXEC将放弃执行该事务队列中的所有命令。 |  始终返回OK。
UNWATCH   |O(1)|   取消当前事务中指定监控的Keys，如果执行了EXEC或DISCARD命令，则无需再手工执行该命令了，因为在此之后，事务中所有被监控的Keys都将自动取消。 |  始终返回OK。

##Redis乐观锁实例
[Redis乐观锁实例](http://tech.it168.com/a2012/0730/1378/000001378719_1.shtml)
Session 1                           |       Session 2
(1)第1步
redis 127.0.0.1:6379> get age
"10"
redis 127.0.0.1:6379> watch age
OK
redis 127.0.0.1:6379> multi
OK
redis 127.0.0.1:6379>
                                            (2)第2步
                                            redis 127.0.0.1:6379> set age 30
                                            OK
                                            redis 127.0.0.1:6379> get age
                                            "30"
                                            redis 127.0.0.1:6379>
(3)第3步
redis 127.0.0.1:6379> set age 20
QUEUED
redis 127.0.0.1:6379> exec
(nil)
redis 127.0.0.1:6379> get age
"30"
redis 127.0.0.1:6379>

第一步，Session 1 还没有来得及对age的值进行修改
第二步，Session 2 已经将age的值设为30
第三步，Session 1 希望将age的值设为20，但结果一执行返回是nil，说明执行失败，之后我们再取一下age的值是30，这是由于Session 1中对age加了乐观锁导致的。
PS:
redis的事务实现是如此简单，当然会存在一些问题。第一个问题是redis只能保证事务的每个命令连续执行，但是如果事务中的一个命令失败了，并不回滚其他命令，比如使用的命令类型不匹配



---
#dev
https://github.com/xetorthio/jedis/wiki

[Redis几个认识误区](http://timyang.net/data/redis-misunderstanding/) 
性能：memcache的Libevent,CAS问题
Redis用libevent中两个文件修改实现了自己的epoll event loop(4)
redis自己实现VM，主要OS的VM换入换出是基于Page概念，无法控制粒度，另外访问操作系统SWAP内存区域时block进程

##数据结构选择
###建议使用hashset而不是set/get的方式来使用Redis
[Full of keys(Salvatore antirez Sanfilippo)](http://oldblog.antirez.com/post/redis-weekly-update-7.html)

##监控
https://github.com/LittlePeng/redis-monitor



---
#集群
[benchamark，集群方案概览](http://www.cnblogs.com/lulu/archive/2013/06/10/3130878.html)
http://redis.io/topics/cluster-spec

#twemproxy
[github](https://github.com/twitter/twemproxy)
[Redis Command Support](https://github.com/twitter/twemproxy/blob/master/notes/redis.md)
[Hash Tags](https://github.com/twitter/twemproxy/blob/master/notes/recommendation.md#hash-tags)
##配置
打开debug日志 编译增加 --enable-debug=log 
mbuf：zero copy
    --mbuf-size=N
    small mbuf allows us to handle more connections，并发高
    large mbuf allows us to read and write more data to and from kernel socket buffers，单个连接读写效率高


## keepalived
http://heylinux.com/archives/1942.html

##redis自带集群
[redis 3.0](http://blog.csdn.net/myrainblues/article/details/25881535)

### 主从配置
master:namenode:6379
slave1:datanode1
slave2:datanode2

slave1:/etc/redis_slave.conf
slaveof namenode 6379


## 分布式
架构细节：
* 所有的redis节点彼此互联(PING-PONG机制),内部使用二进制协议优化传输速度和带宽.
* 节点的fail是通过集群中超过半数的节点检测失效时才生效.
* 客户端与redis节点直连,不需要中间proxy层.客户端不需要连接集群所有节点,连接集群中任何一个可用节点即可
* redis-cluster把所有的物理节点映射到[0-16383]slot上,cluster 负责维护node<->slot<->value













---
#setup
##cygwin
[Windows 7 64位下编译Redis-2.8.3/Redis-3.0.1](http://my.oschina.net/maxid/blog/186506)
下载Redis，对Redis进行适当修改

下载：
$ wget http://download.redis.io/releases/redis-2.8.3.tar.gz
$ tar -zxvf redis-2.8.3.tar.gz
$ cd redis-2.8.3
若要顺利编译，需要对redis.h进行修改：

$ vi src/redis.h
在第一个#define前增加以下代码，解决"debug.c: 790:37: error: 'SA_ONSTACK' undeclared (first use in this function)"错误
```
/* Cygwin Fix */   
#ifdef __CYGWIN__   
#ifndef SA_ONSTACK   
#define SA_ONSTACK 0x08000000   
#endif   
#endif
```
注：redis-2.8.3只需要进行上述修改即可顺利编译, redis-3.0.1 需要更新net.c文件，如下:

vi /deps/hiredis/net.c
在 #include "sds.h"后增加以下代码
```
/* Cygwin Fix */   
#ifdef __CYGWIN__
#define TCP_KEEPCNT 8
#define TCP_KEEPINTVL 150
#define TCP_KEEPIDLE 14400
#endif
```
4. 编译与运行

先编译依赖包

$ cd deps
$ make lua hiredis linenoise
$ cd ..
然后编译主项目

$ make && make install

###Q
/usr/include/netinet/tcp.h:54:2: error: unknown type name ‘u_short’

http://comments.gmane.org/gmane.comp.gnu.config.patches/55

[Build in Cygwin environment #341](https://github.com/acplt/open62541/issues/341)
$ gcc -v
使用内建 specs。
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-pc-cygwin/4.9.3/lto-wrapper.exe
目标：x86_64-pc-cygwin
配置为：/cygdrive/i/szsz/tmpp/gcc/gcc-4.9.3-1.x86_64/src/gcc-4.9.3/configure --srcdir=/cygdrive/i/szsz/tmpp/gcc/gcc-4.9.3-1.x86_64/src/gcc-4.9.3 --prefix=/usr --exec-prefix=/usr --localstatedir=/var --sysconfdir=/etc --docdir=/usr/share/doc/gcc --htmldir=/usr/share/doc/gcc/html -C --build=x86_64-pc-cygwin --host=x86_64-pc-cygwin --target=x86_64-pc-cygwin --without-libiconv-prefix --without-libintl-prefix --libexecdir=/usr/lib --enable-shared --enable-shared-libgcc --enable-static --enable-version-specific-runtime-libs --enable-bootstrap --enable-__cxa_atexit --with-dwarf2 --with-tune=generic --enable-languages=ada,c,c++,fortran,lto,objc,obj-c++ --enable-graphite --enable-threads=posix --enable-libatomic --enable-libgomp --disable-libitm --enable-libquadmath --enable-libquadmath-support --enable-libssp --enable-libada --enable-libgcj-sublibs --disable-java-awt --disable-symvers --with-ecj-jar=/usr/share/java/ecj.jar --with-gnu-ld --with-gnu-as --with-cloog-include=/usr/include/cloog-isl --without-libiconv-prefix --without-libintl-prefix --with-system-zlib --enable-linker-build-id
线程模型：posix
gcc 版本 4.9.3 (GCC)

$ make -v
GNU Make 4.1
Built for x86_64-unknown-cygwin
Copyright (C) 1988-2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.



[Cannot compile C code with #include <sys/times.h> in Cygwin](http://stackoverflow.com/questions/12749529/cannot-compile-c-code-with-include-sys-times-h-in-cygwin)
```
gcc -v net.c
#include "..." 搜索从这里开始：
#include <...> 搜索从这里开始：
 /usr/lib/gcc/x86_64-pc-cygwin/4.9.3/include
 /usr/lib/gcc/x86_64-pc-cygwin/4.9.3/include-fixed
 /usr/include
 /usr/lib/gcc/x86_64-pc-cygwin/4.9.3/../../../../lib/../include/w32api
搜索列表结束。



```



cc: 错误：unrecognized command line option ‘-rdynamic’
Makefile:171: recipe for target 'redis-server' failed
make: *** [redis-server] Error 1


















