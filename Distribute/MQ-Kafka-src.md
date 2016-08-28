


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
```
/consumers
	/[group_id]
		/ids
			/[consumer_id]
				topic1
				...
				topicN
		/owner
			/[topic]
				/[partition_id]
				...
					/consumer_id
		/offsets
			/[topic]
				/[partition_id]
					/offset_counter_value
```
###Consumer id registry,ids
/consumers/[group_id]/ids/[consumer_id] -> topic1,...topicN
每个消费者会将它的id注册为临时znode并且将它所消费的topic设置为znode的值,当客户端(消费者)退出时,znode(consumer_id)会被删除.

A consumer subscribes to event changes of the consumer id registry within its group.
每个consumer会订阅它所在的消费组中关于consumer_id注册的更新事件. Kafka只会将一条消息发送到一个消费组中唯一的一个消费者.
如果某个消费者挂了,它要把本来发给挂的消费者的消费转给这个消费组中其他的消费者.同理,有新消费者加入消费组时,也会进行rebalance

###Partition owner registry,owner
/consumers/[group_id]/owner/[topic]/[broker_id-partition_id] --> consumer_node_id
在消费时,每个topic的partition只能被一个消费者组中的唯一的一个消费者消费.在每次重新负载的时候,这个映射策略就会重新构建.

###Consumer offset tracking
/consumers/[group_id]/offsets/[topic]/[broker_id-partition_id] --> offset_counter_value
每个消费者都要跟踪自己消费的每个Partition最近的offset.表示自己读取到Partition的最新位置.
由于一个Partition只能被消费组中的一个消费者消费,所以offset是以消费组为级别的,而不是消费者.
因为如果原来的消费者挂了后,应当将这个Partition交给同一个消费组中别的消费者,而此时offset是没有变化的.
一个partition可以被不同的消费者组中的不同消费者消费，所以不同的消费者组必须维护他们各自对该partition消费的最新的offset

---
##init
* 连接zk
* 抓取线程交给ConsumerFetcherManager统一管理
* 由消费者客户端自己保存offset,而消费者会消费多个topic的多个partition
* 类似多个数据抓取线程有管理类,多个partition的offset管理类OffsetManager是一个GroupCoordinator
* 定时提交线程会使用OffsetManager建立的通道定时提交offset到zk或者kafka.

