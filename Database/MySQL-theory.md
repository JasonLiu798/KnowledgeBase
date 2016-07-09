#theory
---
#逻辑结构
```
连接/线程处理
 |         |
查询缓存<-解析器->
优化器
 |
存储引擎
```


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


---
#引擎
MyISAM 表级并发控制锁
InnoDB 记录级并发控制锁

BDB 页面级并发控制锁
内存存储引擎 HEAP表，适合查找表，周期性缓存聚合数据，保存中间数据，表级锁，并发写入差，每行长度固定，
merge 合并存储引擎，
archive，只支持insert select，zlib压缩，针对高速插入和压缩优化的简单引擎
cluster，
csv，不支持索引
blackhole，
fedreted，访问其他mysql的代理
custom storage engine，

##InnoDB MyISAM 引擎选择
[InnoDB还是MyISAM 再谈MySQL存储引擎的选择](http://database.51cto.com/art/200905/124370.htm)
你的数据库有外键吗？ 
◆你需要事务支持吗？ 
◆你需要全文索引吗？ 
◆你经常使用什么样的查询模式？ 
◆你的数据有多大？

特点      | myisam    |   innoDB
----------|----------|-----------
批量插入速度| 高       |       低
事务安全    |         |     支持
全文检索    | 支持，系统内建|  无
锁机制     | 表锁     |  行锁
存储限制    |   无   |   64TB
B树索引    |   支持  |   支持
哈希索引    |       |   支持
集群索引    |       |   支持
数据缓存    |       |   支持
索引缓存    | 支持   |   支持
数据可压缩   | 支持    |   
空间使用    | 低     | 高
内存使用    | 低     | 高
外键        |        | 支持

MyISAM 
1.MyISAM的索引和数据是分开的，并且索引是有压缩的；Innodb是索引和数据是紧密捆绑的
2.MyISAM恢复，移植方便
3.Innodb达不到MyISAM的写性能，如果是针对基于索引的update操作，虽然MyISAM可能会逊色Innodb，如并发高，myISM可通过分库分表解决
4.myISAM merge引擎
5.系统内建全文索引

Innodb
1.InnoDB可以利用事务日志进行数据恢复，这会比较快。而MyISAM可能会需要几个小时甚至几天来干这些事，InnoDB只需要几分钟。
2.select count(*) 和order by一类的，Innodb其实也是会锁表


LRU midpoint insertion strategy
innodb_old_blocks_time






---
#索引
##优点
* 减少服务器扫描的数据量
* 帮助服务器避免排序和临时表
* 将随机IO变为顺序IO


##b-tree
```sql
create table people(
    last_name varhcar(50) not null,
    first_name varhcar(50) not null,
    dob     data not null,
    gender  enum('m','f') not null,
    key(last_name,first_name,dob)
    );
```
索引有效情况
* 全值匹配
* 匹配最左前缀，如给出last_name值
* 匹配列前缀，如 last name以J开头
* 匹配范围值，
* 精确匹配某一列并范围匹配另外一列，如last name=allen,first name开头为K
* 只访问索引的查询
索引还可满足排序需求

###限制
* 不是从最左列开始查找，或某个字母结尾的
* 不能跳过索引中的列，如给出了last_name，dob，但没有给出first_name
* 查询中有某个列的范围查询，则右边的所有列都无法使用索引优化查找，如last_name='Smith' AND first_name LIKE 'J%' AND dob='1976-12-23'，只能使用到last_name,first_name
PS:以上限制，在未来版本可能变更

##哈希索引
###限制
* 只包含哈希值和行指针，不存储字段值，不能避免行读取
* 不是按照所有值顺序存储，无法排序
* 不支持部分索引列匹配查找，如索引(A,B)，查询值只有A,则无法使用索引
* 只支持等值比较查询，包括=、IN()、<=>，不支持任何范围
* 速度很快，除非有很多哈希冲突
* 冲突很多情况下，维护索引操作代价较高

innoDB自适应哈希索引

自定义哈希索引，如：较长的字符串+crc(字符串)
    手动维护、触发器维护

##空间树索引
地理数据存储
##全文索引
##分形树索引

##高性能索引策略
* 独立的列 where actor_id+1=5
* 前缀索引和索引选择性（不重复的索引值）
    select count(distinct left(xxx,3))/count(*) from ttt;
* 多列索引
    - 多列建立独立索引并不能提高性能
* 选择合适的索引列顺序（只适用与btree）
    - 选择性更高的索引在前
    - 特殊值，某些值特别多，如：默认值，
* 聚簇索引
    - 相关数据保存在一起
    - 数据访问更快
    - 覆盖索引扫描的查询可以直接使用叶节点中的主键值
    缺点：
    - 最大限度提高了IO密集型应用的性能
    - 插入速度严重依赖插入顺序，如果不是按照主键顺序加载数据，加载完后最好OPTIMIZE TABLE重新组织表
    - 更新聚簇索引列代价很高
    - 基于聚簇索引的表插入新行或者主键被更新导致需要移动行的时候，可能面临 页分裂 问题，导致表占用更多磁盘空间
    - 聚簇索引导致全表扫描变慢，尤其是行比较稀疏，或者 页分裂
    - 二级索引 比想象的更大
    - 二级索引 两次索引查找，索引存的是主键值（好处是移动行，不需要更新），而不是物理地址，自适应哈希可以减少重复工作

    索引值最好为顺序，随机值会导致页分裂，缓存失效，如UUID，可以通过OPTIMIZE TABLE重建优化表

    延迟关联 deferred join
    
* 索引排序
    - 索引顺序与Orderby子句顺序一致，所有列排序方向（倒序或正序）一样，才能用索引来对结果排序
    - 满足索引最左前缀，前面列如果为常量 也可满足
* 压缩索引
    - 前缀压缩，空间更少，某些操作更慢
* 冗余重复索引
    - A,ID，ID为主键列，已经包含在二级索引中了
    - 索引越多插入速度越慢
* 未使用的索引
* 索引和锁
    - 只有当innoDB在存储引擎层能够过滤掉所有不需要的行时，才有效
    - 范围查询
    - 二级索引-共享锁，主键索引-排它锁

---
#事务
##隔离级别
     隔离级别    | 脏读 | 不可重复读| 幻读   | 加锁读
-----------------|------|-----------|--------|--------
read uncommitted |  Y   |   Y       |   Y    |  N
read committed   |  N   |   Y       |   Y    |  N
repeatable read  |  N   |   N       |   Y    |  N
serializable     |  N   |   N       |   N    |  N

间隙锁 next-key locking，防止幻读












---
#主从
主从复制:
MySQL的主从复制解决了数据库的读写分离，并很好的提升了读的性能

##性能瓶颈问题
1. 写入无法扩展
2. 写入无法缓存
3. 复制延时
4. 锁表率上升
5. 表变大，缓存率下降

##优化方案
按业务垂直分区，业务间独立，无法直接join
水平分区

---
#分表
[mysql分表的3种方法](http://www.blogjava.net/kelly859/archive/2012/06/08/380369.html)
执行一个sql的过程:
1,接收到sql;
2,把sql放到排队队列中;
3,执行sql;
4,返回执行结果
在这个执行过程中最花时间在什么地方呢？第一，是排队等待的时间，第二，sql的执行时间。其实这二个是一回事，等待的同时，肯定有sql在执行。所以我们要缩短sql的执行时间。

表锁定（myisam存储引擎），一个是行锁定（innodb存储引擎）
1.mysql集群，利用mysql cluster ，mysql proxy，mysql replication，drdb等等
减少节点的sql排队队列中的sql的数量
优点：扩展性好，没有多个分表后的复杂操作（php代码）
缺点：单个表的数据量还是没有变，一次操作所花的时间还是那么多，硬件开销大。

2，预先估计会出现大数据量并且访问频繁的表，将其分为若干个表
hash,求余,根据时间
优点：避免一张表出现几百万条数据，缩短了一条sql的执行时间
缺点：当一种规则确定时，打破这条规则会很麻烦，上面的例子中我用的hash算法是crc32，如果我现在不想用这个算法了，改用md5后，会使同一个用户的消息被存储到不同的表中，这样数据乱套了。扩展性很差。

3，利用merge存储引擎来实现分表
如果要把已有的大数据量表分开比较痛苦，最痛苦的事就是改代码，因为程序里面的sql语句已经写好了。用merge存储引擎来实现分表, 这种方法比较适合.
a，如果你使用 alter table 来把 merge 表变为其它表类型，到底层表的映射就被丢失了。
b，一些说replace不起作用
c.一个 merge 表不能在整个表上维持 unique 约束。
d.当你创建一个 merge 表之时，没有检查去确保底层表的存在以及有相同的机构。
优点：扩展性好，并且程序代码改动的不是很大
缺点：这种方法的效果比第二种要差一点



---
#分布式
[分布式MySQL数据库TDSQL架构分析](http://mp.weixin.qq.com/s?__biz=MzAwNjMxNjQzNA==&mid=207514436&idx=1&sn=c20a2169fbf2339751086734e8a5f036&scene=5#rd)



---
#存储过程
###速查
[MySQL存储过程详解](http://blog.sina.com.cn/s/blog_52d20fbf0100ofd5.html)


http://mp.weixin.qq.com/s?__biz=MzAwNjMxNjQzNA==&mid=207514436&idx=1&sn=c20a2169fbf2339751086734e8a5f036&scene=5#rd
