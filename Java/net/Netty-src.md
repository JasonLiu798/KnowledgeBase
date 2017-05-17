#netty源码学习
----
[Netty5 Read事件处理过程_源码讲解](http://www.open-open.com/lib/view/open1433299979104.html)

----------
#数据流

ServerBootstrap bind
    AbstractBootstrap bind
    AbstractBootstrap doBind
    AbstractBootstrap doBind0
        eventLoop. new runnable
            AbstractChannel bind
                DefaultChannelPipeline bind
                    AbstractChannelHandlerContext tail.bind
                    AbstractChannelHandlerContext invokeBind
                        ChannelOutboundHandler bind



Bootstrap connect->doConnect->doConnect0
    eventLoop. new runnable
        Channel connect
            DefaultChannelPipeline connect
                AbstractChannelHandlerContext tail.connect -> invokeConnect














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
    Chunk(16 page,16x4=64byte)
        Page(4byte)
```
                64
       |                  |
      32                  32
   |         |        |        |
  16        16       16       16
 |   |    |   |    |   |    |   |
 8   8    8   8    8   8    8   8
| | | |  | | | |  | | | |  | | | | 
4 4 4 4  4 4 4 4  4 4 4 4  4 4 4 4
```

PoolSubpage
一个page只能用于分配与第一次申请时，大小相同的内存
bitmap 用于记录区域占用情况   


##PooledDirectByteBuf
新实例从内存池获取，引用计数值设为1，设置缓冲区最大容量后返回


----
#ByteBuf辅助类
##ByteBufHolder
ByteBuf容器

##ByteBufAllocator
字节缓冲区分配器
[I]ByteBufAllocator
    AbstractByteBufAllocator
        PooledByteBufAllocator
        UnpooledByteBufAllocator

零拷贝
ByteBufAllocator.ioBuffer


##CompositeByteBuf
将多个ByteBuf实例组装到一起，形成统一视图

##ByteBufUtil
###debug tool
ByteBufUtil
    hexDump()



----
#Channel
接口层，Facade模式统一封装
定义尽量大而全
具体实现采用聚合而非包含

##AbstractChannel源码分析
AbstractNioByteChannel
```java
    @Override
    protected void doWrite(ChannelOutboundBuffer in) throws Exception {
        int writeSpinCount = -1;
        boolean setOpWrite = false;//写半包标识
        for (;;) {
            Object msg = in.current();
            if (msg == null) {
                // Wrote all messages.
                clearOpWrite();
                // Directly return here so incompleteWrite(...) is not called.
                return;
            }
            if (msg instanceof ByteBuf) {
                ByteBuf buf = (ByteBuf) msg;
                int readableBytes = buf.readableBytes();
                if (readableBytes == 0) {
                    in.remove();
                    continue;
                }
                boolean done = false;//是否结束
                long flushedAmount = 0;//发送的总消息字节数
                //writeSpinCount 循环发送次数
                if (writeSpinCount == -1) {
                    writeSpinCount = config().getWriteSpinCount();
                }
                for (int i = writeSpinCount - 1; i >= 0; i --) {
                    int localFlushedAmount = doWriteBytes(buf);
                    if (localFlushedAmount == 0) {//TCP缓冲区已满
                        setOpWrite = true;//空循环提前退出
                        break;
                    }
                    flushedAmount += localFlushedAmount;
                    if (!buf.isReadable()) {
                        done = true;
                        break;
                    }
                }
                in.progress(flushedAmount);
                if (done) {
                    in.remove();
                } else {
                    // Break the loop and so incompleteWrite(...) is called.
                    break;
                }
            }
            //else 处理文件...
        }
        incompleteWrite(setOpWrite);//处理半包
    }
```

##AbstractNioMessageChannel
```


```

##NioSocketChannel
connect
```java
protected boolean doConnect(SocketAddress remoteAddress, SocketAddress localAddress) throws Exception {
        if (localAddress != null) {
            javaChannel().socket().bind(localAddress);
        }

        boolean success = false;
        try {
            boolean connected = javaChannel().connect(remoteAddress);
            if (!connected) {
                selectionKey().interestOps(SelectionKey.OP_CONNECT);
            }
            success = true;
            return connected;
        } finally {
            if (!success) {
                doClose();
            }
        }
    }
    //1.连接成功，返回true
    //2.暂时没有连接上，服务器无ack，不确定，返回false
    //3.连接失败，抛出异常
```
doWrite
```java
protected void doWrite(ChannelOutboundBuffer in) throws Exception {
        for (;;) {
            int size = in.size();
            if (size == 0) {
                // All written so clear OP_WRITE
                clearOpWrite();
                break;
            }
            long writtenBytes = 0;
            boolean done = false;
            boolean setOpWrite = false;

            // Ensure the pending writes are made of ByteBufs only.
            ByteBuffer[] nioBuffers = in.nioBuffers();
            int nioBufferCnt = in.nioBufferCount();//需要发送的ByteBuffer数组个数
            long expectedWrittenBytes = in.nioBufferSize();//需要发送的总字节数
            SocketChannel ch = javaChannel();

            // Always us nioBuffers() to workaround data-corruption.
            // See https://github.com/netty/netty/issues/2761
            switch (nioBufferCnt) {
                case 0:
                    // We have something else beside ByteBuffers to write so fallback to normal writes.
                    super.doWrite(in);
                    return;
                case 1:
                    // Only one ByteBuf so use non-gathering write
                    ByteBuffer nioBuffer = nioBuffers[0];
                    //对selector轮询写操作次数进行上限控制，如果TCP缓冲区满，TCP处于Keep-alive状态，消息无法发送出去，停留在此状态，reactor线程无法处理读取其他消息和执行排队task
                    for (int i = config().getWriteSpinCount() - 1; i >= 0; i --) {
                        final int localWrittenBytes = ch.write(nioBuffer);
                        if (localWrittenBytes == 0) {//TCP缓冲区可能满，无法再次写进去
                            setOpWrite = true;//设置半包标记为true
                            break;
                        }
                        expectedWrittenBytes -= localWrittenBytes;//发送字节总数 - 已发送字节
                        writtenBytes += localWrittenBytes;//发送字节总数 + 已发送字节数
                        if (expectedWrittenBytes == 0) {
                            done = true;//设置发送完标记
                            break;
                        }
                    }
                    break;
                default:
                    for (int i = config().getWriteSpinCount() - 1; i >= 0; i --) {
                        final long localWrittenBytes = ch.write(nioBuffers, 0, nioBufferCnt);//参数(要发是的ByteBuffer，数组偏移量，ByteBuffer个数)
                        if (localWrittenBytes == 0) {
                            setOpWrite = true;//设置半包标记为true
                            break;
                        }
                        expectedWrittenBytes -= localWrittenBytes;
                        writtenBytes += localWrittenBytes;
                        if (expectedWrittenBytes == 0) {
                            done = true;
                            break;
                        }
                    }
                    break;
            }

            // Release the fully written buffers, and update the indexes of the partially written buffer.
            in.removeBytes(writtenBytes);

            if (!done) {
                // Did not write all buffers completely.
                incompleteWrite(setOpWrite);
                break;
            }
        }
    }
```

```java
//AbstractNioByteChannel
    /**
     * 处理半包
     * @param setOpWrite
     */
    protected final void incompleteWrite(boolean setOpWrite) {
        // Did not write completely.
        if (setOpWrite) {
            setOpWrite();
        } else {
            // Schedule flush again later so other tasks can be picked up in the meantime
            Runnable flushTask = this.flushTask;
            if (flushTask == null) {
                flushTask = this.flushTask = new Runnable() {
                    @Override
                    public void run() {
                        flush();
                    }
                };
            }
            eventLoop().execute(flushTask);
        }
    }
```
###doReadBytes
```java
    protected int doReadBytes(ByteBuf byteBuf) throws Exception {
        final RecvByteBufAllocator.Handle allocHandle = unsafe().recvBufAllocHandle();
        allocHandle.attemptedBytesRead(byteBuf.writableBytes());
        return byteBuf.writeBytes(javaChannel(), allocHandle.attemptedBytesRead());
    }
```


##NioServerSocketChannel
private static final ChannelMetadata METADATA = new ChannelMetadata(false);

doConnect


doReadMessages




##Unsafe
register


write,消息发送到环形数组
flush，缓冲区消息全部写入channel，并发送给通信对方


##AbstractNioUnsafe












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




---
#ChannelPipeline 
addFirst addBefore addAfter addLast 
Remove  
Replace

get(...)    
context(...)    
names() iterator()

fireChannelRegistered



##ChannelPipeline的inbound事件

##ChannelPipeline的outbound事件

##ChannelHandlerAdapter


##ChannelHandlerContext

#codec
## Decoder

ReferenceCountUtil.release(message) 
ReferenceCountUtil.retain(message)


ReplayingDecoder
自动检测缓冲区是否有足够的字节


public class CombinedChannelDuplexHandler<I extends ChannelInboundHandler,O extends ChannelOutboundHandler>
这提供了一个容器,单独的解码器和编码器类合作而无需直接扩展抽象的编解码器类。














---
#EventLoop EventLoopGroup
##NioEventLoop
```java

    protected void run() {
        for (;;) {
            boolean oldWakenUp = wakenUp.getAndSet(false);
            try {
                if (hasTasks()) {
                    selectNow();
                } else {
                    select(oldWakenUp);
                     if (wakenUp.get()) {
                        selector.wakeup();
                    }
                }

                cancelledKeys = 0;
                needsToSelectAgain = false;
                final int ioRatio = this.ioRatio;
                if (ioRatio == 100) {
                    processSelectedKeys();
                    runAllTasks();
                } else {
                    final long ioStartTime = System.nanoTime();
                    processSelectedKeys();
                    final long ioTime = System.nanoTime() - ioStartTime;
                    runAllTasks(ioTime * (100 - ioRatio) / ioRatio);
                }

                if (isShuttingDown()) {
                    closeAll();
                    if (confirmShutdown()) {
                        break;
                    }
                }
            } catch (Throwable t) {
                logger.warn("Unexpected exception in the selector loop.", t);

                // Prevent possible consecutive immediate failures that lead to
                // excessive CPU consumption.
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    // Ignore.
                }
            }
        }
    }


    private void select(boolean oldWakenUp) throws IOException {
        Selector selector = this.selector;
        try {
            int selectCnt = 0;
            long currentTimeNanos = System.nanoTime();
            long selectDeadLineNanos = currentTimeNanos + delayNanos(currentTimeNanos);
            for (;;) {
                long timeoutMillis = (selectDeadLineNanos - currentTimeNanos + 500000L) / 1000000L;
                if (timeoutMillis <= 0) {
                    if (selectCnt == 0) {
                        selector.selectNow();
                        selectCnt = 1;
                    }
                    break;
                }

                int selectedKeys = selector.select(timeoutMillis);
                selectCnt ++;

                if (selectedKeys != 0 || oldWakenUp || wakenUp.get() || hasTasks() || hasScheduledTasks()) {
                    // - Selected something,
                    // - waken up by user, or
                    // - the task queue has a pending task.
                    // - a scheduled task is ready for processing
                    break;
                }
                if (Thread.interrupted()) {
                    // Thread was interrupted so reset selected keys and break so we not run into a busy loop.
                    // As this is most likely a bug in the handler of the user or it's client library we will
                    // also log it.
                    //
                    // See https://github.com/netty/netty/issues/2426
                    if (logger.isDebugEnabled()) {
                        logger.debug("Selector.select() returned prematurely because " +
                                "Thread.currentThread().interrupt() was called. Use " +
                                "NioEventLoop.shutdownGracefully() to shutdown the NioEventLoop.");
                    }
                    selectCnt = 1;
                    break;
                }

                long time = System.nanoTime();
                if (time - TimeUnit.MILLISECONDS.toNanos(timeoutMillis) >= currentTimeNanos) {
                    // timeoutMillis elapsed without anything selected.
                    selectCnt = 1;
                } else if (SELECTOR_AUTO_REBUILD_THRESHOLD > 0 &&
                        selectCnt >= SELECTOR_AUTO_REBUILD_THRESHOLD) {
                    // The selector returned prematurely many times in a row.
                    // Rebuild the selector to work around the problem.
                    logger.warn(
                            "Selector.select() returned prematurely {} times in a row; rebuilding selector.",
                            selectCnt);

                    rebuildSelector();
                    selector = this.selector;

                    // Select again to populate selectedKeys.
                    selector.selectNow();
                    selectCnt = 1;
                    break;
                }
                currentTimeNanos = time;
            }

            if (selectCnt > MIN_PREMATURE_SELECTOR_RETURNS) {
                if (logger.isDebugEnabled()) {
                    logger.debug("Selector.select() returned prematurely {} times in a row.", selectCnt - 1);
                }
            }
        } catch (CancelledKeyException e) {
            if (logger.isDebugEnabled()) {
                logger.debug(CancelledKeyException.class.getSimpleName() + " raised by a Selector - JDK bug?", e);
            }
            // Harmless exception - log anyway
        }
    }
```



































