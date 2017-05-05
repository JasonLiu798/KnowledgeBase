#Java Thread/Concurrent
---
#1.doc
[Disruptor](http://ifeve.com/locks-are-bad/)
[fucking-java-concurrency](https://github.com/oldratlee/fucking-java-concurrency)
[构建高性能服务（一）ConcurrentSkipListMap和链表构建高性能Java Memcached](http://maoyidao.iteye.com/blog/1559420)





---
#2.theory
一个Thread类实例只是一个对象，像Java中的任何其他对象一样，具有变量和方法，生死于堆上。
Java中，每个线程都有一个调用栈，即使不在程序中创建任何新的线程，线程也在后台运行着，比如GC中的线程。

创建一个新的线程，就产生一个新的调用栈。
线程总体分两类：用户线程和守候线程。
一个线程可以创建和撤消另一个线程，同一进程中的多个线程之间可以并发执行

线程也有就绪、阻塞和运行三种基本状态
当所有用户线程执行完毕的时候，JVM自动关闭。但是守候线程却独立于JVM，守候线程一般是由操作系统或者用户自己创建的

##线程状态
　　在Java当中，线程通常都有五种状态，创建、就绪、运行、阻塞和死亡。
　　第一是创建状态。在生成线程对象，并没有调用该对象的start方法，这是线程处于创建状态。
　　第二是就绪状态。当调用了线程对象的start方法之后，该线程就进入了就绪状态，但是此时线程调度程序还没有把该线程设置为当前线程，此时处于就绪状态。在线程运行之后，从等待或者睡眠中回来之后，也会处于就绪状态。
　　第三是运行状态。线程调度程序将处于就绪状态的线程设置为当前线程，此时线程就进入了运行状态，开始运行run函数当中的代码。
　　第四是阻塞状态。线程正在运行的时候，被暂停，通常是为了等待某个时间的发生(比如说某项资源就绪)之后再继续运行。sleep,suspend，wait等方法都可以导致线程阻塞。
　　第五是死亡状态。如果一个线程的run方法执行结束或者调用stop方法后，该线程就会死亡。对于已经死亡的线程，无法再使用start方法令其进入就绪。

##状态转换
[一张图让你看懂JAVA线程间的状态转换](http://my.oschina.net/mingdongcheng/blog/139263)
1 new ------t.start()------> 2
2 runnable----OS选中-------> 3
3 runing,obtain my timeslice ----时间片用完，yield-----------> 2
                             ----o.wait()--------------------> 4
                             ----synchronized(o)-------------> 5
                             ----等待用户输入，sleep，join---> 6
                             ----run/main结束 异常退出--> 7
4 等待队列 release lock or monitor ---其他线程o2.notify/notifyAll-----> 5
5 锁池 lock pool ----拿到锁标识----> 2
6 阻塞 不释放锁 ------输入完成，sleep结束，t2结束---------> 2
7 dead
PS：
sleep 让进程从 running -> 阻塞 时间结束/interrupt -> runnable
wait 让进程从 running -> 等待队列 notify 等待队列->锁池 ->runable


##实现
1:1（内核线程）、N:1（用户态线程）、M:N（混合）模型
HotSpot VM
在这个JVM的较新版本所支持的所有平台上，它都是使用1:1线程模型的——除了Solaris之外
http://www.oracle.com/technetwork/java/threads-140302.html

[聊聊JVM（五）从JVM角度理解线程](http://blog.csdn.net/iter_zc/article/details/41843595)
JVM定义的Thread的类继承结构如下:
Class hierarchy
 - Thread
   - NamedThread
     - VMThread
     - ConcurrentGCThread
     - WorkerThread
       - GangWorker
       - GCTaskThread
   - JavaThread
   - WatcherThread
另外还有一个重要的类OSThread不在这个继承关系里，它以组合的方式被Thread类所使用

java.lang.Thread: 这个是Java语言里的线程类，由这个Java类创建的instance都会 1:1 映射到一个操作系统的osthread

JavaThread: JVM中C++定义的类，一个JavaThread的instance代表了在JVM中的java.lang.Thread的instance, 它维护了线程的状态，并且维护一个指针指向java.lang.Thread创建的对象(oop)。它同时还维护了一个指针指向对应的OSThread，来获取底层操作系统创建的osthread的状态

OSThread: JVM中C++定义的类，代表了JVM中对底层操作系统的osthread的抽象，它维护着实际操作系统创建的线程句柄handle，可以获取底层osthread的状态

VMThread: JVM中C++定义的类，这个类和用户创建的线程无关，是JVM本身用来进行虚拟机操作的线程，比如GC。

有两种方式可以让用户在JVM中创建线程
1. new java.lang.Thread().start()
2. 使用JNI将一个native thread attach到JVM中


针对 new java.lang.Thread().start()这种方式，只有调用start()方法的时候，才会真正的在JVM中去创建线程，主要的生命周期步骤有：
1. 创建对应的JavaThread的instance
2. 创建对应的OSThread的instance
3. 创建实际的底层操作系统的native thread
4. 准备相应的JVM状态，比如ThreadLocal存储空间分配等
5. 底层的native thread开始运行，调用java.lang.Thread生成的Object的run()方法
6. 当java.lang.Thread生成的Object的run()方法执行完毕返回后,或者抛出异常终止后，终止native thread
7. 释放JVM相关的thread的资源，清除对应的JavaThread和OSThread

针对JNI将一个native thread attach到JVM中，主要的步骤有：
1. 通过JNI call AttachCurrentThread申请连接到执行的JVM实例
2. JVM创建相应的JavaThread和OSThread对象
3. 创建相应的java.lang.Thread的对象
4. 一旦java.lang.Thread的Object创建之后，JNI就可以调用Java代码了
5. 当通过JNI call DetachCurrentThread之后，JNI就从JVM实例中断开连接
6. JVM清除相应的JavaThread, OSThread, java.lang.Thread对象

从JVM的角度来看待线程状态的状态有以下几种:
```
enum JavaThreadState{
    _thread_uninitialized = 0
    _thread_new = 2
    _thread_new_trans = 3
    _thread_in_native = 4
    _thread_in_native_trans = 5
    _thread_in_vm = 6
    _thread_in_vm_trans = 7
    _thread_in_Java = 8
    _thread_in_Java_trans = 9
    _thread_blocked = 10
    _thread_blocked_trans = 11
    _thread_max_state = 12
};
```
其中主要的状态是这5种:
_thread_new: 新创建的线程
_thread_in_Java: 在运行Java代码
_thread_in_vm: 在运行JVM本身的代码
_thread_in_native: 在运行native代码
_thread_blocked: 线程被阻塞了，包括等待一个锁，等待一个条件，sleep，执行一个阻塞的IO等

从OSThread的角度，JVM还定义了一些线程状态给外部使用，比如用jstack输出的线程堆栈信息中线程的状态:
```
enum ThreadState{
   ALLOCATED,
   INITIALIZED,
   RUNNABLE,
   MONITOR_WAIT,
   CONDVAR_WAIT,
   OBJECT_WAIT,
   BREAKPOINTED,
   SLEEPING,
   ZOMBIE
}
```

---
#3.java内存模型
##顺序一致模型
保证单线程内操作按照程序顺序执行
保证所有线程只看到一致的操作执行顺序

##JMM模型
最小安全性
线程执行时读取到的值，要么是之前某个线程写入的值，要么是默认值
JVM会同步分配对象和内存空间清零操作
不保证Long，double类型 内存读写的原子性（JSR-133之后，读操作必须原子性，写操作可以拆分）



---
#资源同步
#volatile
线程可见性：其他线程可以看到最新的修改
指令重排：
第二个操作是volatile写，不管第一个操作是什么，都不能重排序
第一个操作是volatile读，不管第二个操作是什么，都不能重排序
第一个操作是volatile写，第二个操作是读，不能重排序

##内存屏障插入策略
保守策略
每个volatiel写操作之前插入一个StoreStore屏障（普通写刷入主存）
每个volatiel写操作之后插入一个StoreLoad屏障（或者在每个读之前插入StoreLoad，效率低）
每个volatiel读操作之后插入一个LoadLoad屏障（禁止之后普通读和上面的volatile读重排）
每个volatiel读操作之后插入一个LoadStore屏障（禁止之后普通写和上面的volatile读重排）

##只解决了可见性问题，没有解决互斥性
适合：
一个线程写，其他线程读


---
#Synchronized
[synchronized关键字详解](http://www.cnblogs.com/mengdd/archive/2013/02/16/2913806.html)
从语法角度来说就是Obj.wait(),Obj.notify必须在synchronized(Obj){...}语句块内
wait功能：线程在获取对象锁后，主动释放对象锁，同时本线程休眠。直到有其它线程调用对象的notify()唤醒该线程，才能继续获取对象锁，并继续执行。
notify()就是对对象锁的唤醒操作
notify()调用后，并不是马上就释放对象锁的，而是在相应的synchronized(){}语句块执行结束，自动释放锁后，JVM会在wait()对象锁的线程中随机选取一线程，赋予其对象锁，唤醒线程，继续执行。

##用法
synchronized method，等价于 synchronized (this) block
synchronized block
```java
    public synchronized void fun1() {
        // do something here
    }
    public synchronized void fun2() {
        synchronized (this) {
        // do something here
        }
    }
```
静态方法的 synchronized method也就等价于下面这种形式的 synchronized block
```java
    public static synchronized void fun2() {
        synchronized (ClassName.class) {
        // do something here
        }
    }
```

##实现
[synchronized的实现方式](http://blog.csdn.net/feelang/article/details/40134631)
```java
typedef struct monitor {
pthread_mutex_t lock;
Thread *owner;
Object *obj;
int count;
int in_wait;
uintptr_t entering;
int wait_count;
Thread *wait_set;
struct monitor *next;
} Monitor;


void monitorLock(Monitor *mon, Thread *self) {
    if(mon->owner == self)
        mon->count++;
    else {
        if(pthread_mutex_trylock(&mon->lock)) {
            disableSuspend(self);

            self->blocked_mon = mon;
            self->blocked_count++;
            self->state = BLOCKED;//

            pthread_mutex_lock(&mon->lock);

            self->state = RUNNING;
            self->blocked_mon = NULL;

            enableSuspend(self);
        }
        mon->owner = self;
    }
}
```


##关于synchronized string
[使用Synchronized块同步变量](http://itlab.idcquan.com/Java/line/808077.html)
第一个s和再次赋值后的s的hashCode的值是不一样的。由于创建String类的实例并不需要使用new，因此，在同步String类型的变量时要注意不要给这个变量赋值，否则会使变量无法同步。

##synchronized lock对比
[synchronized 与 Lock 的那点事](http://www.cnblogs.com/benshan/p/3551987.html)
synchronized的限制
1.一个线程因为等待内置锁而进入，就无法中断该线程
2.尝试获取内置锁，无法设置超时
3.获取内置锁，必须使用synchronized块



---
#Lock
```java
//1.获取锁可以中断
final ReetrantLock l1 = new ReentrantLock();
l1.lockInterruptibly();
//2.设置获取锁失败超时机制
if(l1.tryLock(1000,TimeUnit.MILLISECONDS)){
}
```
tryLock避免了无尽死锁，会受到活锁影响
减小活锁几率：为每个线程设置不同超时时间


##队列同步器 AbstractQueuedSynchronizer
排他式获取



共享式获取
acquireShared
释放
releaseShared


###独占式超时获取同步状态
doAcquireNanos

##重入锁 ReentrantLock
Mutex不支持重进入锁，重获取会阻塞自身
公平：绝对时间上，先对锁获取的请求一定先满足；等待时间最长线程最优先获取锁
    减少饥饿

nonfairTryAcquire
    再次获取锁，增加 同步状态值


##读写锁 readWriteLock
高16位 读，低16位写；位运算确定读写各自状态
各个线程获取读锁的次数，保存在ThreadLocal中
锁降级
    当前拥有写锁，获取读锁，在释放写锁
    获取读锁，保证数据可见性，如果直接释放写锁，其他线程获取写锁后，当前线程无法感知数据更新。


##LockSupport工具


##Condition接口
await，当前线程进入等待状态知道被通知或中断，当前线程进入运行状态且从await方法返回的情况包括：
    其他线程调用该Condition的signal()或singalAll()方法

signal，唤醒一个等待在Condition上的线程，该线程从等待方法返回前必须获得与Condition相关联的锁
signalAll，唤醒所有等待Condition线程，能从等待方法返回的，必须获得与Condition相关联的锁

###实现
ConditionObject是同步器AbstractQueuedSynchronizer内部类
等待队列
    首节点firstWaiter，尾节点lastWaiter
等待
    相当于 同步队列首节点移动到 等待队列中
通知
    唤醒等待队列中 等待时间最长节点（首节点），唤醒前将节点移动到同步队列中















---
#线程调度
##wait /sleep
###sleep
sleep(long millis)，sleep(long millis, long nanos)，调用sleep方法后，当前线程进入休眠期，暂停执行，但该线程继续拥有监视资源的所有权。到达休眠时间后线程将继续执行，直到完成。若在休眠期另一线程中断该线程，则该线程退出。

###wait
wait()，wait(long timeout)，wait(long timeout, long nanos)，调用wait方法后，该线程放弃监视资源的所有权进入等待状态；
wait()：等待有其它的线程调用notify()或notifyAll()进入调度状态，与其它线程共同争夺监视。wait()相当于wait(0)，wait(0, 0)。
wait(long timeout)：当其它线程调用notify()或notifyAll()，或时间到达timeout亳秒，或有其它某线程中断该线程，则该线程进入调度状态。
wait(long timeout, long nanos)：相当于wait(1000000*timeout + nanos)，只不过时间单位为纳秒。

###对比
1.sleep是Thread的静态类方法，谁调用的谁去睡觉，即使在a线程里调用了b的sleep方法，实际上还是a去睡觉，要让b线程睡觉要在b的代码中调用sleep。

2.最主要是sleep方法没有释放锁，而wait方法释放了锁，使得其他线程可以使用同步控制块或者方法。
sleep不出让系统资源；wait是进入线程等待池等待，出让系统资源，其他线程可以占用CPU。
一般wait不会加时间限制，因为如果wait线程的运行资源不够，再出来也没用，要等待其他线程调用notify/notifyAll唤醒等待池中的所有线程，才会进入就绪队列等待OS分配系统资源。
sleep(milliseconds)可以用时间指定使它自动唤醒过来，如果时间不到只能调用interrupt()强行打断。
Thread.Sleep(0)的作用是“触发操作系统立刻重新进行一次CPU竞争”。

3.使用范围：wait，notify和notifyAll只能在同步控制方法或者同步控制块里面使用，而sleep可以在任何地方使用
   synchronized(x){
      x.notify()
     //或者wait()
   }

4.sleep必须捕获异常，而wait，notify和notifyAll不需要捕获异常

Thread.State.BLOCKED（阻塞）表示线程正在获取锁时，因为锁不能获取到而被迫暂停执行下面的指令，一直等到这个锁被别的线程释放。BLOCKED状态下线程，OS调度机制需要决定下一个能够获取锁的线程是哪个，这种情况下，就是产生锁的争用，无论如何这都是很耗时的操作。



###注意点
始终使用while循环来调用wait方法，原因是尽管不满足被唤醒条件，但由于其他线程调用notifyAll会导致被阻塞线程意外唤醒，将破坏锁保护的约定关系，导致约束失效，引起意想不到的结果
```java
synchronized(this){
    while(condition)
        Object.wait;
    ...
}
```

##wait/notify/notifyAll
##CountdownLatch
一个线程(或者多个)， 等待另外N个线程完成某个事情之后才能执行
这种现象只出现一次——计数无法被重置。
在一些应用场合中，需要等待某个条件达到要求后才能做后面的事情；同时当线程都完成后也会触发事件，以便进行后面的操作。 这个时候就可以使用CountDownLatch。CountDownLatch最重要的方法是countDown()和await()，前者主要是倒数一次，后者是等待倒数到0，如果没有到达0，就只有阻塞等待了。
###public void countDown()
递减锁存器的计数，如果计数到达零，则释放所有等待的线程。如果当前计数大于零，则将计数减少。如果新的计数为零，出于线程调度目的，将重新启用所有的等待线程。
如果当前计数等于零，则不发生任何操作。
###public boolean await(long timeout,TimeUnit unit) throws InterruptedException
使当前线程在锁存器倒计数至零之前一直等待，除非线程被中断或超出了指定的等待时间。如果当前计数为零，则此方法立刻返回 true 值。
如果当前计数大于零，则出于线程调度目的，将禁用当前线程，且在发生以下三种情况之一前，该线程将一直处于休眠状态：
由于调用countDown()方法，计数到达零；或者其他某个线程中断当前线程；或者已超出指定的等待时间。
如果计数到达零，则该方法返回 true 值。
如果当前线程：在进入此方法时已经设置了该线程的中断状态；或者在等待时被中断，则抛出InterruptedException，并且清除当前线程的已中断状态。如果超出了指定的等待时间，则返回值为false。如果该时间小于等于零，则此方法根本不会等待。
参数：
timeout - 要等待的最长时间
unit - timeout 参数的时间单位。
返回：
如果计数到达零，则返回 true；如果在计数到达零之前超过了等待时间，则返回 false
抛出：
InterruptedException - 如果当前线程在等待时被中断


##semaphore


##join
public final void join() throws InterruptedException Waits for this thread to die. Throws: InterruptedException  - if any thread has interrupted the current thread. The interrupted status of the current thread is cleared when this exception is thrown.

[Thread.join()详解](http://www.open-open.com/lib/view/open1371741636171.html)
join是Thread类的一个方法，启动线程后直接调用
如果子线程里要进行大量的耗时的运算，主线程往往将于子线程之前结束，但是如果主线程处理完其他的事务后，需要用到子线程的处理结果，也就是主线程需要等待子线程执行完成之后再结束，这个时候就要用到join()方法了。
public final void join() throws InterruptedException Waits for this thread to die. Throws: InterruptedException  - if any thread has interrupted the current thread. The interrupted status of the current thread is cleared when this exception is thrown.
wait()
Causes the current thread to wait until another thread invokes the notify() method or the notifyAll() method for this object. In other words, this method behaves exactly as if it simply performs the call wait(0).
The current thread must own this object's monitor. The thread releases ownership of this monitor and waits until another thread notifies threads waiting on this object's monitor to wake up either through a call to the notify method or the notifyAll method. The thread then waits until it can re-obtain ownership of the monitor and resumes execution.


##yield
暂停当前正在执行的线程对象，并执行其他线程，目的是让相同优先级的线程之间能适当的轮转执行
但是，实际中无法保证yield()达到让步目的，因为让步的线程还有可能被线程调度程序再次选中

yield()方法执行时，当前线程仍处在可运行状态，所以，不可能让出较低优先级的线程些时获得 CPU 占有权，在一个运行系统中，如果较高优先级的线程没有调用 sleep 方法，又没有受到 I\O 阻塞，那么，较低优先级线程只能等待所有较高优先级的线程运行结束，才有机会运行。

## sync collection
vector hashmap
## concurrent collection
concurrentHashMap lockStriping
CopyOnWriteArrayList
BlockingQueue
latch
futureTask
counting semaphore
barrier exchanger

# 活跃性危险
##deadlock
    sequence lock
    open call
### analyze
timeout
thread dump

## other
stave
livelock





---
#集合类
##CopyOnWrite
[CopyOnWrite](http://ifeve.com/java-copy-on-write/)
添加的时候是需要加锁的，否则多线程写的时候会Copy出N个副本出来
读的时候不需要加锁，如果读的时候有多个线程正在向ArrayList添加数据，读还是会读到旧的数据，因为写的时候不会锁住旧的ArrayList。
适用：读多写少的并发场景
实现
```java
public boolean add(T e) {
    final ReentrantLock lock = this.lock;
    lock.lock();
    try {
        Object[] elements = getArray();
        int len = elements.length;
        // 复制出新数组
        Object[] newElements = Arrays.copyOf(elements, len + 1);
        // 把新元素添加到新数组里
        newElements[len] = e;
        // 把原数组引用指向新数组
        setArray(newElements);
        return true;
    } finally {
        lock.unlock();
    }
}
final void setArray(Object[] a) {
    array = a;
}
```
读的时候不需要加锁，如果读的时候有多个线程正在向ArrayList添加数据，读还是会读到旧的数据，因为写的时候不会锁住旧的ArrayList。

CopyOnWriteMap
```java
import java.util.Collection;
import java.util.Map;
import java.util.Set;
public class CopyOnWriteMap<K, V> implements Map<K, V>, Cloneable {
    private volatile Map<K, V> internalMap;
    public CopyOnWriteMap() {
        internalMap = new HashMap<K, V>();
    }
    public V put(K key, V value) {
        synchronized (this) {
            Map<K, V> newMap = new HashMap<K, V>(internalMap);
            V val = newMap.put(key, value);
            internalMap = newMap;
            return val;
        }
    }
    public V get(Object key) {
        return internalMap.get(key);
    }
    public void putAll(Map<? extends K, ? extends V> newData) {
        synchronized (this) {
            Map<K, V> newMap = new HashMap<K, V>(internalMap);
            newMap.putAll(newData);
            internalMap = newMap;
        }
    }
}
```
###缺点
CopyOnWrite容器有很多优点，但是同时也存在两个问题，即内存占用问题和数据一致性问题



##ConcurrentHashMap
[Java Core系列之ConcurrentHashMap实现(JDK 1.7)](http://www.blogjava.net/DLevin/archive/2013/10/18/405030.html)
HashTable锁粒度太大，put同时，无法get
Segment数组，ReentrantLock
HashEntry数组

get不加锁
    使用volatile
    transient volatile int count;
    volatile V value;
put
    1.是否需要扩容
    2.添加元素位置，放入HashEntry数组

##ConcurrentLinkedQueue
wait-free算法 CAS
入队：
    1.insertnode设为尾节点下一个节点
    2.更新tail，如果tail.next为null，则将 insertnode 设为tail


##ArrayBlockingQueue
不保证线程公平访问


##LinkedBlockingQueue
[LinkedBlockingQueue](http://blog.csdn.net/mazhimazh/article/details/19242767)
在必要是阻塞，队列为满，调用put会阻塞，队列为空，调用take会阻塞
生产者消费者模式为什么不用 ConcurrentLinkedQueue？
如果生产、消费速度不同，生产过快，使用ConcurrentLinkedQueue会导致队列大小不断增加，可能会超过内存容量。

PriorityBlockingQueue

##DelayQueue
支持延时获取元素的无界阻塞队列
适合：缓存系统设计，定式调度任务

SynchronousQueue
LinkedTransferQueue
LinkedBlockingDeque

---
#Unsafe
[unsafe](http://blog.csdn.net/zgmzyr/article/details/8902683)


---
#测试
[模拟并发测试](http://forrest420.iteye.com/blog/1169071)
[Future/Callable/Runnable基本](http://www.cnblogs.com/dolphin0520/p/3949310.html)


---
#threadpool 线程池
[几种Java线程池的实现算法分析](http://www.open-open.com/lib/view/open1406778349171.html)
##作用
* 复用
类似WEB服务器等系统，长期来看内部需要使用大量的线程处理请求，而单次请求响应时间通常比较短，此时Java基于操作系统的本地调用 方式大量的创建和销毁线程本身会成为系统的一个性能瓶颈和资源浪费。若使用线程池技术可以实现工作线程的复用，即一个工作线程创建和销毁的生命周期期间内 可以执行处理多个任务，从而总体上降低线程创建和销毁的频率和时间，提升了系统性能。
* 流控
服务器资源有限，超过服务器性能的过高并发设置反而成为系统的负担，造成CPU大量耗费于上下文切换、内存溢出等后果。通过线程池技术可以控制系统最大并发数和最大处理任务量，从而很好的实现流控，保证系统不至于崩溃。
* 功能
JDK的线程池实现的非常灵活，并提供了很多功能，一些场景基于功能的角度会选择使用线程池。

##技术要点
* 工作者线程worker
即线程池中可以重复利用起来执行任务的线程，一个worker的生命周期内会不停的处理多个业务job。线程池“复 用”的本质就是复用一个worker去处理多个job，“流控“的本质就是通过对worker数量的控制实现并发数的控制。通过设置不同的参数来控制worker的数量可以实现线程池的容量伸缩从而实现复杂的业务需求
* 待处理工作job的存储队列
工作者线程workers的数量是有限的，同一时间最多只能处理最多workers数量个job。对于来不及处理的job需要保存到等待队列里，空闲的工作者work会不停的读取空闲队列里的job进行处理。基于不同的队列实现，可以扩展出多种功能的线程池，如定制队列出队顺序实现带处理优先级的线程池、定制队列为阻塞有界队列实现可阻塞能力的线程池等。流控一方面通过控制worker数控制并发数和处理能力，一方面可基于队列控制线程池处理能力的上限。
* 线程池初始化
即线程池参数的设定和多个工作者workers的初始化。通常有一开始就初始化指定数量的workers或者有请求时逐步初始化工作者两种方式。前者线程池启动初期响应会比较快但造成了空载时的少量性能浪费，后者是基于请求量灵活扩容但牺牲了线程池启动初期性能达不到最优。
* 处理业务job算法
业务给线程池添加任务job时线程池的处理算法。有的线程池基于算法识别直接处理job还是增加工作者数处理job或者放入待处理队列，也有的线程池会直接将job放入待处理队列，等待工作者worker去取出执行。
* workers的增减算法
业务线程数不是持久不变的，有高低峰期。线程池要有自己的算法根据业务请求频率高低调节自身工作者workers的 数量来调节线程池大小，从而实现业务高峰期增加工作者数量提高响应速度，而业务低峰期减少工作者数来节省服务器资源。增加算法通常基于几个维度进行：待处理工作job数、线程池定义的最大最小工作者数、工作者闲置时间。
* 线程池终止逻辑
应用停止时线程池要有自身的停止逻辑，保证所有job都得到执行或者抛弃。


##线程池大小选择策略
* 硬件性能，CPU核数
* 线程任务类型（CPU密集，IO密集），IO阻塞比率
* 是否有其他任务

##ThreadPoolExecutor
* 状态
```java
    volatile int runState;
     /* 线程池正在运行，可以正常的接收新任务，同时执行任务队列中缓存的任务 */
    static final int RUNNING    = 0;
     /* 线程池处于关闭状态，暂停接受新任务，但是会继续执行缓存队列中的旧任务     */
    static final int SHUTDOWN   = 1;
    /*
     * 线程池处于停止状态，暂停接受新的任务，也不会去执行缓存队列中的旧任务
     */
    static final int STOP       = 2;
    /*
     * 线程池处于终止状态，不接受新任务，也不执行缓存队列中的旧任务，同时关闭所有执行线程
     */
    static final int TERMINATED = 3;
```
状态只能从RUNNING->SHUTDOWN->STOP->TERMINATED，不能反向跳转状态

线程池刚创建时，处于RUNNING状态
当使用者调用shutdown()方法后，线程池被设置为SHUTDOWN状态
当使用者调用shutdownNow()方法后，线程池被设置为STOP状态
当线程处于SHUTDOWN或STOP状态，并且所有工作线程已经销毁，任务缓存队列已经清空或执行结束后，线程池被设置为TERMINATED状态


* 任务队列
private final BlockingQueue<Runnable> workQueue;

* 核心线程池
ThreadPoolExecutor 使用一个HashSet对象保存执行任务的线程，这些线程，从任务缓存队列中获取任务，并进行执行。任务执行线程是可伸缩的，有三个参数和线程池的大小相关，分别为corePoolSize、maximumPoolSize以及poolSize，线程池在工作时，可以根据上述参数，动态调整线程池的大小。
```java
    /**
     * 核心线程池大小
     * 线程池在工作时，核心线程池大小是可以调整的，将核心线程池从大调小时，线程池会尝试关闭已经不再使用的线程
     */
    private volatile int   corePoolSize;
    /**
     * 最大线程池大小
     * 线程池在工作时，最大线程池大小也是可以调整的，将最大线程池从大调小是，线程池会尝试关闭不再使用的线程
     */
    private volatile int   maximumPoolSize;
    /**
     * 当前线程池大小
     * 对于此变量的修改，必须在mainLock的保护下进行
     */
    private volatile int   poolSize;
```

* 执行任务
每个线程池，都必须有三样元素构成:
    - 任务缓存队列：用于缓存需要执行的任务，新加入的任务，放到队列尾部，执行线程从队列头部获取新的任务，并进行执行
    - 主控线程：用来控制任务的分发，即从 任务缓存队列 头部，获取一个任务，分发到其中一个 任务执行线程中执行，相当于管理者或监工的角色
    - 任务执行线程：用来接受主控线程分发的任务并完成任务，相当于工人的角色。

ThreadPoolExecutor中有没有主控线程，只有任务缓存队列和任务执行线程，每个任务执行线程，自行从任务缓存队列中获取任务，并且执行，类似于某些公司吹嘘的“员工自我管理与提高”

```java
    public void execute(Runnable command) {
        if (command == null)
            throw new NullPointerException();
        if (poolSize >= corePoolSize || !addIfUnderCorePoolSize(command)) {
            /*
             * 如果当前任务执行线程大小比核心线程大，或创建新的线程失败
             */
            if (runState == RUNNING && workQueue.offer(command)) {
                //因为当前线程未加锁，所以这里需要再次判断线程池状态
                if (runState != RUNNING || poolSize == 0)
                    ensureQueuedTaskHandled(command);
            }else if (!addIfUnderMaximumPoolSize(command))//如果这里创建了新的线程，那么无法保证新入队的任务，先执行，后入队的任务后执行，这是ThreadPoolExecutor的调度策略
                reject(command); // is shutdown or saturated
        }
    }
```


##FixedThreadPool

##SingleThreadExecutor


##CachedThreadPool
    new ThreadPoolExecutor(0,Integer.MAX_VALUE,
    60L, TimeUnit.SECONDS,
    new SynchronousQueue<Runnable>());

##ScheduledThreadPoolExecutor




---
#Atomic
##LongAdder
jdk-8u20以上可用
[从LongAdder 看更高效的无锁实现](http://www.liuinsect.com/2014/04/15/%E6%AF%94atomiclong%E8%BF%98%E9%AB%98%E6%95%88%E7%9A%84longadder-%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90/)

[Java 8 Performance Improvements: LongAdder vs AtomicLong](http://blog.palominolabs.com/2014/02/10/java-8-performance-improvements-longadder-vs-atomiclong/)


DoubleAdder



---
#API
##创建
```java
Thread thread = new Thread(){
        public void run(){

        }
}
Thread thread = new Thread(new Runnable(){
          public void run(){

           }
});
```





---
# performance
## Amdahl's law
加速比是用并行前的执行速度和并行后的执行速度之比来表示的，它表示了在并行化之后的效率提升情况
{W_s + W_p} / {{W_s + {W_p}/{p}}
W_s, W_p分别表示问题规模的串行分量（问题中不能并行化的那一部分）和并行分量，p表示处理器数量
p->infty => {W}/{W_s}
{W}={W_s}+{W_p}
这意味着无论我们如何增大处理器数目，加速比是无法高于这个数的。
## thread cost
context switch
memory barrier
block
## decrease lock compete


----
#threadlocal
[threadlocal](http://blog.csdn.net/lufeng20/article/details/24314381)
[Java并发编程：深入剖析ThreadLocal](http://www.cnblogs.com/dolphin0520/p/3920407.html)
ThreadLocalMap


[指令重排](https://www.zhihu.com/question/39458585)



---
#Disruptor
[剖析Disruptor:为什么会这么快？(一)锁的缺点(1)](http://developer.51cto.com/art/201306/398864.htm)
http://developer.51cto.com/art/201306/399082.htms

http://developer.51cto.com/art/201306/398232.htm





















---
#distriputor
[构建高性能服务（三）Java高性能缓冲设计 vs Disruptor vs LinkedBlockingQueue](http://maoyidao.iteye.com/blog/1663193)












