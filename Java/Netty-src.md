#netty源码学习
----
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
