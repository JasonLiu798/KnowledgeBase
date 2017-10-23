


#JAVA NIO之浅谈内存映射文件原理与DirectMemory
JAVA类库中的NIO包相对于IO 包来说有一个新功能是内存映射文件，日常编程中并不是经常用到，但是在处理大文件时是比较理想的提高效率的手段。本文我主要想结合操作系统中（OS）相关方面的知识介绍一下原理。
   在传统的文件IO操作中，我们都是调用操作系统提供的底层标准IO系统调用函数  read()、write() ，此时调用此函数的进程（在JAVA中即java进程）由当前的用户态切换到内核态，然后OS的内核代码负责将相应的文件数据读取到内核的IO缓冲区，然 后再把数据从内核IO缓冲区拷贝到进程的私有地址空间中去，这样便完成了一次IO操作。至于为什么要多此一举搞一个内核IO缓冲区把原本只需一次拷贝数据 的事情搞成需要2次数据拷贝呢？ 我想学过操作系统或者计算机系统结构的人都知道，这么做是为了减少磁盘的IO操作，为了提高性能而考虑的，因为我们的程序访问一般都带有局部性，也就是所 谓的局部性原理，在这里主要是指的空间局部性，即我们访问了文件的某一段数据，那么接下去很可能还会访问接下去的一段数据，由于磁盘IO操作的速度比直接 访问内存慢了好几个数量级，所以OS根据局部性原理会在一次 read()系统调用过程中预读更多的文件数据缓存在内核IO缓冲区中，当继续访问的文件数据在缓冲区中时便直接拷贝数据到进程私有空间，避免了再次的低 效率磁盘IO操作。在JAVA中当我们采用IO包下的文件操作流，如：  
