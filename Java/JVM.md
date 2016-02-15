#JVM
---
#theory
[栈式虚拟机和寄存器式虚拟机](http://www.zhihu.com/question/35777031)
[寄存器分配问题](http://www.zhihu.com/question/29355187)
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
##jps
-q only lvmid
-m parameter passed to main()
-l class full name
-v init parameter
jps -lv

##内存分析
###jconsole
###visualvm
###jmap
jmap -dump:format=b,file=heap.bin <pid>

###MAT
mat: eclipse memory analyzer, 基于eclipse RCP的内存分析工具。
详细信息参见：http://www.eclipse.org/mat/
jhat：JDK自带的java heap analyze tool


###jstat
-class
-compiler
-gc
-gccapacity
-gccause
-gcnew
-gcnewcapacity
-gcold
-gcoldcapacity
-gcpermcapacity
-gcutil
-printcompilation

##jhat

###MAT

##线程分析
###jstack

###TDA








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
#内存分析
[使用 Eclipse Memory Analyzer 进行堆转储文件分析](http://www.ibm.com/developerworks/cn/opensource/os-cn-ecl-ma/index.html)
