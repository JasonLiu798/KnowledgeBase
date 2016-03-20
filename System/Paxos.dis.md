#Paxos算法
[前百度牛人李海磊](http://www.tudou.com/programs/view/e8zM8dAL6hM/)
[paxos算法之粗浅理解](http://blog.csdn.net/flyforfreedom2008/article/details/45542583)

#目的
paxos用来确定一个不可变变量的取值
  * 取值可以为任意二进制数
  * 一旦确定，不再更改，而且可以被获取到（不可变性、可读取性）

分布式存储系统中应用Paxos
  * 数据本身可变，采用多副本进行存储
  * 多个副本的更新操作序列(op1,op2...opn)是相同的、不变的
  * 用paxos依次来确定不可变变量opi，依次类推
  * google的chubby,megastore,spanner都采用paxos对数据副本更新序列达成一致

#场景描述
设计一个系统，存储名称为var的变量
  * 系统内部由多个acceptor组成，负责存储和管理var变量
  * 外部有多个proposer机器任意并发调用API，向系统提交不同var取值
  * var取值可以为任意二进制数据
  * 系统对外AIP库接口为：propose(var,V)=><ok,f> or <error>
系统需要保证var取值一致性
  * 如果var取值没有确定，则var取值为null
  * 一旦var取值被确定，则不可被更改。并且可以一直获取到这个值
系统需要满足容错性
  * 可以容忍任意proposer机器出现故障
  * 可以容忍少数Acceptor故障（半数以下）
暂不考虑
  * 网络分化
  * acceptor故障会丢失var信息

##确定一个不可变量----难点
* 管理多个proposer并发执行
* 保证var变量不可变
* 容忍任意proposer机器故障
* 容忍半数以下Acceptor机器故障

##方案1--互斥锁
系统由单个Acceptor组成，互斥锁
Acceptor::prepare()
Acceptor::release()
Acceptor::accept(var,V)
后续proposer不可更改先前proposer修改的值

缺点：
proposer在释放互斥访问权，会导致系统陷入死锁
* 不能容忍任意proposer出现故障

##方案2
引入抢占式访问权
* acceptor可以让某个proposer获取到的访问权失效，不再接受它的访问
* 之后，可以将访问权发放给其他proposer，让其他proposer访问acceptor.
proposer向Acceptor申请访问权时，指定编号epoch（越大的epoch越新），获取到访问权后，才能向acceptor提交取值
新epoch可以抢占旧epoch，让旧epoch的访问权失效。旧epoch的proposer将无法运行，新epoch的proposer将开始运行
为保持一致，不同epoch的proposer之间采用“后者认同前者”原则
* 在肯定旧epoch无法生成确定性取值时，新的epoch会提交自己的value，不会冲突
* 一旦旧epoch形成确定性取值，新的epoch肯定可以获取到此取值，并且认同此值，不会破坏

基于抢占式访问权的Acceptor的实现
* acceptor保存的状态
  - 当前var的取值<accepted_epoch,accepted_value>
  - 最新发放访问权的epoch(latest_prepared_epoch)





Paxos算法基本上来说是个民主选举的算法——大多数的决定会成个整个集群的统一决定。任何一个点都可以提出要修改某个数据的提案,是否通过这个提案取决于这个集群中是否有超过半数的节点同意(所以Paxos算法需要集群中的节点是单数)


```
两阶段提交协议的消息流程：
Coordinator                                         Cohort
                              QUERY TO COMMIT
                -------------------------------->
                              VOTE YES/NO           prepare*/abort*
                <-------------------------------
commit*/abort*                COMMIT/ROLLBACK
                -------------------------------->
                              ACKNOWLEDGMENT        commit*/abort*
                <--------------------------------  
end
```
两阶段提交协议包含投票(Vote)和提交(Commit)两个阶段，它是一个阻塞的协议，如果参与者给协调者发送YES消息后协调者永久性地挂了，那么参与者将陷入无限等待中，并且会带来数据不一致的问题

```
//三阶段提交消息流程：
Coordinator                                       Cohort

Soliciting 
votes...                canCommit?
              -------------------------------->
                        Yes                       Phase1   Uncertain
              <-------------------------------             Timeout causes abort

Commit authorized.         
timeout cause            preCommit
about.          -------------------------------->
                        ACK                                 
                <-------------------------------  Phase2   Prepared to commit.
                                                           timeout cause commit.
Finalizing commit.                        
timeout causes             doCommit
about.           -------------------------------->
                           haveCommitted        
Done.            <--------------------------------  Phase3 Commited.

```
增加了准备提交(Prepared to commit)阶段
解决了协调者挂掉后参与者无限阻塞和数据可能不一致的问题，但仍然无法解决网络分区的问题

如何在分布式系统中确定某
一个变量的值。在这个具体的场景中，这个变量的值指定了哪个节点将被选出来担当新协调者的角色


---
#paxos角色和规则
从上面的结构图中，我们看到paxos主要涉及三个角色，分别为Acceptor、Proposer和Learner，在实践中，往往每个节点都具备这三个角色，这里为了让我们大脑少些迷糊，暂且以每个节点只具备一种角色来讨论。

##Prepare
Proposer向所有Acceptor发送Prepare申请访问权，并携带一个提案号(epoch)
Acceptor赋予访问权或拒绝，并且返回该Acceptor已经接受的值和对应的提案号
如果Proposer获得超过半数Acceptor的访问权，那么会进入第二阶段；

##Accept
1) 如果所有的Acceptor返回值都为空，则Proposer将携带自己预设的值v和自己的epoch号向获取到访问权的Acceptor发送请求;
2)如果Proposer第一阶段获得某些Acceptor的返回值不为空，则将epoch号最大的提案号对应的值f作为自己的预设值，和自己的提案号一起向Acceptor发送请求
(如果第一阶段返回f的Acceptor已经超过了半数，则表示已经形成确定性取值，此时直接返回成功，不需要进行Accept请求了)；

