#Storm
---
#概念


##Storm组件
对于一个Storm集群，一个连续运行的主节点组织若干节点工作。

在Storm集群中，有两类节点：主节点master node和工作节点worker nodes。主节点运行着一个叫做Nimbus的守护进程。这个守护进程负责在集群中分发代码，为工作节点分配任务，并监控故障。Supervisor守护进程作为拓扑的一部分运行在工作节点上。一个Storm拓扑结构在不同的机器上运行着众多的工作节点。

因为Storm在Zookeeper或本地磁盘上维持所有的集群状态，守护进程可以是无状态的而且失效或重启时不会影响整个系统的健康（见图1-2）

在系统底层，Storm使用了zeromq(0mq, zeromq(http://www.zeromq.org))。这是一种先进的，可嵌入的网络通讯库，它提供的绝妙功能使Storm成为可能。


##zeromq 特性
简化编程    如果你曾试着从零开始实现实时处理，你应该明白这是一件多么痛苦的事情。使用Storm，复杂性被大大降低了。
使用一门基于JVM的语言开发会更容易，但是你可以借助一个小的中间件，在Storm上使用任何语言开发。有现成的中间件可供选择，当然也可以自己开发中间件。
容错         Storm集群会关注工作节点状态，如果宕机了必要的时候会重新分配任务。
可扩展    所有你需要为扩展集群所做的工作就是增加机器。Storm会在新机器就绪时向它们分配任务。
可靠的    所有消息都可保证至少处理一次。如果出错了，消息可能处理不只一次，不过你永远不会丢失消息。
快速        速度是驱动Storm设计的一个关键因素
事务性   You can get exactly once messaging semantics for pretty much any computation.你可以为几乎任何计算得到恰好一次消息语义。


##spout龙卷
源处读取数据并放入topology
当Storm接收失败时
    可靠的Spout会对tuple（元组，数据项组成的列表）进行重发
    不可靠的Spout不会考虑接收成功与否只发射一次

##bolt雷电
Topology中所有的处理都由Bolt完成。
Bolt可以完成任何事，比如：连接的过滤、聚合、访问文件/数据库、等等。
Bolt从Spout中接收数据并进行处理，如果遇到复杂流的处理也可能将tuple发送给另一个Bolt进行处理。而Bolt中最重要的方法是execute（），以新的tuple作为参数接收。
不管是Spout还是Bolt，如果将tuple发射成多个流，这些流都可以通过declareStream（）来声明

##nimbus 雨云
主节点的守护进程，负责为工作节点分发任务。

##topology 拓扑结构
Storm的一个任务单元

##define field(s) 定义域
由spout或bolt提供，被bolt接收

##Stream Groupings
###随机分组（Shuffle grouping）
随机分发tuple到Bolt的任务，保证每个任务获得相等数量的tuple。
###字段分组（Fields grouping）
根据指定字段分割数据流，并分组。例如，根据“user-id”字段，相同“user-id”的元组总是分发到同一个任务，不同“user-id”的元组可能分发到不同的任务。
###全部分组（All grouping）
tuple被复制到bolt的所有任务。这种类型需要谨慎使用。
###全局分组（Global grouping）
全部流都分配到bolt的同一个任务。明确地说，是分配给ID最小的那个task。
###无分组（None grouping）
你不需要关心流是如何分组。目前，无分组等效于随机分组。但最终，Storm将把无分组的Bolts放到Bolts或Spouts订阅它们的同一线程去执行（如果可能）。
###直接分组（Direct grouping）
这是一个特别的分组类型。元组生产者决定tuple由哪个元组处理者任务接收。
当然还可以实现CustomStreamGroupimg接口来定制自己需要的分组。

##临界分析
###瞬间临界值监测(instant thershold)
一个字段的值在那个瞬间超过了预设的临界值，如果条件符合的话则触发一个trigger。举个例子当车辆超越80公里每小时，则触发trigger

###时间序列临界监测(time series threshold)
字段的值在一个给定的时间段内超过了预设的临界值，如果条件符合则触发一个触发器。比如：在5分钟类，时速超过80KM两次及以上的车辆






















