#nio
---
#docs
[在 Java 7 中体会 NIO.2 异步执行的快乐](http://www.ibm.com/developerworks/cn/java/j-lo-nio2/)

---
#BIO
```
client1--->acceptor-->new thread1
client2--->        -->new thread2
client3--->        -->new thread3
```
* 服务端线程数：客户端数量=1:1
* 阻塞I/O
* 可靠性：非常差
* 吞吐量：低
* 调试难度：低
* API难度：简单

##伪异步IO|池化BIO
* 使用线程池
* 客户端 : 线程数量=M:N
* 阻塞I/O
* 同步I/O
M可以远大于N
* 弊端
    - read()直到 数据传输可用/检测到文件尾/发生异常 之前会阻塞
    - write()直到 数据完全写完 之前会阻塞
    - 因此，阻塞IO无法解决通信线程阻塞问题
* 可靠性：差
* 吞吐量：中
* 调试难度：中
* API难度：简单

##nio，非阻塞IO
* 客户端:IO线程数=M:1
* Non-block I/O
* 同步I/O
* 可靠性：高
* 吞吐量：高
* 调试难度：复杂
* API难度：非常复杂

##aio
* 客户端:IO线程数=M:0(不需要额外线程，被动回调)
* Non-block I/O
* 异步I/O
* 可靠性：高
* 吞吐量：高
* 调试难度：复杂
* API难度：复杂


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

* flip
```java
public final Buffer flip() {
    limit = position;
    position = 0;
    mark = -1;
    return this;
}
```
读取之前写入的内容，w->r,pos=0
反转缓冲区。首先将限制设置为当前位置，然后将位置设置为 0
如果已定义了标记，则丢弃该标记。
常与compact方法一起使用。通常情况下，在准备从缓冲区中读取数据时调用flip方法。

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
```
public final Buffer rewind() {
    position = 0;
    mark = -1;
    return this;
}
```
pos=0,limit保持不变，数据重写入Buffer前调用

* clear
```
public final Buffer clear(){
    position = 0; //重置当前读写位置
    limit = capacity; 
    mark = -1;  //取消标记
    return this;
}
```
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

* compareTo 
    比较两个Buffer的剩余元素         
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
非阻塞模式下，write()方法在尚未写出任何内容时可能就返回了。所以需要在循环中调用write()

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


##最佳实践
Reactor线程数量：核心数，核心数的两倍
DirectBufferPool使用
Reactor线程与异步线程池的合理使用
```
client-->mainReactor->acceptor-->subReactor->read,decode,compute,encode,send
                                           ->read,decode,compute,encode,send
                              -->subReactor->read,decode,compute,encode,send
                                            ...

```



---
# lib 相关库
[common-vfs](http://commons.apache.org/proper/commons-vfs/)













