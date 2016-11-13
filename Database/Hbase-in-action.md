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



















