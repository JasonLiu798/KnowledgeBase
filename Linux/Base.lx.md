
---
#filesystem
[Zero-Copy&sendfile浅析](http://blog.csdn.net/jiangbo_hit/article/details/6146502)
[sendfile:Linux中的"零拷贝"](http://blog.csdn.net/caianye/article/details/7576198)
1当调用read系统调用时，通过DMA（Direct Memory Access）将数据copy到内核模式[1 disk->Kernel]
2然后由CPU控制将内核模式数据copy到用户模式下的 buffer中[2 kernel->user buffer]
3read调用完成后，write调用首先将用户模式下 buffer中的数据copy到内核模式下的socket buffer中[3 user buffer->socket buffer]
4最后通过DMA copy将内核模式下的socket buffer中的数据copy到网卡设备中传送。[4 socket buffer->network card]

sendfile传送文件只需要一次系统调用，当调用 sendfile时：
1。首先通过DMA copy将数据从磁盘读取到kernel buffer中[1 disk->kernel buffer]
2。然后通过CPU copy将数据从kernel buffer copy到sokcet buffer中[2 kernel buffer->socket buffer]
3。最终通过DMA copy将socket buffer中数据copy到网卡buffer中发送[3 socket buffer->network buffer]
sendfile与read/write方式相比，少了一次模式切换一次CPU copy。但是从上述过程中也可以发现从kernel buffer中将数据copy到socket buffer是没必要的。

linux 2.4 改进后
改进后的处理过程如下：
1 DMA copy将磁盘数据copy到kernel buffer中
2 向socket buffer中追加当前要发送的数据在kernel buffer中的位置和偏移量
3 DMA gather copy根据socket buffer中的位置和偏移量直接将kernel buffer中的数据copy到网卡上。
经过上述过程，数据只经过了2次copy就从磁盘传送出去了。


Java NIO中的transferTo()
Java NIO中FileChannel.transferTo(long position, long count,WriteableByteChannel target)方法将当前通道中的数据传送到目标通道target中，在支持Zero-Copy的linux系统中，transferTo()的实现依赖于sendfile()调用。

《Zero Copy I: User-Mode Perspective》http://www.linuxjournal.com/article/6345?page=0,0
《Efficient data transfer through zero copy》http://www.ibm.com/developerworks/linux/library/j-zerocopy
《The C10K problem》http://www.kegel.com/c10k.html





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














