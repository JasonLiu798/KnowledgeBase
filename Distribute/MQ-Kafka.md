#kafka
---
# doc
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


##目的
就是要成为一个队列平台，仅仅使用它就能够既支持离线又支持在线使用这两种情况。
不可变（immutable）的活动数据

##Btree 对比持久化队列
Btree运算的时间复杂度为O(log N)
磁盘寻道时间一次要花10ms的时间，而且每个磁盘同时只能进行一个寻道操作，因而其并行程度很有限。因此，即使少量的磁盘寻道操作也会造成非常大的时间开销。
行级锁代价高昂

持久化队列
所有的操作的复杂度都是O(1)，读取操作并不需要阻止写入操作，而且反之亦然

##消息集
API是围绕这“消息集”（message set）抽象机制进行设计的，消息集将消息进行自然分组。这么做能让网络请求把消息合成一个小组，分摊网络往返（roundtrip）所带来的开销，而不是每次仅仅发送一个单个消息

##零拷贝
为了将数据从页面缓存直接传送给socket，现代的Unix操作系统提供了一个高度优化的代码路径（code path）
Linux中这是通过sendfile这个系统调用实现的。通过Java中的API，FileChannel.transferTo

数据从文件传输到socket的数据路径，未优化的步骤：
操作系统将数据从磁盘中读取到内核空间里的页面缓存
应用程序将数据从内核空间读入到用户空间的缓冲区
应用程序将读到的数据写回内核空间并放入socke的缓冲区
操作系统将数据从socket的缓冲区拷贝到NIC（网络借口卡，即网卡）的缓冲区，自此数据才能通过网络发送出去

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

##setup zookeeper
##conf
zoo.cfg
server.1=namenode:2888:3888
server.2=datanode1:2888:3888
server.3=datanode2:2888:3888

###namenode->server.properties
broker.id=0  
port=9092
host.name=namenode
advertised.host.name=namenode
    ...  
num.partitions=2
    ...
zookeeper.connect=namenode:2181,datanode1:2181,datanode2:2181

pscp -h /root/zk.txt -l root /opt/kafka/config/server.properties /opt/kafka/config

###datanode1->server.properties
broker.id=1
host.name=datanode1
advertised.host.name=datanode1

###datanode2->server.properties
broker.id=2
host.name=datanode2
advertised.host.name=datanode2

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







