#hbase
---
#基本架构




---
#HBase访问接口
1. Native Java API，最常规和高效的访问方式，适合Hadoop MapReduce Job并行批处理HBase表数据
2. HBase Shell，HBase的命令行工具，最简单的接口，适合HBase管理使用
3. Thrift Gateway，利用Thrift序列化技术，支持C++，PHP，Python等多种语言，适合其他异构系统在线访问HBase表数据
4. REST Gateway，支持REST 风格的Http API访问HBase, 解除了语言限制
5. Pig，可以使用Pig Latin流式编程语言来操作HBase中的数据，和Hive类似，本质最终也是编译成MapReduce Job来处理HBase表数据，适合做数据统计
6. Hive，当前Hive的Release版本尚没有加入对HBase的支持，但在下一个版本Hive 0.7.0中将会支持HBase，可以使用类似SQL语言来访问HBase


---
#HBase存储模型
##基本概念
* RowKey
Byte array，是表中每条记录的“主键”，方便快速查找，Rowkey的设计非常重要，因为根据rowkey查找数据效率极高。
* Column Family
列族，拥有一个名称(string)，包含一个或者多个相关列，创建一个表的时候列族要事先定义并不能动态更改，类似关系数据库的Schema
* Column
属于某一个columnfamily，familyName:columnName，每个列族中的列无需事先定义，可动态增加（HBase表动态拓展的关键）
* Version Number
类型为Long，默认值是系统时间戳，可由用户自定义
* Value(Cell) 
Byte array

##逻辑模型 table structure
Row Key |column-family1 | column-family2 | column-family3
------- | ------------- | -------------- | ------------- 
        |col1  col2     | col1    col2   |  col3  | col1
key1    |                    
key2    |                    
key3    |

可以看到每一行都有一个rowkey作为主键唯一标识一行，并且列族是固定的。
同一个列族，但是不同的行，所包含的列并不一样，只存储有值的列。
每一个值可能有多个版本，默认以时间戳作为区分。
所有值都是以字节数组的形式被存储。

##物理上如何存储（HRegion，Store，MemStore，StoreFile，HFile，HLog）
(1) Table中所有行都按照row key的字典序排列；
(2) Table按照行被分割为多个Region。当Table随着记录数不断增加而变大后，会逐渐分裂成多份splits，成为regions，一个region由[startkey,endkey)表示，不同的region会被Master分配给相应的RegionServer进行管理。
(3) Region按大小分割的，每个表开始只有一个Region，随着数据增多，Region不断增大，当增大到一个阀值的时候，Region就会等分会两个新的Region，之后会有越来越多的Region；
(4) Region是Hbase中分布式存储和负载均衡的最小单元，不同Region分布到不同RegionServer上。











---
#command
[hbase shell基础和常用命令详解](http://www.jb51.net/article/31172.htm)

hbase shell
status
version
list

## 1 hadoop 
hadoop fsck / -files -blocks

### chk size
hadoop dfsadmin -report

### file operation
hadoop fs -copyFromLocal localfile hdfs://localhost/xxx

http://zy19982004.iteye.com/blog/2024467

## 2 hbase
### DDL
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

### DML
#### add data
put <table>,<rowkey>,<family:column>,<value>,<timestamp>
put 'gpsInfoTest','0000000320101227','baseInfo:081351','01010200202010000003\x00;2010-12-27 08:13:51\x00;109.10437\x00;36.64465\x00;',1293408831000

put 'user','andieguo','info:age','27'

#### get data
get <table>,<rowkey>,[<family:column>,....]
get 'gpsInfoTest','0000000320101227','baseInfo:081351'

get 'user','andieguo',{COLUMN=>'info:age',TIMESTAMP=>1409304}

get 'gpsInfoTest','0000000320101227','info'

#### del data
delete  '表名' ,'行名称' , '列名称'
delete 'test_gpsinfo','0101024050602010796620150325','baseInfo'

delete 'test_gpsinfo','0101024050602010796620150325','baseInfo:113922'

put '表名称', '行名称', '列名称:', '值'
status
version

##### del row
deleteall 'gpsInfoTest','null20150611'

#### truncate table
truncate 'tablename'

#### hbase分页
http://ronxin999.blog.163.com/blog/static/422179202013621111545534/
