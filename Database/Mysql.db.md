#mysql notes
---
#Setup
##ubuntu
```bash
sudo apt-get install mysql-server  mysql-client  libmysqlclient-dev
sudo netstat -tap | grep mysql
```
mysql -u root -p 
###启动关闭重启
```
service mysql start
sudo /etc/init.d/mysql start 
sudo /etc/init.d/mysql stop 
sudo /etc/init.d/mysql restart

mysql -u root -p
mysql -h 192.168.143.113 -u root -proot
```

##mac
开机启动
```bash
vi /Library/LaunchDaemons/com.mysql.plist
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.mysql</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/mysql/bin/mysqld_safe</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
  </dict>
</plist>
```
检查格式
```
sudo plutil -lint /Library/LaunchDaemons/com.mysql.plist
launchctl load -w com.mysql.plist
```
错误1：Dubious ownership on file (skipping) 这个错误，原因是：这个plist文件必须是属于root用户，wheel组，用chown修改之


---
#settings
##root password
```
use mysql
update user set password=PASSWORD('root') where user='root';
flush privileges;
quit
```

##/etc/mysql/my.cnf  my.ini

###root远程登录
//找到如下内容，并注释
bind-address = 127.0.0.1
###method a change table
```
mysql>use mysql;
mysql>update user set host = '%' where user = 'root';
mysql>select host, user from user;
```
###method b grant privilage
```
mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
mysql>GRANT ALL PRIVILEGES ON *.* TO 'jack'@'10.10.50.127' IDENTIFIED BY '654321' WITH GRANT OPTION;
```
##忘记密码
/etc/my.cnf
在[mysqld]下添加一行skip-grant-table，再设置密码

##charset
```sql
show variables like 'character%';
show variables like 'collation%';
character_set_client
character_set_connection  为建立连接使用的编码；
character_set_database    数据库的编码；
character_set_results   结果集的编码；
character_set_server    数据库服务器的编码；
只要保证以上四个采用的编码方式一样，就不会出现乱码问题。

--修改字符集
SET NAMES 'utf8';
equals three below
SET character_set_client = utf8;
SET character_set_results = utf8;
SET character_set_connection = utf8;
--以上命令有部分只对当前登录有效，一般只有在访问之前执行这个代码就解决问题了，下面是创建数据库和数据表的，设置为我们自己的编码格式。

--数据库编码
create database name character set utf8;
--修改库编码
alter database name character set utf8;

--表编码
CREATE TABLE `type` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `flag_deleted` enum('Y','N') character set utf8 NOT NULL default 'N',
  `flag_type` int(5) NOT NULL default '0',
  `type_name` varchar(50) character set utf8 NOT NULL default '',
  PRIMARY KEY (`id`)
  ) DEFAULT CHARSET=utf8;
--修改表编码
alter table type character set utf8;

--修改字段编码
alter table type modify type_name varchar(50) CHARACTER SET utf8;

--my.ini my.cnf
--在 [mysqld] 标签下加上三行
default-character-set = utf8
character_set_server = utf8
lower_case_table_names = 1 //表名不区分大小写（此与编码无关）
--在 [mysql] 标签下加上一行
default-character-set = utf8
--在 [mysql.server]标签下加上一行
default-character-set = utf8
--在 [mysqld_safe]标签下加上一行
default-character-set = utf8
--在 [client]标签下加上一行
default-character-set = utf8

```


<<<<<<< HEAD

