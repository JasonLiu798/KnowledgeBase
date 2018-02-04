# 内存屏障

## 作用
* 阻止屏障两侧的指令重排序；
* 强制把写缓冲区/高速缓存中的脏数据等写回主内存，让缓存中相应的数据失效。

硬件层的内存屏障分为两种：Load Barrier 和 Store Barrier即读屏障和写屏障
## Load Barrier
在指令前插入LoadBarrier，可以让高速缓存中的数据失效，强制从新从主内存加载数据；
## Store Barrier
在指令后插入StoreBarrier，能让写入缓存中的最新数据更新写入主内存，让其他线程可见。

## java内存屏障
java的内存屏障通常所谓的四种即LoadLoad,StoreStore,LoadStore,StoreLoad实际上也是上述两种的组合，完成一系列的屏障和数据同步功能。

### LoadLoad屏障
对于这样的语句Load1; LoadLoad; Load2，在Load2及后续读取操作要读取的数据被访问前，保证Load1要读取的数据被读取完毕。
### StoreStore屏障
对于这样的语句Store1; StoreStore; Store2，在Store2及后续写入操作执行前，保证Store1的写入操作对其它处理器可见。
## LoadStore屏障
对于这样的语句Load1; LoadStore; Store2，在Store2及后续写入操作被刷出前，保证Load1要读取的数据被读取完毕。
## StoreLoad屏障
对于这样的语句Store1; StoreLoad; Load2，在Load2及后续所有读取操作执行前，保证Store1的写入对所有处理器可见。它的开销是四种屏障中最大的。在大多数处理器的实现中，这个屏障是个万能屏障，兼具其它三种内存屏障的功能

## volatile语义中的内存屏障
volatile的内存屏障策略非常严格保守，非常悲观且毫无安全感的心态：
* 在每个volatile写操作
	- 前插入StoreStore屏障
	- 写操作后插入StoreLoad屏障
* 在每个volatile读操作
	- 前插入LoadLoad屏障
	- 后插入LoadStore屏障
由于内存屏障的作用，避免了volatile变量和其它指令重排序、线程之间实现了通信，使得volatile表现出了锁的特性。


## final语义中的内存屏障
对于final域，编译器和CPU会遵循两个排序规则：
* 新建对象过程中，构造体中对final域的初始化写入和这个对象赋值给其他引用变量，这两个操作不能重排序；
* 初次读包含final域的对象引用和读取这个final域，这两个操作不能重排序；（晦涩，意思就是先赋值引用，再调用final值）

总之上面规则的意思可以这样理解，必需保证一个对象的所有final域被写入完毕后才能引用和读取。这也是内存屏障的起的作用：
写final域：在编译器写final域完毕，构造体结束之前，会插入一个StoreStore屏障，保证前面的对final写入对其他线程/CPU可见，并阻止重排序。
读final域：在上述规则2中，两步操作不能重排序的机理就是在读final域前插入了LoadLoad屏障。
X86处理器中，由于CPU不会对写-写操作进行重排序，所以StoreStore屏障会被省略；而X86也不会对逻辑上有先后依赖关系的操作进行重排序，所以LoadLoad也会变省略。















