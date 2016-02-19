#lock
---

1、自旋锁
2、自旋锁的其他种类
3、阻塞锁
4、可重入锁
5、读写锁
6、互斥锁
7、悲观锁
8、乐观锁
9、公平锁
10、非公平锁
11、偏向锁
12、对象锁
13、线程锁
14、锁粗化
15、轻量级锁
JDK1.6轻量级锁能提升程序同步性能的依据是“对于绝大部分的锁，在整个同步周期内都是不存在竞争的”，这是一个经验数据。轻量级锁在当前线程的栈帧中建立一个名为锁记录的空间，用于存储锁对象目前的指向和状态。如果没有竞争，轻量级锁使用CAS操作避免了使用互斥量的开销，但如果存在锁竞争，除了互斥量的开销外，还额外发生了CAS操作，因此在有竞争的情况下，轻量级锁会比传统的重量级锁更慢。
16、锁消除
JDK1.6 锁削除是指虚拟机即时编译器在运行时，对一些代码上要求同步，但是被检测到不可能存在共享数据竞争的锁进行削除。
17、锁膨胀
JDK1.6和数据库中的锁升级有些相似，多个或多次调用粒度太小的锁，进行加锁解锁的消耗，反而还不如一次大粒度的锁调用来得高效，因此JVM可将锁的范围优化到更大的区域
18、信号量

#自旋锁
线程要进入阻塞状态，肯定需要调用操作系统的函数来完成从用户态进入内核态的过程，这一步通常是性能低下的。
那么在遇到锁的争用时，或许等待线程可以不那么着急进入阻塞状态，而是等一等，看看锁是不是马上就释放了，这就是锁自旋。锁自旋在多处理器上有重要价值。
当然锁自旋也带来了一些问题，比如如何判断自旋周期，如何确定自旋锁的个数，如何处理线程优先级差异等。

当前线程不停地的在循环体内执行实现的，当循环的条件被其他线程改变时 才能进入临界区
```java
public class SpinLock {
    private AtomicReference<Thread> sign =new AtomicReference<>();
    public void lock(){
        Thread current = Thread.currentThread();
        while(!sign .compareAndSet(null, current)){
        }
    }
    public void unlock (){
        Thread current = Thread.currentThread();
        sign.compareAndSet(current, null);
    }
}
```
由于自旋锁只是将当前线程不停地执行循环体，不进行线程状态的改变，所以响应速度更快。但当线程数不停增加时，性能下降明显，因为每个线程都需要执行，占用CPU时间。如果线程竞争不激烈，并且保持锁的时间段。适合使用自旋锁。

#TicketLock
主要解决的是访问顺序的问题，主要的问题是在多核cpu上
每次都要查询一个serviceNum 服务号，影响性能（必须要到主内存读取，并阻止其他cpu修改）。
```java
package com.alipay.titan.dcc.dal.entity;
import java.util.concurrent.atomic.AtomicInteger;
public class TicketLock {
    private AtomicInteger                     serviceNum = new AtomicInteger();
    private AtomicInteger                     ticketNum  = new AtomicInteger();
    private static final ThreadLocal<Integer> LOCAL      = new ThreadLocal<Integer>();
    public void lock() {
        int myticket = ticketNum.getAndIncrement();
        LOCAL.set(myticket);
        while (myticket != serviceNum.get()) {
        }

    }
    public void unlock() {
        int myticket = LOCAL.get();
        serviceNum.compareAndSet(myticket, myticket + 1);
    }
}
```

#CLHlock 
链表的形式进行排序
CLHlock是不停的查询前驱变量， 导致不适合在NUMA 架构下使用（在这种结构下，每个线程分布在不同的物理内存区域）
```java
import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;

public class CLHLock {
    public static class CLHNode {
        private volatile boolean isLocked = true;
    }

    @SuppressWarnings("unused")
    private volatile CLHNode                                           tail;
    private static final ThreadLocal<CLHNode>                          LOCAL   = new ThreadLocal<CLHNode>();
    private static final AtomicReferenceFieldUpdater<CLHLock, CLHNode> UPDATER = AtomicReferenceFieldUpdater.newUpdater(CLHLock.class,CLHNode.class, "tail");

    public void lock() {
        CLHNode node = new CLHNode();
        LOCAL.set(node);
        CLHNode preNode = UPDATER.getAndSet(this, node);
        if (preNode != null) {
            while (preNode.isLocked) {
            }
            preNode = null;
            LOCAL.set(node);
        }
    }

    public void unlock() {
        CLHNode node = LOCAL.get();
        if (!UPDATER.compareAndSet(this, node, null)) {
            node.isLocked = false;
        }
        node = null;
    }
}
```

