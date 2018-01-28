



# 默认堆大小
The default value is chosen at runtime based on system configuration.
Smaller of 1/4th of the physical memory or 1GB. 

# 默认NewRatio
默认的，新生代 ( Young ) 与老年代 ( Old ) 的比例的值为 1:2 ( 该值可以通过参数 –XX:NewRatio 来指定 )

# 默认 eden:survivor
默认Eden : from : to = 8 : 1 : 1 ( 可以通过参数 –XX:SurvivorRatio 来设定 )



-XX:+PrintGC 输出GC日志
-XX:+PrintGCDetails 输出GC的详细日志
-XX:+PrintGCTimeStamps 输出GC的时间戳（以基准时间的形式）
-XX:+PrintGCDateStamps 输出GC的时间戳（以日期的形式，如 2013-05-04T21:53:59.234+0800）
-XX:+PrintHeapAtGC 在进行GC的前后打印出堆的信息
-XX:+PrintGCApplicationStoppedTime // 输出GC造成应用暂停的时间
-Xloggc:../logs/gc.log 日志文件的输出路径




# 指定gc
## -XX:+UseSerialGC
开启单线程、Stop-The-World的新生代和老年代垃圾收集器

## -XX:+UseParallelGC
开启jvm的多线程、Stop-The-World的Throughput收集器。又被称为并行收集器。使用多线程利用多CPU来提高GC的效率，主要以达到一定的吞吐量为目标。不过只是在新生代使用多线程垃圾收集器，而老年代还是使用单线程、Stop-The-World垃圾收集器。如果使用的jvm版本支持-XX:+UseParallelOldGC，
可以优先使用-XX:+UseParallelOldGC,而不是-XX:+UseParallelGC，具体描述请参见-XX:+UseParallelOldGC。-XX:+UseParallelGC是server模式默认使用的垃圾收集器。

## -XX:+UseParallelOldGC
开启jvm多线程、Stop-The-World的Throughput收集器，与-XX:+UseParallelGC指令不同之处是新生代和老年代都是用多线程垃圾收集器。设定-XX:+UseParallelOldGC时自动开启-XX:+UseParallelGC

## -XX:-UseAdaptiveSizePolicy
关闭自适应调整新生代Eden区和Survivor区尺寸的特性。只有Throughput支持自适应尺寸调整。开启或关闭自适应尺寸调整在CMS收集器和Serial收集器时不起作用。用-XX:+UseParallelGC和-XX:+UseParallelOldGC收集器时会自动开启自适应调整尺寸

## -XX:+UseConcMarkSweepGC
开启jvm的CMS收集器。它会自动开启-XX:+UseParNewGC，新生代使用多线程垃圾收集器，老年代使用CMS收集器。当Throughput收集器无法满足应用的延迟需求时，可使用CMS收集器。使用CMS收集器时，通常需要对新生代大小、Survivor区大小和CMS垃圾收集周期的初始阶段进行细致调优。

## -XX:+UseParNewGC
开启单线程、Stop-The-World的新生代垃圾收集器，需要配合以并发为主的老年代收集器CMS。

## -XX:ParallelGCThreads=<n> 
配置多线程垃圾收集器线程的并行数，<n>是运行的线程数量，从JDK6u23开始，如果java api Runtime.availableProcessors()小于等于8，则<n>默认为这个值，否则默认为8+(Runtime.availableProcessors()-8) * 5/8。如果一个系统上运行了多个应用，建议用-XX:ParallelGCThreads显示的设置垃圾收集线程的并行数，该数应该小于jvm的默认值，运行在一个系统上的垃圾收集器线程，总数不应该超过Runtime.availableProcessors()，即cpu总核数。

## -XX:MaxTenuringThreshold=<n> 
设置最大晋升值为<n>，jvm将这个值作为对象的最大年龄，它会将达到这个阀值的对象从新生代提升的老年代。使用CMS收集器时，为了使对象老化的算法更有效，可以使用-XX:MaxTenuring- Threshold细调Survivor区。

## -XX:CMSInitiatingOccupancyFraction=<percent> 
老年代占用达到该百分比时，就会引发CMS的第一次垃圾收集周期，后续CMS垃圾收集周期的开始点则由jvm自动优化计算得到的占用量而决定，如果还设置了-XX:+UseCMSInitiatingOccupancyOnly,则每次老年代占用达到该百分比时，就会开始CMS的垃圾收集周期。

## -XX:+UseCMSInitiatingOccupancyOnly 
表示只有在老年代占用达到-XX:CMSInitiatingOccupancyFraction=<percent> 设置的阀值时，才会触发CMS的并发垃圾收集周期。











