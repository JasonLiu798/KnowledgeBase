#Kafka in action
----
#doc
[某互联网大厂kafka最佳实践](http://www.jianshu.com/p/8689901720fd)
<<<<<<< HEAD

[Kafka 0.9 新消费者API](http://www.cnblogs.com/admln/p/5446361.html)
[kafka 可靠性思考](http://www.java123.net/975509.html)
=======
[go client](https://github.com/wvanbergen/kafka)

>>>>>>> b05f61101a6c7239fd01d6aa478087dfec7c66f0
---
#一、硬件考量
##1.1、内存
不建议为kafka分配超过5g的heap，因为会消耗28-30g的文件系统缓存，而是考虑为kafka的读写预留充足的buffer。Buffer大小的快速计算方法是平均磁盘写入数量的30倍。推荐使用64GB及以上内存的服务器，低于32GB内存的机器可能会适得其反，导致不断依赖堆积机器来应付需求增长。（我们在生产环境使用的机器是64G内存的，但也看到LinkedIn用了大量28G内存的服务器。）

##1.2、CPU
kafka不算是CPU消耗型服务，在主频和CPU核数之间，选择后者，将会获得多核带来的更好的并发处理性能。

##1.3、磁盘
毋庸置疑，RAID是优先推荐的，它在底层实现了物理磁盘的负载均衡和冗余，虽然会牺牲一些磁盘空间和写入性能。更进一步，我们推荐在配置中使用多目录，每个目录挂在在不同的磁盘（或者RAID）上。需要注意的是，NAS是不可取的，无论供应商如何吹嘘他们的NAS的卓越性能。另外，我们经常看到用户咨询kafka是否一定要采用SSD，答案是没有必要。

##1.4网络
分布式系统中，网络的速度和可靠性异常重要，千兆甚至万兆网络现在应该成为数据中心的标配。避免kafka集群出现跨数据中心的情况，更要避免有很大的物理空间跨度，尤其中国还有诡异的联通电信问题。kafka集群中各个节点地位均等，一旦因为延时导致分布式集群不稳定，排错尤其困难。

##1.5、文件系统
ext4是最佳选择。

##1.6、其它
在硬件越来越强大和云计算如火如荼的今天，你需要在超高配置的服务器和IaaS供应商的数百个虚拟机之间做取舍。我们建议使用中等配置的服务器，因为集群规模越大，单台超高配置的服务器运行的节点越多，集群稳定性随之下降，复杂度则会上升。

#二、JVM的考虑
对于java应用，jvm和gc是绕不过去的坎。实践表明，官方JDK1.7u51会是一个不错的选择，配合以G1来做垃圾回收。推荐配置可参考：
-Xms4g -Xmx4g -XX:PermSize=48m -XX:MaxPermSize=48m -XX:+UseG1GC-XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35
注：kafka版本更新会带来变化。请随时关注。我们现在的版本是kafka_2.11-0.8.2.1

#三、File descriptors
kafka会使用大量文件和网络socket，所以，我们需要把file descriptors的默认配置改为100000。修改方法如下：
```
#vi /etc/sysctl.conf
fs.file-max = 32000

#vi /etc/security/limits.conf
yourusersoftnofile10000
youruserhardnofile30000
```

#四、关键配置项解读
尽管默认配置已经很不错，但出于性能和实际集群部署情况，我们还是需要讲解一些重要的配置项。除此之外，如果对某个默认参数存在质疑，在详细了解改参数的作用前，建议采用默认配置。
##4.1、zookeeper.connect
必配参数，建议在kafka集群的每天机器都配置所有zk。

##4.2、broker.id
必配参数。集群节点的标示符，不得重复。取值范围0~n。

##4.3、log.dirs
建议参照文章前面描述的磁盘配置，不要使用默认的“/tmp/kafka-logs”

##4.4、advertised.host.name
注册到zk供用户使用的主机名。内网环境通常无需配置，而IaaS一般需要配置为公网地址。默认为“host.name”，可以通过java.net.InetAddress.getCanonicalHostName()接口获取该值。

##4.5、advertised.port
注册到zk供用户使用的服务端口，通常在IaaS环境需要额外配置。

##4.6、num.partitions
自动创建topic的默认partition数量。默认是1，为了获得更好的性能，建议修改为更大。最优取值参考后文。

##4.7、default.replication.factor
自动创建topic的默认副本数量，官方建议修改为2；但通常一个副本就足够了。

##4.8、min.insync.replicas
ISR提交生成者请求的最小副本数。

##4.9、unclean.leader.election.enable
是否允许不具备ISR资格的replicas选举为leader作为不得已的措施，甚至不惜牺牲部分数据。默认允许。建议允许。数据异常重要的情况例外。

##4.10、controlled.shutdown.enable
在kafka收到stop命令或者异常终止时，允许自动同步数据。建议开启。

#五、动态调整配置
大部分kafka配置是写死在properties文件里的。然而，许多关于topic的参数我们可以动态调配，kafka-topic.sh工具提供了该功能，更改将一直生效直到服务器重启。可以调整的参数如下：
unclean.leader.election.enable：不严格的leader选举，有助于集群健壮，但是存在数据丢失风险。
min.insync.replicas：如果同步状态的副本小于该值，服务器将不再接受request.required.acks为-1或all的写入请求。
max.message.bytes：单条消息的最大长度。如果修改了该值，那么replica.fetch.max.bytes和消费者的fetch.message.max.bytes也要跟着修改。
cleanup.policy：生命周期终结数据的处理，默认删除。
flush.messages：强制刷新写入的最大缓存消息数。
flust.ms：强制刷新写入的最大等待时长。
还有segment.bytes、segment.ms、retention.bytes、retention.ms和segment.jitter.ms。详见官方解释。











---
#高可用
##broker宕机

##zookeeper宕机

##数据一致性


---
#可靠性
##Producer到broker
把request.required.acks设为1，丢会重发，丢的概率很小
##Broker
###落盘的数据
除非磁盘坏了，不会丢的
###对于内存中没有flush的数据
broker重启会丢
可以通过log.flush.interval.messages和log.flush.interval.ms来配置flush间隔，interval大丢的数据多些，小会影响性能
但在0.8版本，可以通过replica机制保证数据不丢，代价就是需要更多资源，尤其是磁盘资源，kafka当前支持GZip和Snappy压缩，来缓解这个问题看，是否使用replica取决于在可靠性和资源代价之间的balance

##Consumer 旧版API 0.8.3之前
###High-level consumer
* 定期自动commit offset，这样可能会丢数据的，因为consumer可能拿到数据没有处理完crash
* 改客户端增加手动commit接口
kafka.javaapi.consumer.ZookeeperConsumerConnector
High-level接口的特点，就是简单，但是对kafka的控制不够灵活

###Simple consumer，low-level
这套接口比较复杂的，你必须要考虑很多事情，优点就是对Kafka可以有完全的控制 
You must keep track of the offsets in your application to know where you left off consuming. 
You must figure out which Broker is the lead Broker for a topic and partition 
You must handle Broker leader changes
在考虑如何将storm和kafka结合的时候，有一些开源的库，基于high-level和low-level接口的都有
我比较了一下，还是kafka官方列的storm-kafka-0.8-plus比较靠谱些 
这个库是基于simple consumer接口实现的，看着挺复杂，所以我先读了遍源码，收获挺大，除了发现我自己代码的问题，还学到些写storm应用的技巧呵呵
这个库会自己管理spout线程和partition之间的对应关系和每个partition上的已消费的offset(定期写到zk) 
并且只有当这个offset被storm ack后，即成功处理后，才会被更新到zk，所以基本是可以保证数据不丢的 
即使spout线程crash，重启后还是可以从zk中读到对应的offset
kafka和storm的结合可靠性还是可以的，你真心不想丢数据，还是可以做到的 
Kafka只是能保证at-least once逻辑，即数据是可能重复的，这个在应用上需要可以容忍 
当然通过Storm transaction也是可以保证only once逻辑的，但是代价比较大，后面如果有这样的需求可以继续深入调研一下 
对于kafka consumer，一般情况下推荐使用high-level接口，最好不要直接使用low-level，太麻烦
当前其实Kafka对consumer的设计不太到位，high-level太不灵活，low-level又太难用，缺乏一个medium-level 
所以在0.9中consumer会被重新design，https://cwiki.apache.org/confluence/display/KAFKA/Consumer+Client+Re-Design





---
#性能优化技巧
##partitons数量
首先，我们必须理解，partiton是kafka的并行单元。
从producer和broker的视角看，向不同的partition写入是完全并行的；
而对于consumer，并发数完全取决于partition的数量，即，如果consumer数量大于partition数量，则必有consumer闲置。所以，我们可以认为kafka的吞吐与partition时线性关系。partition的数量要根据吞吐来推断，假定p代表生产者写入单个partition的最大吞吐，c代表消费者从单个partition消费的最大吞吐，我们的目标吞吐是t，那么partition的数量应该是t/p和t/c中较大的那一个。实际情况中，p的影响因素有批处理的规模，压缩算法，确认机制和副本数等，然而，多次benchmark的结果表明，单个partition的最大写入吞吐在10MB/sec左右；c的影响因素是逻辑算法，需要在不同场景下实测得出。

这个结论似乎太书生气和不实用。我们通常建议partition的数量一定要大于等于消费者的数量来实现最大并发。官方曾测试过1万个partition的情况，所以不需要太担心partition过多的问题。下面的知识会有助于读者在生产环境做出最佳的选择：

a、一个partition就是一个存储kafka-log的目录。
b、一个partition只能寄宿在一个broker上。
c、单个partition是可以实现消息的顺序写入的。
d、单个partition只能被单个消费者进程消费，与该消费者所属于的消费组无关。这样做，有助于实现顺序消费。
e、单个消费者进程可同时消费多个partition，即partition限制了消费端的并发能力。
f、partition越多则file和memory消耗越大，要在服务器承受服务器设置。
g、每个partition信息都存在所有的zk节点中。
h、partition越多则失败选举耗时越长。
k、offset是对每个partition而言的，partition越多，查询offset就越耗时。
i、partition的数量是可以动态增加的（只能加不能减）。

我们建议的做法是，如果是3个broker的集群，有5个消费者，那么建议partition的数量是15，也就是broker和consumer数量的最小公倍数。当然，也可以是一个大于消费者的broker数量的倍数，比如6或者9，还请读者自行根据实际环境裁定。


##consumer
###consumer数量
如果你的分区数是N，那么最好线程数也保持为N，这样通常能够达到最大的吞吐量。超过N的配置只是浪费系统资源，因为多出的线程不会被分配到任何分区。
topic下的一个分区只能被同一个consumer group下的一个consumer线程来消费，但反之并不成立，即一个consumer线程可以消费多个分区的数据，比如Kafka提供的ConsoleConsumer，默认就只是一个线程来消费所有分区的数据。


---
#监控
##KafkaOffsetMonitor
http://www.cnblogs.com/Leo_wl/p/4564699.html

* 启动
java -cp KafkaOffsetMonitor-assembly-0.2.0.jar com.quantifind.kafka.offsetapp.OffsetGetterWeb --zk 10.202.125.16:2181 --port 8089 --refresh 10.seconds --retain 1.days

- Topic：创建Topic名称
- Partition：分区编号
- Offset：表示该Parition已经消费了多少Message
- LogSize：表示该Partition生产了多少Message
- Lag：表示有多少条Message未被消费
- Owner：表示消费者
- Created：表示该Partition创建时间
- Last Seen：表示消费状态刷新最新时间



Kafka提供的两种分配策略： range和roundrobin，由参数partition.assignment.strategy指定，默认是range策略。本文只讨论range策略。所谓的range其实就是按照阶段平均分配。举个例子就明白了，假设你有10个分区，P0 ~ P9，consumer线程数是3， C0 ~ C2，那么每个线程都分配哪些分区呢？



###参数调优
如果是高吞吐量数据，设置每次拿取消息(fetch.min.bytes)大些，
拿取消息频繁(fetch.wait.max.ms)些(或时间间隔短些)，如果是低延时要求，则设置时间时间间隔小，每次从kafka broker拿取消息尽量小些。





---
#案例&问题
##环境
线上的版本是0.9.0.1, 6个broker作集群, 机器的配置为32G内存，600G SAS盘，一共有40+ topics, 日均处理消息量为6000W+。

##使用最少一次
offset没有提交就rebanlance, 这样会导致消息重复消费
Kafka还采用了批量fetch提交offset最高位（HW，HighWater）的方式

##消息消费阻塞
消费处理过慢,session timeout 30s，没有向kafka broker发送心跳和提交offset，broker会发起客户端的rebalancing
* 增大session time时间(暂时)
* 减小max.partition.fetch.bytes，默认1M
* 增大最大拉取消息数的参数 max.poll.records
kafka-consumer-group.sh 查看 消费情况
* 消息大于fetch.size（默认为1M
* 应用阻塞代码（如，异常没有捕获，可用JMC，jvisualvm查看线程状态
* consumer rebalance 失败，会看到ConsumerRebalanceFailedException

##有序性
* Producer send指定分区 
* Consumer指定分区消费，需要自己实现fail-over 
* replication-factor设置为N（N为Broker的数量），保证Broker n-1 的宕机容忍性
Linkedin针对这点，构建一个流式处理系统Apache Samza，由Kafka、Yarn和SamaJob组成，其中Kafka作为消息传递，Yarn作资源调度和配置(指定分区)，Samza的基本处理流程是一个用户任务从一个或多个输入流中读取数据，再输出到一个或多个输出流中，具体映射到kafka上就是从一个或多个topic读入数据，再写出到另一个或多个topic中去。多个job串联起来就完成了流式的数据处理流程了。

##partition数量
+ partitions决定comsuer并行度。
+ partitions 只可以增加，不能减小。
+ 每个partition都在ZooKeeper上注册。
+ 越多partition越久Leader fail-over时间。
根据应用场景制定partitions，关注rebalancing情况，关注ZooKepper情况









