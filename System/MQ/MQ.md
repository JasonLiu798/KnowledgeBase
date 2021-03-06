#MessageQueue
---
#theory
[mq comparison](http://blog.csdn.net/joeyon1985/article/details/38487395)

[performance](http://bravenewgeek.com/dissecting-message-queues/)

---
#JMS
[Spring JMS 消息处理 1-2-3](http://www.ibm.com/developerworks/cn/java/wa-spring4/)



---
#消息顺序性保证
[消息队列中的消息是并行执行的，那如果消息之间有顺序依赖怎么办呢](https://www.zhihu.com/question/27707687)
为了讨论这个问题，让我们做一些简化问题的假设：
有若干个消息队列A、B、C……
有若干个线程在产生消息，并分别将消息加入这些队列
每个消息队列有一个对应的线程（WorkerA、WorkerB、Worker C……），从队列中读取和处理消息
另外，还有一个很重要的前提：
要保持多个消息之间的时间顺序，首先它们要有一个全局的时间顺序。因此，每个消息在被创建时，都将被赋予一个全局唯一的、单调递增的、连续的序列号（SerialNumber，SN）。
可以通过一个全局计数器来实现这一点。通过比较两个消息的SN，确定其先后顺序。
回到问题。微博这个例子相对来说是比较简单的，可适用以下方案：

##方案一 通过某种算法，将需要保持先后顺序的消息放到同一个消息队列中
在本例中，针对某一个微博的操作（评论、通知、删除评论等），都依序放到消息队列A中（一般是通过对微博的ID进行hash来决定对应的消息队列）。既然同一个消息队列只有一个worker，那么很显然对其处理的顺序是可以保证的。已经有其他回答提到过这个方案。

这个方案还有一个隐藏的前提，就是对某个微博的操作的消息应该被保证按时间顺序放入消息队列。也就是说，对微博的评论的消息应该先于删除评论的消息被放入队列。为了做到这一点，需要先将评论的消息放入队列，然后再使评论可见，然后删除评论才可能发生（类似于数据库中的Write Ahead Log，WAL）
###问题 负载不均衡
以微博为例，一个极端的情况是，所有人都在评论某一条微博，而其它微博没有人评论。结果是队列A不堪重负，而其它队列为空，系统退回到单线程处理消息的状况。在这种情况下，仍然需要把对同一个微博的评论尽量平均地放到所有的消息队列中。这样，我们仍然需要保证不同的消息队列中的消息的先后顺序。实践中，更通用的例子是，对微博B1的评论处于队列A，对微博B2的评论处于队列B，但是后者引用了前者，所以必须保证前者首先被处理。
假设消息M1的SN=100，消息M2的SN=110。为了保证消息M1在M2之前被处理，关键是，处理M2之前，必须先检查M1是否已经被处理，如果没有，就等待。

##方案二：在将M1加入消息队列A时，同时对其它每一个队列加入一个特殊消息（Block Message，BM）
当某个消息队列处理BM时，检查M1是否已经被处理。如果M1已经被处理，则继续处理后面的消息。如果没有，则等待，直到M1被处理。严格地说，方案二不仅仅保证了M1和M2的时间顺序，更多地是保证了M1和所有M1之后的消息的时间顺序，因此它更适用于保证某个影响范围较大的操作的时间顺序。例如，M1对应创建一个用户的操作，而所有与此用户有关的操作都必须在创建此用户后才能执行。
###问题 资源浪费
在将M1加入队列时，必须明确知道其后会有依赖于M1的操作进行。对本例而言，评论微博以后，不一定会有删除微博的操作，而为了M1而block所有其它的消息队列，无疑会造成很大的性能浪费。

##方案三：每一个消息队列都记录自己处理的最后一个消息的SN，称为LastSN，LSN
假设消息M1的SN=100，消息M2的SN=110。当处理到M2时，检查所有其它消息队列的LSN是否大于等于100：如果所有消息队列的LSN都大于100，那么M1肯定已经被处理了。
如果有一个或多个消息队列的LSN小于100，那么，M1可能还没有被处理，但一定已经被放到了某个队列中（因为M2已经在当前队列中了）。在这种情况下，block所有LSN大于100的队列，等待所有LSN小于100队列继续运行，直到这些队列要么LSN大于等于100，要么队列为空。
有一个优化条件是，任何时候，如果某个消息队列的LSN等于100，那么M1肯定已经被处理了，可以直接结束等待。当然，这肯定会导致性能上的额外开销。



---
#Q&A
##消息发送一致性
context:
process->send message
send message->process
Reason:应用系统故障，消息系统故障
Solution:
    XA，分布式事务
    最终一致，暂存消息，业务成功再发送

##消息中间件与使用者强依赖
使用者消息入库，业务操作与入库作为本地事务，但消息中间件需要访问库

消息模型对消息接收的影响


## 消息模型对消息接收的影响
集群间 Topic模型
集群内 Queue模型

持久订阅：消费者存在则接收数据，不存在则保留等到下次启动后发送
非持久订阅：消费者存在则接收数据，不存在则不接收，消息不单独保留

## 保证消息可靠性的做法
Sender send to MQ



###MQ save message
消息表投递表，
分开
单独表（消费者共用一个字段）
    无法按消费者索引，只能按消息检索
    长度有限，消费者数量有限
    处理较快的集群，与慢集群的矛盾

单机raid，要考虑单机安全性
多机数据同步，复制有延迟
应用双写，应对存储自身复制有延迟，应用会变复杂

###MQ send to Receiver 投递的可靠性
投递，确认线程分离，避免确认慢的customer阻塞线程池
一个应用，多个订阅者，订阅多份同样


## Receiver角度，消息重复产生和应对
原因：
    MQ down
    MQ 负载高，响应慢
    success应答返回时Network down

应对：
要求Receiver消息处理为幂等操作

## 保证顺序的消息队列

## Push和Pull对比
Push    |  Pull
服务端|消费端
维护每次传输状态|   不需要
实时| 根据pull间隔
依据订阅者消费能力做流控|消费端根据自身能力决定pull


---
#软负载中心
地址聚合
生命周期感知

##上下线感知
可能问题：
1.软负载中心本身负载过大，导致接收心跳超时，可用服务器被误判
2.服务到软负载中心链路问题
解决方案：
1.通过历史连接和心跳数据判断，交给第三方验证（但有可能第三方和服务方链路出现问题，但Provicer和customer之间正常，解决办法让customer确认）

##数据分发的特点和设计
分发与订阅的区别
1.MQ保证每条消息不丢失
软负载中心只保证最新数据送到相关订阅者，不保证每次变化都被最终订阅者感知
2.消息中间件，同一集群不同机器分享所有消息
软负载中心，维护大家都需要的服务数据

提升分发性能需要注意的问题
数据压缩
全量与增量的选择

##针对服务化的特性支持
软负载数据分组
    根据环境区分
    分优先级的隔离
提供自动感知以外的上下线开关
    优雅的停止服务
    保持应用场景，用于排错

##从单机到集群
数据管理问题
连接管理问题
1.数据统一管理
管理连接的机器可以是无状态的
根据职责分离
2.数据对等管理方案
每个节点有整个集群的数据，节点对等，各节点之间数据同步


---







