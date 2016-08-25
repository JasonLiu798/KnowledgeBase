


---
#consumer scala
#high level consumer

ConsumerConnector: Consumer的连接器,这里基于ZK实现,是ZookeeperConsumerConnector
KafkaStream:消息流,每个消费者线程都对应了一个消息流,消息会放入消息流的阻塞队列中
ConsumerIterator: 消费者迭代器,只有迭代器开始迭代获取数据时,才会返回给消费者

##ConsumerConnector
```scala
object Consumer extends Logging {
  def createJavaConsumerConnector(config: ConsumerConfig): kafka.javaapi.consumer.ConsumerConnector = {
    val consumerConnect = new kafka.javaapi.consumer.ZookeeperConsumerConnector(config)
    consumerConnect
  }
}

trait ConsumerConnector {
  def createMessageStreams(topicCountMap: Map[String,Int]): Map[String, List[KafkaStream[Array[Byte],Array[Byte]]]]
  def commitOffsets(offsetsToCommit: immutable.Map[TopicAndPartition, OffsetAndMetadata], retryOnFailure: Boolean)
  def setConsumerRebalanceListener(listener: ConsumerRebalanceListener)
  def shutdown()
}
```

##ZookeeperConsumerConnector
* fetcher: 消费者获取数据, 使用ConsumerFetcherManager fetcher线程抓取数据
* zkUtils: 消费者要和ZK通信, 除了注册自己,还有其他信息也会写到ZK中
* topicThreadIdAndQueues: 消费者会指定自己消费哪些topic,并指定线程数, 所以topicThreadId都对应一个队列
* messageStreamCreated: 消费者会创建消息流, 每个队列都对应一个消息流
* offsetsChannel:offset可以存储在ZK或者kafka中,如果存在kafka里,像其他请求一样,需要和Broker通信
* 还有其他几个Listener监听器,分别用于topicPartition的更新,负载均衡,消费者重新负载等

kafka内部还是会帮你管理offset
ZookeeperConsumerConnector的offset是保存在ZooKeeper中
```scala
private[kafka] class ZookeeperConsumerConnector(val config: ConsumerConfig, val enableFetcher: Boolean) 
        extends ConsumerConnector with Logging with KafkaMetricsGroup {
  private var fetcher: Option[ConsumerFetcherManager] = None
  private var zkUtils: ZkUtils = null
  private var topicRegistry = new Pool[String, Pool[Int, PartitionTopicInfo]]
  private val checkpointedZkOffsets = new Pool[TopicAndPartition, Long]
  private val topicThreadIdAndQueues = new Pool[(String, ConsumerThreadId), BlockingQueue[FetchedDataChunk]]
  private val scheduler = new KafkaScheduler(threads = 1, threadNamePrefix = "kafka-consumer-scheduler-")
  private val messageStreamCreated = new AtomicBoolean(false)
  private var offsetsChannel: BlockingChannel = null
  private var sessionExpirationListener: ZKSessionExpireListener = null
  private var topicPartitionChangeListener: ZKTopicPartitionChangeListener = null
  private var loadBalancerListener: ZKRebalancerListener = null
  private var wildcardTopicWatcher: ZookeeperTopicEventWatcher = null
  private var consumerRebalanceListener: ConsumerRebalanceListener = null

  connectZk() // ① 创建ZkUtils,会创建对应的ZkConnection和ZkClient
  createFetcher() // ② 创建ConsumerFetcherManager,消费者fetcher线程
  ensureOffsetManagerConnected()    // ③ 确保连接上OffsetManager.
  if (config.autoCommitEnable) {    // ④ 启动定时提交offset线程
    scheduler.startup              
    scheduler.schedule("kafka-consumer-autocommit", autoCommit, ...)
  }
}
```

##zk and broker
/brokers 
	topics和ids: 集群中所有的topics,以及所有的brokers.
/brokers/ids/broker_id
	主机的基本信息,包括主机地址和端口号
/brokers/topics/topic_name
	topic的每个partition,以及分配的replicas(AR)
/brokers/topics/topic_name/partitions/partition_id/state
	这个partition的leader,isr

##Broker node registry
/brokers/ids/0
	{ "host" : "host:port", "topics" : {"topic1": ["partition1" ... "partitionN"], ..., "topicN": ["partition1" ... "partitionN"] } }
每个Broker节点在自己启动的时候,会在/brokers下创建一个逻辑节点. 内容包括了Broker的主机和端口, Broker服务的所有topic,
以及分配到当前Broker的这个topic的partition列表(并不是topic的全部partition,会将所有partition分布在不同的brokers).

A consumer subscribes to event changes of the broker node registry.
当Broker挂掉的时候,在这个Broker上的所有Partition都丢失了,而Partition是给消费者服务的.
所以Broker挂掉后在做迁移的时候,会将其上的Partition转移到其他Broker上,因此消费者要消费的Partition也跟着变化.

##Broker topic registry
/brokers/topics/topic1
	{"version":1,"partitions":{"2":[5,4],"1":[4,3],"0":[3,5]}}
虽然topic是在/brokers下,但是这个topic的信息是全局的.在创建topic的时候,这个topic的每个partition的编号以及replicas.
具体每个partition的Leader以及isr信息则是在
/brokers/topics/topic_name/partitions/partition_id/state


##zk and consumer
Consumer id registry: 
/consumers/[group_id]/ids/[consumer_id] -> topic1,...topicN
每个消费者会将它的id注册为临时znode并且将它所消费的topic设置为znode的值,当客户端(消费者)退出时,znode(consumer_id)会被删除.

A consumer subscribes to event changes of the consumer id registry within its group.
每个consumer会订阅它所在的消费组中关于consumer_id注册的更新事件. 为什么要注册呢,因为Kafka只会将一条消息发送到一个消费组中唯一的一个消费者.
如果某个消费者挂了,它要把本来发给挂的消费者的消费转给这个消费组中其他的消费者.同理,有新消费者加入消费组时,也会进行负载均衡.

Partition owner registry: /consumers/[group_id]/owner/[topic]/[broker_id-partition_id] --> consumer_node_id
在消费时,每个topic的partition只能被一个消费者组中的唯一的一个消费者消费.在每次重新负载的时候,这个映射策略就会重新构建.

Consumer offset tracking: /consumers/[group_id]/offsets/[topic]/[broker_id-partition_id] --> offset_counter_value
每个消费者都要跟踪自己消费的每个Partition最近的offset.表示自己读取到Partition的最新位置.
由于一个Partition只能被消费组中的一个消费者消费,所以offset是以消费组为级别的,而不是消费者.
因为如果原来的消费者挂了后,应当将这个Partition交给同一个消费组中别的消费者,而此时offset是没有变化的.
一个partition可以被不同的消费者组中的不同消费者消费，所以不同的消费者组必须维护他们各自对该partition消费的最新的offset














