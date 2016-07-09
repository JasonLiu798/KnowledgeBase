#Java Thread Concurrent
---
[Disruptor](http://ifeve.com/locks-are-bad/)

[fucking-java-concurrency](https://github.com/oldratlee/fucking-java-concurrency)
#theory
一个Thread类实例只是一个对象，像Java中的任何其他对象一样，具有变量和方法，生死于堆上。
Java中，每个线程都有一个调用栈，即使不在程序中创建任何新的线程，线程也在后台运行着，比如GC中的线程。

创建一个新的线程，就产生一个新的调用栈。
线程总体分两类：用户线程和守候线程。
一个线程可以创建和撤消另一个线程，同一进程中的多个线程之间可以并发执行

线程也有就绪、阻塞和运行三种基本状态
当所有用户线程执行完毕的时候，JVM自动关闭。但是守候线程却独立于JVM，守候线程一般是由操作系统或者用户自己创建的

线程的几种状态
　　在Java当中，线程通常都有五种状态，创建、就绪、运行、阻塞和死亡。
　　第一是创建状态。在生成线程对象，并没有调用该对象的start方法，这是线程处于创建状态。
　　第二是就绪状态。当调用了线程对象的start方法之后，该线程就进入了就绪状态，但是此时线程调度程序还没有把该线程设置为当前线程，此时处于就绪状态。在线程运行之后，从等待或者睡眠中回来之后，也会处于就绪状态。
　　第三是运行状态。线程调度程序将处于就绪状态的线程设置为当前线程，此时线程就进入了运行状态，开始运行run函数当中的代码。
　　第四是阻塞状态。线程正在运行的时候，被暂停，通常是为了等待某个时间的发生(比如说某项资源就绪)之后再继续运行。sleep,suspend，wait等方法都可以导致线程阻塞。
　　第五是死亡状态。如果一个线程的run方法执行结束或者调用stop方法后，该线程就会死亡。对于已经死亡的线程，无法再使用start方法令其进入就绪。


---
#java内存模型
##顺序一致模型
保证单线程内操作按照程序顺序执行
保证所有线程只看到一致的操作执行顺序

##JMM模型
最小安全性
线程执行时读取到的值，要么是之前某个线程写入的值，要么是默认值
JVM会同步分配对象和内存空间清零操作
不保证Long，double类型 内存读写的原子性（JSR-133之后，读操作必须原子性，写操作可以拆分）

---
#threadpool 线程池
大小：硬件性能、线程任务类型（CPU密集，IO密集）、是否有其他任务


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


#Synchronized
[synchronized关键字详解](http://www.cnblogs.com/mengdd/archive/2013/02/16/2913806.html)
从语法角度来说就是Obj.wait(),Obj.notify必须在synchronized(Obj){...}语句块内
wait功能：线程在获取对象锁后，主动释放对象锁，同时本线程休眠。直到有其它线程调用对象的notify()唤醒该线程，才能继续获取对象锁，并继续执行。
notify()就是对对象锁的唤醒操作
notify()调用后，并不是马上就释放对象锁的，而是在相应的synchronized(){}语句块执行结束，自动释放锁后，JVM会在wait()对象锁的线程中随机选取一线程，赋予其对象锁，唤醒线程，继续执行。

##synchronized的实现方式
[synchronized的实现方式](http://blog.csdn.net/feelang/article/details/40134631)
synchronized method
synchronized block

synchronized method 就等价于 synchronized (this) block
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


##关于synchronized string
[使用Synchronized块同步变量](http://itlab.idcquan.com/Java/line/808077.html)
第一个s和再次赋值后的s的hashCode的值是不一样的。由于创建String类的实例并不需要使用new，因此，在同步String类型的变量时要注意不要给这个变量赋值，否则会使变量无法同步。

##synchronized lock对比
[synchronized 与 Lock 的那点事](http://www.cnblogs.com/benshan/p/3551987.html)
synchronized的限制
1.一个线程因为等待内置锁而进入，就无法中断该线程
2.尝试获取内置锁，无法设置超时
3.获取内置锁，必须使用synchronized块

Lock
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


##Lock
交替锁
链表





#CAS指令





---
#线程调度
##wait /sleep
wait和sleep比较：
sleep方法有：sleep(long millis)，sleep(long millis, long nanos)，调用sleep方法后，当前线程进入休眠期，暂停执行，但该线程继续拥有监视资源的所有权。到达休眠时间后线程将继续执行，直到完成。若在休眠期另一线程中断该线程，则该线程退出。

wait方法有：wait()，wait(long timeout)，wait(long timeout, long nanos)，调用wait方法后，该线程放弃监视资源的所有权进入等待状态；
wait()：等待有其它的线程调用notify()或notifyAll()进入调度状态，与其它线程共同争夺监视。wait()相当于wait(0)，wait(0, 0)。
wait(long timeout)：当其它线程调用notify()或notifyAll()，或时间到达timeout亳秒，或有其它某线程中断该线程，则该线程进入调度状态。
wait(long timeout, long nanos)：相当于wait(1000000*timeout + nanos)，只不过时间单位为纳秒。

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
# 集合类
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


##BlockingQueue
[LinkedBlockingQueue](http://blog.csdn.net/mazhimazh/article/details/19242767)
在必要是阻塞，队列为满，调用put会阻塞，队列为空，调用take会阻塞
生产者消费者模式为什么不用 ConcurrentLinkedQueue？
如果生产、消费速度不同，生产过快，使用ConcurrentLinkedQueue会导致队列大小不断增加，可能会超过内存容量。



---
#测试
[模拟并发测试](http://forrest420.iteye.com/blog/1169071)
[Future/Callable/Runnable基本](http://www.cnblogs.com/dolphin0520/p/3949310.html)


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


---
#实现
1:1（内核线程）、N:1（用户态线程）、M:N（混合）模型
HotSpot VM
在这个JVM的较新版本所支持的所有平台上，它都是使用1:1线程模型的——除了Solaris之外

http://www.oracle.com/technetwork/java/threads-140302.html

##synchronized
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


