#MCSlock 
MCSLock则是对本地变量的节点进行循环。不存在CLHlock 的问题。
```java
import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;

public class MCSLock {
    public static class MCSNode {
        volatile MCSNode next;
        volatile boolean isLocked = true;
    }

    private static final ThreadLocal<MCSNode> NODE    = new ThreadLocal<MCSNode>();
    @SuppressWarnings("unused")
    private volatile MCSNode queue;
    private static final AtomicReferenceFieldUpdater<MCSLock, MCSNode> UPDATER = AtomicReferenceFieldUpdater.newUpdater(MCSLock.class,MCSNode.class, "queue");

    public void lock() {
        MCSNode currentNode = new MCSNode();
        NODE.set(currentNode);
        MCSNode preNode = UPDATER.getAndSet(this, currentNode);
        if (preNode != null) {
            preNode.next = currentNode;
            while (currentNode.isLocked) {

            }
        }
    }

    public void unlock() {
        MCSNode currentNode = NODE.get();
        if (currentNode.next == null) {
            if (UPDATER.compareAndSet(this, currentNode, null)) {

            } else {
                while (currentNode.next == null) {
                }
            }
        } else {
            currentNode.next.isLocked = false;
            currentNode.next = null;
        }
    }
}
```
从代码上 看，CLH 要比 MCS 更简单，
CLH 的队列是隐式的队列，没有真实的后继结点属性。
MCS 的队列是显式的队列，有真实的后继结点属性。
JUC ReentrantLock 默认内部使用的锁 即是 CLH锁（有很多改进的地方，将自旋锁换成了阻塞锁等等）。

#阻塞锁
与自旋锁不同，改变了线程的运行状态
线程Thread有如下几个状态：
1，新建状态
2，就绪状态
3，运行状态
4，阻塞状态
5，死亡状态
可以说是让线程进入阻塞状态进行等待，当获得相应的信号（唤醒，时间） 时，才可以进入线程的准备就绪状态，准备就绪状态的所有线程，通过竞争，进入运行状态。
JAVA中，能够进入\退出、阻塞状态或包含阻塞锁的方法有 ，synchronized 关键字（其中的重量锁），ReentrantLock，Object.wait()\notify(),LockSupport.park()/unpart()(j.u.c经常使用)

```java
package lock;
import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;
import java.util.concurrent.locks.LockSupport;
public class CLHLock1 {
    public static class CLHNode {
        private volatile Thread isLocked;
    }
    @SuppressWarnings("unused")
    private volatile CLHNode                                            tail;
    private static final ThreadLocal<CLHNode>                           LOCAL   = new ThreadLocal<CLHNode>();
    private static final AtomicReferenceFieldUpdater<CLHLock1, CLHNode> UPDATER = AtomicReferenceFieldUpdater.newUpdater(CLHNode.class, "tail");
    public void lock() {
        CLHNode node = new CLHNode();
        LOCAL.set(node);
        CLHNode preNode = UPDATER.getAndSet(this, node);
        if (preNode != null) {
            preNode.isLocked = Thread.currentThread();
            LockSupport.park(this);
            preNode = null;
            LOCAL.set(node);
        }
    }

    public void unlock() {
        CLHNode node = LOCAL.get();
        if (!UPDATER.compareAndSet(this, node, null)) {
            System.out.println("unlock\t" + node.isLocked.getName());
            LockSupport.unpark(node.isLocked);
        }
        node = null;
    }
}
```
LockSupport.unpark()的阻塞锁。 该例子是将CLH锁修改而成
优势在于，阻塞的线程不会占用cpu时间， 不会导致 CPu占用率过高，但进入时间以及恢复时间都要比自旋锁略慢。
在竞争激烈的情况下 阻塞锁的性能要明显高于 自旋锁。
理想的情况则是:
在线程竞争不激烈的情况下，使用自旋锁
竞争激烈的情况下使用，阻塞锁

