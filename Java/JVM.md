#JVM
---
#doc
[编程语言与高级语言虚拟机杂谈](http://zhuanlan.zhihu.com/hllvm)
[IntelliJ IDEA设置JVM运行参数](http://blog.csdn.net/sdujava2011/article/details/50086933)

[ JCONSOLE的连接问题](http://blog.csdn.net/blade2001/article/details/7742574)
[内存模型barrier](http://ifeve.com/jmm-cookbook-mb/)
---
#theory
[栈式虚拟机和寄存器式虚拟机](http://www.zhihu.com/question/35777031)
[寄存器分配问题](http://www.zhihu.com/question/29355187)

[JVM系列三:JVM参数设置、分析](http://www.cnblogs.com/redcreen/archive/2011/05/04/2037057.html)


##procedure
编译
装载class
执行class

##memory
方法区，堆，方法栈，本地方法栈，PC寄存器



###分配
栈上
TLAB分配
堆上分配

###GC
分代回收
    新生代
        串行copying
        并行回收copying
        并行copying
    MinorGC出发机制及日志格式
    旧生代可用GC
        串行Mark-Sweep-Compact
        并行Compacting
        并发Mark-Sweep
    FullGC出发机制以及日志格式
G1

##class load



---
#tools
##jinfo
jinfo 33673|more
可以输出并修改运行时的java 进程的opts。 

##jps
与unix上的ps类似，用来显示本地的java进程，可以查看本地运行着几个java程序，并显示他们的进程号。 

##jps
-q only lvmid
-m parameter passed to main()
-l class full name
-v init parameter
jps -lv

##jconsole

##visualvm

##jmap
输出所有内存中对象的工具，甚至可以将VM 中的heap，以二进制输出成文本
jmap -dump:format=b,file=heap.bin <pid>

###jstat
监视VM内存工具。可以用来监视VM内存内的各种堆和非堆的大小及其内存使用量
```bash
jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]
```
* 常用选项
jstat -gccapacity 33673 1000 10
可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小，如：PGCMN显示的是最小perm的内存使用量，PGCMX显示的是perm的内存最大使用量，PGC是当前新生成的perm内存占用量，PC是但前perm内存占用量。其他的可以根据这个类推， OC是old内纯的占用量。

jstat -gcutil {pid} {interval} {count}
jstat -gcutil 529 1000 30
```
   S0: Survivor space 0 utilization as a percentage of the space's current capacity.

   S1: Survivor space 1 utilization as a percentage of the space's current capacity.

   E: Eden space utilization as a percentage of the space's current capacity.

   O: Old space utilization as a percentage of the space's current capacity.

   M: Metaspace utilization as a percentage of the space's current capacity.

   CCS: Compressed class space utilization as a percentage.

   YGC: Number of young generation GC events.

   YGCT: Young generation garbage collection time.

   FGC: Number of full GC events.

   FGCT: Full garbage collection time.

   GCT: Total garbage collection time.
```
jstat -class pid:显示加载class的数量，及所占空间等信息。 
jstat -compiler pid:显示VM实时编译的数量等信息。 
jstat -gc pid:可以显示gc的信息，查看gc的次数，及时间。其中最后五项，分别是young gc的次数，young gc的时间，full gc的次数，full gc的时间，gc的总时间。 
jstat -gccapacity:可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小，如：PGCMN显示的是最小perm的内存使用量，PGCMX显示的是perm的内存最大使用量，PGC是当前新生成的perm内存占用量，PC是但前perm内存占用量。其他的可以根据这个类推， OC是old内纯的占用量。 
jstat -gcnew pid:new对象的信息。 
jstat -gcnewcapacity pid:new对象的信息及其占用量。 
jstat -gcold pid:old对象的信息。 
jstat -gcoldcapacity pid:old对象的信息及其占用量。 
jstat -gcpermcapacity pid: perm对象的信息及其占用量。 
jstat -util pid:统计gc信息统计。 
jstat -printcompilation pid:当前VM执行的信息。 

##jhat

##MAT
mat: eclipse memory analyzer, 基于eclipse RCP的内存分析工具。
详细信息参见：http://www.eclipse.org/mat/
jhat：JDK自带的java heap analyze tool


##jstack
[jstack和线程dump分析](http://jameswxx.iteye.com/blog/1041173)
[Java自带的性能监测工具用法简介——jstack、jconsole、jinfo、jmap、jdb、jsta、jvisualvm](http://blog.csdn.net/feihong247/article/details/7874063)




###TDA



---
#GC
##Serial gc
扫描，复制均为单线程

minor gc
eden---(存活)---->To space(s0)
minor gc
To space(s1) From space(s0)

To space满

多次minro gc存活 ->old



##并行回收GC Parallel Scavenge
扫描，复制多线程
server级（CPU核数>2，内存>2G）默认GC方式
eden空间不够，对象大小等于enden space一半大小，直接在旧生代分配

##并行GC ParNew
必须配合旧生代使用CMS GC
CMS回收旧生代的时候有些过程为并发进行，此时发送Minor GC需要相应处理，并行回收GC 无此操作，因此ParNew不可以与并行的旧生代GC同时使用

##旧生代
* 串行GC
三色着色标记
遍历未标记，回收
滑动压缩（sliding compaction）

* 并行GC
Mark-Compact
划分并行region
三色着色标记
大部分情况下，左边region为活跃对象，压缩移动不值得，继续向右扫描到值得压缩移动的region，找到后 region左边作为高密度区dense prefix，这些区域不回收，继续向右扫描，压缩移动

* 并发GC CMS
free-list记录空闲
I.Initial Marking ，暂停应用
II.Concurrent Marking 
标记对象
Mod Union Table记录 Minor GC后修改的Card信息
浮动垃圾
III.final Marking (remark)
IV.Concurrent Sweeping


##G1
jvm heap划分为 多个固定大小region
扫描采用Snapshot-at-the-beginning 并发marking算法对整个heap中region进行mark



---
#参数调优
http://www.cnblogs.com/redcreen/archive/2011/05/04/2037057.html


##JVM参数的含义
-Xms    初始堆大小
-Xmx    最大堆大小
-Xmn    年轻代大小(1.4or lator)
-XX:NewSize 设置年轻代大小(for 1.3/1.4)    
-XX:MaxNewSize  年轻代最大值(for 1.3/1.4)
-XX:PermSize    设置持久代(perm gen)初始值
-XX:MaxPermSize 设置持久代最大值
-Xss    每个线程的堆栈大小
-XX:ThreadStackSize Thread Stack Size
-XX:NewRatio    年轻代(包括Eden和两个Survivor区)与年老代的比值(除去持久代)
-XX:SurvivorRatio   Eden区与Survivor区的大小比值
-XX:LargePageSizeInBytes    内存页的大小不可设置过大， 会影响Perm的大小
-XX:+UseFastAccessorMethods 原始类型的快速优化
-XX:+DisableExplicitGC      关闭System.gc()
-XX:MaxTenuringThreshold    垃圾最大年龄  串行GC时才有效
-XX:+AggressiveOpts     加快编译         
-XX:+UseBiasedLocking   锁机制的性能改善         
-Xnoclassgc             禁用垃圾回收       
-XX:SoftRefLRUPolicyMSPerMB     每兆堆空闲空间中SoftReference的存活时间  1s  
-XX:PretenureSizeThreshold      对象超过多大是直接在旧生代分配，另一种直接在旧生代分配的情况是大的数组对象,且数组中无外部引用对象
-XX:TLABWasteTargetPercent      TLAB占eden区的百分比  1%   
-XX:+CollectGen0First           FullGC时是否先YGC   false    

##并行收集器相关参数
-XX:+UseParallelGC      Full GC采用parallel MSC
-XX:+UseParNewGC        设置年轻代为并行收集 JDK5.0以上,无需再设置此值
-XX:ParallelGCThreads   并行收集器的线程数，此值最好配置与处理器数目相等
-XX:+UseParallelOldGC   年老代垃圾收集方式为并行收集(Parallel Compacting) 
-XX:MaxGCPauseMillis    每次年轻代垃圾回收的最长时间(最大暂停时间)
-XX:+UseAdaptiveSizePolicy  自动选择年轻代区大小和相应的Survivor区比例  
-XX:GCTimeRatio         设置垃圾回收时间占程序运行时间的百分比，公式为1/(1+n)
-XX:+ScavengeBeforeFullGC   Full GC前调用YGC   true

##CMS相关参数
-XX:+UseConcMarkSweepGC     使用CMS内存收集
-XX:+AggressiveHeap         试图是使用大量的物理内存，长时间大内存使用的优化，能检查计算资源（内存， 处理器数量）至少需要256MB内存，大量的CPU／内存， （在1.4.1在4CPU的机器上已经显示有提升）
-XX:CMSFullGCsBeforeCompaction      多少次后进行内存压缩      由于并发收集器不对内存空间进行压缩,整理,所以运行一段时间以后会产生"碎片",使得运行效率降低.此值设置运行多少次GC以后对内存空间进行压缩,整理.

-XX:+CMSParallelRemarkEnabled       降低标记停顿       
-XX+UseCMSCompactAtFullCollection   在FULL GC的时候， 对年老代的压缩        CMS是不会移动内存的， 因此， 这个非常容易产生碎片， 导致内存不够用， 因此， 内存的压缩这个时候就会被启用。 增加这个参数是个好习惯。
可能会影响性能,但是可以消除碎片
-XX:+UseCMSInitiatingOccupancyOnly  使用手动定义初始化定义开始CMS收集      禁止hostspot自行触发CMS GC
-XX:CMSInitiatingOccupancyFraction=70   使用cms作为垃圾回收，使用70％后开始CMS收集，为了保证不出现promotion failed(见下面介绍)错误,值的设置需要满足以下公式CMSInitiatingOccupancyFraction计算公式
-XX:CMSInitiatingPermOccupancyFraction  设置Perm Gen使用到达多少比率时触发  
-XX:+CMSIncrementalMode     设置为增量模式     用于单CPU情况
-XX:+CMSClassUnloadingEnabled    

##辅助信息
### -XX:+PrintGC            
输出形式:
[GC 118250K->113543K(130112K), 0.0094143 secs]
[Full GC 121376K->10414K(130112K), 0.0650971 secs]

### -XX:+PrintGCDetails         
输出形式:[GC [DefNew: 8614K->781K(9088K), 0.0123035 secs] 118250K->113543K(130112K), 0.0124633 secs]
[GC [DefNew: 8614K->8614K(9088K), 0.0000665 secs][Tenured: 112761K->10414K(121024K), 0.0433488 secs] 121376K->10414K(130112K), 0.0436268 secs]

### -XX:+PrintGCTimeStamps           
### -XX:+PrintGC:PrintGCTimeStamps          
可与-XX:+PrintGC -XX:+PrintGCDetails混合使用
输出形式:11.851: [GC 98328K->93620K(130112K), 0.0082960 secs]
### -XX:+PrintGCApplicationStoppedTime  
打印垃圾回收期间程序暂停的时间.可与上面混合使用        
输出形式:Total time for which application threads were stopped: 0.0468229 seconds
### -XX:+PrintGCApplicationConcurrentTime   
打印每次垃圾回收前,程序未中断的执行时间.可与上面混合使用
输出形式:Application time: 0.5291524 seconds
### -XX:+PrintHeapAtGC  
打印GC前后的详细堆栈信息        
### -Xloggc:filename    把相关日志信息记录到文件以便分析.
与上面几个配合使用        
### -XX:+PrintClassHistogram
garbage collects before printing the histogram.      
### -XX:+PrintTLAB  
查看TLAB空间的使用情况        
### XX:+PrintTenuringDistribution   
查看每次minor GC后新的存活周期的阈值      
Desired survivor size 1048576 bytes, new threshold 7 (max 15)
new threshold 7即标识新的存活周期的阈值为7。


## 堆快照
###-XX:+HeapDumpOnOutOfMemoryError     设定当发生OOM时自动dump出堆信息。不过该方法需要JDK5以上版本。
路径
###-XX:HeapDumpPath
-verbose
三个子标志： gc、 class 和 jni

-Xint，在解释模式下运行 JVM（对于测试 JIT 编译器实际上是否对您的代码起
作用或者验证是否 JIT 编译器中有一个 bug， 这都很有用）。
-Xloggc:，和 -verbose:gc 做同样的事，但是记录一个文件而不输出到命令行窗口。



---
#GC
##CMS
Mark-Sweep
第一次标记（Initial Marking）
该步聚须暂停整个应用，扫描从根集合对象到旧生代中可直接访问的对象，并对这些对象进行着色。对于着色的对象CMS采用一个外部的bit数组来进行记录。







---
#dev
空闲内存： 
Runtime.getRuntime().freeMemory() 
总内存： 
Runtime.getRuntime().totalMemory() 
最大内存： 
Runtime.getRuntime().maxMemory() 
已占用的内存： 
Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory() 




---
#OOM分析
[深入理解OutOfMemoryError](http://blog.csdn.net/wisgood/article/details/21939495)
[plumbr](https://plumbr.eu/)
##I.OutOfMemoryError： PermGen space
发生这种问题的原意是程序中使用了大量的jar或class，使java虚拟机装载类的空间不够，与Permanent Generation space有关。

解决这类问题有以下两种办法：
1. 增加java虚拟机中的XX:PermSize和XX:MaxPermSize参数的大小，其中XX:PermSize是初始永久保存区域大小，XX:MaxPermSize是最大永久保存区域大小。如针对tomcat6.0，在catalina.sh 或catalina.bat文件中一系列环境变量名说明结束处（大约在70行左右） 增加一行：
JAVA_OPTS=" -XX:PermSize=64M -XX:MaxPermSize=128m"
如果是windows服务器还可以在系统环境变量中设置。感觉用tomcat发布sprint+struts+hibernate架构的程序时很容易发生这种内存溢出错误。使用上述方法，我成功解决了部署ssh项目的tomcat服务器经常宕机的问题。
2. 清理应用程序中web-inf/lib下的jar，如果tomcat部署了多个应用，很多应用都使用了相同的jar，可以将共同的jar移到tomcat共同的lib下，减少类的重复加载。这种方法是网上部分人推荐的，我没试过，但感觉减少不了太大的空间，最靠谱的还是第一种方法。

##II.OutOfMemoryError：  Java heap space
发生这种问题的原因是java虚拟机创建的对象太多，在进行垃圾回收之间，虚拟机分配的到堆内存空间已经用满了，与Heap space有关。
1.内存中加载的数据量过于庞大，如一次从数据库取出过多数据；
2.集合类中有对对象的引用，使用完后未清空，使得JVM不能回收；
3.代码中存在死循环或循环产生过多重复的对象实体；
4.使用的第三方软件中的BUG；
5.启动参数内存值设定的过小；

解决这类问题有两种思路：
  1)检查代码中是否有死循环或递归调用。
  2)检查是否有大循环重复产生新对象实体。
  3)检查对数据库查询中，是否有一次获得全部数据的查询。一般来说，如果一次取十万条记录到内存，就可能引起内存溢出。这个问题比较隐蔽，在上线前，数据库中数据较少，不容易出问题，上线后，数据库中数据多了，一次查询就有可能引起内存溢出。因此对于数据库查询尽量采用分页的方式查询。
  4)检查List、MAP等集合对象是否有使用完后，未清除的问题。List、MAP等集合对象会始终存有对对象的引用，使得这些对象不能被GC回收。
增加Java虚拟机中Xms（初始堆大小）和Xmx（最大堆大小）参数的大小。如：set JAVA_OPTS= -Xms256m -Xmx1024m

##III.OutOfMemoryError：unable to create new native thread
这种错误在Java线程个数很多的情况下容易发生
这个限制的大小跟平台相关，如果你对这个限制的大小好奇的话，可以用下面这小段代码做下试验。在我的64位的Mac OSX上使用最新的JDK7，当创建的线程到2032时的就会报错。
```
while(true){
    new Thread(new Runnable(){
        public void run() {
            try {
                Thread.sleep(10000000);
            } catch(InterruptedException e) { }        
        }   
    }).start();
}
```


##IV.java.lang.OutOfMemoryError: GC overhead limit exceeded
这个问题有点特殊。这里没有提示说堆还是持久代有问题，虚拟机只是告诉你你的程序花在垃圾回收上的时间太多了，却没有什么见效。默认的话，如果你98%的时间都花在GC上并且回收了才不到2%的空间的话，虚拟机才会抛这个异常。这是一个快速失败的安全保障的很好的实践。一般来说禁用它也没有太大用处，如果需要的话你可以把-XX:-UseGCOverheadLimit加到启动脚本里。

##V.java.lang.OutOfMemoryError: nativeGetNewTLA
指当虚拟机不能分配新的线程本地空间(Thread Local Area）的时候错误信息。
这个异常只有在jRockit虚拟机时才会碰到。
线程本地空间是多线程程序里面为了更有效的进行内存分配而建立的缓存。每一个线程都有一份自己的缓存，当这个线程要创建对象的时候，就在这上面分配。如果你有很多线程同时并发，又要创建大量的对象，可能会出现这个问题，这种情况下你可以调整一下-XXtlaSize这个参数。


##VI.java.lang.OutOfMemoryError: Requested array size exceeds VM limit
当你正准备创建一个超过虚拟机允许的大小的数组时，这条错误就会出现在你眼前。在我的64位Mac系统上的最新的JDK7，我发现如果数组的长度是Integer.MAXINT-2的时候，是正常的，但只要再增加一个，也就是Integer.MAXINT-1,就成为那最后一根稻草了。在老的32位机器上，由于堆比较小，限制数组的大小是有好处的。不过在现代的64位机器上感觉有点多余。

##VII.java.lang.OutOfMemoryError: request bytes for . Out of swap space？
这个错误是当虚拟机向本地操作系统申请内存失败时抛出的。
这和你用完了堆或者持久化中的内存的情况有些不同。这个错误通常是在你的程序已经逼近平台限制的时候产生的。这个信息告诉你的是你可能已经用光了物理内存以及虚拟内存了。由于虚拟内存通常是用磁盘作为交换分区，因此你最先想到的解决方法可能是先增加交换分区的大小。不过我从没见过一个程序在频繁进行内存交换还能正常运行的，所以这个方法可能不会起到什么作用。

##IX.java.lang.OutOfMemoryError: (Native method)
，现在是时候找你开发C语言的小伙伴请求帮助了。因为现在你看到的错误信息是来自本地代码的，相对于刚才的出错信息，这次异常是在JNI或者 本地方法中检测到的，而不是在虚拟机执行的代码中。












---
#内存分析
[使用 Eclipse Memory Analyzer 进行堆转储文件分析](http://www.ibm.com/developerworks/cn/opensource/os-cn-ecl-ma/index.html)


