###createMessageStreams
由ConsumerConnector创建消息流,需要指定解码器,因为要将日志反序列化(生产者写消息时对消息序列化到日志文件).
consume并不真正的消费数据,只是初始化存放数据的queue.真正消费数据的是对该queue进行shallow iterator.
在kafka的运行过程中,会有其他的线程将数据放入partition对应的queue中. 而queue是用于KafkaStream的.
一旦数据添加到queue后,KafkaStream的阻塞队列就有数据了,消费者就可以从队列中消费消息.
```scala
def createMessageStreams[K,V](topicCountMap: Map[String,Int], 
  keyDecoder: Decoder[K], valueDecoder: Decoder[V]) : Map[String, List[KafkaStream[K,V]]] = {
  consume(topicCountMap, keyDecoder, valueDecoder)
}
def consume[K, V](topicCountMap: scala.collection.Map[String,Int], 
  keyDecoder: Decoder[K], valueDecoder: Decoder[V]) : Map[String,List[KafkaStream[K,V]]] = {
  val topicCount = TopicCount.constructTopicCount(consumerIdString, topicCountMap)
  val topicThreadIds = topicCount.getConsumerThreadIdsPerTopic

  // make a list of (queue,stream) pairs, one pair for each threadId 只是准备了队列和流,数据什么时候填充呢?
  val queuesAndStreams = topicThreadIds.values.map(threadIdSet =>
    threadIdSet.map(_ => {
      val queue =  new LinkedBlockingQueue[FetchedDataChunk](config.queuedMaxMessages)
      val stream = new KafkaStream[K,V](queue, config.consumerTimeoutMs, keyDecoder, valueDecoder, config.clientId)
      (queue, stream)
    })
  ).flatten.toList  //threadIdSet是个集合,外层的topicThreadIds.values也是集合,所以用flatten压扁为queue-stream对

  val dirs = new ZKGroupDirs(config.groupId)                  // /consumers/[group_id]
  registerConsumerInZK(dirs, consumerIdString, topicCount)    // /consumers/[group_id]/ids/[consumer_id]
  reinitializeConsumer(topicCount, queuesAndStreams)          // 重新初始化消费者 ⬅️

  // 返回KafkaStream, 每个Topic都对应了多个KafkaStream. 数量和topicCount中的count一样
  loadBalancerListener.kafkaMessageAndMetadataStreams.asInstanceOf[Map[String, List[KafkaStream[K,V]]]]
```
consumerIdString会返回当前Consumer在哪个ConsumerGroup的编号.每个consumer在消费组中的编号都是唯一的.
一个消费者,对一个topic可以使用多个线程一起消费(一个进程可以有多个线程). 当然一个消费者也可以消费多个topic.
```scala
def makeConsumerThreadIdsPerTopic(consumerIdString: String, topicCountMap: Map[String,  Int]) = {
  val consumerThreadIdsPerTopicMap = new mutable.HashMap[String, Set[ConsumerThreadId]]()
  for ((topic, nConsumers) <- topicCountMap) {                // 每个topic有几个消费者线程
    val consumerSet = new mutable.HashSet[ConsumerThreadId]   // 一个消费者线程对应一个ConsumerThreadId
    for (i <- 0 until nConsumers)
      consumerSet += ConsumerThreadId(consumerIdString, i)
    consumerThreadIdsPerTopicMap.put(topic, consumerSet)      // 每个topic都有多个Consumer线程,但是只有一个消费者进程
  }
  consumerThreadIdsPerTopicMap                                // topic到消费者线程集合的映射
}
```
假设消费者C1声明了topic1:2, topic2:3. topicThreadIds=consumerThreadIdsPerTopicMap.
topicThreadIds.values = [ (C1_1,C1_2), (C1_1,C1_2,C1_3)]一共有5个线程,queuesAndStreams也有5个元素.
```scala
consumerThreadIdsPerTopicMap = {
    topic1: [C1_1, C1_2],
    topic2: [C1_1, C1_2, C1_3]
}
topicThreadIds.values = [
    [C1_1, C1_2],
    [C1_1, C1_2, C1_3]
]
threadIdSet循环[C1_1, C1_2]时, 生成两个queue->stream pair. 
threadIdSet循环[C1_1, C1_2, C1_3]时, 生成三个queue->stream pair. 
queuesAndStreams = [
    (LinkedBlockingQueue_1,KafkaStream_1),      //topic1:C1_1
    (LinkedBlockingQueue_2,KafkaStream_2),      //topic1:C1_2
    (LinkedBlockingQueue_3,KafkaStream_3),      //topic2:C1_1
    (LinkedBlockingQueue_4,KafkaStream_4),      //topic2:C1_2
    (LinkedBlockingQueue_5,KafkaStream_5),      //topic2:C1_3
]
```
对于消费者而言,它只要指定要消费的topic和线程数量就可以了,其他具体这个topic分成多少个partition,
以及topic-partition是分布是哪个broker上,对于客户端而言都是透明的.
客户端关注的是我的每个线程都对应了一个队列,每个队列都是一个消息流就可以了.
在Producer以及前面分析的Fetcher,都是以Broker-Topic-Partition为级别的.
AbstractFetcherManager的fetcherThreadMap就是以brokerAndFetcherId来创建拉取线程的.
而消费者是通过拉取线程才有数据可以消费的,所以客户端的每个线程实际上也是针对Partition级别的.

