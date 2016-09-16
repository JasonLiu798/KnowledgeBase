#Zookeeper
---
#docs
[Zookeeper入门开发demo](http://www.cnblogs.com/chengxin1982/p/3997726.html)

---
#theory
[zookeeper的部署和使用](http://wangwei.cao.blog.163.com/blog/static/102362526201022414553362/)
[zookeeper原理](http://cailin.iteye.com/blog/2014486/)
##特点
简单：核心是精简的文件系统
富有表现力：原语操作室一组丰富的构件
高可用性：
松耦合交互
资源库

原子性
可靠性
单一性
及时性
等待无关：慢的或者失效client不得干预快速client的请求
顺序一致性：全局有序，偏序


##设计目的
1最终一致性：client不论连接到哪个Server，展示给它都是同一个视图，这是zookeeper最重要的性能
2可靠性：具有简单、健壮、良好的性能，如果消息m被到一台服务器接受，那么它将被所有的服务器接受。
3实时性：Zookeeper保证客户端将在一个时间间隔范围内获得服务器的更新信息，或者服务器失效的信息。但由于网络延时等原因，Zookeeper不能保证两个客户端能同时得到刚更新的数据，如果需要最新数据，应该在读数据之前调用sync()接口。
4等待无关（wait-free）：慢的或者失效的client不得干预快速的client的请求，使得每个client都能有效的等待。
5原子性：更新只能成功或者失败，没有中间状态。
6顺序性：包括全局有序和偏序两种：全局有序是指如果在一台服务器上消息a在消息b前发布，则在所有Server上消息a都将在消息b前被发布；偏序是指如果一个消息b在消息a后被同一个发送者发布，a必将排在b前面。


---
#Zab协议
* ZAB协议确保那些已经在Leader服务器上提交的事务最终被所有服务器都提交
* ZAB协议确保丢弃那些只在Leader服务器上被提出的事务

阶段1：选主
阶段2：原子广播
阶段3：
不同于paxos算法，操作方面不同，例如依靠TCP保证消息顺序

##Server三种状态
LOOKING：当前Server不知道leader是谁，正在搜寻
LEADING：当前Server即为选举出来的leader
FOLLOWING：leader已经选举出来，当前Server与之同步

##选主
一种是基于basic paxos实现的，另外一种是基于fast paxos算法实现的
系统默认的选举算法为fast paxos

###zxid
递增的事务id号（zxid）来标识事务。所有的提议（proposal）都在被提出的时候加上了zxid。实现中zxid是一个64位的数字，它高32位是epoch用来标识leader关系是否改变，每次一个leader被选出来，它都会有一个新的epoch，标识当前属于那个leader的统治时期。低32位用于递增计数。

###basic paxos流程
1选举线程由当前Server发起选举的线程担任，其主要功能是对投票结果进行统计，并选出推荐的Server；
2选举线程首先向所有Server发起一次询问(包括自己)；
3选举线程收到回复后，验证是否是自己发起的询问(验证zxid是否一致)，然后获取对方的id(myid)，并存储到当前询问对象列表中，最后获取对方提议的leader相关信息(id,zxid)，并将这些信息存储到当次选举的投票记录表中；
4收到所有Server回复以后，就计算出zxid最大的那个Server，并将这个Server相关信息设置成下一次要投票的Server；
5线程将当前zxid最大的Server设置为当前Server要推荐的Leader，如果此时获胜的Server获得n/2 + 1的Server票数， 设置当前推荐的leader为获胜的Server，将根据获胜的Server相关信息设置自己的状态，否则，继续这个过程，直到leader被选举出来。

###fast paxos流程
是在选举过程中，某Server首先向所有Server提议自己要成为leader，当其它Server收到提议以后，解决epoch和zxid的冲突，并接受对方的提议，然后向对方发送接受提议完成的消息，重复这个流程，最后一定能选举出Leader。

##同步流程
选完leader以后，zk就进入状态同步过程。
1. leader等待server连接；
2 .Follower连接leader，将最大的zxid发送给leader；
3 .Leader根据follower的zxid确定同步点；
4 .完成同步后通知follower 已经成为uptodate状态；
5 .Follower收到uptodate消息后，又可以重新接受client的请求进行服务了。

##工作流程
###2.3.1 Leader工作流程
Leader主要有三个功能：
1 .恢复数据；
2 .维持与Learner的心跳，接收Learner请求并判断Learner的请求消息类型；
3 .Learner的消息类型主要有PING消息、REQUEST消息、ACK消息、REVALIDATE消息，根据不同的消息类型，进行不同的处理。

###Follower工作流程
Follower主要有四个功能：
1. 向Leader发送请求（PING消息、REQUEST消息、ACK消息、REVALIDATE消息）；
2 .接收Leader消息并进行处理；
3 .接收Client的请求，如果为写请求，发送给Leader进行投票；
4 .返回Client结果。







---
#场景
##数据发布/订阅

##负载均衡
DDNS

##命名服务

##分布式协调/通知

##通用的分布式系统机器间通信方式
###心跳检测
临时节点
###工作进度汇报
###系统调度

##集群管理


##master选举
利用zk强一致性，多个客户端无法重复创建同一个节点

##分布式锁

##分布式队列









