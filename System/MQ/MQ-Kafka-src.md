


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
  //属于某个topic的所有partitions. 当然topic是当前消费者订阅的范围内,其他topic并不关心
  val partitionsForTopic: collection.Map[String, Seq[Int]] = zkUtils.getPartitionsForTopics(myTopicThreadIds.keySet.toSeq)

  // 在当前消费组内,属于某个topic的所有consumers
  val consumersForTopic: collection.Map[String, List[ConsumerThreadId]] = zkUtils.getConsumersPerTopic(group, excludeInternalTopics)
  val consumers: Seq[String] = zkUtils.getConsumersInGroup(group).sorted
}
```

/brokers/topics/topic_name记录的是topic的partition分配情况.获取partition信息,读取的是partitions字段(partitionMap).
```scala
def getPartitionsForTopics(topics: Seq[String]): mutable.Map[String, Seq[Int]] = {
  getPartitionAssignmentForTopics(topics).map { topicAndPartitionMap =>
    val topic = topicAndPartitionMap._1
    val partitionMap = topicAndPartitionMap._2
    (topic -> partitionMap.keys.toSeq.sortWith((s,t) => s < t))
  }
}
```

每个消费者都可以指定消费的topic和线程数,对于同一个消费组中多个消费者可以指定消费同一个topic或不同topic.
获取topic的所有consumers时,统计所有消费这个topic的消费者线程(原先以消费者,现在转换为以topic).
注意: 这里是取出当前消费组下所有消费者的所有topic,并没有过滤出属于当前消费者感兴趣的topics.
```scala
def getConsumersPerTopic(group: String, excludeInternalTopics: Boolean) : mutable.Map[String, List[ConsumerThreadId]] = 
{
  val dirs = new ZKGroupDirs(group)
  // 当前消费组下所有的consumers
  val consumers = getChildrenParentMayNotExist(dirs.consumerRegistryDir)
  val consumersPerTopicMap = new mutable.HashMap[String, List[ConsumerThreadId]]
  for (consumer <- consumers) {
    // 每个consumer都指定了topic和thread-count
    val topicCount = TopicCount.constructTopicCount(group, consumer, this, excludeInternalTopics)
    for ((topic, consumerThreadIdSet) <- topicCount.getConsumerThreadIdsPerTopic) {
      // 现在是在同一个consumer里, 对同一个topic,有多个thread-id
      for (consumerThreadId <- consumerThreadIdSet)
        // 最后按照topic分,而不是按照consumer分,比如多个consumer都消费了同一个topic,则这些consuemr会加入到同一个topic中
        consumersPerTopicMap.get(topic) match {
          case Some(curConsumers) => consumersPerTopicMap.put(topic, consumerThreadId :: curConsumers)
          case _ => consumersPerTopicMap.put(topic, List(consumerThreadId))
        }
    }
  }
  for ((topic, consumerList) <- consumersPerTopicMap) 
  	consumersPerTopicMap.put(topic, consumerList.sortWith((s,t) => s < t))
  consumersPerTopicMap
}
```

##PartitionAssignor 为Partition分配Consumer的算法
将可用的partitions以及消费者线程排序, 将partitions处于线程数,表示每个线程(不是消费者数量)平均可以分到几个partition.
如果除不尽,剩余的会分给前面几个消费者线程. 

比如有两个消费者,每个都是两个线程,一共有5个可用的partitions:(p0-p4).
每个消费者线程(一共四个线程)可以获取到至少一共partition(5/4=1),剩余一个(5%4=1)partition分给第一个线程.
最后的分配结果为: 
p0 -> C1-0, p1 -> C1-0, p2 -> C1-1, p3 -> C2-0, p4 -> C2-1

```scala
class RangeAssignor() extends PartitionAssignor with Logging {
  def assign(ctx: AssignmentContext) = {
    val valueFactory = (topic: String) => new mutable.HashMap[TopicAndPartition, ConsumerThreadId]
    // consumerThreadId -> (TopicAndPartition -> ConsumerThreadId). 所以上面的valueFactory的参数不对哦!
    val partitionAssignment = new Pool[String, mutable.Map[TopicAndPartition, ConsumerThreadId]](Some(valueFactory))
    for (topic <- ctx.myTopicThreadIds.keySet) {
      val curConsumers = ctx.consumersForTopic(topic)                   // 订阅了topic的消费者列表(4)
      val curPartitions: Seq[Int] = ctx.partitionsForTopic(topic)       // 属于topic的partitions(5)
      val nPartsPerConsumer = curPartitions.size / curConsumers.size    // 每个线程都可以有这些个partition(1)
      val nConsumersWithExtraPart = curPartitions.size % curConsumers.size  // 剩余的分给前面几个(1)
      for (consumerThreadId <- curConsumers) {                          // 每个消费者线程: C1_0,C1_1,C2_0,C2_1
        val myConsumerPosition = curConsumers.indexOf(consumerThreadId) // 线程在列表中的索引: 0,1,2,3
        val startPart = nPartsPerConsumer * myConsumerPosition + myConsumerPosition.min(nConsumersWithExtraPart)
        val nParts = nPartsPerConsumer + (if (myConsumerPosition + 1 > nConsumersWithExtraPart) 0 else 1)
        // Range-partition the sorted partitions to consumers for better locality. 
        // The first few consumers pick up an extra partition, if any.
        if (nParts > 0)
          for (i <- startPart until startPart + nParts) {
            val partition = curPartitions(i)
            // record the partition ownership decision 记录partition的ownership决定,即把partition分配给consumerThreadId
            val assignmentForConsumer = partitionAssignment.getAndMaybePut(consumerThreadId.consumer)
            assignmentForConsumer += (TopicAndPartition(topic, partition) -> consumerThreadId)
          }
        }
      }
    }
    // 前面的for循环中的consumers是和当前消费者有相同topic的,如果消费者的topic和当前消费者不一样,则在本次assign中不会为它分配的.  
    // assign Map.empty for the consumers which are not associated with topic partitions 没有和partition关联的consumer分配空的partiton.
    ctx.consumers.foreach(consumerId => partitionAssignment.getAndMaybePut(consumerId))
    partitionAssignment
  }
}
```

##PartitionAssignment -> PartitionTopicInfo
这是ZKRebalancerListener.rebalance的第三步.
首先为当前消费者创建AssignmentContext上下文.
上面知道partitionAssignor.assign的返回值是所有consumer的分配结果(虽然有些consumer在本次中并没有分到partition)
partitionAssignment的结构是
	consumerThreadId -> (TopicAndPartition -> ConsumerThreadId),
所以获取当前consumer只要传入assignmentContext.consumerId就可以得到当前消费者的PartitionAssignment.
```scala
// ③ 为partition重新选择consumer
val assignmentContext = new AssignmentContext(group, consumerIdString, config.excludeInternalTopics, zkUtils)
val globalPartitionAssignment = partitionAssignor.assign(assignmentContext)
val partitionAssignment = globalPartitionAssignment.get(assignmentContext.consumerId)
val currentTopicRegistry = new Pool[String, Pool[Int, PartitionTopicInfo]](
  valueFactory = Some((topic: String) => new Pool[Int, PartitionTopicInfo]))

