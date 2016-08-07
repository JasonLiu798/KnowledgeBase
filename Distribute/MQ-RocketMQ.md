#RocketMQ
---


NameServer

Broker
    Master BrokerId 0   可部署多个
    Slaver BrokerId 非0 对应1个Master





Producer-------长连接------NameServer
        -------长连接------Master



[RocketMQ与Kafka对比（18项差异）](http://blog.csdn.net/damacheng/article/details/42846549)



---
#setup
1.RocketMQ用Java编写的，故先要安装JDK1.7(必须是64位1.7版本)，具体安装。
#tar -zxvf  jdk-7u75-linux-x64.tar.gz
#mv jdk1.7.0_75 /usr/local/java
#vi /etc/profile
#####profile文件末添加如下内容######
JAVA_HOME=/usr/local/java
PATH=$JAVA_HOME/bin:$PATH
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME
export PATH
export CLASSPATH

#source /etc/profile
PS:NameServer机器跟Broker Server是独立的，所以需要三台机器
 
2.RocketMQ安装
#tar -zxvf alibaba-rocketmq-3.2.6.tar.gz
#mv alibaba-rocketmq /usr/local/rocketmq
#chown -R root:root /usr/local/rocketmq
#chmod -R +x /usr/local/rocketmq
#vi /etc/profile
export ROCKETMQ_HOME=/usr/local/rocketmq
export PATH=$PATH:$ROCKETMQ_HOME/bin
#source /etc/profile

3.启动nameserver（work用户下启动）
#su - work
#nohup mqnamesrv > /dev/null 2>&1 &
nameserver默认日志目录位于
$HOME/logs/rocketmqlogs/namesrv.log
$HOME/logs/rocketmqlogs/namesrv_default.log
可以修改$ROCKETMQ_HOME/conf/logback_namesrv.xml文件修改nameserver日志级别及存放目录
(注：mqnameserv会直接获取主机名，根据主机名去找hosts文件dns路由来获取ip，所以需要在/etc/hosts配置主机名)
 
4、启动BrokerServer A【master1】
# cd /usr/local/rocketmq/conf/2m-2s-async 
# vi broker-a.properties
brokerClusterName=xxxRocketMQCluster
brokerName=broker-a
namesrvAddr=192.168.138.148:9876
brokerId=0
deleteWhen=04
fileReservedTime=48
storePathRootDir=/data/rocketmq/store
storePathCommitLog=/data/rocketmq/commitlog 
brokerRole=ASYNC_MASTER 
flushDiskType=ASYNC_FLUSH
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
ps:namesrvAddr=192.168.138.148:9876这个配置项根据前面name server具体IP具体配置
(注：namesrvAddr后面不允许有空格，storePathRootDir后有空格建文件夹会把空格一起建进去，建议全部参数后都不带任何空格)
 
#mkdir -p /data/rocketmq/commitlog
#chown -R work:work /data/rocketmq
#su - work（服务启动需要转到work用户启动）
# nohup sh mqbroker -c /usr/local/rocketmq/conf/2m-2s-async/broker-a.properties  >/dev/null 2>&1 &
 
5、启动BrokerServer A-S【slave1】
# cd /usr/local/rocketmq/conf/2m-2s-async
# vi broker-a-s.properties
brokerClusterName=XXXRocketMQCluster 
brokerName=broker-a
namesrvAddr=192.168.138.148:9876
brokerId=1
 
deleteWhen=04
fileReservedTime=48 
storePathRootDir=/data/rocketmq/store
storePathCommitLog=/data/rocketmq/commitlog
brokerRole=SLAVE 
 
flushDiskType=ASYNC_FLUSH

----------------------------------------------------------------------------------------------------------------------------------
ps:namesrvAddr=192.168.138.148:9876这个配置项根据前面name server具体IP具体配置
(注：namesrvAddr后面不允许有空格，storePathRootDir后有空格建文件夹会把空格一起建进去，建议全部参数后都不带任何空格)

#mkdir -p /data/rocketmq/commitlog
#chown -R work:work /data/rocketmq
#su - work（服务启动需要转到work用户启动）
# nohup sh mqbroker -c /usr/local/rocketmq/conf/2m-2s-async/broker-a-s.properties  >/dev/null 2>&1 &

---
#Q
```
1.1、没消费掉的消息，Topic所在Master节点停掉或者网络断掉，无法查阅该topic的信息，重启节点或网络重连后，可以消费该topic消息
1.2、消息订阅了后，消费了消息，不会再次消费，但RocketMQ上的消息不会立刻删除。默认三天后删除该消息。
1.3、消息订阅，由于消息订阅不会删除原来的消息，下次注册新的消费者（即是不同组的消费者），之前老的消息会被新的消费者拉取下来。
1.4、删除topic后，会连带将topic对应的信息也删除
1.5、消息发送成功后，slave节点当掉，不影响消费者消费，消费者还可以正常的消费掉全部的消息
1.6、slave节点宕机，不影响消息的发送及消费
1.7、master节点当掉一个不影响消息的发送，全部当掉，则无法发送消息。
1.8、RocketMQ消息只往master机器去写，不会直接写到slave机器。
1.9、同一组APP消费者所属组必须要一样，否则会导致重复消费消息。同样消费者组下的消费者只能消费一次相同topic的消息。
        DefaultMQPushConsumer cosumer = new DefaultMQPushConsumer(consumerGroupName)；
        RocketMQ是根据consumerGroupName来判断是否消费消息
```























