#kafka
---
#doc
Kafka，高吞吐的分布式消息系统，源于LinkedIn，现在是apache顶级项目。大部分由Scala编写，一些Kafka用Java编写，共有9个核心的开发者，社区非常活跃

http://kafka.apache.org
[消息系统Kafka介绍](http://dongxicheng.org/search-engine/kafka/)
[Updated Kafka PHP client library - Lorenzo Alberton](http://www.tuicool.com/articles/zIzyq2)
[日志：每个软件工程师都应该知道的有关实时数据的统一概念](http://www.oschina.net/translate/log-what-every-software-engineer-should-know-about-real-time-datas-unifying)
[分布式发布订阅消息系统 Kafka 架构设计](http://www.oschina.net/translate/kafka-design?lang=chs&page=1#)-[原文](http://kafka.apache.org/documentation.html#design)
[Benchmarking Apache Kafka: 2 Million Writes Per Second (On Three Cheap Machines)](https://engineering.linkedin.com/kafka/benchmarking-apache-kafka-2-million-writes-second-three-cheap-machines)

---
#架构
[Kafka剖析（一）：Kafka背景及架构介绍](http://www.infoq.com/cn/articles/kafka-analysis-part-1)
[](http://www.infoq.com/cn/articles/kafka-analysis-part-2)
[](http://www.infoq.com/cn/articles/kafka-analysis-part-3)

##核心思想
日志有两个重要的特征 有序，不可变

##目的
就是要成为一个队列平台，仅仅使用它就能够既支持离线又支持在线使用这两种情况。
不可变（immutable）的活动数据

活动流数据是所有站点在对其网站使用情况做报表时要用到的数据中最常规的部分。
活动数据包括页面访问量（page view）、被查看内容方面的信息以及搜索情况等内容。
这种数据通常的处理方式是先把各种活动以日志的形式写入某种文件，然后周期性地对这些文件进行统计分析。
运营数据指的是服务器的性能数据（CPU、IO使用率、请求时间、服务日志等等数据)。运营数据的统计方法种类繁多。

###活动流和运营数据的若干用例
* "动态汇总（News feed）"功能。将你朋友的各种活动信息广播给你
* 相关性以及排序。通过使用计数评级（count rating）、投票（votes）或者点击率（ click-through）判定一组给定的条目中那一项是最相关的.
* 安全：网站需要屏蔽行为不端的网络爬虫（crawler），对API的使用进行速率限制，探测出扩散垃圾信息的企图，并支撑其它的行为探测和预防体系，以切断网站的某些不正常活动。
* 运营监控：大多数网站都需要某种形式的实时且随机应变的方式，对网站运行效率进行监控并在有问题出现的情况下能触发警告。
* 报表和批处理: 将数据装载到数据仓库或者Hadoop系统中进行离线分析，然后针对业务行为做出相应的报表，这种做法很普遍。

###活动流数据的特点
不可变（immutable）
数据量大
传统的日志文件统计分析对报表和批处理这种离线处理，对于实时处理来说其时延太大，而且还具有较高的运营复杂度
现有MQ适合于在实时或近实时（near-real-time）的情况下使用，但它们对很长的未被处理的消息队列的处理很不给力，往往并不将数据持久化作为首要的事情考虑


##主要的设计元素
Kafka之所以和其它绝大多数信息系统不同，是因为下面这几个为数不多的比较重要的设计决策：
* Kafka在设计之时为就将持久化消息作为通常的使用情况进行了考虑。
* 主要的设计约束是吞吐量而不是功能。
* 有关哪些数据已经被使用了的状态信息保存为数据使用者（consumer）的一部分，而不是保存在服务器之上。
* Kafka是一种显式的分布式系统。它假设，数据生产者（producer）、代理（brokers）和数据使用者（consumer）分散于多台机器之上。


##消息持久化（Message Persistence）及其缓存
不要害怕文件系统！
在对消息进行存储和缓存时，Kafka严重地依赖于文件系统。 大家普遍认为“磁盘很慢”，因而人们都对持久化结（persistent structure）构能够提供说得过去的性能抱有怀疑态度。实际上，同人们的期望值相比，磁盘可以说是既很慢又很快，这取决于磁盘的使用方式。设计的很好的磁盘结构往往可以和网络一样快。

磁盘性能方面最关键的一个事实是，在过去的十几年中，硬盘的吞吐量正在变得和磁盘寻道时间严重不一致了。结果，在一个由6个7200rpm的SATA硬盘组成的RAID-5磁盘阵列上，线性写入（linear write）的速度大约是300MB/秒，但随即写入却只有50k/秒，其中的差别接近10000倍。

操作系统采用预读（read-ahead）和后写（write-behind）技术对磁盘读写进行探测并优化后效果也不错

JVM内存
Java对象的内存开销（overhead）非常大，往往是对象中存储的数据所占内存的两倍（或更糟）。
Java中的内存垃圾回收会随着堆内数据不断增长而变得越来越不明确，回收所花费的代价也会越来越大。

这些因素，使用文件系统并依赖于页面缓存要优于自己在内存中维护一个缓存或者什么别的结构 —— 通过对所有空闲内存自动拥有访问权，我们至少将可用的缓存大小翻了一倍，然后通过保存压缩后的字节结构而非单个对象，缓存可用大小接着可能又翻了一倍。

这就让人联想到一个非常简单的设计方案：不是要在内存中保存尽可能多的数据并在需要时将这些数据刷新（flush）到文件系统，而是我们要做完全相反的事情。所有数据都要立即写入文件系统中持久化的日志中但不进行刷新数据的任何调用。


##Btree 对比持久化队列
Btree运算的时间复杂度为O(log N)
磁盘寻道时间一次要花10ms的时间，而且每个磁盘同时只能进行一个寻道操作，因而其并行程度很有限。因此，即使少量的磁盘寻道操作也会造成非常大的时间开销。
行级锁代价高昂

持久化队列
所有的操作的复杂度都是O(1)，读取操作并不需要阻止写入操作，而且反之亦然

##效率最大化
导致低效率的原因常见的有两个：过多的网络请求和大量的字节拷贝操作
###消息集
API是围绕这“消息集”（message set）抽象机制进行设计的，消息集将消息进行自然分组。这么做能让网络请求把消息合成一个小组，分摊网络往返（roundtrip）所带来的开销，而不是每次仅仅发送一个单个消息

##零拷贝
[Efficient data transfer through zero copy](https://www.ibm.com/developerworks/linux/library/j-zerocopy/)
为了将数据从页面缓存直接传送给socket，现代的Unix操作系统提供了一个高度优化的代码路径（code path）
Linux中这是通过sendfile这个系统调用实现的。通过Java中的API，FileChannel.transferTo

数据从文件传输到socket的数据路径，未优化的步骤：
操作系统将数据从磁盘中读取到内核空间里的页面缓存
应用程序将数据从内核空间读入到用户空间的缓冲区
应用程序将读到的数据写回内核空间并放入socke的缓冲区
操作系统将数据从socket的缓冲区拷贝到NIC（网络借口卡，即网卡）的缓冲区，自此数据才能通过网络发送出去

##端到端的批量压缩
高效压缩需要将多条消息一起进行压缩而不是分别压缩每条消息


##传统的消息确认
* 处理多次:`如果使用者已经处理了该消息但却未能发送出确认信息，那么就会让这一条消息被处理两次。
* 性能：这种策略中的代理必须为每条单个的消息维护多个状态（首先为了防止重复发送就要将消息锁定，然后，然后还要将消息标示为已使用后才能删除该消息

##消息传递语义
* 最多一次—这种用于处理前段文字所述的第一种情况。消息在发出后立即标示为已使用，因此消息不会被发出去两次，但这在许多故障中都会导致消息丢失。
* 至少一次—这种用于处理前文所述的第二种情况，系统保证每条消息至少会发送一次，但在有故障的情况下可能会导致重复发送。
* 仅仅一次—这种是人们实际想要的，每条消息只会而且仅会发送一次。

##pull还是push
kafka:由生产者将数据Push给代理，然后由使用者将数据代理那里Pull回来
基于push的缺点:
基于Push的系统中代理控制着数据的传输速率，因此它难以应付大量不同种类的使用者。我们的设计目标是，让使用者能以它最大的速率使用数据


##消息
指的是通信的基本单位。由消息生产者（producer）发布关于某话题（topic）的消息，这句话的意思是，消息以一种物理方式被发送给了作为代理（broker）的服务器（可能是另外一台机器）。若干的消息使用者（consumer）订阅（subscribe）某个话题，然后生产者所发布的每条消息都会被发送给所有的使用者。
Producers
写数据到 Brokers
Consumers
从 Brokers 读数据

##订阅机制
分布式系统日志
###状态机复制原理
如果两个相同的、确定性的进程从同一状态开始，并且以相同的顺序获得相同的输入，那么这两个进程将会生成相同的输出，并且结束在相同的状态。
###确定性
意味着处理过程是与时间无关的，而且任何其他“外部的“输入不会影响到处理结果
###进程状态
是进程保存在机器上的任何数据，在进程处理结束的时候，这些数据要么保存在内存里，要么保存在磁盘上

分布式系统文献通常把处理和复制（processing and replication）方案宽泛地分成两种。
『状态机器模型』常常被称为主-主模型（active-active model）， 记录输入请求的日志，各个复本处理每个请求。
对这个模型做了细微的调整称为『主备模型』（primary-backup model），即选出一个副本做为leader，让leader按请求到达的顺序处理请求，并输出它请求处理的状态变化日志。 其他的副本按照顺序应用leader的状态变化日志，保持和leader同步，并能够在leader失败的时候接替它成为leader。

变更日志（changelog）101：表与事件的二象性（duality）


##Topics
Queue：同一个小组
Topic：不同小组
Producer一直往后追加
Consume通过offset控制消费进度

##Partitions
一个topic由多个partitions组成
有序+不可变的消息不断往后追加
每个Partition相当于一个文件夹

##Replicas
Partition的备份
防止数据丢失&高可用
replication-factor=2可容忍1个broker宕机

消息传递语义
最多一次，不会重复，故障情况下会导致丢失
最少一次，默认，消息不会丢失，故障情况会重复
仅仅一次，不会重复也不回丢失

##有序性
单分区有序
1.producer send指定分区
2.consumer指定分区消费，自行实现fail-over
3.replication-factor设置为N（N为broker数量），保证broker n-1宕机容忍度
Apache Samza=Kafka+Yarn+SamzaJob




---
#实现分析

每个日志文件都是一个log entrie序列，每个log entrie包含一个4字节整型数值（值为N+5），1个字节的"magic value"，4个字节的CRC校验码，其后跟N个字节的消息体。每条消息都有一个当前Partition下唯一的64字节的offset，它指明了这条消息的起始位置。磁盘上存储的消息格式如下：

message length ： 4 bytes (value: 1+4+n)
"magic" value ： 1 byte
crc ： 4 bytes
payload ： n bytes










---
#setup
##copy tgz
pscp -h /root/ot.txt -l root kafka_2.8.0-0.8.1.1.tgz /opt/rpm/

pssh -h /root/ot.txt -l root -i 'tar -zpxvf /opt/rpm/kafka_2.8.0-0.8.1.1.tgz -C /opt/rpm'
pssh -h /root/ot.txt -l root -i 'ln -sfv /home/rpm/kafka_2.8.0-0.8.1.1 /opt/kafka'

##edit profile
 /etc/profile
    export KAFKA_HOME=/opt/kafka
    export ZK_HOME=/opt/zookeeper
    export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
    export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$KAFKA_HOME/bin:$ZK_HOME/bin:$PATH

pscp -h /root/ot.txt -l root /root/.bashrc /root

##[setup zookeeper](Zookeeper.md)

##server.properties
###node1
```
broker.id=0
port=9092
host.name=node0
advertised.host.name=node0
num.partitions=2
zookeeper.connect=zk1:2181,zk2:2181,zk3:2181
```
pscp -h /root/zk.txt -l root /opt/kafka/config/server.properties /opt/kafka/config

###node1
```
broker.id=1
host.name=node1
advertised.host.name=node1
```

###node2
```
broker.id=2
host.name=datanode2
advertised.host.name=datanode2
```


---
#startup
##start zookeeper
##start kafka
pssh -h /root/all -l root -i 'nohup kafka-server-start.sh $KAFKA_HOME/config/server.properties > $KAFKA_HOME/logs/kafka.out 2>&1 &'

    *Q*
    Java HotSpot(TM) 64-Bit Server VM warning: INFO: os::commit_memory(0x00000000c5330000, 986513408, 0) failed; error='Cannot allocate memory' (errno=12)
    kafka-server-start.sh
    export KAFKA_HEAP_OPTS="-Xmx256m -Xms128m"
    pscp -h /root/slave -l root kafka-server-start.sh /opt/kafka/bin


---
#command
##topic
###create
kafka-topics.sh --create --topic gpsraw --replication-factor 3 --partitions 2 --zookeeper namenode:2181

###delete
kafka-topics.sh --zookeeper namenode:2181 --delete --topic {topic name}

###alter
kafka-topics.sh --create --topic gpsraw --replication-factor 3 --partitions 3 --zookeeper namenode:2181

###list
```
#list-all
kafka-list-topic.sh --zookeeper 192.168.197.170:2181,192.168.197.171:2181
#list-single
kafka-list-topic.sh --zookeeper 192.168.197.170:2181,192.168.197.171:2181
#list-single
kafka-topics.sh --zookeeper namenode:2181,datanode1:2181,datanode2:2181 --delete --topic {topic name}

kafka-topics.sh --zookeeper zk_host:port/chroot --alter --topic my_topic_name --config x=y

```

###alter
* add partion
kafka-topics.sh --zookeeper namenode:2181 --alter --topic gpsraw --partitions 3


---
#producer&consumer operation
##procuder
datanode1
kafka-console-producer.sh --broker-list namenode:9092 --sync --topic test
kafka-console-producer.sh --broker-list namenode:9092,datanode1:9092,datanode2:9092 --topic test

##consumer
datanode2
kafka-console-consumer.sh --zookeeper namenode:2181 --topic test --from-beginning


##list topic
kafka-topics.sh --list --zookeeper namenode:2181,datanode1:2181,datanode2:2181

./kafka-list-topic.sh --zookeeper C5-3_Kafka01.cnpc.com.cn:2222,C5-3_Kafka02.cnpc.com.cn:2222,C5-3_Kafka03.cnpc.com.cn:2222,C5-3_Kafka04.cnpc.com.cn:2222,C5-3_Kafka05.cnpc.com.cn:2222

11.10.141.30


---
#dev
##producer
brokerlist namenode:9092,datanode1:9092,datanode2:9092

http://blog.csdn.net/lizhitao/article/details/37811291

offical
http://kafka.apache.org/documentation.html#intro_consumers
consumer
https://cwiki.apache.org/confluence/display/KAFKA/Consumer+Group+Example

##env
http://www.cnblogs.com/huxi2b/p/4364128.html