FileInputStream in = new FileInputStream("D:\\java.txt");  
in.read();  
JAVA虚拟机内部便会调用OS底层的 read()系统调用完成操作，如上所述，在第二次调用 in.read()的时候可能就是从内核缓冲区直接返回数据了（可能还有经过 native堆做一次中转，因为这些函数都被声明为 native，即本地平台相关，所以可能在C代码中有做一次中转，如 win32中是通过 C代码从OS读取数据，然后再传给JVM内存）。既然如此，JAVA的IO包中为啥还要提供一个 BufferedInputStream 类来作为缓冲区呢。关键在于四个字，"系统调用"！当读取OS内核缓冲区数据的时候，便发起了一次系统调用操作（通过native的C函数调用），而系统 调用的代价相对来说是比较高的，涉及到进程用户态和内核态的上下文切换等一系列操作，所以我们经常采用如下的包装：
FileInputStream in = new FileInputStream("D:\\java.txt");   
BufferedInputStream buf_in = new BufferedInputStream(in);  
buf_in.read();
这样一来，我们每一次 buf_in.read() 时候，BufferedInputStream 会根据情况自动为我们预读更多的字节数据到它自己维护的一个内部字节数组缓冲区中，这样我们便可以减少系统调用次数，从而达到其缓冲区的目的。所以要明确 的一点是 BufferedInputStream 的作用不是减少 磁盘IO操作次数（这个OS已经帮我们做了），而是通过减少系统调用次数来提高性能的。同理 BufferedOuputStream , BufferedReader/Writer 也是一样的。在 C语言的函数库中也有类似的实现，如 fread()，这个函数就是 C语言中的缓冲IO，作用与BufferedInputStream()相同.
这里简单的引用下JDK6 中 BufferedInputStream 的源码验证下：
```
public  
class BufferedInputStream extends FilterInputStream {  
  
    private static int defaultBufferSize = 8192;  
  
    /** 
     * The internal buffer array where the data is stored. When necessary, 
     * it may be replaced by another array of 
     * a different size. 
     */  
    protected volatile byte buf[];  
  /** 
     * The index one greater than the index of the last valid byte in  
     * the buffer.  
     * This value is always 
     * in the range <code>0</code> through <code>buf.length</code>; 
     * elements <code>buf[0]</code>  through <code>buf[count-1] 
     * </code>contain buffered input data obtained 
     * from the underlying  input stream. 
     */  
    protected int count;  
  
    /** 
     * The current position in the buffer. This is the index of the next  
     * character to be read from the <code>buf</code> array.  
     * <p> 
     * This value is always in the range <code>0</code> 
     * through <code>count</code>. If it is less 
     * than <code>count</code>, then  <code>buf[pos]</code> 
     * is the next byte to be supplied as input; 
     * if it is equal to <code>count</code>, then 
     * the  next <code>read</code> or <code>skip</code> 
     * operation will require more bytes to be 
     * read from the contained  input stream. 
     * 
     * @see     java.io.BufferedInputStream#buf 
     */  
    protected int pos;  
  
 /* 这里省略去 N 多代码 ------>>  */  
  
  /** 
     * See 
     * the general contract of the <code>read</code> 
     * method of <code>InputStream</code>. 
     * 
     * @return     the next byte of data, or <code>-1</code> if the end of the 
     *             stream is reached. 
     * @exception  IOException  if this input stream has been closed by 
     *              invoking its {@link #close()} method, 
     *              or an I/O error occurs.  
     * @see        java.io.FilterInputStream#in 
     */  
    public synchronized int read() throws IOException {  
    if (pos >= count) {  
        fill();  
        if (pos >= count)  
        return -1;  
    }  
    return getBufIfOpen()[pos++] & 0xff;  
    }  
```

   我们可以看到，BufferedInputStream 内部维护着一个 字节数组 byte[] buf 来实现缓冲区的功能，我们调用的  buf_in.read() 方法在返回数据之前有做一个 if 判断，如果 buf 数组的当前索引不在有效的索引范围之内，即 if 条件成立， buf 字段维护的缓冲区已经不够了，这时候会调用 内部的 fill() 方法进行填充，而fill()会预读更多的数据到 buf 数组缓冲区中去，然后再返回当前字节数据，如果 if 条件不成立便直接从 buf缓冲区数组返回数据了。其中getBufIfOpen()返回的就是 buf字段的引用。顺便说下，源码中的 buf 字段声明为  protected volatile byte buf[];  主要是为了通过 volatile 关键字保证 buf数组在多线程并发环境中的内存可见性.
   和 JAVA NIO 的内存映射无关的部分说了这么多篇幅，主要是为了做个铺垫，这样才能建立起一个知识体系，以便更好的理解内存映射文件的优点。
   内存映射文件和之前说的 标准IO操作最大的不同之处就在于它虽然最终也是要从磁盘读取数据，但是它并不需要将数据读取到OS内核缓冲区，而是直接将进程的用户私有地址空间中的一 部分区域与文件对象建立起映射关系，就好像直接从内存中读、写文件一样，速度当然快了。为了说清楚这个，我们以 Linux操作系统为例子，看下图：
   
   此图为 Linux 2.X 中的进程虚拟存储器，即进程的虚拟地址空间，如果你的机子是 32 位，那么就有  2^32 = 4G的虚拟地址空间，我们可以看到图中有一块区域： “Memory mapped region for shared libraries” ，这段区域就是在内存映射文件的时候将某一段的虚拟地址和文件对象的某一部分建立起映射关系，此时并没有拷贝数据到内存中去，而是当进程代码第一次引用这 段代码内的虚拟地址时，触发了缺页异常，这时候OS根据映射关系直接将文件的相关部分数据拷贝到进程的用户私有空间中去，当有操作第N页数据的时候重复这 样的OS页面调度程序操作。注意啦，原来内存映射文件的效率比标准IO高的重要原因就是因为少了把数据拷贝到OS内核缓冲区这一步（可能还少了 native堆中转这一步）。
   java中提供了3种内存映射模式，即：只读(readonly)、读写(read_write)、专用(private) ，对于  只读模式来说，如果程序试图进行写操作，则会抛出ReadOnlyBufferException异 常；第二种的读写模式表明了通过内存映射文件的方式写或修改文件内容的话是会立刻反映到磁盘文件中去的，别的进程如果共享了同一个映射文件，那么也会立即 看到变化！而不是像标准IO那样每个进程有各自的内核缓冲区，比如JAVA代码中，没有执行 IO输出流的 flush() 或者  close() 操作，那么对文件的修改不会更新到磁盘去，除非进程运行结束；最后一种专用模式采用的是OS的“写时拷贝”原则，即在没有发生写操作的情况下，多个进程之 间都是共享文件的同一块物理内存（进程各自的虚拟地址指向同一片物理地址），一旦某个进程进行写操作，那么将会把受影响的文件数据单独拷贝一份到进程的私 有缓冲区中，不会反映到物理文件中去。
 
   在JAVA NIO中可以很容易的创建一块内存映射区域，代码如下：




```java
File file = new File("E:\\download\\office2007pro.chs.ISO");  
FileInputStream in = new FileInputStream(file);  
FileChannel channel = in.getChannel();  
MappedByteBuffer buff = channel.map(FileChannel.MapMode.READ_ONLY, 0,channel.size());  
```

