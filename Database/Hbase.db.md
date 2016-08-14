#hbase
---
#基本架构







[HBASE在淘宝网的应用和优化小结](http://www.eygle.com/digest/2012/03/hbase_at_taobao.html)
优点
数据100%可靠 己经证明了hdfs集群的安全性，以及服务于海量数据的能力。其次hbase本身的数据读写服务没有单点的限制，服务能力可以随服务器的增长而线性增长， 达到几十上百台的规模。LSM-Tree模式的设计让hbase的写入性能非常良好，单次写入通常在1-3ms内即可响应完成，且性能不随数据量的增长而 下降。region（相当于数据库的分表）可以ms级动态的切分和移动，保证了负载均衡性。由于hbase上的数据模型是按rowkey排序存储的，而读 取时会一次读取连续的整块数据做为cache，因此良好的rowkey设计可以让批量读取变得十分容易，甚至只需要１次io就能获取几十上百条用户想要的 数据。

缺点
hbase本身也有不适合的场景。比如，索引只支持主索引（或看成主组合索引），又比如服务是单点 的，单台机器宕机后在master恢复它期间它所负责的部分数据将无法服务等。这就要求在选型上需要对自己的应用系统有足够了解。



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
```java
SortedMap<
	RowKey,List<
		SortedMap<
			Column,List<
				Value,Timestamp
			>
		>
	>
>
```
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
(5) Region虽然是分布式存储的最小单元，但并不是存储的最小单元。HRegion由一个或者多个Store组成
Store存储是HBase存储的核心了，其中由两部分组成，一部分是MemStore，一部分是StoreFiles

* MemStore缓存用户写入的数据
MemStore是Sorted Memory Buffer，用户写入的数据首先会放入MemStore。
* StoreFile最终存储这些数据
当MemStore满了以后会Flush成一个StoreFile（底层实现是HFile），当StoreFile文件数量增长到一定阈值，会触发Compact合并操作，将多个StoreFiles合并成一个StoreFile，合并过程中会进行版本合并和数据删除，因此可以看出HBase其实只有增加数据，所有的更新和删除操作都是在后续的compact过程中进行的，这使得用户的写操作只要进入内存中就可以立即返回，保证了HBase I/O的高性能。当StoreFiles Compact后，会逐步形成越来越大的StoreFile，当单个StoreFile大小超过一定阈值后，会触发Split操作，同时把当前Region Split成2个Region，父Region会下线，新Split出的2个孩子Region会被HMaster分配到相应的HRegionServer上，使得原先1个Region的压力得以分流到2个Region上。
```
Table
	Region
		Store
			MemStore
			StoreFiles
```

关于列族的存储：
每个HStore对应了Table中的一个Column Family的存储，每个Column Family其实就是一个集中的存储单元，因此最好将具备共同IO特性的column放在一个ColumnFamily中，这样最高效。
我理解这句话的意思是这样的： 不论是Region，Store，还是构成Store的一个MemStore和多个StoreFile，他们都是逻辑上的概念，在HBase中都描述为一个类，最终真实存储数据的物理存储对象是HDFS上的HFile。
一个Store对应一个列族，意思就是一个特定的列族是用一个Store对象描述，通过这个Store对象可以访问到这个列族的所有信息。

###HFile
一个列族对应于一个HStore，其中又包含一个写缓存MemStore，多个存储数据的HFile，实际上还有一个读缓存BlockCache。
一个列族在存储到其HStore的时候，是先写满一个HFile，再写下一个HFile。所以针对任意一行，其一个列族的数据必定存储在一个HFile文件中，所以说访问一个列族的数据比较高效。另外任意一行的所有列族的数据一定存储在一个region中。

HBase是面向列的数据库：列族中的每一列，若没有数据则不会存储。
HBase是按列族存储的数据库： 一行中 同一个列族中的数据必定存放在一起（一个HFile中）。

###HLog
用于防止写入MemStore的数据丢失：
在分布式系统环境中，无法避免系统出错或者宕机，因此一旦HRegionServer意外退出，MemStore中的内存数据将会丢失，这就需要引入HLog了。每个HRegionServer中都有一个HLog对象，HLog是一个实现Write Ahead Log的类，在每次用户操作写入MemStore的同时，也会写一份数据到HLog文件中（HLog文件格式见后续），HLog文件定期会滚动出新的，并删除旧的文件（已持久化到StoreFile中的数据）。当HRegionServer意外终止后，HMaster会通过Zookeeper感知到，HMaster首先会处理遗留的 HLog文件，将其中不同Region的Log数据进行拆分，分别放到相应region的目录下，然后再将失效的region重新分配，领取 到这些region的HRegionServer在Load Region的过程中，会发现有历史HLog需要处理，因此会Replay HLog中的数据到MemStore中，然后flush到StoreFiles，完成数据恢复。

备注：上面提到两个概念，即HFile和HLog，HBase中的所有数据文件都存储在Hadoop HDFS文件系统上，主要包括这两种文件类型：
1.HFile， HBase中KeyValue数据的存储格式，HFile是Hadoop的二进制格式文件，实际上StoreFile就是对HFile做了轻量级包装，即StoreFile底层就是HFile
2.HLog File，HBase中WAL（Write Ahead Log）的存储格式，物理上是Hadoop的Sequence File



---
#HBase架构及组件
Client
HBaseClient使用HBase的RPC机制与HMaster和HRegionServer进行通信.
对于管理类操作，Client与HMaster进行RPC；对于数据读写类操作，Client与HRegionServer进行RPC。
HBaseClient包含访问HBase的接口，并维护cache来加快对HBase的访问，比如region的位置信息

Zookeeper
HBase中有两张特殊的Table，-ROOT-和.META.
Ø .META.：记录了用户表的Region信息，.META.可以有多个regoin
Ø -ROOT-：记录了.META.表的Region信息，-ROOT-只有一个region
Ø Zookeeper中记录了-ROOT-表的location
(1) Client访问用户数据之前需要首先访问zookeeper，拿到-ROOT表的位置信息，然后访问-ROOT-表，拿到对应的.META表的位置信息，接着访问.META.表，最后才能找到用户数据的位置去访问，中间需要多次网络操作，不过client端会做cache缓存。
(2)ZookeeperQuorum中除了存储了-ROOT-表的地址和HMaster的地址，HRegionServer也会把自己以Ephemeral方式注册到Zookeeper中，使得HMaster可以随时感知到各个HRegionServer的健康状态。此外，Zookeeper也避免了HMaster的单点问题

##HMaster
HMaster没有单点问题，HBase中可以启动多个HMaster，通过Zookeeper的MasterElection机制保证总有一个Master运行，HMaster在功能上主要负责Table和Region的管理工作：
1.管理用户对Table的增、删、改、查操作
2.管理HRegionServer的负载均衡，调整Region分布
3.在RegionSplit后，负责新Region的分配
4.在HRegionServer停机后，负责失效HRegionServer上的Regions迁移

HRegionServer
HRegionServer维护region，处理对这些region的IO请求，向HDFS文件系统中读写数据，是HBase中最核心的模块。




---
#实现架构
##数据查找和传输
###B+树
OPTIMIZE TABLE 优化表，按顺序重写表，范围查询编程多段连续读取

###LSM树
log-structred merge-tree

输入数据先被存储在日志文件，这些文件内数据完全有序
当有日志文件被修改时，对应更新会被保存在内存中来加速查询
当系统经历多次数据修改，且内存空间逐渐被占满后，LSM树会把有序 键-记录 对写到磁盘中，同时创建一个新的数据存储文件。
最近修改都被持久化，内存中保存最近更新就可以被丢弃了
存储文件的组织与B树类似，为顺序读取做了优化，按页 存储

##存储
###写路径
WAL是hadoop的SequenceFile并存储了HLogKey实例
写入WAL后，被放到MemStore中，检查是否已满
	满-写入磁盘 另一个HRegionServer线程处理，写成HDFS中的一个新HFile，同时保存最后写入的序号

预刷写 prefushing ，memstore被刷写到磁盘第二个理由
region被要求关闭，首先检查memstore，任何大于配置值hbase.hregion.preclose.flush.size（默认5MB）的memstore会刷写到磁盘，最后一轮阻塞正常访问的刷写后关闭region

另一方面，关闭region服务器会强制所有Memstore被刷写到磁盘，不关心memstore是否达到配置的最大值，可以使用hbase.hregion.memstore.flush.size（默认值64MB）或者通过创建表进行设置。一旦所有memstore刷写到磁盘，region会被关闭，且在转移到其他region服务器时，不会重做WAL

###文件
/hbase
hadoop dfs-lsr查看hbase目录结构

根级文件
.logs 目录

表级文件
.tableinfo 文件
.tmp 目录

region级文件
testtable,row-500,130981215390-.d9ffc3a5...5ad48e237a.
文件名结尾的.标识包含散列值的新样式名字，以前版本不包含
region文件总体结构
/<hbase-root-dir>/<tablename>/<encoded-regionname>/<column-family>/<filename>

.regioninfo文件

###region拆分
当一个region存储文件增长到大于配置的hbase.hregion.max.filesize大小或列族层面配置的大小时，一分为二

合并
minor合并，重写多个文件写到一个更大文件中
hbase.hstore.compaction.min 默认=3
minor合并处理最大文件数量默认为10
hbase.hstore.compaction.max 

hbase.hstore.compaction.ratio 默认1.2确保选择过程中包括足够的文件

major合并：把所有文件"压缩"为一个单独文件
触发：memstor被写到磁盘；compact、major_compact之后触发检查；相应API调用后触发；异步后台进程触发
CompactionChecker类实现
hbase.server.htread.wakefrequency
hbase.server.htread.wakefrequency.multiplier设为1000

hbase.hregion.majorcompaction 指定的时限 24小时
hbase.hregion.majorcompaction.jitter 0.2 20%

###HFile格式
基于Hadoop的TFile类
Data | Data | Data | Meta(Optional) | Meta(Optional | .. |FileInfo | DataIndex | MetaIndex | Trailer 

Data:
Magic | Key-Value | Key-Value | ... | Key-Value | Key-Value | 

可变长度，唯一固定的块是File Info块和Trailer块
Trailer指向其他块的指针，持久化数据到文件结束时写入，写入后确定其成为不可变的数据存储文件
Index块记录Data和Meta块的偏移量

块大小由HColumnDescriptor配置

hbase块和HDFS块之间没有匹配关系

###KeyValue格式
KeyLength | ValueLength | RowLength | Row... | ColumnFaimilyLength | ColumnFamily... | ColumnQualifier... | Timestamp | KeyType | Value


---
#WAL
##HLog类
实现了WAL
setWriteToWAL(false)
追踪修改

##HLogKey类

##WALEdit类
日志更新原子性管理

##LongSyncer类
延迟日志刷新deffered log flush 标志，默认false，即每次都调用sync()
管道写：发送到第一个DataNode，成功后，把修改发送到第二个，三个DataNode服务器都确认了写操作，客户端才允许继续进行；延迟高；
多路写：同时发生写操作，所有主机确认写操作后，才继续；延迟低，带宽要求高

deffered log flush设为true，导致修改被缓存在region服务器中，然后在服务器上LogSyncer类作为一个线程运行，短时间间隔内调用sync()，默认1秒
注：只作用于用户表，目录表一直保持同步

##LogRoller类
日志写入大小限制
hbase.regionserver.logroll.period，默认1小时

hbase.regionserver.hlog.blocksize，默认32MB，文件系统默认块大小

hbase.regionserver.logroll.multiplier 0.95

##回放
###单文件
所有数据更新都会写入到region服务器中一个基于HLog的日志文件中
如果每个region分开写，会导致同时写入太多文件，且要保留滚动日志，影响扩展性
缺点：
服务器崩溃，系统需要拆分日志，日志没有索引，master不可能立即把一个崩溃服务器的region部署到其他服务器上，需要等待对应region日志被拆分出来，如果服务器崩溃前来不及将数据更新刷写到文件系统，需要拆分的WAL也将非常庞大

###日志拆分
分布式模式
hbase.master.distributed.log.splitting

###持久性























