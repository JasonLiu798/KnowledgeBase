

本文主要是针对mysql数据库
设计原则
1、不在数据库做运算：cpu计算务必移至业务层
2、控制单表数据量：单表记录控制在1000w
3、控制列数量：字段数控制在20以内
4、平衡范式与冗余：为提高效率牺牲范式设计，冗余数据
5、拒绝3B：拒绝大sql，大事务，大批量
6、表字符集使用UTF8
7、使用INNODB存储引擎
数据表设计
1、尽可能地使用最有效(最小)的数据类型
tinyint(1Byte)
smallint(2Byte)
mediumint(3Byte)
int(4Byte)
bigint(8Byte)
bad case：int(1)/int(11)
2、不要将数字存储为字符串，字符转化为数字，用int存储ip而非char(15)
3、优先使用enum或set，sex enum (‘F’, ‘M’)
4，避免使用NULL字段
NULL字段很难查询优化
NULL字段的索引需要额外空间
NULL字段的复合索引无效
bad case：`name` char(32) default null`age` int not null
good case：`age` int not null default 0
5，少用text/blob，varchar的性能会比text高很多；实在避免不了blob，请拆表
6、不在数据库里存图片
7、对于MyISAM表，如果没有任何变长列(VARCHAR、TEXT或BLOB列)，使用固定尺寸的记录格式。这比较快但是不幸地可能会浪费一些空间。即使你已经用CREATE选项让VARCHAR列ROW_FORMAT=fixed，也可以提示想使用固定长度的行
8、使用sample character set，例如latin1。尽量少使用utf-8，因为utf-8占用的空间是latin1的3倍。可以在不需要使用utf-8的字段上面使用latin1，例如mail，url等
9、精确度与空间的转换。在存储相同数值范围的数据时，浮点数类型通常都会比DECIMAL类型使用更少的空间。FLOAT字段使用4 字节存储 数据。DOUBLE类型需要8 个字节并拥有更高的精确度和更大的数值范围，DECIMAL类型的数据将会转换成DOUBLE类型
10、库名表名字段名必须有固定的命名长度，12个字符以内；库名、表名、字段名禁⽌止超过32个字符。须见名之意；库名、表名、字段名禁⽌止使⽤用MySQL保留字；临时库、表名必须以tmp为前缀，并以⽇日期为后缀； 备份库、表必须以bak为前缀，并以日期为后缀
11、InnoDB表行记录物理长度不超过8KB，InnoDB的data page默认是16KB，基于B+Tree的特点，一个data page中需要至少存储2条记录。因此，当实际存储长度超过8KB（尤其是TEXT/BLOB列）的大列（large column）时会引起“page-overflow存储”，类似ORACLE中的“行迁移”，因此，如果必须使用大列（尤其是TEXT/BLOB类型）且读写频繁的话，则最好把这些列拆分到子表中，不要和主表放在一起存储，如果不太频繁，可以考虑继续保留在主表中，如果将 innodbpagesize 选项修改成 8KB，那么行记录物理长度建议不超过4KB
索引类
1、谨慎合理使用索引
改善查询、减慢更新
索引一定不是越多越好（能不加就不加，要加的一定得加）
覆盖记录条数过多不适合建索引，例如“性别”
2、字符字段必须建前缀索引
3、不在索引做列运算，bad case：select id where age +1 = 10;
4、innodb主键推荐使用自增列
主键建立聚簇索引
主键不应该被修改
字符串不应该做主键
如果不指定主键，innodb会使用唯一且非空值索引代替
5、不用外键，请由程序保证约束
6、避免在已有索引的前缀上建立索引。例如：如果存在index（a，b）则去掉index（a）
7、控制单个索引的长度。使用key（name（8））在数据的前面几个字符建立索引
8、要选择性的使用索引。在变化很少的列上使用索引并不是很好，例如性别列
9、Optimize table可以压缩和排序index，注意不要频繁运行
10、Analyze table可以更新数据
11、索引选择性是不重复的索引值也叫基数（cardinality）表中数据行数的比值，索引选择性=基数/数据行，count(distinct(username))/count(*) 就是索引选择性，高索引选择性的好处就是mysql查找匹配的时候可以过滤更多的行，唯一索引的选择性最佳，值为1
12、不要用重复或多余索引，对于INNODB引擎的索引来说，每次修改数据都要把主键索引，辅助索引中相应索引值修改，这可能会出现大量数 据迁移，分页，以及碎片的出现
13、超过20个长度的字符串列，最好创建前缀索引而非整列索引（例如：ALTER TABLE t1 ADD INDEX(user(20))），可以有效提高索引利用率，不过它的缺点是对这个列排序时用不到前缀索引。前缀索引的长度可以基于对该字段的统计得出， 一般略大于平均长度一点就可以了
14、定期用 pt-duplicate-key-checker 工具检查并删除重复的索引。比如 index idx1(a, b) 索引已经涵盖了 index idx2(a)，就可以删除 idx2 索引了
sql语句设计类
1、sql语句尽可能简单,一条sql只能在一个cpu运算，大语句拆小语句，减少锁时间，一条大sql可以堵死整个库(充分利用QUERY CACHE和充分利用多核CPU)
2、简单的事务,事务时间尽可能短,bad case：上传图片事务
3、避免使用trig/func,触发器、函数不用,客户端程序取而代之
4、不用select *,消耗cpu，io，内存，带宽,这种程序不具有扩展性
5、OR改写为IN()
or的效率是n级别
in的消息时log(n)级别
in的个数建议控制在200以内
select id from t where phone=’159′ or phone=’136′ =>select id from t where phone in (’159′, ’136′);
6、OR改写为UNION
mysql的索引合并很弱智
select id from t where phone = '159' or name = 'john';
=>
select id from t where phone='159' union select id from t where name='jonh';
7、避免负向%，如not in/like
8、慎用count(*)
9、limit高效分页
limit越大，效率越低
select id from t limit 10000, 10;
=>
select id from t where id > 10000 limit 10;
10、使用union all替代union，union有去重开销
11、少用连接join
12、使用group by，分组、自动排序
13、请使用同类型比较
14、使用load data导数据，load data比insert快约20倍；
15、对数据的更新要打散后批量更新，不要一次更新太多数据
16、使用性能分析工具
Sql explain / showprofile / mysqlsla
17、使用--log-slow-queries –long-query-time=2查看查询比较慢的语句。然后使用explain分析查询，做出优化
show profile;
mysqlsla;
mysqldumpslow;
explain;
show slow log;
show processlist;
show query_response_time(percona)
optimize 数据在插入，更新，删除的时候难免一些数据迁移，分页，之后就出现一些碎片，久而久之碎片积累起来影响性能， 这就需要DBA定期的优化数据库减少碎片，这就通过optimize命令。如对MyISAM表操作：optimize table 表名
18、禁止在数据库中跑大查询
19、使⽤预编译语句，只传参数，比传递SQL语句更高效；一次解析，多次使用；降低SQL注入概率
20、禁止使⽤order by rand()
21、禁⽌单条SQL语句同时更新多个表
22、避免在数据库中进⾏数学运算(MySQL不擅长数学运算和逻辑判断)
23、SQL语句要求所有研发，SQL关键字全部是大写，每个词只允许有一个空格
24、能不用NOT IN就不用NOTIN，坑太多了。。会把空和NULL给查出来
注意
1、哪怕是基于索引的条件过滤，如果优化器意识到总共需要扫描的数据量超过30%时（ORACLE里貌似是20%，MySQL目前是30%，没准以后会调整），就会直接改变执行计划为全表扫描，不再使用索引
2、多表JOIN时，要把过滤性最大（不一定是数据量最小哦，而是只加了WHERE条件后过滤性最大的那个）的表选为驱动表。此外，如果JOIN之后有排序，排序字段一定要属于驱动表，才能利用驱动表上的索引完成排序
3、绝大多数情况下，排序的代价通常要来的更高，因此如果看到执行计划中有 Using filesort，优先创建排序索引吧
4、利用 pt-query-digest 定期分析slow query log，并结合 Box Anemometer 构建slow query log分析及优化系统