这里创建了一个只读模式的内存映射文件区域，接下来我就来测试下与普通NIO中的通道操作相比性能上的优势，先看如下代码：
```java
public class IOTest {  
    static final int BUFFER_SIZE = 1024;  
  
    public static void main(String[] args) throws Exception {  
  
        File file = new File("F:\\aa.pdf");  
        FileInputStream in = new FileInputStream(file);  
        FileChannel channel = in.getChannel();  
        MappedByteBuffer buff = channel.map(FileChannel.MapMode.READ_ONLY, 0,  
                channel.size());  
  
        byte[] b = new byte[1024];  
        int len = (int) file.length();  
  
        long begin = System.currentTimeMillis();  
  
        for (int offset = 0; offset < len; offset += 1024) {  
  
            if (len - offset > BUFFER_SIZE) {  
                buff.get(b);  
            } else {  
                buff.get(new byte[len - offset]);  
            }  
        }  
  
        long end = System.currentTimeMillis();  
        System.out.println("time is:" + (end - begin));  
  
    }  
}
```
输出为 63，即通过内存映射文件的方式读取 86M多的文件只需要78毫秒，我现在改为普通NIO的通道操作看下：

```java
File file = new File("F:\\liq.pdf");  
FileInputStream in = new FileInputStream(file);  
FileChannel channel = in.getChannel();  
ByteBuffer buff = ByteBuffer.allocate(1024);   
  
long begin = System.currentTimeMillis();  
while (channel.read(buff) != -1) {  
    buff.flip();  
    buff.clear();  
}  
long end = System.currentTimeMillis();  
System.out.println("time is:" + (end - begin));  
```
输出为 468毫秒，几乎是 6 倍的差距，文件越大，差距便越大。所以内存映射文件特别适合于对大文件的操作，JAVA中的限制是最大不得超过 Integer.MAX_VALUE，即2G左右，不过我们可以通过分次映射文件(channel.map)的不同部分来达到操作整个文件的目的。

按照jdk文档的官方说法，内存映射文件属于JVM中的直接缓冲区，还可以通过 ByteBuffer.allocateDirect() ，即DirectMemory的方式来创建直接缓冲区。
他们相比基础的 IO操作来说就是少了中间缓冲区的数据拷贝开销。同时他们属于JVM堆外内存，不受JVM堆内存大小的限制。
 
其中 DirectMemory 默认的大小是等同于JVM最大堆，理论上说受限于 进程的虚拟地址空间大小，比如32位的windows上，每个进程有4G的虚拟空间除去 2G为OS内核保留外，再减去 JVM堆的最大值，剩余的才是DirectMemory大小。通过 设置 JVM参数 -Xmx64M，即JVM最大堆为64M，然后执行以下程序可以证明DirectMemory不受JVM堆大小控制：
```java
public static void main(String[] args) {       
	ByteBuffer.allocateDirect(1024*1024*100); // 100MB  
}  
```
我们设置了JVM堆 64M限制，然后在直接内存上分配了 100MB空间，程序执行后直接报错：Exception in thread "main" java.lang.OutOfMemoryError: Direct buffer memory。
接着我设置 -Xmx200M，程序正常结束。
然后我修改配置： -Xmx64M  -XX:MaxDirectMemorySize=200M，程序正常结束。

###DirectMemory大小 结论
直接内存DirectMemory的大小默认为 -Xmx 的JVM堆的最大值，但是并不受其限制，而是由JVM参数 MaxDirectMemorySize单独控制。

接下来我们来证明直接内存不是分配在JVM堆中。
我们先执行以下程序，并设置 JVM参数 -XX:+PrintGC， 
public static void main(String[] args) {         
	for(int i=0;i<20000;i++) {  
		ByteBuffer.allocateDirect(1024*100);  //100K  
	}  
}
输出结果如下：
     [GC 1371K->1328K(61312K), 0.0070033 secs]
     [Full GC 1328K->1297K(61312K), 0.0329592 secs]
     [GC 3029K->2481K(61312K), 0.0037401 secs]
     [Full GC 2481K->2435K(61312K), 0.0102255 secs]
我们看到这里执行 GC的次数较少，但是触发了 两次 Full GC，原因在于直接内存不受 GC(新生代的Minor GC)影响，只有当执行老年代的 Full GC时候才会顺便回收直接内存！
而直接内存是通过存储在JVM堆中的DirectByteBuffer对象来引用的，所以当众多的 DirectByteBuffer对象从新生代被送入老年代后才触发了 full gc。
 
再看直接在JVM堆上分配内存区域的情况：
```java
public static void main(String[] args) {         
	for(int i=0;i<10000;i++) {
		ByteBuffer.allocate(1024*100);  //100K

	}
}
```

ByteBuffer.allocate 意味着直接在 JVM堆上分配内存，所以受 新生代的 Minor GC影响，输出如下：
```
        [GC 16023K->224K(61312K), 0.0012432 secs]
        [GC 16211K->192K(77376K), 0.0006917 secs]
        [GC 32242K->176K(77376K), 0.0010613 secs]
        [GC 32225K->224K(109504K), 0.0005539 secs]
        [GC 64423K->192K(109504K), 0.0006151 secs]
        [GC 64376K->192K(171392K), 0.0004968 secs]
        [GC 128646K->204K(171392K), 0.0007423 secs]
        [GC 128646K->204K(299968K), 0.0002067 secs]
        [GC 257190K->204K(299968K), 0.0003862 secs]
        [GC 257193K->204K(287680K), 0.0001718 secs]
        [GC 245103K->204K(276480K), 0.0001994 secs]
        [GC 233662K->204K(265344K), 0.0001828 secs]
        [GC 222782K->172K(255232K), 0.0001998 secs]
        [GC 212374K->172K(245120K), 0.0002217 secs]
```
可以看到，由于直接在 JVM堆上分配内存，所以触发了多次GC，且不会触及  Full GC，因为对象根本没机会进入老年代。
 
