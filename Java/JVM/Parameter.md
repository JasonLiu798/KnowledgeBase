
JVM调优 – JVM内存分配参数
堆内存：-Xmx、-Xms
新生代：-Xmn，一般设置为整个堆空间的1/4到1/3
Hot   Spot虚拟机中-XX:NewSize、-XX:MaxNewSize
持久代：-XX:PermSize、-XX:MaxPermSize
线程栈：-Xss
堆比例参数
-XX:SurvivorRatio = eden / s0 = eden / s1
-XX:NewRatio = 老年代 / 新生代




