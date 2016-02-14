#Java Thread Concurrent
---
#资源同步
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



---
# 集合类
[LinkedBlockingQueue](http://blog.csdn.net/mazhimazh/article/details/19242767)


---
#测试
[模拟并发测试](http://forrest420.iteye.com/blog/1169071)
[Future/Callable/Runnable基本](http://www.cnblogs.com/dolphin0520/p/3949310.html)


---
#交互机制
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
[Thread.join()详解](http://www.open-open.com/lib/view/open1371741636171.html)
join是Thread类的一个方法，启动线程后直接调用
如果子线程里要进行大量的耗时的运算，主线程往往将于子线程之前结束，但是如果主线程处理完其他的事务后，需要用到子线程的处理结果，也就是主线程需要等待子线程执行完成之后再结束，这个时候就要用到join()方法了。
public final void join() throws InterruptedException Waits for this thread to die. Throws: InterruptedException  - if any thread has interrupted the current thread. The interrupted status of the current thread is cleared when this exception is thrown.
wait()
Causes the current thread to wait until another thread invokes the notify() method or the notifyAll() method for this object. In other words, this method behaves exactly as if it simply performs the call wait(0).
The current thread must own this object's monitor. The thread releases ownership of this monitor and waits until another thread notifies threads waiting on this object's monitor to wake up either through a call to the notify method or the notifyAll method. The thread then waits until it can re-obtain ownership of the monitor and resumes execution.




---
# base module
## Thread schedule
priority 
block

sleep

##yield
暂停当前正在执行的线程对象，并执行其他线程，目的是让相同优先级的线程之间能适当的轮转执行
但是，实际中无法保证yield()达到让步目的，因为让步的线程还有可能被线程调度程序再次选中

yield()方法执行时，当前线程仍处在可运行状态，所以，不可能让出较低优先级的线程些时获得 CPU 占有权，在一个运行系统中，如果较高优先级的线程没有调用 sleep 方法，又没有受到 I\O 阻塞，那么，较低优先级线程只能等待所有较高优先级的线程运行结束，才有机会运行。


##join
public final void join() throws InterruptedException Waits for this thread to die. Throws: InterruptedException  - if any thread has interrupted the current thread. The interrupted status of the current thread is cleared when this exception is thrown.

##wait 

##notify


1 2 3 4 5 6 7 8 9 

2 5 8


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
#并发测试
thread.yeild

-xx: +PrintCompilation

AbstractQueuedSynchronizer(AQS)


non-blocking sync
CAS
compare and set