###registerConsumerInZK
消费者需要向ZK注册一个临时节点,路径为:/consumers/[group_id]/ids/[consumer_id],内容为订阅的topic.
```scala
private def registerConsumerInZK(dirs: ZKGroupDirs, consumerIdString: String, topicCount: TopicCount) {
  val consumerRegistrationInfo = Json.encode(Map("version" -> 1, 
    "subscription" -> topicCount.getTopicCountMap, "pattern" -> topicCount.pattern, "timestamp" -> timestamp))
  val zkWatchedEphemeral = new ZKCheckedEphemeral(dirs.consumerRegistryDir + "/" + consumerIdString, 
    consumerRegistrationInfo, zkUtils.zkConnection.getZookeeper, false)
  zkWatchedEphemeral.create()
}
```
问题:什么时候这个节点会被删除掉呢? Consumer进程挂掉时,或者Session失效时删除临时节点. 重连时会重新创建.
由于是临时节点,一旦创建节点的这个进程挂掉了,临时节点就会自动被删除掉. 这是由zk机制决定的,不是由消费者完成的.

###reinitializeConsumer listener
当前Consumer在ZK注册之后,需要重新初始化Consumer. 对于全新的消费者,注册多个监听器,在zk的对应节点的注册事件发生时,会回调监听器的方法.
将topic对应的消费者线程id及对应的LinkedBlockingQueue放入topicThreadIdAndQueues中,LinkedBlockingQueue是真正存放数据的queue
① 注册sessionExpirationListener,监听状态变化事件.在session失效重新创建session时调用
② 向/consumers/[group_id]/ids注册Child变更事件的loadBalancerListener,当消费组下的消费者发生变化时调用
③ 向/brokers/topics/[topic]注册Data变更事件的topicPartitionChangeListener,在topic数据发生变化时调用
显式调用loadBalancerListener.syncedRebalance(), 会调用reblance方法进行consumer的初始化工作
```scala
private def reinitializeConsumer[K,V](topicCount: TopicCount, 
  queuesAndStreams: List[(LinkedBlockingQueue[FetchedDataChunk],KafkaStream[K,V])]) {
  val dirs = new ZKGroupDirs(config.groupId)
  // ② listener to consumer and partition changes
  if (loadBalancerListener == null) {
    val topicStreamsMap = new mutable.HashMap[String,List[KafkaStream[K,V]]]
    loadBalancerListener = new ZKRebalancerListener(config.groupId, consumerIdString, 
      topicStreamsMap.asInstanceOf[scala.collection.mutable.Map[String, List[KafkaStream[_,_]]]])
  }
  // ① create listener for session expired event if not exist yet
  if (sessionExpirationListener == null) sessionExpirationListener = 
    new ZKSessionExpireListener(dirs, consumerIdString, topicCount, loadBalancerListener)
  // ③ create listener for topic partition change event if not exist yet
  if (topicPartitionChangeListener == null) 
    topicPartitionChangeListener = new ZKTopicPartitionChangeListener(loadBalancerListener)

  // listener to consumer and partition changes
  zkUtils.zkClient.subscribeStateChanges(sessionExpirationListener)
  zkUtils.zkClient.subscribeChildChanges(dirs.consumerRegistryDir, loadBalancerListener)
  // register on broker partition path changes.
  topicStreamsMap.foreach { topicAndStreams => 
    zkUtils.zkClient.subscribeDataChanges(BrokerTopicsPath+"/"+topicAndStreams._1, topicPartitionChangeListener)
  }

  // explicitly trigger load balancing for this consumer
  loadBalancerListener.syncedRebalance()
}
```
ZKRebalancerListener传入ZKSessionExpireListener和ZKTopicPartitionChangeListener.它们都会使用ZKRebalancerListener完成自己的工作.

