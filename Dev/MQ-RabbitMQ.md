# RabbitMQ
---
#theory
[RabbitMQ基础概念详细介绍](http://blog.csdn.net/whycold/article/details/41119807)
[RabbitMQ从入门到精通](http://blog.csdn.net/column/details/rabbitmq.html)
[百度百科](http://baike.baidu.com/link?url=1GP4QquZg-KldH-p-_hxshzDhc4zFuIe9jgu5f17g9ftf0IjKH26FwxARjomqOVcj1KmATXHjTfSlImrSbxoeK)

##场景
AMQP
1.信息的发送者和接收者如何维持这个连接，如果一方的连接中断，这期间的数据如何方式丢失？
2.如何降低发送者和接收者的耦合度？
3.如何让Priority高的接收者先接到数据？
4.如何做到load balance？有效均衡接收者的负载？
5.如何有效的将数据发送到相关的接收者？也就是说将接收者subscribe不同的数据，如何做有效的filter。
6.如何做到可扩展，甚至将这个通信模块发到cluster上？
7.如何保证接收者接收到了完整，正确的数据？


多个消费者可以订阅同一个Queue-平均分摊

##RabbitMQ Server(broker server)
###交换机
routing keys
Direct交换机 完全根据key进行投递的叫做
 
Topic交换机 key进行模式匹配后进行投递的叫做
    符号”#”匹配一个或多个词，符号”*”匹配正好一个词

Fanout交换机
    不需要key的，它采取广播模式，一个消息进来时，投递到与该交换机绑定的所有队列

header
headers类型的Exchange不依赖于routing key与binding key的匹配规则来路由消息，而是根据发送的消息内容中的headers属性进行匹配。

##Message
payload（有效载荷）和label（标签）

Exchanges are where producers publish their messages.
 
Queues are where the messages end up and are received by consumers
Bindings are how the messages get routed from the exchange to particular queues.

##Connection
    RabbitMQ的socket链接，它封装了socket协议相关部分逻辑。
##ConnectionFactory
    为Connection的制造工厂
##Channel
    大部分的业务操作是在Channel这个接口中完成的，包括定义Queue、定义Exchange、绑定Queue与Exchange、发布消息等。



##持久化
（1）exchange持久化，在声明时指定durable => 1
（2）queue持久化，在声明时指定durable => 1
（3）消息持久化，在投递时指定delivery_mode => 2（1是非持久化）
如果exchange和queue都是持久化的，那么它们之间的binding也是持久化的。如果exchange和queue两者之间有一个持久化，一个非持久化，就不允许建立绑定。


##消息确认
[RabbitMQ消息队列（九）：Publisher的消息确认机制](http://blog.csdn.net/anzhsoft/article/details/21603479)






---
#setup
##ubuntu
apt-get update
apt-get install rabbitmq-server

---
#common command
服务器相关命令：
启动
rabbitmq-server start
关闭
rabbitmq-server stop
查看状态
rabbitmqctl status

[example](http://www.rabbitmq.com/getstarted.html)




















































