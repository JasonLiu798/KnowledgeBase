#JVM线程实现
---
#参考
[JVM中的线程模型是用户级的么](https://www.zhihu.com/question/23096638)
[聊聊JVM（五）从JVM角度理解线程](http://blog.csdn.net/iter_zc/article/details/41843595)
----
#实现
JVM规范里是没有规定的——具体实现用1:1（内核线程）、N:1（用户态线程）、M:N（混合）模型的任何一种都完全OK

Java SE最常用的JVM是Oracle/Sun研发的HotSpot VM。在这个JVM的较新版本所支持的所有平台上，它都是使用1:1线程模型的——除了Solaris之外，它是个特例。

这是HotSpot VM在Solaris上所支持的线程模型：Java(TM) and Solaris(TM) Threading
<- 可以看到HotSpot VM在Solaris上支持M:N和1:1模型。当前默认是用1:1模型。

我喜欢用的一个例子是Oracle/Sun的另一个JVM实现，用于Java ME CLDC的CLDC HotSpot Implementation（CLDC-HI）。它支持两种线程模型，默认使用N:1线程模型，所有Java线程都映射到一个内核线程上，是典型的用户态线程模型；它也可以使用一种特殊的混合模型，Java线程仍然全部映射到一个内核线程上，但当Java线程要执行一个阻塞调用时，CLDC-HI会为该调用单独开一个内核线程，并且调度执行其它Java线程，等到那个阻塞调用完成之后再重新调度之前的Java线程继续执行。有权限访问到的同学可以去读读CLDC HotSpot Implementation Architecture Guide（百度文库有对应CLDC-HI 2.0的版本：CLDC-Hotspot-Architecture_百度文库），里面的第5章介绍了CLDC-HI的线程模型，下面引用部分内容过来：
```
The system has two distinct threading models. The simplest and preferred model supports LWTs (light weight threads). In this model, CLDC HotSpot Implementation implements all LWTs on a single native OS thread. LWTs are essentially co-routines created and scheduled by the virtual machine. This is transparent at the Java runtime environment level....A special style of handling threading might be preferable in some ports. This style relies on the availability of native thread support in the target platform OS. It is called hybrid threading, ...
```
然后在另一份文档，CLDC HotSpot Implementation Porting Guide的第4章里介绍了如何移植CLDC-HI的线程系统到别的平台。http://elastos.org有一份CLDC-HI 1.1.3版本的：http://elastos.org/elorg_files/FreeBooks/java/thesis/CLDC-Hotspot-Port.pdf。同样摘抄一小段描述出来：
```
Non-blocking scheduling - The native method de-schedules its lightweightthread (LWT) until another part of the virtual machine determines that the nativemethod can be executed without blocking. Then the native method is reentered toproceed with the given problematic call that is now guaranteed to be ofsufficiently short duration.

Hybrid threading - The native method de-schedules its LWT after delegating thetask to an OS thread to execute the given blocking call. When this OS thread,which is truly concurrent to the rest of the virtual machine, completes the call, itcauses the LWT to resume. The LWT then reenters the native method to fetch theresults of the blocking call....

If you port to another platform, it might be the case that only one of the styles can beimplemented. Non-blocking scheduling depends on the existence of functions thatcan determine whether a subsequent call would block. Take for example theselect() function for BSD sockets that can be used to determine whether a socketis ready for a non-blocking data transmission call. Hybrid threading requires thatseveral OS threads are available and that all the blocking OS calls that you want toemploy are reentrant.
```
可见，使用用户态线程是会有潜在的并行瓶颈问题，但也有（一定程度的）解决办法。


---
#模型
##1:1
模型下Java线程与操作系统线程一一对应，在JVM内没有任何线程调度器，全部交给操作系统的调度器解决。
##N:1
模型则是所有Java线程共用一个操作系统线程，Java线程的调度全部由JVM内的调度器实现
##M:N
是上述两者的混合模型。

HotSpot VM
在这个JVM的较新版本所支持的所有平台上，它都是使用1:1线程模型的——除了Solaris之外
http://www.oracle.com/technetwork/java/threads-140302.html


---
#Thread
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