###ZKSessionExpireListener
当Session失效时,新的会话建立时,立即进行rebalance操作.
```scala
class ZKSessionExpireListener(val dirs: ZKGroupDirs, val consumerIdString: String, 
  val topicCount: TopicCount, val loadBalancerListener: ZKRebalancerListener) extends IZkStateListener {
  def handleNewSession() {
    loadBalancerListener.resetState()
    registerConsumerInZK(dirs, consumerIdString, topicCount)
    loadBalancerListener.syncedRebalance()
  }
}
```

###ZKTopicPartitionChangeListener
当topic的数据变化时,通过触发的方式启动rebalance操作.
```scala
class ZKTopicPartitionChangeListener(val loadBalancerListener: ZKRebalancerListener) 
  extends IZkDataListener {
  def handleDataChange(dataPath : String, data: Object) {
    loadBalancerListener.rebalanceEventTriggered()
  }
}
```

###ZKRebalancerListener watcher
```scala
class ZKRebalancerListener(val group: String, val consumerIdString: String,
                           val kafkaMessageAndMetadataStreams: mutable.Map[String,List[KafkaStream[_,_]]])
  extends IZkChildListener {
  private var isWatcherTriggered = false
  private val lock = new ReentrantLock
  private val cond = lock.newCondition()

  private val watcherExecutorThread = new Thread(consumerIdString + "_watcher_executor") {
    override def run() {
      var doRebalance = false
      while (!isShuttingDown.get) {
          lock.lock()
          try {
            // 如果isWatcherTriggered=false,则不会触发syncedRebalance. 等待1秒后,继续判断
            if (!isWatcherTriggered)
              cond.await(1000, TimeUnit.MILLISECONDS) // wake up periodically so that it can check the shutdown flag
          } finally {
            // 不管isWatcherTriggered值是多少,在每次循环时,都会执行. 如果isWatcherTriggered=true,则会执行syncedRebalance
            doRebalance = isWatcherTriggered
            // 重新设置isWatcherTriggered=false, 因为其他线程触发一次后就失效了,想要再次触发,必须再次设置isWatcherTriggered=true
            isWatcherTriggered = false
            lock.unlock()
          }
          if (doRebalance) syncedRebalance        // 只有每次rebalanceEventTriggered时,才会调用一次syncedRebalance
      }
    }
  }
  watcherExecutorThread.start()

  // 触发rebalance开始进行, 修改isWatcherTriggered标志位,触发cond条件运行
  def rebalanceEventTriggered() {
    inLock(lock) {
      isWatcherTriggered = true
      cond.signalAll()
    }
  }
```

watcherExecutorThread线程通过锁的方式判断何时需要进行syncedRebalance操作.

reinitializeConsumer的topicStreamsMap是从(topic,thread)->(queue,stream)根据topic获取stream得来的.

```scala
val topicStreamsMap = loadBalancerListener.kafkaMessageAndMetadataStreams
// map of {topic -> Set(thread-1, thread-2, ...)}
val consumerThreadIdsPerTopic: Map[String, Set[ConsumerThreadId]] = topicCount.getConsumerThreadIdsPerTopic
// list of (Queue, KafkaStreams): (queue1,stream1),(queue2,stream2),...
val allQueuesAndStreams = queuesAndStreams 

// (topic,thread-1), (topic,thread-2), ... 一个topic有多个线程:threadIds,将threadIds中每个threadId都添加上topic标识
val topicThreadIds = consumerThreadIdsPerTopic.map {
  case(topic, threadIds) => threadIds.map((topic, _))
}.flatten
// (topic,thread-1), (queue1, stream1)
// (topic,thread-2), (queue2, stream2)
val threadQueueStreamPairs = topicThreadIds.zip(allQueuesAndStreams)

threadQueueStreamPairs.foreach(e => {
  val topicThreadId = e._1  // (topic,threadId)
  val q = e._2._1           // Queue
  topicThreadIdAndQueues.put(topicThreadId, q)
})

val groupedByTopic = threadQueueStreamPairs.groupBy(_._1._1)
// 根据topic分组之后, groupedByTopic的每个元素的_1为topic,_2为属于这个topic的所有(topic,thread-1), (queue1, stream1)形式的列表
groupedByTopic.foreach(e => {
  val topic = e._1
  // e._2是一个List[((topic,thread),(queue,stream))],下面收集这个topic的所有stream
  val streams = e._2.map(_._2._2).toList
  topicStreamsMap += (topic -> streams)
})
```
一个topic多个threads
一个thread一个queue
一个queue一个stream
一个topic多个stream

