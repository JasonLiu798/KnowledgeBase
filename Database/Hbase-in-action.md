#hbase in action
---
#doc

#API client
所有修改操作行级原子性
创建HTable实例需要扫描.META表，推荐只创建一次，每个线程创建一个，生存期复用这个对象；需要多个HTable实例，考虑使用HTablePool


---
#命名空间Namespace
在关系数据库系统中，命名空间，namespace指的是一个 表的逻辑分组 ，同一组中的表有类似的用途。命名空间的概念为 即将到来 的多租户特性打下基础：
配额管理Quota Management (HBASE-8410)：限制一个namespace可以使用的资源，资源包括region和table等；
命名空间安全管理Namespace Security Administration (HBASE-9206)：提供了另一个层面的多租户安全管理；
Region服务器组Region server groups (HBASE-6721)：一个命名空间或一张表，可以被固定到一组regionservers上，从而保证了数据隔离性。
##命名空间管理
命名空间可以被创建、移除、修改。
表和命名空间的隶属关系 在在创建表时决定，通过以下格式指定：
<namespace>:<table>

Example：hbase shell中创建命名空间、创建命名空间中的表、移除命名空间、修改命名空间
```shell
#Create a namespace
create_namespace 'my_ns'

#create my_table in my_ns namespace
create 'my_ns:my_table', 'fam'

#drop namespace
drop_namespace 'my_ns'

#alter namespace
alter_namespace 'my_ns', {METHOD => 'set', 'PROPERTY_NAME' => 'PROPERTY_VALUE'}
```
##预定义的命名空间
有两个系统内置的预定义命名空间：
hbase ：系统命名空间，用于包含hbase的内部表
default ： 所有未指定命名空间的表都自动进入该命名空间
Example：指定命名空间和默认命名空间
```shell
#namespace=foo and table qualifier=bar
create 'foo:bar', 'fam'

#namespace=default and table qualifier=bar
create 'bar', 'fam'
```