我想提个疑问，NIO中的DirectMemory和内存文件映射同属于直接缓冲区，但是前者和 -Xmx和-XX:MaxDirectMemorySize有关，而后者完全没有JVM参数可以影响和控制，这让我不禁怀疑两者的直接缓冲区是否相同，
前者指的是 JAVA进程中的 native堆，即涉及底层平台如 win32的dll 部分，因为 C语言中的 malloc()分配的内存就属于 native堆，不属于 JVM堆，这也是DirectMemory能在一些场景中显著提高性能的原因，因为它避免了在 native堆和jvm堆之间数据的来回复制；
而后者则是没有经过native堆，是由JAVA进程直接建立起某一段虚拟地址空间和文件对象的关联映射关系，参见Linux虚拟存储器图中的 “Memory mapped region for shared libraries”区域，所以内存映射文件的区域并不在JVMGC的回收范围内，因为它本身就不属于堆区，卸载这部分区域只能通过系统调用 unmap()来实现 (Linux)中，而 JAVA API 只提供了FileChannel.map 的形式创建内存映射区域，却没有提供对应的 unmap()，让人十分费解，导致要卸载这部分区域比较麻烦。
 
最后再试试通过 DirectMemory来操作前面内存映射和基本通道操作的例子，来看看直接内存操作的话，程序的性能如何：
```java
File file = new File("F:\\liq.pdf");  
FileInputStream in = new FileInputStream(file);  
FileChannel channel = in.getChannel();  
ByteBuffer buff = ByteBuffer.allocateDirect(1024);   
  
long begin = System.currentTimeMillis();  
while (channel.read(buff) != -1) {  
    buff.flip();  
    buff.clear();  
}  
long end = System.currentTimeMillis();  
System.out.println("time is:" + (end - begin));  
```
程序输出为312毫秒，看来比普通的NIO通道操作（468毫秒）来的快，但是比mmap 内存映射的63秒差距太多了，我想应该不至于吧，通过修改
ByteBuffer buff = ByteBuffer.allocateDirect(1024);  
为
ByteBuffer buff = ByteBuffer.allocateDirect((int)file.length())
即一次性分配整个文件长度大小的堆外内存，最终输出为78毫秒，由此可以得出两个结论
1.堆外内存的分配耗时比较大
2.还是比mmap内存映射来得慢，都不要说通过mmap读取数据的时候还涉及缺页异常、页面调度的系统调用了，看来内存映射文件确实NB啊，这还只是 86M的文件，如果上 G 的大小呢？

最后一点为 DirectMemory的内存只有在 JVM执行 full gc 的时候才会被回收，那么如果在其上分配过大的内存空间，那么也将出现 OutofMemoryError，即便 JVM 堆中的很多内存处于空闲状态。

本来只想写点内存映射部分，但是写着写着涉及进来的知识多了点，边界不好把控啊
尼玛，都是3月8号凌晨快2点了，不过想想总比以前玩拳皇游戏熬夜来的好吧，写完收工，赶紧睡觉去。。。
  
我想补充下额外的一个知识点，关于 JVM堆大小的设置是不受限于物理内存，而是受限于虚拟内存空间大小，理论上来说是进程的虚拟地址空间大小，但是实际上我们的虚拟内存空间是有限制的，一般windows上默认在C盘，大小为物理内存的2倍左右。
我做了个实验：我机子是64位的win7，那么理论上说进程虚拟空间是几乎无限大，物理内存为4G，而我设置 -Xms5000M， 即在启动JAVA程序的时候一次性申请到超过物理内存大小的5000M内存，程序正常启动，而当我加到-Xms8000M的时候就报OOM错误了，然后我修改增加 win7的虚拟内存，程序又正常启动了，说明 -Xms 受限于虚拟内存的大小。
我设置-Xms5000M，即超过了4G物理内存，并在一个死循环中不断创建对象，并保证不会被GC回收。程序运行一会后整个电脑 几乎死机状态，即卡住了，反映很慢很慢，推测是发生了系统颠簸，即频繁的页面调度置换导致，说明 -Xms -Xmx不是局限于物理内存的大小，而是综合虚拟内存了，JVM会根据电脑虚拟内存的设置来控制。