##ZKRebalancerListener rebalance
因为消费者加入/退出时,消费组的成员会发生变化,而消费组中的所有存活消费者负责消费可用的partitions.
可用的partitions或者消费组中的消费者成员一旦发生变化,都要重新分配partition给存活的消费者.

当然分配partition的工作绝不仅仅是这么简单的,还要处理与之相关的线程,并重建必要的数据:
① 关闭数据抓取线程，获取之前为topic设置的存放数据的queue并清空该queue
② 释放partition的ownership,删除partition和consumer的对应关系
③ 为各个partition重新分配threadid
获取partition最新的offset并重新初始化新的PartitionTopicInfo(queue存放数据,两个offset为partition最新的offset)
④ 重新将partition对应的新的consumer信息写入zookeeper
⑤ 重新创建partition的fetcher线程

关闭拉取线程->是否partition的ownership->为partition重新分配consumer->添加partition的ownership->创建拉取线程

```scala
private def rebalance(cluster: Cluster): Boolean = {
  val myTopicThreadIdsMap = TopicCount.constructTopicCount(group, consumerIdString, zkUtils, config.excludeInternalTopics).getConsumerThreadIdsPerTopic
  val brokers = zkUtils.getAllBrokersInCluster()
  if (brokers.size == 0) {
    zkUtils.zkClient.subscribeChildChanges(BrokerIdsPath, loadBalancerListener)
    true
  } else {
    // ① 停止fetcher线程防止数据重复.如果当前调整失败了,被释放的partitions可能被其他消费者拥有.
    //而没有先停止fetcher的话,原先的消费者仍然会和新的拥有者共同消费同一份数据.  
    closeFetchers(cluster, kafkaMessageAndMetadataStreams, myTopicThreadIdsMap)
    // ② 释放topicRegistry中topic-partition的owner
    releasePartitionOwnership(topicRegistry)
    // ③ 为partition重新分配消费者....
    // ④ 为partition添加consumer owner
    if(reflectPartitionOwnershipDecision(partitionAssignment)) {
        allTopicsOwnedPartitionsCount = partitionAssignment.size
        topicRegistry = currentTopicRegistry
        // ⑤ 创建拉取线程
        updateFetcher(cluster)
        true
```

rebalance操作涉及了以下内容:
PartitionOwnership: Partition的所有者(ownership)的删除和重建
AssignmentContext: 分配信息上下文
PartitionAssignor: 为Partition分配Consumer的算法
PartitionAssignment: Partition分配之后的上下文
PartitionTopicInfo: Partition的最终信息
Fetcher: 完成了rebalance,消费者就可以重新开始抓取数据

###PartitionOwnership
目标：删除/consumers/[group_id]/owner/[topic]/[partition_id]

topicRegistry的数据结构是: topic -> (partition -> PartitionTopicInfo), 表示现有的topic注册信息.
当partition被consumer所拥有后, 会在zk中创建/consumers/[group_id]/owner/[topic]/[partition_id] --> consumer_node_id
释放所有partition的ownership, 数据来源于topicRegistry的topic-partition(消费者所属的group_id也是确定的).
所以deletePartitionOwnershipFromZK会删除/consumers/[group_id]/owner/[topic]/[partition_id]节点.
这样partition没有了owner,说明这个partition不会被consumer消费了,也就相当于consumer释放了partition.

