#cache
------
#本地cache
##ehcache
###ehcache spring集成
http://kim-miao.iteye.com/blog/1622686

###ehcache 集群
http://www.ibm.com/developerworks/cn/java/j-lo-ehcache/

### ehcache配置
#### Cache配置 
* name  Cache的唯一标识
* maxElementsInMemory   内存中最大缓存对象数
* maxElementsOnDisk     磁盘中最大缓存对象数，若是0表示无穷大。 
* eternal   Element是否永久有效，一但设置了，timeout将不起作用。 
* overflowToDisk    配置此属性，当内存中Element数量达到maxElementsInMemory时，Ehcache将会Element写到磁盘中。 
* timeToIdleSeconds 设置Element在失效前的允许闲置时间。仅当element不性，默认值是0，也就是可闲置时间无穷大。 
* timeToLiveSeconds 设置Element在失效前允许存活时间。最大时间介于创当element不是永久有效时使用，默认是0.活时间无穷大。 
* diskPersistent    是否缓存虚拟机重启期数据。（这个虚拟机是指什么虚拟高人还希望能指点一二）。 
* readIntervalSeconds   磁盘失效线程运行时间间隔，默认是120秒。 
* diskSpoolBufferSizeMB     这个参数设置DiskStore（磁盘缓存）的缓存区大Cache都应该有自己的一个缓冲区。 
* memoryStoreEvictionPolicy     当达到maxElementsInMemory限制时，Ehcache将会根据指定的策略去清理内存。默认策略是LRU（最近最少使用）。你可以设置为FIFO（先进先出）或是LFU（较少使用）。这里比较遗憾，Ehcache并没有提供一个用户定制策略的接口，仅仅支持三种指定策略，感觉做的不够理想。 

####Cache Exception Handling配置 
<cacheExceptionHandlerFactory class="com.example.ExampleExceptionHandlerFactory" properties="logLevel=FINE"/>



## 后台
http://blog.csdn.net/ithomer/article/details/10602469









