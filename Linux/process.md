#Process
---
#docs
[Linux如何控制 CPU 利用率](http://blog.csdn.net/bb6lo/article/details/46966689?ref=myread)

---
#fork
fork（）会产生一个和父进程完全相同的子进程，但子进程在此后多会exec系统调用，出于效率考虑，linux中引入了 *写时复制* 技术，也就是只有进程空间的各段的内容要发生变化时，才会将父进程的内容复制一份给子进程。
原来在fork之后exec之前两个进程用的是相同的物理空间（内存区），子进程的代码段、数据段、堆栈都是指向父进程的物理空间，也就是说，两者的虚拟空间不同，但其对应的物理空间是同一个。
当父子进程中有更改相应段的行为发生时，再为子进程相应的段分配物理空间，如果不是因为exec，内核会给子进程的数据段、堆栈段分配相应的物理空间（至此两者有各自的进程空间，互不影响），而代码段继续共享父进程的物理空间（两者的代码完全相同）。而如果是因为exec，由于两者执行的代码不同，子进程的代码段也会分配单独的物理空间。

fork之后内核会通过将子进程放在队列的前面，以让子进程先执行，以免父进程执行导致写时复制，而后子进程执行exec系统调用，因无意义的复制而造成效率的下降。

正文段，数据段，堆，栈

（1）复制P1的正文段，数据段，堆，栈这四个部分，注意是其内容相同。
（2）为这四个部分分配物理块，
P2的 正文段－＞P1的正文段的物理块，其实就是不为P2分配正文段块，让P2的正文段指向P1的正文段块
数据段－＞P2自己的数据段块（为其分配对应的块）
堆－＞P2自己的堆块
栈－＞P2自己的栈块

##写时复制技术
内核只为新生成的子进程创建虚拟空间结构，它们来复制于父进程的虚拟究竟结构，但是不为这些段分配物理内存，它们共享父进程的物理空间，当父子进程中有更改相应段的行为发生时，再为子进程相应的段分配物理空间。

##vfork()
这个做法更加火爆，内核连子进程的虚拟地址空间结构也不创建了，直接共享了父进程的虚拟空间，当然了，这种做法就顺水推舟的共享了父进程的物理空间。


最小线程数量即时cpu内核数量。
如果所有的任务都是计算密集型的，这个最小线程数量就是我们需要的线程数。开辟更多的线程只会影响程序的性能，因为线程之间的切换工作，会消耗额外的资源。
如果任务是IO密集型的任务，我们可以开辟更多的线程执行任务。当一个任务执行IO操作的时候，线程将会被阻塞，处理器立刻会切换到另外一个合适的线程去执行。
如果我们只拥有与内核数量一样多的线程，即使我们有任务要执行，他们也不能执行，因为处理器没有可以用来调度的线程。

如果线程有50%的时间被阻塞，线程的数量就应该是内核数量的2倍。
如果更少的比例被阻塞，那么它们就是计算密集型的，则需要开辟较少的线程。如果有更多的时间被阻塞，那么就是IO密集型的程序，则可以开辟更多的线程。
开辟的线程数量至少等于运行机器的cpu内核数量
线程数量计算公式：
线程数量=内核数量 / （1 - 阻塞率）

可以通过相应的分析工具或者java的management包来得到阻塞率的数值

Linux从内核2.6开始使用NPTL （Native POSIX Thread Library）支持，但这时线程本质上还轻量级进程。 

Java里的线程是由JVM来管理的，它如何对应到操作系统的线程是由JVM的实现来确定的。Linux 2.6上的HotSpot使用了NPTL机制，JVM线程跟内核轻量级进程有一一对应的关系。线程的调度完全交给了操作系统内核，当然jvm还保留一些策略足以影响到其内部的线程调度，举个例子，在linux下，只要一个Thread.run就会调用一个fork产生一个线程。

这种方式实现的线程，是直接由操作系统内核支持的——由内核完成线程切换，内核通过操纵调度器（Thread Scheduler）实现线程调度，并将线程任务反映到各个处理器上。内核线程是内核的一个分身。程序一般不直接使用该内核线程，而是使用其高级接口，即轻量级进程（LWP），也即线程。

KLT即内核线程Kernel Thread，是“内核分身”。每一个KLT对应到进程P中的某一个轻量级进程LWP（也即线程），期间要经过用户态、内核态的切换，并在Thread Scheduler 下反应到处理器CPU上。

这种线程实现的方式也有它的缺陷：在程序面上使用内核线程，必然在操作系统上多次来回切换用户态及内核态；另外，因为是一对一的线程模型，LWP的支持数是有限的。
对于一个大型程序，我们可以开辟的线程数量至少等于运行机器的cpu内核数量。java程序里我们可以通过下面的一行代码得到这个数量：
Runtime.getRuntime().availableProcessors();



##一个fork的面试题
[一个fork的面试题](http://coolshell.cn/articles/7965.html)
题目：请问下面的程序一共输出多少个“-”？
```c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
 
int main(void)
{
   int i;
   for(i=0; i<2; i++){
      fork();
      printf("-");
   }
 
   wait(NULL);
   wait(NULL);
 
   return 0;
}
//printf("-\n");
```




---
#process
[understanding-linux-processes](https://www.gitbook.com/subscribe/book/tobegit3hub1/understanding-linux-processes)
##process state
[Linux process states](https://idea.popcount.org/2012-12-11-linux-process-states/)
static const char * const task_state_array[] = {
  "R (running)",        /*   0 */
  "S (sleeping)",        /*   1 */
  "D (disk sleep)",    /*   2 */
  "T (stopped)",        /*   4 */
  "t (tracing stop)",    /*   8 */
  "X (dead)",        /*  16 */
  "Z (zombie)",        /*  32 */
};

ps aux可以看到进程的状态
O：进程正在处理器运行,这个状态从来没有见过.
S：休眠状态（sleeping）
R：等待运行（runable）R Running or runnable (on run queue) 进程处于运行或就绪状态
I：空闲状态（idle）
Z：僵尸状态（zombie）
T：跟踪状态（Traced）
B：进程正在等待更多的内存页
D: 不可中断的深度睡眠，一般由IO引起，同步IO在做读或写操作时，cpu不能做其它事情，只能等待，这时进程处于这种状态，如果程序采用异步IO，这种状态应该就很少见到了
其中就绪状态表示进程已经分配到除CPU以外的资源，等CPU调度它时就可以马上执行了。运行状态就是正在运行了，获得包括CPU在内的所有资源。等待状态表示因等待某个事件而没有被执行，这时候不耗CPU时间，而这个时间有可能是等待IO、申请不到足够的缓冲区或者在等待信号。

退出码是0到255的整数，通常0表示正常退出，其他数字表示不同的错误。


##活锁
进入活锁的进程是没有阻塞的，会继续使用CPU，但外界看到整个进程都没有前进。
举个很简单的例子，两个人相向过独木桥，他们同时向一边谦让，这样两个人都过不去，然后二者同时又移到另一边，这样两个人又过不去了。如果不受其他因素干扰，两个人一直同步在移动，但外界看来两个人都没有前进，这就是活锁。
活锁会导致CPU耗尽的，解决办法是引入随机变量、增加重试次数等。
所以活锁也是程序设计上可能存在的问题，导致进程都没办法运行下去了，还耗CPU。

##nohup
nohup的原理也很简单，终端关闭后会给此终端下的每一个进程发送SIGHUP信号，而使用nohup运行的进程则会忽略这个信号，因此终端关闭后进程也不会退出。

##进程锁
进程锁与线程锁、互斥量、读写锁和自旋锁不同，它是通过记录一个PID文件，避免两个进程同时运行的文件锁。
[crontab使用进程锁解决冲突](http://www.live-in.org/archives/1036.html)
###flock
flock [-sxun][-w #] fd#
flock [-sxon][-w #] file [-c] command...
常用选项：
-s, --shared ：获得一个共享的锁。
-x, --exclusive ：获得一个独占的锁。
-u, --unlock ：移除一个锁，通常是不需要的，脚本执行完后会自动丢弃锁。
-n, --nonblock ：如果没有立即获得锁直接失败而不是等待。
-w, --timeout ：如果没有立即获得锁就等待指定的时间。
-o, --close ：在运行命令前关闭文件的描述符。用于如果命令产生子进程时会不受锁的管控。
-c, --command ：在shell中运行一个单独的命令。
-h, --help ：显示帮助。
-V, --version ：显示版本。
*/1 * * * * /usr/bin/flock -xn /var/run/test.lock -c '/home/test.sh'

##孤儿进程
指的是在其父进程执行完成或被终止后仍继续运行的一类进程。
作用：
在现实中用户可能刻意使进程成为孤儿进程，这样就可以让它与父进程会话脱钩，成为后面会介绍的守护进程。

##僵尸进程
当一个进程完成它的工作终止之后，它的父进程需要调用wait()或者waitpid()系统调用取得子进程的终止状态。
一个进程使用fork创建子进程，如果子进程退出，而父进程并没有调用wait或waitpid获取子进程的状态信息，那么子进程的进程描述符仍然保存在系统中。这种进程称之为僵死进程
理解了孤儿进程和僵尸进程，我们临时加了守护进程这一小节，守护进程就是后台进程吗？没那么简单。

##守护(Daemon)进程
我们可以认为守护进程就是后台服务进程，因为它会有一个很长的生命周期提供服务，关闭终端不会影响服务，也就是说可以忽略某些信号。
###实现守护进程
首先要保证进程在后台运行，可以在启动程序后面加& 当然更原始的方法是进程自己fork然后结束父进程。
if (pid=fork()) {
  exit(0); // Parent process
}

nohup命令，是让程序以守护进程运行的方式之一，程序运行后忽略SIGHUP信号，也就说关闭终端不会影响进程的运行。
类似的命令还有disown，这里不再详述。


##Poll
Poll本质上是Linux系统调用，其接口为int poll(struct pollfd *fds,nfds_t nfds, int timeout)，作用是监控资源是否可用。
举个例子，一个Web服务器建了多个socket连接，它需要知道里面哪些连接传输发了请求需要处理，功能与select系统调用类似，不过poll不会清空文件描述符集合，因此检测大量socket时更加高效。
##Epoll
我们重点看看epoll，它大幅提升了高并发服务器的资源使用率，相比poll而言哦。前面提到poll会轮询整个文件描述符集合，而epoll可以做到只查询被内核IO事件唤醒的集合，当然它还提供边沿触发(Edge Triggered)等特性。
不知大家是否了解C10K问题，指的是服务器如何支持同时一万个连接的问题。如果是一万个连接就有至少一万个文件描述符，poll的效率也随文件描述符的更加而下降，epoll不存在这个问题是因为它仅关注活跃的socket。
##Mmap
无论是select、poll还是epoll，他们都要把文件描述符的消息送到用户空间，这就存在内核空间和用户空间的内存拷贝。其中epoll使用mmap来共享内存，提高效率。
Mmap不是进程的概念，这里提一下是因为epoll使用了它，这是一种共享内存的方法，而Go语言的设计宗旨是"不要通过共享来通信，通过通信来共享"，所以我们也可以思考下进程的设计，是使用mmap还是Go提供的channel机制呢。

##Copy On Write
一般我们运行程序都是Fork一个进程后马上执行Exec加载程序，而Fork的是否实际上用的是父进程的堆栈空间，Linux通过Copy On Write技术极大地减少了Fork的开销。
Copy On Write的含义是只有真正写的时候才把数据写到子进程的数据，Fork时只会把页表复制到子进程，这样父子进程都指向同一个物理内存页，只有再写子进程的时候才会把内存页的内容重新复制一份。

##Cgroups
Cgroups全称Control Groups，是Linux内核用于资源隔离的技术。目前Cgroups可以控制CPU、内存、磁盘访问。
使用
Cgroups是在Linux 2.6.24合并到内核的，不过项目在不断完善，3.8内核加入了对内存的控制(kmemcg)。
要使用Cgroups非常简单，阅读前建议看sysadmincasts的视频，https://sysadmincasts.com/episodes/14-introduction-to-linux-control-groups-cgroups。
我们首先在文件系统创建Cgroups组，然后修改这个组的属性，启动进程时指定加入的Cgroups组，这样进程相当于在一个受限的资源内运行了。
实现
Cgroups的实现也不是特别复杂。有一个特殊的数据结构记录进程组的信息。
有人可能已经知道Cgroups是Docker容器技术的基础，另一项技术也是大名鼎鼎的Namespaces。
##Namespaces简介
Linux Namespaces是资源隔离技术，在2.6.23合并到内核，而在3.12内核加入对用户空间的支持。
Namespaces是容器技术的基础，因为有了命名空间的隔离，才能限制容器之间的进程通信，像虚拟内存对于物理内存那样，开发者无需针对容器修改已有的代码。
使用Namespaces
阅读以下教程前建议看看，https://blog.jtlebi.fr/2013/12/22/introduction-to-linux-namespaces-part-1-uts/。
Linux内核提供了clone系统调用，创建进程时使用clone取代fork即刻创建同一命名空间下的进程。
更多参数建议man clone来学习。



##进程间通信 Interprocess Communication
###管道(Pipe)
[linux管道的那点事 ](http://blog.chinaunix.net/uid-27034868-id-3394243.html)
管道是进程间通信最简单的方式，任何进程的标准输出都可以作为其他进程的输入。

###信号(Signal)
信息只是告诉进程发生了什么事件，而不会传递任何数据。
信号种类
Linux中定义了很多信号，不同的Unixlike系统也不一样，我们可以通过下面的命令来查当前系统支持的种类。

    kill -l
    HUP INT QUIT ILL TRAP ABRT EMT FPE KILL BUS SEGV SYS PIPE ALRM TERM URG STOP TSTP CONT CHLD TTIN TTOU IO XCPU XFSZ VTALRM PROF WINCH INFO USR1 USR2

其中1至31的信号为传统UNIX支持的信号，是不可靠信号(非实时的)，32到63的信号是后来扩充的，称做可靠信号(实时信号).不可靠信号和可靠信号的区别在于前者不支持排队，可能会造成信号丢失，而后者不会

简单介绍几个我们最常用的，在命令行中止一个程序我们一般摁Ctrl+c，这就是发送SIGINT信号，而使用kill命令呢？默认是SIGTERM，加上-9参数才是SIGKILL。



###消息队列(Message)
和传统消息队列类似，但是在内核实现的。

###共享内存(Shared Memory)
后面也会有更详细的介绍。

###信号量(Semaphore)
信号量本质上是一个整型计数器，调用wait时计数减一，减到零开始阻塞进程，从而达到进程、线程间协作的作用。

###套接口(Socket)
也就是通过网络来通信，这也是最通用的IPC，不要求进程在同一台服务器上。







```c
//glibc-2.12.2\nptl\sysdeps\i386\pthread_spin_lock.c
#ifndef LOCK_PREFIX
# ifdef UP
#  define LOCK_PREFIX    /* nothing */
# else
#  define LOCK_PREFIX    "lock;"
# endif
#endif
 
int
pthread_spin_lock (lock)
     pthread_spinlock_t *lock;
{
  asm ("\n"
       "1:\t" LOCK_PREFIX "decl %0\n\t"
       "jne 2f\n\t"
       ".subsection 1\n\t"
       ".align 16\n"
       "2:\trep; nop\n\t"
       "cmpl $0, %0\n\t"
       "jg 1b\n\t"
       "jmp 2b\n\t"
       ".previous"
       : "=m" (*lock)
       : "m" (*lock));
 
  return 0;
}

```




