##Acceptor接收到Proposer请求，响应规则
1)喜新厌旧
当Acceptor接收到Prepare请求时，它将当前
  自己发放了访问权的epoch号
  和该Prepare请求携带的epoch
进行比较，如果前者小于后者，则将访问权赋予新请求的这个Proposer，
否则拒绝发放访问权。这里我们认为epoch值越大的越新。
2) 一视同仁
当Acceptor接收到Accept请求时，它将当前
  自己发放了访问权的epoch号
  和该Prepare请求携带的epoch
进行比较，如果前者大于后者，则拒绝该请求。
如果这两个epoch号相等，并且Acceptor当前接受的取值为空，则接受该Acceptor请求，同时将该Accept请求的值设置为接受值。
如果之后又更大的epoch号申请到访问权，并发出Accept请求，该值也不会改变，即Acceptor在确定了值之后不再改变，谁先设置就用谁的值。
虽然在发放访问权时是喜新厌旧，但在取值这个问题上一视同仁，不会因为新epoch号大而改变取值。这就像某些人，其他女人可以访问他，但老婆只要定了就不会变。


---
#paxos正确性
假设有N个Acceptor，多数派个数至少为N/2+1。如果有一个以上的Proposer获取到超过半数Acceptor的访问权，那么至少有一个Acceptor是相同的。具体来说，假设Proposer A在Prepare阶段获取到J个Acceptor的访问权，Proposer B在Prepare阶段获取到K个Acceptor的访问权，J>=N/2+1，K>=N/2+1，那么必然有这样一个Acceptor C，C既属于J又属于K，这种情况就是在C给某个Proposer发放访问权后，接着被另一个Proposer抢占到了访问权时发生。 我们假设Proposer A的取值为V1，Proposer B的取值为V2。在Accept阶段，对于Acceptor C来说，它根据访问权来决定接受谁的Accept请求，如果当前是B获得了访问权，则接受B的取值V2，这样A在Accept阶段将失败，失败之后它可能会继续生成新的epoch值重新进入Prepare阶段，但是这回它拿到了返回值V2，这样它之后进入Accept阶段时，会将V2作为它的取值向Acceptor发送申请，最终Proposer A和Proposer B都达成了一致，即V2为最终取值。






---
#Fast Paxos























