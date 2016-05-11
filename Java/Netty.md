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
#API
```java
public void bind(int port) throws Exception {
    /**
     * EventLoopGroup
     * 线程池，包含一组nio线程，专门用于处理网络事件，即Reactor线程组
     * 一个处理服务端接收客户端连接
     * 一个用于进行SocketChannel网络读写
     */
    EventLoopGroup bossGroup = new NioEventLoopGroup();
    EventLoopGroup workerGroup = new NioEventLoopGroup();
    try {
        ServerBootstrap b = new ServerBootstrap();//用于启动NIO服务端的辅助启动类
        b.group(bossGroup, workerGroup)//
                .channel(NioServerSocketChannel.class)//创建channel
                .option(ChannelOption.SO_BACKLOG, 1024)//配置channel
                .childHandler(new ChildChannelHandler());
        // 绑定端口，同步等待成功
        ChannelFuture f = b.bind(port).sync();
        // 等待服务端监听端口关闭
        f.channel().closeFuture().sync();
    } finally {
        // 优雅退出，释放线程池资源
        bossGroup.shutdownGracefully();
        workerGroup.shutdownGracefully();
    }
}
```
```java
public class TimeServerHandler extends ChannelHandlerAdapter {
    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg)
            throws Exception {
        ByteBuf buf = (ByteBuf) msg;
        byte[] req = new byte[buf.readableBytes()];
        buf.readBytes(req);
        String body = new String(req, "UTF-8");
        System.out.println("The time server receive order : " + body);
        String currentTime = "QUERY TIME ORDER".equalsIgnoreCase(body) ? new java.util.Date(
                System.currentTimeMillis()).toString() : "BAD ORDER";
        ByteBuf resp = Unpooled.copiedBuffer(currentTime.getBytes());
        ctx.write(resp);//并不直接写入SocketChannel，只把待发消息发送到缓冲数组中，再通过调用flush方法将发送缓冲区中的消息全部写到SocketChannel中
    }
    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exceptio{
        ctx.flush();
    }
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        ctx.close();
    }
}
```

#粘包/拆包
粘包：多个小包被封装成大数据包
拆包：大包被封装成多个数据包
* 原因
    - 应用进程缓冲区 写入 大于 套接口缓冲区
    - 进行MSS大小的TCP分段
    - 以太网帧的payload大于MTU进行IP分片
SO-SNDBUF
|
MSS大小的TCP分节，通常MSS<=MTU-40(IPv4)或MTU-60(IPv6)
|
MTU大小的IPv4或IPv6分组

##解决策略
* 消息定长
* 包尾增加回车换行符进行分割
* 消息分类头和体，头包含消息总长
* 更复杂的应用层协议

##netty
LineBasedFrameDecoder解决粘包问题
```java
private class ChildChannelHandler extends ChannelInitializer<SocketChannel> {
    @Override
    protected void initChannel(SocketChannel arg0) throws Exception {
        arg0.pipeline().addLast(new LineBasedFrameDecoder(1024));
        arg0.pipeline().addLast(new StringDecoder());
        arg0.pipeline().addLast(new TimeServerHandler());
    }
}
```


DelimiterBasedFrameDecoder
FixedLengthFrameDecoder




---
# 线程模型


## Reactor单线程模型
Reactor

## Rector多线程模型
与单线程模型最大的区别就是有一组NIO线程处理IO操作
1）专门一个NIO线程-Acceptor线程用于监听服务端，接收客户端的TCP连接请求；
2）网络IO操作-读、写等由一个NIO线程池负责，线程池可以采用标准的JDK线程池实现，它包含一个任务队列和N个可用的线程，由这些NIO线程负责消息的读取、解码、编码和发送；
3）1个NIO线程可以同时处理N条链路，但是1个链路只对应1个NIO线程，防止发生并发操作问题。

##主从多线程模型
服务端用于接收客户端连接的不再是个1个单独的NIO线程，而是一个独立的NIO线程池。
Acceptor接收到客户端TCP连接请求处理完成后（可能包含接入认证等），将新创建的SocketChannel注册到IO线程池（sub reactor线程池）的某个IO线程上，由它负责SocketChannel的读写和编解码工作。

##Netty线程模型
###服务端线程模型
服务端监听线程和IO线程分离
bossGroup线程组实际就是Acceptor线程池，负责处理客户端的TCP连接请求，如果系统只有一个服务端端口需要监听，则建议bossGroup线程组线程数设置为1
EventLoopGroup管理的线程数可以通过构造函数设置，没有设置，默认取-Dio.netty.eventLoopThreads，如果该系统参数也没有指定，则为可用的CPU内核数 × 2

![netty4线程模型](../img/netty4-thread.png)


###客户端线程模型



###NioEventLoop
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





----
#ByteBuf
##ByteBuffer
缺点
* 长度固定，不能动态扩展收缩
* 只有一个表示位置的指针position，读写需要手工调用flip()和rewind()等
* API功能有限

##ByteBuf readerIndex writerIndex 
0 <= readerIndex <= writerIndex <= capacity

|      readable                 |   writable bytes      |
0=readerIndex                N=writerIndex           capacity

* 读取M(<N)个字节后
| discardable  | readable       |   writable bytes      |
0             M=readerIndex    N=writerIndex         capacity

* discardReadBytes() 复制清理 ，调用后      
| readable     |   writable bytes                       |
0=readerIndex  N-M=writerIndex                       capacity

* clear()重置，调用后
|   writable bytes                                      |
0=readerIndex=writerIndex                            capacity

* mark
ByteBuffer的：
读操作回滚
mark=position
调用 reset 后，恢复当前位置为mark

ByteBuf的：
markReaderIndex
resetReaderInddex
markWriterIndex
resetWriterIndex

* 查找
indexOf
bytesBefore
forEachByte

* derived buffers
duplicate，浅拷贝，复制读写索引
copy，深拷贝
slice，可读子缓冲区

* 转成ByteBuffer
nioBuffer()

* 随机读写

---
#ByteBuf源码分析
HeapByteBuf
    内存分配回收快，需要额外内存复制
    适合后台消息编解码
DirectByteBuf
    堆外分配，使用速度快
    适合I/O通信线程的读下缓冲区

基于对象池
    维护复杂
普通

##AbstractByteBuf
readBytes
    getBytes
    readerIndex+=length;
writeBytes
    setBytes
    writerIndex+=length;
倍增或步进算法
较小的倍增，浪费空间小，倍增到较大数值后浪费空间较多

重用缓冲区
discardReadByte
    未读取的字节数组复制到缓冲区的起始位置
    setBytes(0,this,readerIndex,writerIndex-readerIndex)

##AbstractReferenceCountedByteBuf
对象引用计数器
retain
    自旋，refCnt+1

##UnpooledHeapByteBuf
基于堆内存分配字节缓冲区

##PooledByteBuf内存池原理
PoolArena
    Chunk
        Page



----

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