[mysql online DDL](http://dev.mysql.com/doc/refman/5.6/en/innodb-create-index-overview.html)


----
#theory
##character set 和 collation
character set， 即字符集
collation, 即比对方法 指定数据集如何排序，以及字符串的比对规则
mysql> show collation;
ollation 名字的规则可以归纳为这两类：
1. <character set>_<language/other>_<ci/cs>
2. <character set>_bin</li>
ci 是 case insensitive 的缩写， cs 是 case sensitive 的缩写，bin 二进制排序
###utf8_general_ci和utf8_unicode_ci的区别
[utf8_general_ci和utf8_unicode_ci的区别](http://www.nowamagic.net/academy/detail/32161544)
当前，utf8_unicode_ci校对规则仅部分支持Unicode校对规则算法
utf8_unicode_ci的最主要的特色是支持扩展
utf8_general_ci是一个遗留的 校对规则，不支持扩展。意味着utf8_general_ci校对规则进行的比较速度很快，但是与使用utf8_unicode_ci的 校对规则相比，比较正确性较差


=======
>>>>>>> 0959f80561b217456f2f54fe40172e31643f1315
---
#common grammer
show databases;
show tables;

##参数
show variables like 'innodb_%';  
show variables where Variable_name like 'log%' and value='ON';  
show global variables;  
show session/local variables;  
SET GLOBAL var_name = value;  


##COALESCE
返回其参数中第一个非空表达式
语法：
COALESCE ( expression [ ,...n ] ) 
如果所有参数均为 NULL，则 COALESCE 返回 NULL。至少应有一个 Null 值为 NULL 类型。尽管 ISNULL 等同于 COALESCE，但它们的行为是不同的。包含具有非空参数的 ISNULL 的表达式将视为 NOT NULL，而包含具有非空参数的 COALESCE 的表达式将视为 NULL。在 SQL Server 中，若要对包含具有非空参数的 COALESCE 的表达式创建索引，可以使用 PERSISTED 列属性将计算列持久化



##distinct
SELECT *, COUNT(DISTINCT nowamagic) FROM table GROUP BY now
1. 《编写高效的SQL语句过滤条件》：避免在最高层使用 distinct 应该是一条基本规则 。原因在于，即使我们遗漏了连接的某个条件， distinct 也会使查询 " 看似正确 " 地执行 —— 无可否认，发现重复数据容易，发现数据不准确很难，所以避免在最高层使用 distinct 应该是一条基本规则。

##差集
//子查询
select table1.id from table1 
where not exists 
(select 1 from table2 
where table1.id = table2.id
);

//外连接
```sql
select table1.id from table1 
left join table2
on table1.id=table2.id
where table2.id is null;
```

##ORD() 函数
ORD() 函数返回字符串第一个字符的 ASCII 值。
##IFNULL(expr1,expr2)
如果 expr1 不是 NULL，IFNULL() 返回 expr1，否则它返回 expr2。
##MID()函数
SQL MID() 函数用于得到一个字符串的一部分
MID() 函数语法为：
SELECT MID(ColumnName, Start [, Length]) FROM TableName
注：字符串从1开始，而非0，Length是可选项，如果没有提供，MID()函数将返回余下的字符串。

##字符串
substr(t.uln_uid,CHAR_LENGTH(t.uln_uid))


---
#base
## Datatype
[v5.7 Json Data Type](http://dev.mysql.com/doc/refman/5.7/en/json.html#json-paths)
[Mysql gis 空间数据库功能详解学习](http://blog.csdn.net/chaiqi/article/details/23099407)

##元数据
information_schema.COLUMNS
字段信息
select COLUMN_NAME，COLUMN_TYPE from information_schema.COLUMNS where table_name = 'table_name' and table_schema = 'db_name';








---
#PerformanceTuning
##慢查询日志

show status

##间歇性问题

show global status
show processlist
观察线程处于的状态

##其他profile工具
1.USER_STATISTICS表
2.strace

##explain
[mysql explain用法和结果的含义 ](http://blog.chinaunix.net/uid-540802-id-3419311.html)

###type性能从差到好排序
all -> index -> range -> index_subquery ->unique_subquery -> index_merage -> ref_or_null -> fulltext -> ref -> eq_ref -> const -> sytem

###key
用到的索引
优化方式：把计划用到的索引用上

###rows
扫描的行数，有误差
优化方式：减少扫描的行数

###extra
常见：
Using index、Using filesort、Using temporary
优化方式：针对不同的类型进行优化，存在索引的情况下减少额外的操作，可以
的话把Using filesort、Using temporary这些类型消灭掉

filesort
在内存排序

##insert
1)使用LOAD DATA INFILE从文本下载数据这将比使用插入语句快20倍。
[mysql load data infile的使用](http://www.2cto.com/database/201108/99655.html)
2)使用带有多个VALUES列表的INSERT语句一次插入几行这将比使用一个单行插入语句快几倍。调整bulk_insert_buffer_size变量也能提高（向包含行的表格中）插入的速度。
3）myisam表并行插入Concurrent_insert系统变量可以被设置用于修改concurrent-insert处理。该变量默认设置为1。如果concurrent_insert被设置为0，并行插入就被禁用。如果该变量被设置为2，在表的末端可以并行插入，即便该表的某些行已经被删除。
4）插入延迟
你的客户不能或无需等待插入完成的时候，这招很有用。当你使用MySQL存储，并定期运行需要很长时间才能完成的SELECT和UPDATE语句的时候，你会发现这种情况很常见。当客户使用插入延迟，服务器立刻返回，如果表没有被其他线程调用，则行会列队等待被插入。使用插入延迟的另一个好处就是从多个客户插入的情况会被绑定并记录在同一个block中。这将比处理多个独立的插入要快得多。
5)插入之前将表锁定(只针对非事务处理型的表)
这将提高数据库性能，因为索引缓冲区只是在所有的插入语句完成后才对磁盘进行一次刷新。通常情况下，有多少个插入语句就会有多少次索引缓冲区刷新。如果你可以用一个插入语句实现所有行的插入，则无需使用显式锁定语句。

##table
[MySQL的数据类型和建库策略详解](http://database.51cto.com/art/200905/123220.htm)

##表分区
[mysql的表分区技术](http://hansionxu.blog.163.com/blog/static/241698109201472111560144/)



---
#performance-schema
##data type
更小的通常更好
简单就好
尽量避免NULL
  缺点：索引、索引统计、值比较 更复杂
  好处：innodb使用单独的位bit存储NULL

##整数
tinyint|smallint|mediumint| int     | bigint
8     |   16    |   24    |   32    |   64

##text blob
tinytext,smalltext=text,mediumtext,longtext
tinyblob,smallblob=blob,mediumblob,longblob
只对每个列前max_sort_length字节排序

##枚举代替字符串

##时间
datetime

timestamp
4字节
1970~2038

##位数据类型


##identifier
存储类型，还要考虑mysql内部怎么执行比较和计算
类型一致，混用会导致隐式转换，影响性能
满足需求的情况下，选择最小的数据类型
字符串
  通常很耗空间，尤其是myisam，压缩索引，性能更差
  随机的字符串如md5，插入新值分布在很大的空间，索引会被写入不同位置，导致插入很慢，（磁盘随机访问、页分裂），select也会变慢，缓存局部原理失效
UUID可以通过unhex转为binary(16)

##坑
太多的列，数千个列
太多的关联，每个关联最多61张表
全能的枚举
变相的枚举
非此发明（not invent here)的NULL

##范式/反范式
范式优点
  更新操作比反范式快
  重复数据少，修改只要改很少数据
  表更小
  更少需要distinct group by
缺点
  需要关联，可能会使索引无效

反范式优点
  查询不需要关联表，避免随机IO
  索引策略更有效


##缓存表和汇总表
物化视图
  flexviews
计数器表
  分散值到多行，随机选一行更新

##加快alter table 操作的速度
facebook,online schema change
shlomi naoch,openark toolkit
percona toolkit




















