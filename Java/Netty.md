#Network/Netty/mina/nio
---
# docs
[可靠性分析](http://www.infoq.com/cn/articles/netty-reliability)
[nio](https://www.gitbook.com/book/lukangping/java-nio/details)
[4.0 user guide](https://github.com/waylau/netty-4-user-guide)
[Essential Netty in Action](https://www.gitbook.com/book/waylau/essential-netty-in-action/details)

## netty3.x->4.x升级问题
[Netty版本升级血泪史之线程篇](http://www.infoq.com/cn/articles/netty-version-upgrade-history-thread-part)
PooledByteBuf 为ThreadLocal
线程模型变更，重点需要关注outbound的ChannelHandler

## Netty系列之Netty高性能之道
http://www.infoq.com/cn/articles/netty-high-performance
http://www.infoq.com/cn/articles/netty-high-performancenetty4.x教程
http://www.cnblogs.com/zou90512/p/3492287.html

## grizzly doc
https://grizzly.java.net/documentation.html

---
#bio/nio对比
##BIO
```
client1--->acceptor-->new thread1
client2--->        -->new thread2
client3--->        -->new thread3
```
服务端线程数：客户端数量=1:1

##池化BIO，伪异步IO
线程池N：客户端M
M可以远大于N
* 弊端
    - read()直到 数据传输可用/检测到文件尾/发生异常 之前会阻塞
    - write()直到 数据完全写完 之前会阻塞
    - 因此，阻塞IO无法解决通信线程阻塞问题

##nio
Non-block I/O


##NIO与BIO区别
IO             |   NIO
---------------|--------------
面向流         |   面向缓冲
阻塞IO         |   非阻塞IO
无             |   选择器
##各自适用场景
IO适合少量的连接使用非常高的带宽，一次发送大量的数据，也许典型的IO服务器实现可能非常契合
低负载、低并发、编程复杂度低
NIO
* 客户端发起连接操作是异步，可以通过再多路复用器注册OP_CONNECT等待后续结果，不需要同步阻塞
* SocketChannel读写都是异步，如没有可读写的数据它不会同步等待，直接返回，不需要同步等待
* 线程模型的优化：由于JDK selector在linux上通过epoll实行，没有连接句柄数限制

##aio



---
#NIO
[nio教程](http://ifeve.com/overview/)
[原文](http://tutorials.jenkov.com/java-nio/index.html)
##channel
* 既可以从通道中读取数据，又可以写数据到通道。但流的读写通常是单向的
* 通道可以异步地读写
* 通道中的数据总是要先读到一个Buffer，或者总是要从一个Buffer中写入

##Buffer
使用Buffer读写数据一般遵循以下四个步骤：
* 写入数据到Buffer
* 调用flip()方法
* 从Buffer中读取数据
* 调用clear(清空所有)方法或者compact(清空已读)方法
###Three Property:
* capacity
* position         
    init:0
    写模式：当前位置，add->下一位置
    max:capacity-1
    flip:w->r,pos=0
* limit             
    表示最多能读/写到多少数据
    写模式:limit等于Buffer的capacity
    读模式:写模式下的position值

###read/write
* write         
    从Channel写到Buffer。
    通过Buffer的put()方法写到Buffer里。
* read
    从Buffer读取数据到Channel。
    使用get()方法从Buffer中读取数据。

###other
* rewind        
    pos=0,limit保持不变
* clear
    pos=0,limit=capacity,数据并未清除
* compact       
    未读的数据拷贝到Buffer起始处，pos=未读元素之后，limit=capacity
* mark
    标记position
* reset         
    恢复到标记position
* equals        
    有相同的类型（byte、char、int等）。
    Buffer中剩余的byte、char等的个数相等。
    Buffer中所有剩余的byte、char等都相同。
* compareTo 比较两个Buffer的剩余元素         
    满足下列条件，则认为一个Buffer“小于”另一个Buffer：
    * 第一个不相等的元素小于另一个Buffer中对应的元素 。
    * 所有元素都相等，但第一个Buffer比另一个先耗尽(第一个Buffer的元素个数比另一个少)。

* Scattering Reads
```java
    ByteBuffer header = ByteBuffer.allocate(128);
    ByteBuffer body   = ByteBuffer.allocate(1024);
    ByteBuffer[] bufferArray = { header, body };
    channel.read(bufferArray);
```
* Gathering Writes
```java
    ByteBuffer header = ByteBuffer.allocate(128);
    ByteBuffer body   = ByteBuffer.allocate(1024);
    //write data into buffers
    ByteBuffer[] bufferArray = { header, body };
    channel.write(bufferArray);
```
* transferFrom      
    将数据从源通道传输到FileChannel
* transferTo            
    FileChannel传输到其他的channel

##selector
与Selector一起使用时，Channel必须处于非阻塞模式下
```java
SelectionKey.OP_CONNECT
SelectionKey.OP_ACCEPT
SelectionKey.OP_READ
SelectionKey.OP_WRITE
```

* attach()
    附加
* key.attachment()
    获取
* select()
    阻塞到至少有一个通道在你注册的事件上就绪了,返回的int值表示有多少通道已经就绪
    select(long timeout)和select()一样，除了最长会阻塞timeout毫秒(参数)。
* selectNow()
    不会阻塞，不管什么通道就绪都立刻返回
* selectedKeys
    访问已选择键集（selected key set）”中的就绪通道
* Selector.wakeup()
* close()       
    方法会关闭该Selector

##FileChannel
```java
write()
    buf.clear()->buf.put()->buf.flip()->write(buf)
size()
position()
close()
truncate() 文件之后被截取
force() 强制写入
    true 同时将文件数据和元数据强制写到磁盘上
```

##SocketChannel
```java
open();
connect(new InetSocketAddress("http://jenkov.com", 80));
ByteBuffer buf = ByteBuffer.allocate(48);
int bytesRead = socketChannel.read(buf);

finishConnect;
close();
```
非阻塞模式
write()
非阻塞模式下，write()方法在尚未写出任何内容时可能就返回了。所以需要在循环中调用write()。前面已经有例子了，这里就不赘述了。

read()
非阻塞模式下,read()方法在尚未读取到任何数据时可能就返回了。所以需要关注它的int返回值，它会告诉你读取了多少字节。

##ServerSocketChannel
```java
open()
bind(new InetSocketAddress(9999))
//非阻塞模式
accept() 方法会立刻返回，需检查返回的SocketChannel 是否为空
```

##DatagramChannel
```java
DatagramChannel channel = DatagramChannel.open();
channel.socket().bind(new InetSocketAddress(9999));


ByteBuffer buf = ByteBuffer.allocate(48);
buf.clear();
channel.receive(buf);

channel.send(buf, new InetSocketAddress("jenkov.com", 80));
//锁住连接
channel.connect(new InetSocketAddress("jenkov.com", 80));
```

##Pipe
2个线程之间的单向数据连接
Thread1->sinkChannel->sourceChannel->Thread2
Pipe pipe = Pipe.open();
Pipe.SinkChannel sinkChannel = pipe.sink();



##Path
Paths.get(absstractPath)
Paths.get(basePath, relativePath)
normalize()

##Files
Files.exists()
Files.createDirectory
move
delete
walkFileTree

##AsynchronousFileChannel





---
# netty
## 线程模型
### Reactor单线程模型
Reactor

### Rector多线程模型
与单线程模型最大的区别就是有一组NIO线程处理IO操作
1）专门一个NIO线程-Acceptor线程用于监听服务端，接收客户端的TCP连接请求；
2）网络IO操作-读、写等由一个NIO线程池负责，线程池可以采用标准的JDK线程池实现，它包含一个任务队列和N个可用的线程，由这些NIO线程负责消息的读取、解码、编码和发送；
3）1个NIO线程可以同时处理N条链路，但是1个链路只对应1个NIO线程，防止发生并发操作问题。

### 主从多线程模型
服务端用于接收客户端连接的不再是个1个单独的NIO线程，而是一个独立的NIO线程池。
Acceptor接收到客户端TCP连接请求处理完成后（可能包含接入认证等），将新创建的SocketChannel注册到IO线程池（sub reactor线程池）的某个IO线程上，由它负责SocketChannel的读写和编解码工作。

### Netty线程模型
#### 服务端线程模型
服务端监听线程和IO线程分离
bossGroup线程组实际就是Acceptor线程池，负责处理客户端的TCP连接请求，如果系统只有一个服务端端口需要监听，则建议bossGroup线程组线程数设置为1
EventLoopGroup管理的线程数可以通过构造函数设置，没有设置，默认取-Dio.netty.eventLoopThreads，如果该系统参数也没有指定，则为可用的CPU内核数 × 2

![netty4线程模型](../img/netty4-thread.png)


#### 客户端线程模型


#### NioEventLoop
作为服务端Acceptor线程，负责处理客户端的请求接入；
作为客户端Connecor线程，负责注册监听连接操作位，用于判断异步连接结果；
作为IO线程，监听网络读操作位，负责从SocketChannel中读取报文；
作为IO线程，负责向SocketChannel写入报文发送给对方，如果发生写半包，会自动注册监听写事件，用于后续继续发送半包数据，直到数据全部发送完成；
作为定时任务线程，可以执行定时任务，例如链路空闲检测和发送心跳消息等；
作为线程执行器可以执行普通的任务线程（Runnable）。



时间轮工作原理
管理和维护大量的timer调度


Netty 4的串行化设计










---
# Netty Essential
Bootstrap
    EventLoopGroup x1
ServerBootstrap
    EventLoopGroup x2
interface Channel
    ChannelPipeline
    ChannelConfig
    ServerChannel
    ChannelOutboundInvoker
    
ChannelHandler
    ChannelInboundHandler
    ChannelOutboundHandler
ChannelPipeline
EventLoop
ChannelFuture
    ChannelFutureFactory


## Transport type
OIO-在低连接数、需要低延迟时、阻塞时使用
NIO-在高连接数时使用
Local-在同一个JVM内通信时使用
Embedded-测试ChannelHandler时使用

## Buffer 
### ByteBuf
0 <= readerIndex <= writerIndex <= capacity
discardReadBytes() 复制清理   
索引 readerIndex ,writerIndex 
    clear()重置
slice()
ByteBufHolder

### 零拷贝
ByteBufAllocator.ioBuffer


### debug tool
ByteBufUtil
    hexDump()

## channel
channelRegistered->channelActive->channelInactive->channelUnregistered
### ChannelHandler
handlerAdded    当 ChannelHandler 添加到 ChannelPipeline 调用
handlerRemoved  当 ChannelHandler 从 ChannelPipeline 移除时调用
exceptionCaught 当 ChannelPipeline 执行发生错误时调用
    ChannelInboundHandler
        channelRegistered 
        channelUnregistere
        channelActive  
        channelInactive 
        channelReadComplete
        channelRead
        channelWritabilityChanged
        userEventTriggered
    ChannelOutboundHandler
        bind    
        connect 
        disconne
        close   
        deregist
        read    
        flush   
        write

### resource manage
ResourceLeakDetector
    Disables
    SIMPLE  
    ADVANCED
    PARANOID
io.netty.leakDetectionLevel



## ChannelPipeline
addFirst addBefore addAfter addLast 
Remove  
Replace

get(...)    
context(...)    
names() iterator()

fireChannelRegistered

##ChannelHandlerContext

# codec
## Decoder

ReferenceCountUtil.release(message) 
ReferenceCountUtil.retain(message)


ReplayingDecoder
自动检测缓冲区是否有足够的字节


public class CombinedChannelDuplexHandler<I extends ChannelInboundHandler,O extends ChannelOutboundHandler>
这提供了一个容器,单独的解码器和编码器类合作而无需直接扩展抽象的编解码器类。

---
#XMPP
[XMPP协议学习笔记](http://topmanopensource.iteye.com/blog/1607638)




---
#SSL/TLS
SslHandler