```scala


private def releasePartitionOwnership(localTopicRegistry: Pool[String, Pool[Int, PartitionTopicInfo]])= {
  for ((topic, infos) <- localTopicRegistry) {
    for(partition <- infos.keys) {
      deletePartitionOwnershipFromZK(topic, partition)
    }
    localTopicRegistry.remove(topic)
  }
  allTopicsOwnedPartitionsCount = 0
}
private def deletePartitionOwnershipFromZK(topic: String, partition: Int) {
  val topicDirs = new ZKGroupTopicDirs(group, topic)
  val znode = topicDirs.consumerOwnerDir + "/" + partition
  zkUtils.deletePath(znode)
}
```

重建ownership. 参数partitionAssignment会指定 partition(TopicAndPartition)要分配给哪个 consumer(ConsumerThreadId)消费的.
```scala
private def reflectPartitionOwnershipDecision(partitionAssignment: Map[TopicAndPartition, ConsumerThreadId]): Boolean = {
  var successfullyOwnedPartitions : List[(String, Int)] = Nil
  val partitionOwnershipSuccessful = partitionAssignment.map { partitionOwner =>
    val topic = partitionOwner._1.topic
    val partition = partitionOwner._1.partition
    val consumerThreadId = partitionOwner._2

    // 返回/consumers/[group_id]/owner/[topic]/[partition_id]节点路径,然后创建节点,节点内容为:consumerThreadId
    val partitionOwnerPath = zkUtils.getConsumerPartitionOwnerPath(group, topic, partition)
    zkUtils.createEphemeralPathExpectConflict(partitionOwnerPath, consumerThreadId.toString)

    // 成功创建的节点,加入到列表中
    successfullyOwnedPartitions ::= (topic, partition)
    true
  }
  // 判断上面的创建节点操作(为consumer分配partition)是否有错误,一旦有一个有问题,就全部回滚(删除掉).只有所有成功才算成功
  val hasPartitionOwnershipFailed = partitionOwnershipSuccessful.foldLeft(0)((sum, decision) => sum + (if(decision) 0 else 1))
  if(hasPartitionOwnershipFailed > 0) {
    successfullyOwnedPartitions.foreach(topicAndPartition => deletePartitionOwnershipFromZK(topicAndPartition._1, topicAndPartition._2))
    false
  }else 
  	true
}
```
关于consumer的注册节点出现的地方有:开始时的registerConsumerInZK,以及这里的先释放再注册.


## AssignmentContext 分配信息上下文
AssignmentContext是PartitionAssignor要为某个消费者分配的上下文.因为消费者只订阅了特定的topic,所以首先要选出topic.
每个topic都是有partitions map,表示这个topic有哪些partition,以及对应的replicas.进而得到partitionsForTopic.
consumersForTopic:要在当前消费者所在的消费组中,找到所有订阅了这个topic的消费者.以topic为粒度,统计所有的线程数.

```scala
class AssignmentContext(group: String, val consumerId: String, excludeInternalTopics: Boolean, zkUtils: ZkUtils) {
  // 当前消费者的消费topic和消费线程, 因为指定了consumerId,所以是针对当前consumer而言
  val myTopicThreadIds: collection.Map[String, collection.Set[ConsumerThreadId]] = {
    val myTopicCount = TopicCount.constructTopicCount(group, consumerId, zkUtils, excludeInternalTopics)
    myTopicCount.getConsumerThreadIdsPerTopic
  }
  // 属于某个topic的所有partitions. 当然topic是当前消费者订阅的范围内,其他topic并不关心
  val partitionsForTopic: collection.Map[String, Seq[Int]] = zkUtils.getPartitionsForTopics(myTopicThreadIds.keySet.toSeq)

  // 在当前消费组内,属于某个topic的所有consumers
  val consumersForTopic: collection.Map[String, List[ConsumerThreadId]] = zkUtils.getConsumersPerTopic(group, excludeInternalTopics)
  val consumers: Seq[String] = zkUtils.getConsumersInGroup(group).sorted
}
```


















