----
#表设计
[开发一个类twitter系统之表设计](http://www.tuicool.com/articles/U7rma2)



----
#rowkey设计
[大数据性能调优之HBase的RowKey设计](http://www.open-open.com/lib/view/open1417612091323.html)
##Rowkey长度原则
Rowkey是一个二进制码流，Rowkey的长度被很多开发者建议说设计在10~100个字节，不过建议是越短越好，不要超过16个字节。
（1）数据的持久化文件HFile中是按照KeyValue存储的，如果Rowkey过长比如100个字节，1000万列数据光Rowkey就要占用100*1000万=10亿个字节，将近1G数据，这会极大影响HFile的存储效率；
（2）MemStore将缓存部分数据到内存，如果Rowkey字段过长内存的有效利用率会降低，系统将无法缓存更多的数据，这会降低检索效率。因此Rowkey的字节长度越短越好。
（3）目前操作系统是都是64位系统，内存8字节对齐。控制在16个字节，8字节的整数倍利用操作系统的最佳特性。

##Rowkey散列原则
如果Rowkey是按时间戳的方式递增，不要将时间放在二进制码的前面，建议将Rowkey的高位作为散列字段，由程序循环生成，低位放时间字段，这样将提高数据均衡分布在每个Regionserver实现负载均衡的几率。如果没有散列字段，首字段直接是时间信息将产生所有新数据都在一个 RegionServer上堆积的热点现象，这样在做数据检索的时候负载将会集中在个别RegionServer，降低查询效率。

##Rowkey唯一原则
必须在设计上保证其唯一性。

##针对事务数据Rowkey设计
事务数据是带时间属性的，建议将时间信息存入到Rowkey中，这有助于提示查询检索速度。对于事务数据建议缺省就按天为数据建表，这样设计的好处是多方面的。按天分表后，时间信息就可以去掉日期部分只保留小时分钟毫秒，这样4个字节即可搞定。加上散列字段2个字节一共6个字节即可组成唯一 Rowkey

事务数据Rowkey设计
第0字节    第1字节    第2字节    第3字节    第4字节    第5字节    …
散列字段    时间字段(毫秒)    扩展字段
0~65535(0x0000~0xFFFF)  0~86399999(0x00000000~0x05265BFF)   
这样的设计从操作系统内存管理层面无法节省开销，因为64位操作系统是必须8字节对齐。但是对于持久化存储中Rowkey部分可以节省25%的开销。也许有人要问为什么不将时间字段以主机字节序保存，这样它也可以作为散列字段了。这是因为时间范围内的数据还是尽量保证连续，相同时间范围内的数据查找的概率很大，对查询检索有好的效果，因此使用独立的散列字段效果更好，对于某些应用，我们可以考虑利用散列字段全部或者部分来存储某些数据的字段信息，只要保证相同散列值在同一时间（毫秒）唯一。


## 针对统计数据的Rowkey设计
统计数据也是带时间属性的，统计数据最小单位只会到分钟（到秒预统计就没意义了）。同时对于统计数据我们也缺省采用按天数据分表，这样设计的好处无需多说。按天分表后，时间信息只需要保留小时分钟，那么0~1400只需占用两个字节即可保存时间信息。由于统计数据某些维度数量非常庞大，因此需要4个字节作为序列字段，因此将散列字段同时作为序列字段使用也是6个字节组成唯一Rowkey。

第0字节    第1字节    第2字节    第3字节    第4字节    第5字节    …
散列字段(序列字段）  时间字段(分钟)    扩展字段
0x00000000~0xFFFFFFFF)  0~1439(0x0000~0x059F)   

同样这样的设计从操作系统内存管理层面无法节省开销，因为64位操作系统是必须8字节对齐。但是对于持久化存储中Rowkey部分可以节省25%的开销。预统计数据可能涉及到多次反复的重计算要求，需确保作废的数据能有效删除，同时不能影响散列的均衡效果，因此要特殊处理。

##针对通用数据的Rowkey设计
通用数据采用自增序列作为唯一主键，用户可以选择按天建分表也可以选择单表模式。这种模式需要确保同时多个入库加载模块运行时散列字段（序列字段）的唯一性。可以考虑给不同的加载模块赋予唯一因子区别。设计结构如下图所示。

通用数据Rowkey设计
第0字节    第1字节    第2字节    第3字节    …
散列字段(序列字段）  扩展字段（控制在12字节内）
0x00000000~0xFFFFFFFF)  可由多个用户字段组成


##支持多条件查询的RowKey设计
HBase按指定的条件获取一批记录时，使用的就是scan方法。 scan方法有以下特点：
（1）scan可以通过setCaching与setBatch方法提高速度（以空间换时间）；
（2）scan可以通过setStartRow与setEndRow来限定范围。范围越小，性能越高。
通过巧妙的RowKey设计使我们批量获取记录集合中的元素挨在一起（应该在同一个Region下），可以在遍历结果时获得很好的性能。
（3）scan可以通过setFilter方法添加过滤器，这也是分页、多条件查询的基础。
在满足长度、三列、唯一原则后，我们需要考虑如何通过巧妙设计RowKey以利用scan方法的范围功能，使得获取一批记录的查询速度能提高。下例就描述如何将多个列组合成一个RowKey，使用scan的range来达到较快查询速度。
例子：

我们在表中存储的是文件信息，每个文件有5个属性：文件id（long，全局唯一）、创建时间（long）、文件名（String）、分类名（String）、所有者（User）。

我们可以输入的查询条件：文件创建时间区间（比如从20120901到20120914期间创建的文件），文件名（“中国好声音”），分类（“综艺”），所有者（“浙江卫视”）。

假设当前我们一共有如下文件：

ID  CreateTime  Name    Category    UserID
1   20120902    中国好声音第1期    综艺  1
2   20120904    中国好声音第2期    综艺  1
3   20120906    中国好声音外卡赛    综艺  1
4   20120908    中国好声音第3期    综艺  1
5   20120910    中国好声音第4期    综艺  1
6   20120912    中国好声音选手采访   综艺花絮    2
7   20120914    中国好声音第5期    综艺  1
8   20120916    中国好声音录制花絮   综艺花絮    2
9   20120918    张玮独家专访  花絮  3
10  20120920    加多宝凉茶广告 综艺广告    4
这里UserID应该对应另一张User表，暂不列出。我们只需知道UserID的含义：

1代表 浙江卫视； 2代表 好声音剧组； 3代表 XX微博； 4代表赞助商。调用查询接口的时候将上述5个条件同时输入find(20120901,20121001,”中国好声音”,”综艺”,”浙江卫视”)。此时我们应该得到记录应该有第1、2、3、4、5、7条。第6条由于不属于“浙江卫视”应该不被选中。我们在设计RowKey时可以这样做：采用 UserID + CreateTime + FileID组成RowKey，这样既能满足多条件查询，又能有很快的查询速度。

需要注意以下几点：

（1）每条记录的RowKey，每个字段都需要填充到相同长度。假如预期我们最多有10万量级的用户，则userID应该统一填充至6位，如000001，000002…

（2）结尾添加全局唯一的FileID的用意也是使每个文件对应的记录全局唯一。避免当UserID与CreateTime相同时的两个不同文件记录相互覆盖。

按照这种RowKey存储上述文件记录，在HBase表中是下面的结构：

rowKey（userID 6 + time 8 + fileID 6） name category ….

00000120120902000001

00000120120904000002

00000120120906000003

00000120120908000004

00000120120910000005

00000120120914000007

00000220120912000006

00000220120916000008

00000320120918000009

00000420120920000010

怎样用这张表？

在建立一个scan对象后，我们setStartRow(00000120120901)，setEndRow(00000120120914)。

这样，scan时只扫描userID=1的数据，且时间范围限定在这个指定的时间段内，满足了按用户以及按时间范围对结果的筛选。并且由于记录集中存储，性能很好。

然后使用 SingleColumnValueFilter（org.apache.hadoop.hbase.filter.SingleColumnValueFilter），共4个，分别约束name的上下限，与category的上下限。满足按同时按文件名以及分类名的前缀匹配。

（注意：使用SingleColumnValueFilter会影响查询性能，在真正处理海量数据时会消耗很大的资源，且需要较长的时间）

如果需要分页还可以再加一个PageFilter限制返回记录的个数。

以上，我们完成了高性能的支持多条件查询的HBase表结构设计。


---
#parameter
##zookeeper.session.timeout
默认 180000
测试 120000
这个参数的意义是regionserver在zookeeper的会话过期时间，默认是3分钟，如果regionserver 在zookeeper.session.timeout这个配置的时间没有去连zookeeper的话，zookeeper会将该regionserver在zookeeper摘除，不让该regionserver向提供服务，很多人都该值配置很大，原因是生产环境中regionserver的内存都配置很大，以扩大memstore和cache的大小，提高性能，但是内存配置大了以后，regionserver在jvm做一次内存大回收时，时间也会变长，很有可能这个时间超过zookeeper.session.timeout时间，导致regionserver在jvm回收内存的时候，zookeeper误以为regionserver挂掉而将regionserver摘除。但我认为该值还是不要配的过大，首先地java已支持cms方式回收内存，每次内存回收的时间不是太长，并且生产环境中，我们也不允许过长时间的服务中断，配置大了，容易造成一个regionserver的服务真出现异常时，zookeeper不会切除该regionserver，使得很多请求失败。

##hbase.regionserver.handler.count
默认 10
测试 100
regionserver的工作线程数量，官方默认值太小，通常都调到100~200之间，提高regionserver性能

##hbase.regionserver.lease.period
默认 60s
regionserer租约时间，默认值是60s，也有点小，如果你的生产环境中，在执行一些任务时，如mapred时出现lease超时的报错，那这个时候就需要去调大这个值了。

##








----
#CRUD
HbaseConfiguration
```
static Configuration create();//尝试从classpath家中hbase-default.xml，hbase-site.xml
static Configuration create(Configuration that);
```
##PUT
add
未指定时间戳，将由region服务器设定为服务器当前时间，因此必须确保服务器时间正确
默认情况，hbase保留3个版本数据

###激活缓冲区
```
table.setAutoFlush(false);//默认true不开启
isAutoFlush();//检查
```
开启后，单行put部产生RPC调用，flushCommits()强制写服务端
缓冲区大小配置：
```java
long getWriteBufferSize();
void setWriteBufferSize(long writeBufferSize) throws IOException;//默认2MB
```
hbase-site.xml配置
```xml
<property>
	<name>hbase.client.write.buffer</name>
	<value>20971520</value><!--20MB-->
</property>
```
隐式刷写：
调用put()或setWriteBufferSize时，比较占用缓冲区和配置大小，超出限制，触发flushCommits
通过getWriteBuffer()获取写入缓存内容
PS：
* 缓冲区为内存列表，程序停止，如未发送RPC，则数据会丢失
* 内存占用，预估：hbase.client.write.buffer x hbase.regionserver.handler.count x region服务器数量
* 如果只存储大单元，则缓冲区左右不大，主要时间在传输
###CAS 原子操作
```java
boolean checkAndPut(byte[] row,byte[] family,byte[] qualifier,byte[] value,Put put) throws IOException
```

##GET
默认按版本降序存储，scan,get只返回一个版本
```java
List<KeyValue> get(byte[] family,byte[] qualifier)
Map<byte[], List<KeyValue>> getFamilyMap()

//check
has(byte[] family,byte[] qualifier)
has(byte[] family,byte[] qualifier,long ts)
has(byte[] family,byte[] qualifier, byte[] value)
has(byte[] family,byte[] qualifier,long ts, byte[] value)

//others
getRow //rowkey
getRowLock
getLockId
setWriteToWAL
getWriteToWAL
getTimeStamp
heapSize
isEmpty
numFamilies
size
```
Get(byte[] row);
Get(byte[] row,RowLock rowLock);

筛选用
Get addFamily(byte[] family);
Get addColumn(byte[] family,byte[] qualifier);
Get setTimeRange(long minStamp,long maxStamp) throws IOException;
Get setTimeStamp(long timeStamp);
Get setMaxVersions();//返回这个单元格中所有的版本
Get setMaxVersions(int maxVersions) throws IOException;


##行锁
RowLock

hbase-site.xml
```xml
<name>hbase.regionserver.lease.period</name>
<value>120000</value>
```

RowLock lock = table.lockRow(ROW1);
lock.getLockId();
table.unlockRow(lock);

手动设定的时间戳被put，如果遇到锁等待，时间戳不会改变，

##Scan
扫描器租约
```xml
<name>hbase.regionserver.lease.period</name>
<value>120000</value>
```
以上值同时适用于租约锁和扫描器租约；延长租约时间，服务端设定有效

* 扫描器缓存
每个next调用一次RPC
setScannerCaching(int scannerCaching)
int getScannerCaching()

范围：扫描层面，本次扫描实例；表层面，这个表所有扫描实例

hbase-site.xml 设置所有扫描器缓存大小
```xml
<property>
	<name>hbase.client.scanner.caching</name>
	<value>10</value>
</property>
```
默认值1

值过高，会导致每次next()调用占用时间更长，过高还会OOM


---
#过滤器
##比较运算符
LESS
LESS_OR_EQUAL
EQUAL
NOT_EQUAL
GREATER_OR_EQUAL
GREATER
NO_OP		排除一切值

##比较器
comparator
WritableByteArrayComparable implement Writable,Comparable

BinaryComparator 	使用Bytes.compareTo()比较
BinaryPrefixComparator
NullComparator

以下三种只能与EQUAL,NOT_EQUAL运算符搭配
BitComparator 		按位比较
RegexStringComparator
SubstringComparator

##比较过滤器 comparison filter
* RowFilter
Filter filter1 = new RowFilter(CompareFilter.CompareOp.LESS_OR_EQUAL,new BinaryComparator(Bytes.toBytes("row-22")));

* FamilyFilter
Filter filter1 = new FamilyFilter(CompareFilter.CompareOp.LESS,new BinaryComparator(Bytes.toBytes("colfam3")));

* QualifierFilter
Filter filter1 = new QualifierFilter(CompareFilter.CompareOp.LESS_OR_EQUAL,new BinaryComparator(Bytes.toBytes("col-2")));

* ValueFilter
Filter filter1 = new ValueFilter(CompareFilter.CompareOp.EQUAL,new SubstringComparator(".4"));

* DependentColumnFilter 参考列过滤器
ValueFilter+时间戳过滤器

private static void filter(boolean frop,CompareFilter.CompareOp operator,WritableByteArrayComparable comparator){
	Filter filter1 = new DependentColumnFilter(Bytes.toBytes("colfam1"),Bytes.toBytes("col-5"),drop,operator);
}

##专用过滤器
* 单列值过滤器 SingleColumnValueFilter
SingleColumnValueFilter filter = new SingleColumnValueFilter(
Bytes.toBytes("colfam1"),
Bytes.toBytes("col-5"),
CompareFilter.CompareOp.NOT_EQUAL,
new SubstringComparator("val-5")
);
filter.setFilterIfMissing(true);

* SingleColumnValueExcludeFilter 单列排除过滤器
参考列不被包含在结果中

* PrefixFilter 前缀过滤器
Filter filter = new PrefixFilter(Bytes.toBytes("row-1"));

* PageFilter 分页过滤器

* KeyOnlyFilter 行健过滤器
只返回行键

* FirstKeyOnlyFilter 首次行键过滤器

* InclusiveStopFIlter
包含结束行

* TimestampsFilter

* ColumnCountGetFilter 列计数过滤器

* ColumnPaginationFilter 列分页过滤器
Filter filter = new ColumnPaginationFilter(5,15);

* ColumnPrefixFilter

* RandomRowFIlter

##附加过滤器
* SkipFilter
扩展并过滤整行数据
Filter filter1 = new ValueFilter(CompareFilter.CompareOp.NOT_EQUAL,new BinaryComparator(Bytes.toBytes("val-0")));

Filter filter2 = new SkipFilter(filter1);

* WhileMatchFilter
有数据不匹配时，放弃扫描
Filter filter1 = new RowFilter(CompareFilter.CompareOp.NOT_EQUAL,new BinaryComparator(Bytes.toBytes("row-05")));

Filter filter2 = new WhileMatchFilter(filter1);

##FilterList
List<Filter> filters = new ArrayList<Filter>();
filters.add(filter1);
...

FilterList filterList1 = new FilterList(filters);//默认MUST_PASS_ALL

FilterList filterList2 = new FilterList(FilterList.Operator.MUST_PASS_ONE,filters);

##自定义过滤器
FilterBase


-------
#计数器












##导数据
[ Bulk Load－HBase数据导入最佳实践](http://blog.csdn.net/opensure/article/details/47054861)

---
#开发
[开发环境搭建](http://blog.csdn.net/chicm/article/details/41787797)


---
#setup
wget -P /opt/rpm http://mirror.bit.edu.cn/apache/hbase/stable/hbase-1.0.1-bin.tar.gz &
pscp -h other.txt -l root /opt/rpm/hbase-1.0.1-bin.tar.gz /opt/rpm
pssh -h other.txt -l root -i 'tar -zpxvf /opt/rpm/hbase-1.0.1-bin.tar.gz -C /opt/rpm'
pssh -h other.txt -l root -i 'ln -sfv /opt/rpm/hbase-1.0.1 /opt/hbase'







---
#shell
[hbase shell基础和常用命令详解](http://www.jb51.net/article/31172.htm)
##管理查看类
```
hbase shell
status
version
list
```

##DDL
### table
#### create table
create 'tablename','column1','column2','column3'...
create 'gpsInfo', 'baseInfo'
create 'gpsInfoTest', 'baseInfo'

count 'test_gpsinfo'

describe 'tablename'
describe 'gpsInfo'
hbase(main):002:0> describe 'gpsInfo'
DESCRIPTION                                                                         ENABLED
 'gpsInfo', {NAME => 'baseInfo', DATA_BLOCK_ENCODING => 'NONE', BLOOMFILTER => 'NON true E', REPLICATION_SCOPE => '0', VERSIONS => '3', COMPRESSION => 'NONE', MIN_VERSIONS  => '0', TTL => '2147483647', KEEP_DELETED_CELLS => 'false', BLOCKSIZE => '65536', IN_MEMORY => 'false', ENCODE_ON_DISK => 'true', BLOCKCACHE => 'true'}


#### del table
disable 'tablename'
drop 'tablename'

#### scan table
scan 'gpsInfo',{LIMIT=>100}
scan 'gpsInfo123',{LIMIT=>5}
scan 'D_AREAQUERY',{LIMIT=>10}

#### other oper
exists 'tablename'
is_enabled 'tablename'
is_disabled 'tablename'


### column

#### del column
* disable table : disable 'tablename'
* alter table:  alter 'tablename',{NAME=>'columnname',METHOD=>'delete'}
* enable 'tablename'

##DML
###add data
put <table>,<rowkey>,<family:column>,<value>,<timestamp>
put 'gpsInfoTest','0000000320101227','baseInfo:081351','01010200202010000003\x00;2010-12-27 08:13:51\x00;109.10437\x00;36.64465\x00;',1293408831000

put 'user','andieguo','info:age','27'

###get data
get <table>,<rowkey>,[<family:column>,....]
get 'gpsInfoTest','0000000320101227','baseInfo:081351'

get 'user','andieguo',{COLUMN=>'info:age',TIMESTAMP=>1409304}

get 'gpsInfoTest','0000000320101227','info'

###del data
delete  '表名' ,'行名称' , '列名称'
delete 'test_gpsinfo','0101024050602010796620150325','baseInfo'

delete 'test_gpsinfo','0101024050602010796620150325','baseInfo:113922'

put '表名称', '行名称', '列名称:', '值'
status
version

####del row
deleteall 'gpsInfoTest','null20150611'

####truncate table
truncate 'tablename'

####hbase分页
http://ronxin999.blog.163.com/blog/static/422179202013621111545534/



---
#API
[simplehbase](http://www.infoq.com/cn/articles/hbase-orm-simplehbase-design)




---
#坑
PageFilter










---
#安装
## oper
start-hbase.sh
stop-hbase.sh
### hbase cleanlog
pssh -h /root/other.txt -l root -i 'rm -f /opt/hbase/logs/*'

## conf
http://ixirong.com/2015/05/25/how-to-install-hbase-cluster/
##.bashrc
HBASE=/opt/hbase
PATH

pssh -h /root/other.txt -l root -i 'mkdir -p /opt/hbase/logs'
##hbase-env.sh
export JAVA_HOME=/opt/java
export HBASE_CLASSPATH=/opt/hbase/conf
export HBASE_MANAGES_ZK=false
export HBASE_HOME=/opt/hbase
export HADOOP_HOME=/opt/hadoop
export HBASE_LOG_DIR=/opt/hbase/logs
export HBASE_PID_DIR=/opt/hbase/pids

pscp -h /root/other.txt -l root /opt/hbase/conf/hbase-env.sh /opt/hbase/conf
pssh -h /root/other.txt -l root -i 'cat /opt/hbase/conf/hbase-env.sh'

pssh -h /root/other.txt -l root -i 'mkdir -p /opt/hbase/pids'


##hbase-site.xml
pscp -h /root/other.txt -l root /opt/hbase/conf/hbase-site.xml /opt/hbase/conf

    <configuration>
            <property>
                    <name>hbase.rootdir</name>
                    <value>hdfs://namenode:9000/hbase</value>
            </property>
            <property>
                    <name>hbase.cluster.distributed</name>
                    <value>true</value>
            </property>
            <property>
                    <name>hbase.master</name>
                    <value>hmaster1:60000</value>
            </property>
            <property>
                    <name>hbase.zookeeper.quorum</name>
                    <value>hmaster1,datanode1,datanode2</value>
            </property>
    </configuration>    
pssh -h /root/other.txt -l root -i 'cat /opt/hbase/conf/hbase-site.xml'

##regionservers
regionServer1
regionServer2
pscp -h /root/other.txt -l root /opt/hbase/conf/regionservers /opt/hbase/conf
pssh -h /root/other.txt -l root -i 'cat /opt/hbase/conf/regionservers'


# Q&A
## NoServerForRegionException: Unable to find region for xxxx
hbase jar包版本问题



