// fetch current offsets for all topic-partitions
val topicPartitions = partitionAssignment.keySet.toSeq
val offsetFetchResponseOpt = fetchOffsets(topicPartitions)
val offsetFetchResponse = offsetFetchResponseOpt.get
topicPartitions.foreach(topicAndPartition => {
    val (topic, partition) = topicAndPartition.asTuple
    val offset = offsetFetchResponse.requestInfo(topicAndPartition).offset
    val threadId = partitionAssignment(topicAndPartition)
    addPartitionTopicInfo(currentTopicRegistry, partition, topic, offset, threadId)
})

// ④ ⑤ 注册到zk上, 并创建新的fetcher线程
if(reflectPartitionOwnershipDecision(partitionAssignment)) {
    topicRegistry = currentTopicRegistry  // topicRegistry来自上一步的addPartitionTopicInfo, 它会被用于updateFetcher
    updateFetcher(cluster)
}
```
PartitionAssignment的key是TopicAndPartition,根据所有topicAndPartitions获取这些partitions的offsets.
返回值offsetFetchResponse包含了对应的offset, 最终根据这些信息创建对应的PartitionTopicInfo.
PartitionTopicInfo包含Partition和Topic:
队列用来存放数据(topicThreadIdAndQueues在reinitializeConsumer中放入),
consumedOffset和fetchedOffset都是来自于offset参数,即上面
offsetFetchResponse中partition的offset.

currentTopicRegistry这个结构也很重要: topic -> (partition -> PartitionTopicInfo)
key是topic,正如名称所示是topic的注册信息(topicRegistry).又因为来自于fetchOffsets,所以表示的是最新当前的.

queue从topicThreadIdAndQueues中获得,在consume方法中queue也作为KafkaStream的参数.
所以后面只要面向PartitionTopicInfo,就能获取到底层的queue,也就可以为KafkaStream的queue填充数据.

```scala
private def addPartitionTopicInfo(currentTopicRegistry: Pool[String, Pool[Int, PartitionTopicInfo]],
                                    partition: Int, topic: String, offset: Long, consumerThreadId: ConsumerThreadId) {
    val partTopicInfoMap = currentTopicRegistry.getAndMaybePut(topic)
    val queue = topicThreadIdAndQueues.get((topic, consumerThreadId))
    val consumedOffset = new AtomicLong(offset)
    val fetchedOffset = new AtomicLong(offset)
    val partTopicInfo = new PartitionTopicInfo(topic,partition,queue,consumedOffset,fetchedOffset,
      new AtomicInteger(config.fetchMessageMaxBytes), config.clientId)
    partTopicInfoMap.put(partition, partTopicInfo)
    checkpointedZkOffsets.put(TopicAndPartition(topic, partition), offset)
  }
}
```

注意:一个threadId可以消费同一个topic的多个partition. 而一个threadId对应一个queue.
所以一个queue也就可以消费多个partition. 即对于不同的partition,可能使用同一个队列来消费.
比如消费者设置了一个线程,就只有一个队列,而partition分了两个给它,这样一个队列就要处理两个partition了.

##updateFetcher & closeFetchers
这里我们看到了在ZooKeeperConsumerConnector初始化时创建的fetcher(ConsumerFetcherManager)终于派上用场了.
allPartitionInfos是分配给Consumer的Partition列表(但是这里还不知道Leader的,所以在Manager中要自己寻找Leader).
```scala
private def updateFetcher(cluster: Cluster) {   // update partitions for fetcher
  var allPartitionInfos : List[PartitionTopicInfo] = Nil
  // topicRegistry是在addPartitionTopicInfo中加到currentTopicRegistry,再被赋值给topicRegistry
  for (partitionInfos <- topicRegistry.values)  
    for (partition <- partitionInfos.values)    // PartitionTopicInfo
      allPartitionInfos ::= partition 
  fetcher match {
    case Some(f) => f.startConnections(allPartitionInfos, cluster)
  }
}
```
创建Fetcher是为PartitionInfos准备开始连接,在rebalance时一开始要先closeFetchers就是关闭已经建立的连接.
relevantTopicThreadIdsMap是当前消费者的topic->threadIds,要从topicThreadIdAndQueues过滤出需要清除的queues.

DataStructure				| Explain
relevantTopicThreadIdsMap	| 消费者注册的topic->threadIds
topicThreadIdAndQueues	    | 消费者的(topic,threadId)->queue
messageStreams				| 消费者注册的topic->List[KafkaStream]消息流

关闭Fetcher时要注意: 先提交offset,然后才停止消费者. 因为在停止消费者的时候当前的数据块中还会有点残留数据.
因为这时候还没有释放partiton的ownership(即partition还归当前consumer所有),强制提交offset,
这样拥有这个partition的下一个消费者线程(rebalance后),就可以使用已经提交的offset了,确保不中断.
因为fetcher线程已经关闭了(stopConnections),这是消费者能得到的最后一个数据块,以后不会有了,直到平衡结束,fetcher重新开始

topicThreadIdAndQueues来自于topicThreadIds,所以它的topic应该都在relevantTopicThreadIdsMap的topics中.
为什么还要过滤呢? 注释中说到在本次平衡之后,只需要清理可能不再属于这个消费者的队列(部分的topicPartition抓取队列).

```scala
private def closeFetchers(cluster: Cluster, messageStreams: Map[String,List[KafkaStream[_,_]]], 
  relevantTopicThreadIdsMap: Map[String, Set[ConsumerThreadId]]) {
  // only clear the fetcher queues for certain topic partitions that *might* 
  // no longer be served by this consumer after this rebalancing attempt
  val queuesTobeCleared = topicThreadIdAndQueues.filter(q => relevantTopicThreadIdsMap.contains(q._1._1)).map(q => q._2)
  closeFetchersForQueues(cluster, messageStreams, queuesTobeCleared)
}
private def closeFetchersForQueues(cluster: Cluster, messageStreams: Map[String,List[KafkaStream[_,_]]], 
  queuesToBeCleared: Iterable[BlockingQueue[FetchedDataChunk]]) {
  val allPartitionInfos = topicRegistry.values.map(p => p.values).flatten
  fetcher match {
    case Some(f) =>
      f.stopConnections     // 停止FetcherManager管理的所有Fetcher线程
      clearFetcherQueues(allPartitionInfos, cluster, queuesToBeCleared, messageStreams)
      if (config.autoCommitEnable) commitOffsets(true)
  }
}
private def clearFetcherQueues(topicInfos: Iterable[PartitionTopicInfo], cluster: Cluster, 
  queuesTobeCleared: Iterable[BlockingQueue[FetchedDataChunk]], messageStreams: Map[String,List[KafkaStream[_,_]]]) {
  // Clear all but the currently iterated upon chunk in the consumer thread's queue
  queuesTobeCleared.foreach(_.clear)
  // Also clear the currently iterated upon chunk in the consumer threads
  if(messageStreams != null) messageStreams.foreach(_._2.foreach(s => s.clear()))
}
```

问题:新创建的ZKRebalancerListener中kafkaMessageAndMetadataStreams(即这里的messageStreams)为空的Map.
如何清空里面的数据? 实际上KafkaStream只是一个迭代器,在运行过程中会有数据放入到这个流中,这样流就有数据了.

---
#ConsumerFetcherManager
topicInfos是上一步updateFetcher的topicRegistry,是分配给给consumer的注册信息:
topic->(partition->PartitionTopicInfo).
Fetcher线程要抓取数据关心的是PartitionTopicInfo,首先要找出Partition Leader(因为只向Leader Partition发起抓取请求).
初始时假设所有topicInfos(PartitionTopicInfo)都找不到Leader,即同时加入partitionMap和noLeaderPartitionSet.
在LeaderFinderThread线程中如果找到Leader,则从noLeaderPartitionSet中移除.
```scala
def startConnections(topicInfos: Iterable[PartitionTopicInfo], cluster: Cluster) {
  leaderFinderThread = new LeaderFinderThread(consumerIdString + "-leader-finder-thread")
  leaderFinderThread.start()

  inLock(lock) {
    partitionMap = topicInfos.map(tpi => (TopicAndPartition(tpi.topic, tpi.partitionId), tpi)).toMap
    this.cluster = cluster
    noLeaderPartitionSet ++= topicInfos.map(tpi => TopicAndPartition(tpi.topic, tpi.partitionId))
    cond.signalAll()
  }
}
```

ConsumerFetcherManager管理了当前Consumer的所有Fetcher线程.
注意ConsumerFetcherThread构造函数中的partitionMap和构建FetchRequest时的partitionMap是不同的.
不过它们的相同点是都有offset信息.并且都有fetch操作.

#小结
high level的Consumer Rebalance的控制策略是由每一个Consumer通过在Zookeeper上注册Watch完成的。

每个Consumer被创建时会触发Consumer Group的Rebalance,具体的启动流程是:
(High Level)Consumer启动时将其ID注册到其Consumer Group下 (registerConsumerInZK)
/consumers/[group_id]/ids上和/brokers/ids
上分别注册Watch (reinitializeConsumer->Listener)

强制自己在其Consumer Group内启动Rebalance流程 (ZKRebalancerListener.rebalance)
在这种策略下，每一个Consumer或者Broker的增加或者减少都会触发Consumer Rebalance。

因为每个Consumer只负责调整自己所消费的Partition，为了保证整个Consumer Group的一致性，
当一个Consumer触发了Rebalance时，该Consumer Group内的其它所有其它Consumer也应该同时触发Rebalance。

该方式有如下缺陷:
Herd effect(羊群效应): 任何Broker或者Consumer的增减都会触发所有的Consumer的Rebalance
Split Brain(脑裂): 每个Consumer分别单独通过Zookeeper判断哪些Broker和Consumer 宕机了，
那么不同Consumer在同一时刻从Zookeeper“看”到的View就可能不一样，这是由Zookeeper的特性决定的，这就会造成不正确的Reblance尝试。
调整结果不可控: 所有的Consumer都并不知道其它Consumer的Rebalance是否成功，这可能会导致Kafka工作在一个不正确的状态。





