#可重入锁
可重入锁，也叫做递归锁，指的是同一线程 外层函数获得锁之后 ，内层递归函数仍然有获取该锁的代码，但不受影响。
在JAVA环境下 ReentrantLock 和synchronized 都是 可重入锁

可重入锁最大的作用是避免死锁
```java
public class SpinLock {
    private AtomicReference<Thread> owner =new AtomicReference<>();
    public void lock(){
        Thread current = Thread.currentThread();
        while(!owner.compareAndSet(null, current)){
        }
    }
    public void unlock (){
        Thread current = Thread.currentThread();
        owner.compareAndSet(current, null);
    }
}
```
对于自旋锁来说，
1、若有同一线程两调用lock() ，会导致第二次调用lock位置进行自旋，产生了死锁
说明这个锁并不是可重入的。（在lock函数内，应验证线程是否为已经获得锁的线程）
2、若1问题已经解决，当unlock（）第一次调用时，就已经将锁释放了。实际上不应释放锁（采用计数次进行统计）
```java
public class SpinLock1 {
    private AtomicReference<Thread> owner =new AtomicReference<>();
    private int count =0;
    public void lock(){
        Thread current = Thread.currentThread();
        if(current==owner.get()) {
            count++;
            return ;
        }

        while(!owner.compareAndSet(null, current)){

        }
    }
    public void unlock (){
        Thread current = Thread.currentThread();
        if(current==owner.get()){
            if(count!=0){
                count--;
            }else{
                owner.compareAndSet(current, null);
            }

        }

    }
}
```


#偏向锁
[](http://itlab.idcquan.com/Java/advance/805449.html)
JDK1.6引入的，主要为了解决在没有竞争情况下锁的性能问题。
锁都是可重入的，在已经获得锁的情况下，该线程可以多次锁住该对象，但是每次执行这样的操作会因为CAS（CPU的Compare-And-Swap指令）操作而造成一些开销，为了减少这种开销，这个锁会偏向于第一个获得它的线程，如果在接下来的执行过程中，该锁没有被其他的线程获取，则持有偏向锁的线程将永远不需要再进行同步。

轻量级锁也是一种多线程优化，它与偏向锁的区别在于，轻量级锁是通过CAS来避免进入开销较大的互斥操作，而偏向锁是在无竞争场景下完全消除同步，连CAS也不执行（CAS本身仍旧是一种操作系统同步原语，始终要在JVM与OS之间来回，有一定的开销）。


实现原理
　　偏向锁，顾名思义，它会偏向于第一个访问锁的线程，如果在接下来的运行过程中，该锁没有被其他的线程访问，则持有偏向锁的线程将永远不需要触发同步。
　　如果在运行过程中，遇到了其他线程抢占锁，则持有偏向锁的线程会被挂起，JVM会尝试消除它身上的偏向锁，将锁恢复到标准的轻量级锁。(偏向锁只能在单线程下起作用)


---
#无锁编程
如果站在语言层面之上，仅从设计的层面看，可以避免锁的思路至少包括：
1、单线程来主导行为，多线程池化操作避开状态变量。
比如在一个WEB应用中，每一个Action都可以给相应的用户线程分配一个实例，线程之间互不干扰；但是到了业务逻辑Service内，避开Service状态变量的使用，减少了开发人员对并发编程的关注。
2、函数式编码。
函数式编码是最天然的和最高效的免锁方式，如果你对函数式编码还不了解，请参看这篇文章。
3、资源局部复制、异步处理。
总所周知对资源的争夺是造成锁的一个重要原因，在很多情况下，资源只能有一份，但是对使用资源的每个线程来说，都可以看到属于它自己的一份（这一份并非是真正的资源，很可能只是一个缓冲区，每个线程使用它自己的一个缓冲区，到一定程度时将缓冲区的数据处理到唯一资源中，这就减少了需要加锁对线程的影响），无需考虑并发地去使用。














