#dubbo
---
#theory
[Dubbo架构设计详解](http://shiyanjun.cn/archives/325.html)
##层次划分
###服务接口层（Service）
该层是与实际业务逻辑相关的，根据服务提供方和服务消费方的业务设计对应的接口和实现。
###配置层（Config）
对外配置接口，以ServiceConfig和ReferenceConfig为中心，可以直接new配置类，也可以通过spring解析配置生成配置类。
###服务代理层（Proxy）
服务接口透明代理，生成服务的客户端Stub和服务器端Skeleton，以ServiceProxy为中心，扩展接口为ProxyFactory。
###服务注册层（Registry）
封装服务地址的注册与发现，以服务URL为中心，扩展接口为RegistryFactory、Registry和RegistryService。可能没有服务注册中心，此时服务提供方直接暴露服务。
###集群层（Cluster）
封装多个提供者的路由及负载均衡，并桥接注册中心，以Invoker为中心，扩展接口为Cluster、Directory、Router和LoadBalance。将多个服务提供方组合为一个服务提供方，实现对服务消费方来透明，只需要与一个服务提供方进行交互。
###监控层（Monitor）
RPC调用次数和调用时间监控，以Statistics为中心，扩展接口为MonitorFactory、Monitor和MonitorService。
###远程调用层（Protocol）
封将RPC调用，以Invocation和Result为中心，扩展接口为Protocol、Invoker和Exporter。Protocol是服务域，它是Invoker暴露和引用的主功能入口，它负责Invoker的生命周期管理。Invoker是实体域，它是Dubbo的核心模型，其它模型都向它靠扰，或转换成它，它代表一个可执行体，可向它发起invoke调用，它有可能是一个本地的实现，也可能是一个远程的实现，也可能一个集群实现。
###信息交换层（Exchange）
封装请求响应模式，同步转异步，以Request和Response为中心，扩展接口为Exchanger、ExchangeChannel、ExchangeClient和ExchangeServer。
###网络传输层（Transport）
抽象mina和netty为统一接口，以Message为中心，扩展接口为Channel、Transporter、Client、Server和Codec。
###数据序列化层（Serialize）
可复用的一些工具，扩展接口为Serialization、 ObjectInput、ObjectOutput和ThreadPool。


##协议支持
Dubbo协议
Hessian协议
HTTP协议
RMI协议
WebService协议
Thrift协议
Memcached协议
Redis协议

##模块
Dubbo以包结构来组织各个模块，各个模块及其关系
dubbo-common 公共逻辑模块，包括Util类和通用模型。
dubbo-remoting 远程通讯模块，相当于Dubbo协议的实现，如果RPC用RMI协议则不需要使用此包。
dubbo-rpc 远程调用模块，抽象各种协议，以及动态代理，只包含一对一的调用，不关心集群的管理。
dubbo-cluster 集群模块，将多个服务提供方伪装为一个提供方，包括：负载均衡、容错、路由等，集群的地址列表可以是静态配置的，也可以是由注册中心下发。
dubbo-registry 注册中心模块，基于注册中心下发地址的集群方式，以及对各种注册中心的抽象。
dubbo-monitor 监控模块，统计服务调用次数，调用时间的，调用链跟踪的服务。
dubbo-config 配置模块，是Dubbo对外的API，用户通过Config使用Dubbo，隐藏Dubbo所有细节。
dubbo-container 容器模块，是一个Standalone的容器，以简单的Main加载Spring启动，因为服务通常不需要Tomcat/JBoss等Web容器的特性，没必要用Web容器去加载服务。


[RMI优劣](http://www.51testing.com/html/38/225738-222944.html)
[dubbo官方文档](http://www.51testing.com/html/38/225738-222944.html)
[阿阮-博客-dubbo](http://my.oschina.net/aruan/blog?catalog=578563)




---
#源码分析
[阿里巴巴Dubbo实现的源码分析](http://blog.csdn.net/aisoo/article/details/8286875)    
服务提供Invoker和服务消费Invoker：

ExtensionLoader

com.alibaba.dubbo.config.spring.schema
DubboNamespaceHandler





---
# API
## 结果缓存
2.1.0以上版本支持
### cunsumer
```html
<dubbo:reference cache="true"/>
或
<dubbo:reference interface="com.foo.BarService">
    <dubbo:method name="findBar" cache="lru" />
</dubbo:reference>
```
### server


## 泛化引用

## 回声测试
所有服务自动实现EchoService接口，只需将任意服务引用强制转型为EchoService，即可使用。
MemberService memberService = ctx.getBean("memberService"); // 远程服务引用
EchoService echoService = (EchoService) memberService; // 强制转型为EchoService
String status = echoService.$echo("OK"); // 回声测试可用性
assert(status.equals("OK"))

## 上下文信息
### client

xxxService.xxx(); // 远程调用
boolean isConsumerSide = RpcContext.getContext().isConsumerSide(); // 本端是否为消费端，这里会返回true
String serverIP = RpcContext.getContext().getRemoteHost(); // 获取最后一次调用的提供方IP地址
String application = RpcContext.getContext().getUrl().getParameter("application"); // 获取当前服务配置信息，所有配置信息都将转换为URL的参数
// ...
yyyService.yyy(); // 注意：每发起RPC调用，上下文状态会变化
// ...

### server 
boolean isProviderSide = RpcContext.getContext().isProviderSide(); // 本端是否为提供端，这里会返回true
        String clientIP = RpcContext.getContext().getRemoteHost(); // 获取调用方IP地址
        String application = RpcContext.getContext().getUrl().getParameter("application"); // 获取当前服务配置信息，所有配置信息都将转换为URL的参数
        // ...
        yyyService.yyy(); // 注意：每发起RPC调用，上下文状态会变化
        boolean isProviderSide = RpcContext.getContext().isProviderSide(); // 此时本端变成消费端，这里会返回false

## 隐式传参
### client
RpcContext.getContext().setAttachment("index", "1"); 
### server
RpcContext.getContext().getAttachment("index"); 

## 异步调用
2.0.6及其以上版本支持
基于NIO的非阻塞实现并行调用，客户端不需要启动多线程即可完成并行调用多个远程服务，相对多线程开销较小。
### consumer
async="true"
sent="true" 等待消息发出，消息发送失败将抛出异常。
sent="false" 不等待消息发出，将消息放入IO队列，即刻返回。
return="false" 不返回

## 本地调用
本地调用，使用了Injvm协议，是一个伪协议，它不开启端口，不发起远程调用，只在JVM内直接关联，但执行Dubbo的Filter链。
<dubbo:protocol name="injvm" />




---
#异构对接
##基于hessian
[基于Dubbo的Hessian协议实现远程调用](http://shiyanjun.cn/archives/349.html)




---
#Q
##mina相关
[dubbo中的那些“坑”(1) – 关于MINA传输协议的bug定位及修复](http://www.tuicool.com/articles/RJZ3uuY)
1.netty是为每一个channel分配了一个NettyCodecAdapter, mina确实在服务器监听前配置了MinaCodecAdapter
2.也就是说，netty的每一个独立的通道的Codec(encoder/decoder）是通道安全的
3.mina的所有通道是共享相同的codec(encoder/decoder)的，因此，解码器中的实例数据时非channel安全的
4.解决方案
1.配置acceptor的监听器
codecAdapter = new MinaCodecAdapter(getCodec(), getUrl(), this);acceptor.getFilterChain().addLast(“codec”, new ProtocolCodecFilter(codecAdapter));
...

##netty4相关
[dubbo中的那些“坑"(3)-netty4-rpc网络接口中的高并发的bug](http://my.oschina.net/aruan/blog/351622)
内核是需要ByteBuf.release的，继续通过byteBuf的一个实现PooledByteBuf分析源码，原来是实现了一个基于简单计数应用计数的循环使用的缓冲区，一旦计数变为1，该缓冲区被归还到netty4内核，被后面的数据读取线程重新使用




---
# Performance Test
## process time <100ms,network 11.0M/s <1ms
4core
local
1 1c,local,1provider
sync
cost 2 ms
async
cost 580 ms

1000000(100W) 1000c,local,1 provider,
total:164 346 ms

100W 1000c,local,2 provider,
total:221 180 ms

100W 1000c,local,1provider,async
total:182649 ms.

100W 1000c,remote,1 provider
sync
total:102 568 ms
async
total:89 430 ms.
total:81 542 ms.

100W 500c,1provider

async
total:85 229 ms.
total:94 565 ms.
total:79 967 ms.

100W 1000c,remote,2 provider(same network segment)
total:134 475 ms.
total:112 794 ms.
async
total:125 780 ms.
total:88 946 ms.
total:107 480 ms.

100W 500c,remote,2provider
async
total:95 993 ms.
total:96 458 ms.

100W 1000c,remote,3 provider(same network segment)
sync
total:155 275 ms.
async
total:113 839 ms.
total:116 435 ms.

100W 500c
async
total:106255 ms.

## process time 500ms,network 11.0M/s <1ms
100W 1000c,remote,1 provider(same network segment)
total:1619 017 ms.

100W 1000c,remote,3 provider(same network segment)
sync
total:810 953 ms.

----



