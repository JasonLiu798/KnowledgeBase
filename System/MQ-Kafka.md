#kafka
---
# doc
http://kafka.apache.org
[消息系统Kafka介绍](http://dongxicheng.org/search-engine/kafka/)
[Updated Kafka PHP client library - Lorenzo Alberton](http://www.tuicool.com/articles/zIzyq2)
[日志：每个软件工程师都应该知道的有关实时数据的统一概念](http://www.oschina.net/translate/log-what-every-software-engineer-should-know-about-real-time-datas-unifying)
[分布式发布订阅消息系统 Kafka 架构设计](http://www.oschina.net/translate/kafka-design?lang=chs&page=1#)


---
#架构
[Kafka剖析（一）：Kafka背景及架构介绍](http://www.infoq.com/cn/articles/kafka-analysis-part-1)
[](http://www.infoq.com/cn/articles/kafka-analysis-part-2)
[](http://www.infoq.com/cn/articles/kafka-analysis-part-3)



消息
指的是通信的基本单位。由消息生产者（producer）发布关于某话题（topic）的消息，这句话的意思是，消息以一种物理方式被发送给了作为代理（broker）的服务器（可能是另外一台机器）。若干的消息使用者（consumer）订阅（subscribe）某个话题，然后生产者所发布的每条消息都会被发送给所有的使用者。

Producers 写数据到 Brokers
Consumers 从 Brokers 读数据

订阅机制

分布式系统日志
状态机复制原理：如果两个相同的、确定性的进程从同一状态开始，并且以相同的顺序获得相同的输入，那么这两个进程将会生成相同的输出，并且结束在相同的状态。

确定性:意味着处理过程是与时间无关的，而且任何其他“外部的“输入不会影响到处理结果
进程状态:是进程保存在机器上的任何数据，在进程处理结束的时候，这些数据要么保存在内存里，要么保存在磁盘上

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
#operation
##topic
###create
kafka-topics.sh --create --topic gpsraw --replication-factor 3 --partitions 2 --zookeeper namenode:2181

###delete
kafka-topics.sh --zookeeper namenode:2181 --delete --topic {topic name}

###alter
kafka-topics.sh --create --topic gpsraw --replication-factor 3 --partitions 3 --zookeeper namenode:2181

###list
kafka-topics.sh --zookeeper namenode:2181,datanode1:2181,datanode2:2181 --delete --topic {topic name}
kafka-topics.sh --zookeeper zk_host:port/chroot --alter --topic my_topic_name --config x=y

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







