# Java并发结构
http://ifeve.com/java-concurrency-constructs/
http://gee.cs.oswego.edu/dl/cpj/mechanics.html
内容

线程
同步
监视器
线程
线程是一个独立执行的调用序列，同一个进程的线程在同一时刻共享一些系统资源（比如文件句柄等）也能访问同一个进程所创建的对象资源（内存资源）。java.lang.Thread对象负责统计和控制这种行为。

每个程序都至少拥有一个线程-即作为Java虚拟机(JVM)启动参数运行在主类main方法的线程。在Java虚拟机初始化过程中也可能启动其他的后台线程。这种线程的数目和种类因JVM的实现而异。然而所有用户级线程都是显式被构造并在主线程或者是其他用户线程中被启动。

这里对Thread类中的主要方法和属性以及一些使用注意事项作出总结。这些内容会在这本书(《Java Concurrency Constructs》)上进行进一步的讨论阐述。Java语言规范以及已发布的API文档中都会有更详细权威的描述。

构造方法
Thread类中不同的构造方法接受如下参数的不同组合：

一个Runnable对象，这种情况下，Thread.start方法将会调用对应Runnable对象的run方法。如果没有提供Runnable对象，那么就会立即得到一个Thread.run的默认实现。
一个作为线程标识名的String字符串，该标识在跟踪和调试过程中会非常有用，除此别无它用。
线程组（ThreadGroup），用来放置新创建的线程，如果提供的ThreadGroup不允许被访问，那么就会抛出一个SecurityException 。
Thread类本身就已经实现了Runnable接口，因此，除了提供一个用于执行的Runnable对象作为构造参数的办法之外，也可以创建一个Thread的子类，通过重写其run方法来达到同样的效果。然而，比较好的实践方法却是分开定义一个Runnable对象并用来作为构造方法的参数。将代码分散在不同的类中使得开发人员无需纠结于Runnable和Thread对象中使用的同步方法或同步块之间的内部交互。更普遍的是，这种分隔使得对操作的本身与其运行的上下文有着独立的控制。更好的是，同一个Runnable对象可以同时用来初始化其他的线程，也可以用于构造一些轻量化的执行框架(Executors)。另外需要提到的是通过继承Thread类实现线程的方式有一个缺点：使得该类无法再继承其他的类。

Thread对象拥有一个守护(daemon)标识属性，这个属性无法在构造方法中被赋值，但是可以在线程启动之前设置该属性(通过setDaemon方法)。当程序中所有的非守护线程都已经终止，调用setDaemon方法可能会导致虚拟机粗暴的终止线程并退出。isDaemon方法能够返回该属性的值。守护状态的作用非常有限，即使是后台线程在程序退出的时候也经常需要做一些清理工作。（daemon的发音为”day-mon”,这是系统编程传统的遗留，系统守护进程是一个持续运行的进程，比如打印机队列管理，它总是在系统中运行。）

启动线程
调用start方法会触发Thread实例以一个新的线程启动其run方法。新线程不会持有调用线程的任何同步锁。

当一个线程正常地运行结束或者抛出某种未检测的异常（比如，运行时异常(RuntimeException)，错误(ERROR) 或者其子类）线程就会终止。当线程终止之后，是不能被重新启动的。在同一个Thread上调用多次start方法会抛出InvalidThreadStateException异常。

如果线程已经启动但是还没有终止，那么调用isAlive方法就会返回true.即使线程由于某些原因处于阻塞(Blocked)状态该方法依然返回true。如果线程已经被取消(cancelled),那么调用其isAlive在什么时候返回false就因各Java虚拟机的实现而异了。没有方法可以得知一个处于非活动状态的线程是否已经被启动过了(译者注：即线程在开始运行前和结束运行后都会返回false，你无法得知处于false的线程具体的状态)。另一点，虽然一个线程能够得知同一个线程组的其他线程的标识，但是却无法得知自己是由哪个线程调用启动的。

优先级
Java虚拟机为了实现跨平台(不同的硬件平台和各种操作系统)的特性，Java语言在线程调度与调度公平性上未作出任何的承诺，甚至都不会严格保证线程会被执行。但是Java线程却支持优先级的方法，这些方法会影响线程的调度：

每个线程都有一个优先级，分布在Thread.MIN_PRIORITY和Thread.MAX_PRIORITY之间（分别为1和10）
默认情况下，新创建的线程都拥有和创建它的线程相同的优先级。main方法所关联的初始化线程拥有一个默认的优先级，这个优先级是Thread.NORM_PRIORITY (5).
线程的当前优先级可以通过getPriority方法获得。
线程的优先级可以通过setPriority方法来动态的修改，一个线程的最高优先级由其所在的线程组限定。

当可运行的线程数超过了可用的CPU数目的时候，线程调度器更偏向于去执行那些拥有更高优先级的线程。具体的策略因平台而异。比如有些Java虚拟机实现总是选择当前优先级最高的线程执行。有些虚拟机实现将Java中的十个优先级映射到系统所支持的更小范围的优先级上，因此，拥有不同优先级的线程可能最终被同等对待。还有些虚拟机会使用老化策略（随着时间的增长，线程的优先级逐渐升高）动态调整线程优先级，另一些虚拟机实现的调度策略会确保低优先级的线程最终还是能够有机会运行。设置线程优先级可以影响在同一台机器上运行的程序之间的调度结果，但是这不是必须的。

线程优先级对语义和正确性没有任何的影响。特别是，优先级管理不能用来代替锁机制。优先级仅仅是用来表明哪些线程是重要紧急的，当存在很多线程在激励进行CPU资源竞争的情况下，线程的优先级标识将会显得非常有用。比如，在ParticleApplet中将particle animation线程的优先级设置的比创建它们的applet线程低，在某些系统上能够提高对鼠标点击的响应，而且不会对其他功能造成影响。但是即使setPriority方法被定义为空实现，程序在设计上也应该保证能够正确执行（尽管可能会没有响应）。

下面这个表格列出不同类型任务在线程优先级设定上的通常约定。在很多并发应用中，在任一指定的时间点上，只有相对较少的线程处于可执行的状态（另外的线程可能由于各种原因处于阻塞状态），在这种情况下，没有什么理由需要去管理线程的优先级。另一些情况下，在线程优先级上的调整可能会对并发系统的调优起到一些作用。

范围  用途
10      Crisis management（应急处理）
7-9    Interactive, event-driven（交互相关，事件驱动）
4-6    IO-bound（IO限制类）
2-3    Background computation（后台计算）
1        Run only if nothing else can（仅在没有任何线程运行时运行的）

控制方法
只有很少几个方法可以用于跨线程交流：

每个线程都有一个相关的Boolean类型的中断标识。在线程t上调用t.interrupt会将该线程的中断标识设为true，除非线程t正处于Object.wait,Thread.sleep,或者Thread.join,这些情况下interrupt调用会导致t上的这些操作抛出InterruptedException异常，但是t的中断标识会被设为false。
任何一个线程的中断状态都可以通过调用isInterrupted方法来得到。如果线程已经通过interrupt方法被中断，这个方法将会返回true。
但是如果调用了Thread.interrupted方法且中断标识还没有被重置，或者是线程处于wait，sleep，join过程中，调用isInterrupted方法将会抛出InterruptedException异常。调用t.join()方法将会暂停执行调用线程，直到线程t执行完毕：当t.isAlive()方法返回false的时候调用t.join()将会直接返回(return)。另一个带参数毫秒(millisecond)的join方法在被调用时，如果线程没能够在指定的时间内完成，调用线程将重新得到控制权。因为isAlive方法的实现原理，所以在一个还没有启动的线程上调用join方法是没有任何意义的。同样的，试图在一个还没有创建的线程上调用join方法也是不明智的。
起初，Thread类还支持一些另外一些控制方法：suspend,resume,stop以及destroy。这几个方法已经被声明过期。其中destroy方法从来没有被实现，估计以后也不会。而通过使用等待/唤醒机制增加suspend和resume方法在安全性和可靠性的效果有所欠缺，将在3.2章节进行具体讨论。而stop方法所带来的问题也将在3.1.2.3进行探讨。

静态方法
Thread类中的部分方法被设计为只适用于当前正在运行的线程（即调用Thread方法的线程）。为强调这点，这些方法都被声明为静态的。

Thread.currentThread方法会返回当前线程的引用，得到这个引用可以用来调用其他的非静态方法，比如Thread.currentThread().getPriority()会返回调用线程的优先级。
Thread.interrupted方法会清除当前线程的中断状态并返回前一个状态。（一个线程的中断状态是不允许被其他线程清除的）
Thread.sleep(long msecs)方法会使得当前线程暂停执行至少msecs毫秒。
Thread.yield方法纯粹只是建议Java虚拟机对其他已经处于就绪状态的线程（如果有的话）调度执行，而不是当前线程。最终Java虚拟机如何去实现这种行为就完全看其喜好了。

尽管缺乏保障，但在不支持分时间片/可抢占式的线程调度方式的单CPU的Java虚拟机实现上，yield方法依然能够起到切实的作用。在这种情况下，线程只在被阻塞的情况下（比如等待IO，或是调用了sleep等）才会进行重新调度。在这些系统上，那些执行非阻塞的耗时的计算任务的线程就会占用CPU很长的时间，最终导致应用的响应能力降低。如果一个非阻塞的耗时计算线程会导致时间处理线程或者其他交互线程超出可容忍的限度的话，就可以在其中插入yield操作(或者是sleep)，使得具有较低线程优先级的线程也可以执行。为了避免不必要的影响，你可以只在偶然间调用yield方法，比如，可以在一个循环中插入如下代码:if (Math.random() < 0.01) Thread.yield();

在支持可抢占式调度的Java虚拟机实现上，线程调度器忽略yield操作可能是最完美的策略，特别是在多核处理器上。

线程组
每一个线程都是一个线程组中的成员。默认情况下，新建线程和创建它的线程属于同一个线程组。线程组是以树状分布的。当创建一个新的线程组，这个线程组成为当前线程组的子组。getThreadGroup方法会返回当前线程所属的线程组，对应地，ThreadGroup类也有方法可以得到哪些线程目前属于这个线程组，比如enumerate方法。

ThreadGroup类存在的一个目的是支持安全策略来动态的限制对该组的线程操作。比如对不属于同一组的线程调用interrupt是不合法的。这是为避免某些问题(比如，一个applet线程尝试杀掉主屏幕的刷新线程)所采取的措施。ThreadGroup也可以为该组所有线程设置一个最大的线程优先级。

线程组往往不会直接在程序中被使用。在大多数的应用中，如果仅仅是为在程序中跟踪线程对象的分组，那么普通的集合类（比如java.util.Vector）应是更好的选择。

在ThreadGroup类为数不多的几个方法中，uncaughtException方法却是非常有用的，当线程组中的某个线程因抛出未检测的异常（比如空指针异常NullPointerException）而中断的时候，调用这个方法可以打印出线程的调用栈信息。

同步
对象与锁
每一个Object类及其子类的实例都拥有一个锁。其中，标量类型int，float等不是对象类型，但是标量类型可以通过其包装类来作为锁。单独的成员变量是不能被标明为同步的。锁只能用在使用了这些变量的方法上。然而正如在2.2.7.4上描述的，成员变量可以被声明为volatile，这种方式会影响该变量的原子性，可见性以及排序性。

类似的，持有标量变量元素的数组对象拥有锁，但是其中的标量元素却不拥有锁。（也就是说，没有办法将数组成员声明为volatile类型的）。如果锁住了一个数组并不代表其数组成员都可以被原子的锁定。也没有能在一个原子操作中锁住多个对象的方法。

Class实例本质上是个对象。正如下所述，在静态同步方法中用的就是类对象的锁。

同步方法和同步块
使用synchronized关键字，有两种语法结构：同步代码块和同步方法。同步代码块需要提供一个作为锁的对象参数。这就允许了任意方法可以去锁任一一个对象。但在同步代码块中使用的最普通的参数却是this。

同步代码块被认为比同步方法更加的基础。如下两种声明方式是等同的：

1
synchronized void f() { /* body */ }
2
void f() { synchronized(this) { /* body */ } }
synchronized关键字并不是方法签名的一部分。所以当子类覆写父类中的同步方法或是接口中声明的同步方法的时候，synchronized修饰符是不会被自动继承的，另外，构造方法不可能是真正同步的（尽管可以在构造方法中使用同步块）。

同步实例方法在其子类和父类中使用同样的锁。但是内部类方法的同步却独立于其外部类， 然而一个非静态的内部类方法可以通过下面这种方式锁住其外部类：

1
synchronized(OuterClass.this) { /* body */ }
等待锁与释放锁
使用synchronized关键字须遵循一套内置的锁等待-释放机制。所有的锁都是块结构的。当进入一个同步方法或同步块的时候必须获得该锁，而退出的时候（即使是异常退出）必须释放这个锁。你不能忘记释放锁。

锁操作是建立在独立的线程上的而不是独立的调用基础上。一个线程能够进入一个同步代码的条件是当前锁未被占用或者是当前线程已经占用了这个锁，否则线程就会阻塞住。（这种可重入锁或是递归锁不同于POSIX线程）。这就允许一个同步方法可以去直接调用同一个锁管理的另一个同步方法，而不需要被冻结（注：即不需要再经历释放锁-阻塞-申请锁的过程）。

同步方法或同步块遵循这种锁获取/锁释放的机制有一个前提，那就是所有的同步方法或同步块都是在同一个锁对象上。如果一个同步方法正在执行中，其他的非同步方法也可以在任何时候执行。也就是说，同步不等于原子性，但是同步机制可以用来实现原子性。

当一个线程释放锁的时候，另一个线程可能正等待这个锁（也可能是同一个线程，因为这个线程可能需要进入另一个同步方法）。但是关于哪一个线程能够紧接着获得这个锁以及什么时候，这是没有任何保证的。（也就是，没有任何的公平性保证-见3.4.1.5）另外，没有什么办法能够得到一个给定的锁正被哪个线程拥有着。

正如2.2.7讨论的，除了锁控制之外，同步也会对底层的内存系统带来副作用。

静态变量/方法
锁住一个对象并不会原子性的保护该对象类或其父类的静态成员变量。而应该通过同步的静态方法或代码块来保证访问一个静态的成员变量。静态同步使用的是静态方法锁声明的类对象所拥有的锁。类C的静态锁可以通过内置的实例方法获取到：
synchronized(C.class) { /* body */ }

每个类所对应的静态锁和其他的类（包括其父类）没有任何的关系。通过在子类中增加一个静态同步方法来试图保护父类中的静态成员变量是无效的。应使用显式的代码块来代替。

如下这种方式也是一种不好的实践：
synchronized(getClass()) { /* body */ } // Do not use
这种方式，可能锁住的实际中的类，并不是需要保护的静态成员变量所对应的类（有可能是其子类）

Java虚拟机在类加载和类初始化阶段，内部获得并释放类锁。除非你要去写一个特殊的类加载器或者需要使用多个锁来控制静态初始顺序，这些内部机制不应该干扰普通类对象的同步方法和同步块的使用。Java虚拟机没有什么内部操作可以独立的获取你创建和使用的类对象的锁。然而当你继承java.*的类的时候，你需要特别小心这些类中使用的锁机制。

监视器
正如每个对象都有一个锁一样，每一个对象同时拥有一个由这些方法(wait,notify,notifyAll,Thread,interrupt)管理的一个等待集合。拥有锁和等待集合的实体通常被称为监视器（虽然每种语言定义的细节略有不同），任何一个对象都可以作为一个监视器。

对象的等待集合是由Java虚拟机来管理的。每个等待集合上都持有在当前对象上等待但尚未被唤醒或是释放的阻塞线程。

因为与等待集合交互的方法（wait，notify，notifyAll）只在拥有目标对象的锁的情况下才被调用，因此无法在编译阶段验证其正确性，但在运行阶段错误的操作会导致抛出IllegalMonitorStateException异常。

这些方法的操作描述如下：

Wait
调用wait方法会产生如下操作：

如果当前线程已经终止，那么这个方法会立即退出并抛出一个InterruptedException异常。否则当前线程就进入阻塞状态。
Java虚拟机将该线程放置在目标对象的等待集合中。
释放目标对象的同步锁，但是除此之外的其他锁依然由该线程持有。即使是在目标对象上多次嵌套的同步调用，所持有的可重入锁也会完整的释放。这样，后面恢复的时候，当前的锁状态能够完全地恢复。
Notify
调用Notify会产生如下操作：

Java虚拟机从目标对象的等待集合中随意选择一个线程(称为T，前提是等待集合中还存在一个或多个线程)并从等待集合中移出T。当等待集合中存在多个线程时，并没有机制保证哪个线程会被选择到。
线程T必须重新获得目标对象的锁，直到有线程调用notify释放该锁，否则线程会一直阻塞下去。如果其他线程先一步获得了该锁，那么线程T将继续进入阻塞状态。
线程T从之前wait的点开始继续执行。
NotifyAll

notifyAll方法与notify方法的运行机制是一样的，只是这些过程是在对象等待集合中的所有线程上发生（事实上，是同时发生）的。但是因为这些线程都需要获得同一个锁，最终也只能有一个线程继续执行下去。

Interrupt（中断）
如果在一个因wait而中断的线程上调用Thread.interrupt方法，之后的处理机制和notify机制相同，只是在重新获取这个锁之后，该方法将会抛出一个InterruptedException异常并且线程的中断标识将被设为false。如果interrupt操作和一个notify操作在同一时间发生，那么不能保证那个操作先被执行，因此任何一个结果都是可能的。（JLS的未来版本可能会对这些操作结果提供确定性保证）

Timed Wait（定时等待）
定时版本的wait方法，wait(long mesecs)和wait(long msecs,int nanosecs),参数指定了需要在等待集合中等待的最大时间值。如果在时间限制之内没有被唤醒，它将自动释放，除此之外，其他的操作都和无参数的wait方法一样。并没有状态能够表明线程正常唤醒与超时唤醒之间的不同。需要注意的是，wait(0)与wait(0,0)方法其实都具有特殊的意义，其相当于不限时的wait()方法，这可能与你的直觉相反。

由于线程竞争，调度策略以及定时器粒度等方面的原因，定时等待方法可能会消耗任意的时间。（注：关于定时器粒度并没有任何的保证，目前大多数的Java虚拟机实现当参数设置小于1毫秒的时候，观察的结果基本上在1～20毫秒之间）

Thread.sleep(long msecs)方法使用了定时等待的wait方法，但是使用的并不是当前对象的同步锁。它的效果如下描述：
if (msecs != 0)  {
Object s = new Object();
synchronized(s) { s.wait(msecs); }
}
当然，系统不需要使用这种方式去实现sleep方法。需要注意的，sleep(0)方法的含义是中断线程至少零时间，随便怎么解释都行。（译者注：该方法有着特殊的作用，从原理上它可以促使系统重新进行一次CPU竞争）。

原文
Threads
A thread is a call sequence that executes independently of others, while at the same time possibly sharing underlying system resources such as files, as well as accessing other objects constructed within the same program (see �1.2.2). A java.lang.Thread object maintains bookkeeping and control for this activity.

Every program consists of at least one thread – the one that runs the main method of the class provided as a startup argument to the Java virtual machine (“JVM”). Other internal background threads may also be started during JVM initialization. The number and nature of such threads vary across JVM implementations. However, all user-level threads are explicitly constructed and started from the main thread, or from any other threads that they in turn create.

Here is a summary of the principal methods and properties of class Thread, as well as a few usage notes. They are further discussed and illustrated throughout this book. The JavaTM Language Specification (“JLS”) and the published API documentation should be consulted for more detailed and authoritative descriptions.

Construction

Different Thread constructors accept combinations of arguments supplying:

A Runnable object, in which case a subsequent Thread.start invokes run of the supplied Runnable object. If no Runnable is supplied, the default implementation of Thread.run returns immediately.
A String that serves as an identifier for the Thread. This can be useful for tracing and debugging, but plays no other role.
The ThreadGroup in which the new Thread should be placed. If access to the ThreadGroup is not allowed, a SecurityException is thrown.
Class Thread itself implements Runnable. So, rather than supplying the code to be run in a Runnable and using it as an argument to a Thread constructor, you can create a subclass of Thread that overrides the run method to perform the desired actions. However, the best default strategy is to define a Runnable as a separate class and supply it in a Thread constructor. Isolating code within a distinct class relieves you of worrying about any potential interactions of synchronized methods or blocks used in the Runnable with any that may be used by methods of class Thread. More generally, this separation allows independent control over the nature of the action and the context in which it is run: The same Runnable can be supplied to threads that are otherwise initialized in different ways, as well as to other lightweight executors (see �4.1.4). Also note that subclassing Thread precludes a class from subclassing any other class.

Thread objects also possess a daemon status attribute that cannot be set via any Thread constructor, but may be set only before a Thread is started. The method setDaemon asserts that the JVM may exit, abruptly terminating the thread, so long as all other non-daemon threads in the program have terminated. The isDaemon method returns status. The utility of daemon status is very limited. Even background threads often need to do some cleanup upon program exit. (The spelling of daemon, often pronounced as “day-mon”, is a relic of systems programming tradition. System daemons are continuous processes, for example print-queue managers, that are “always” present on a system.)

Starting threads

Invoking its start method causes an instance of class Thread to initiate its run method as an independent activity. None of the synchronization locks held by the caller thread are held by the new thread (see �2.2.1).

A Thread terminates when its run method completes by either returning normally or throwing an unchecked exception (i.e., RuntimeException, Error, or one of their subclasses). Threads are not restartable, even after they terminate. Invoking start more than once results in an InvalidThreadStateException.

The method isAlive returns true if a thread has been started but has not terminated. It will return true if the thread is merely blocked in some way. JVM implementations have been known to differ in the exact point at which isAlive returns false for threads that have been cancelled (see �3.1.2). There is no method that tells you whether a thread that is not isAlive has ever been started. Also, one thread cannot readily determine which other thread started it, although it may determine the identities of other threads in its ThreadGroup (see �1.1.2.6).

Priorities

To make it possible to implement the Java virtual machine across diverse hardware platforms and operating systems, the Java programming language makes no promises about scheduling or fairness, and does not even strictly guarantee that threads make forward progress (see �3.4.1.5). But threads do support priority methods that heuristically influence schedulers:

Each Thread has a priority, ranging between Thread.MIN_PRIORITY and Thread.MAX_PRIORITY (defined as 1 and 10 respectively).
By default, each new thread has the same priority as the thread that created it. The initial thread associated with a main by default has priority Thread.NORM_PRIORITY (5).
The current priority of any thread can be accessed via method getPriority.
The priority of any thread can be dynamically changed via method setPriority. The maximum allowed priority for a thread is bounded by its ThreadGroup.
When there are more runnable (see �1.3.2) threads than available CPUs, a scheduler is generally biased to prefer running those with higher priorities. The exact policy may and does vary across platforms. For example, some JVM implementations always select the thread with the highest current priority (with ties broken arbitrarily). Some JVM implementations map the ten Thread priorities into a smaller number of system-supported categories, so threads with different priorities may be treated equally. And some mix declared priorities with aging schemes or other scheduling policies to ensure that even low-priority threads eventually get a chance to run. Also, setting priorities may, but need not, affect scheduling with respect to other programs running on the same computer system.

Priorities have no other bearing on semantics or correctness (see �1.3). In particular, priority manipulations cannot be used as a substitute for locking. Priorities can be used only to express the relative importance or urgency of different threads, where these priority indications would be useful to take into account when there is heavy contention among threads trying to get a chance to execute. For example, setting the priorities of the particle animation threads in ParticleApplet below that of the applet thread constructing them might on some systems improve responsiveness to mouse clicks, and would at least not hurt responsiveness on others. But programs should be designed to run correctly (although perhaps not as responsively) even if setPriority is defined as a no-op. (Similar remarks hold for yield; see �1.1.2.5.)

The following table gives one set of general conventions for linking task categories to priority settings. In many concurrent applications, relatively few threads are actually runnable at any given time (others are all blocked in some way), in which case there is little reason to manipulate priorities. In other cases, minor tweaks in priority settings may play a small part in the final tuning of a concurrent system.

Range	Use
10	Crisis management
7-9	Interactive, event-driven
4-6	IO-bound
2-3	Background computation
1	Run only if nothing else can
Control methods

Only a few methods are available for communicating across threads:

Each Thread has an associated boolean interruption status (see �3.1.2). Invoking t.interrupt for some Thread t sets t’s interruption status to true, unless Thread t is engaged in Object.wait, Thread.sleep, or Thread.join; in this case interrupt causes these actions (in t) to throw InterruptedException, but t’s interruption status is set to false.
The interruption status of any Thread can be inspected using method isInterrupted. This method returns true if the thread has been interrupted via the interrupt method but the status has not since been reset either by the thread invoking Thread.interrupted (see �1.1.2.5) or in the course of wait, sleep, or join throwing InterruptedException.
Invoking t.join() for Thread t suspends the caller until the target Thread t completes: the call to t.join() returns when t.isAlive() is false (see �4.3.2). A version with a (millisecond) time argument returns control even if the thread has not completed within the specified time limit. Because of how isAlive is defined, it makes no sense to invoke join on a thread that has not been started. For similar reasons, it is unwise to try to join a Thread that you did not create.
Originally, class Thread supported the additional control methods suspend, resume, stop, and destroy. Methods suspend, resume, and stop have since been deprecated; method destroy has never been implemented in any release and probably never will be. The effects of methods suspend and resume can be obtained more safely and reliably using the waiting and notification techniques discussed in �3.2. The problems surrounding stop are discussed in �3.1.2.3.

Static methods

Some Thread class methods are designed to be applied only to the thread that is currently running (i.e., the thread making the call to the Thread method). To enforce this, these methods are declared as static.

Thread.currentThread returns a reference to the current Thread. This reference may then be used to invoke other (non-static) methods. For example, Thread.currentThread().getPriority() returns the priority of the thread making the call.
Thread.interrupted clears interruption status of the current Thread and returns previous status. (Thus, one Thread’s interruption status cannot be cleared from other threads.)
Thread.sleep(long msecs) causes the current thread to suspend for at least msecs milliseconds (see �3.2.2).
Thread.yield is a purely heuristic hint advising the JVM that if there are any other runnable but non-running threads, the scheduler should run one or more of these threads rather than the current thread. The JVM may interpret this hint in any way it likes.

Despite the lack of guarantees, yield can be pragmatically effective on some single-CPU JVM implementations that do not use time-sliced pre-emptive scheduling (see �1.2.2). In this case, threads are rescheduled only when one blocks (for example on IO, or via sleep). On these systems, threads that perform time-consuming non-blocking computations can tie up a CPU for extended periods, decreasing the responsiveness of an application. As a safeguard, methods performing non-blocking computations that might exceed acceptable response times for event handlers or other reactive threads can insert yields (or perhaps even sleeps) and, when desirable, also run at lower priority settings. To minimize unnecessary impact, you can arrange to invoke yield only occasionally; for example, a loop might contain:
if (Math.random() < 0.01) Thread.yield();

On JVM implementations that employ pre-emptive scheduling policies, especially those on multiprocessors, it is possible and even desirable that the scheduler will simply ignore this hint provided by yield.

ThreadGroups

Every Thread is constructed as a member of a ThreadGroup, by default the same group as that of the Thread issuing the constructor for it. ThreadGroups nest in a tree-like fashion. When an object constructs a new ThreadGroup, it is nested under its current group. The method getThreadGroup returns the group of any thread. The ThreadGroup class in turn supports methods such as enumerate that indicate which threads are currently in the group.

One purpose of class ThreadGroup is to support security policies that dynamically restrict access to Thread operations; for example, to make it illegal to interrupt a thread that is not in your group. This is one part of a set of protective measures against problems that could occur, for example, if an applet were to try to kill the main screen display update thread. ThreadGroups may also place a ceiling on the maximum priority that any member thread can possess.

ThreadGroups tend not to be used directly in thread-based programs. In most applications, normal collection classes (for example java.util.Vector) are better choices for tracking groups of Thread objects for application-dependent purposes.

Among the few ThreadGroup methods that commonly come into play in concurrent programs is method uncaughtException, which is invoked when a thread in a group terminates due to an uncaught unchecked exception (for example a NullPointerException). This method normally causes a stack trace to be printed.

Synchronization
Objects and locks

Every instance of class Object and its subclasses possesses a lock. Scalars of type int, float, etc., are not Objects. Scalar fields can be locked only via their enclosing objects. Individual fields cannot be marked as synchronized. Locking may be applied only to the use of fields within methods. However, as described in �2.2.7.4, fields can be declared as volatile, which affects atomicity, visibility, and ordering properties surrounding their use.

Similarly, array objects holding scalar elements possess locks, but their individual scalar elements do not. (Further, there is no way to declare array elements as volatile.) Locking an array of Objects does not automatically lock all its elements. There are no constructs for simultaneously locking multiple objects in a single atomic operation.

Class instances are Objects. As described below, the locks associated with Class objects are used in static synchronized methods.

Synchronized methods and blocks

There are two syntactic forms based on the synchronized keyword, blocks and methods. Block synchronization takes an argument of which object to lock. This allows any method to lock any object. The most common argument to synchronized blocks is this.

Block synchronization is considered more fundamental than method synchronization. A declaration:
synchronized void f() { /* body */ }
is equivalent to:
void f() { synchronized(this) { /* body */ } }

The synchronized keyword is not considered to be part of a method’s signature. So the synchronized modifier is not automatically inherited when subclasses override superclass methods, and methods in interfaces cannot be declared as synchronized. Also, constructors cannot be qualified as synchronized (although block synchronization can be used within constructors).

Synchronized instance methods in subclasses employ the same lock as those in their superclasses. But synchronization in an inner class method is independent of its outer class. However, a non-static inner class method can lock its containing class, say OuterClass, via code blocks using:
synchronized(OuterClass.this) { /* body */ }.

Acquiring and releasing locks

Locking obeys a built-in acquire-release protocol controlled only by use of the synchronized keyword. All locking is block-structured. A lock is acquired on entry to a synchronized method or block, and released on exit, even if the exit occurs due to an exception. You cannot forget to release a lock.

Locks operate on a per-thread, not per-invocation basis. A thread hitting synchronized passes if the lock is free or the thread already possess the lock, and otherwise blocks. (This reentrant or recursive locking differs from the default policy used for example in POSIX threads.) Among other effects, this allows one synchronized method to make a self-call to another synchronized method on the same object without freezing up.

A synchronized method or block obeys the acquire-release protocol only with respect to other synchronized methods and blocks on the same target object. Methods that are not synchronized may still execute at any time, even if a synchronized method is in progress. In other words, synchronized is not equivalent to atomic, but synchronization can be used to achieve atomicity.

When one thread releases a lock, another thread may acquire it (perhaps the same thread, if it hits another synchronized method). But there is no guarantee about which of any blocked threads will acquire the lock next or when they will do so. (In particular, there are no fairness guarantees – see �3.4.1.5.) There is no mechanism to discover whether a given lock is being held by some thread.

As discussed in �2.2.7, in addition to controlling locking, synchronized also has the side-effect of synchronizing the underlying memory system.

Statics

Locking an object does not automatically protect access to static fields of that object’s class or any of its superclasses. Access to static fields is instead protected via synchronized static methods and blocks. Static synchronization employs the lock possessed by the Class object associated with the class the static methods are declared in. The static lock for class C can also be accessed inside instance methods via:
synchronized(C.class) { /* body */ }

The static lock associated with each class is unrelated to that of any other class, including its superclasses. It is not effective to add a new static synchronized method in a subclass that attempts to protect static fields declared in a superclass. Use the explicit block version instead.

It is also poor practice to use constructions of the form:
synchronized(getClass()) { /* body */ } // Do not use

This locks the actual class, which might be different from (a subclass of) the class defining the static fields that need protecting.

The JVM internally obtains and releases the locks for Class objects during class loading and initialization. Unless you are writing a special ClassLoader or holding multiple locks during static initialization sequences, these internal mechanics cannot interfere with the use of ordinary methods and blocks synchronized on Class objects. No other internal JVM actions independently acquire any locks for any objects of classes that you create and use. However, if you subclass java.* classes, you should be aware of the locking policies used in these classes.

Monitors
In the same way that every Object has a lock (see �2.2.1), every Object has a wait set that is manipulated only by methods wait, notify, notifyAll, and Thread.interrupt. Entities possessing both locks and wait sets are generally called monitors (although almost every language defines details somewhat differently). Any Object can serve as a monitor.

The wait set for each object is maintained internally by the JVM. Each set holds threads blocked by wait on the object until corresponding notifications are invoked or the waits are otherwise released.

Because of the way in which wait sets interact with locks, the methods wait, notify, and notifyAll may be invoked only when the synchronization lock is held on their targets. Compliance generally cannot be verified at compile time. Failure to comply causes these operations to throw an IllegalMonitorStateException at run time.

The actions of these methods are as follows:

Wait
A wait invocation results in the following actions:
If the current thread has been interrupted, then the method exits immediately, throwing an InterruptedException. Otherwise, the current thread is blocked.
The JVM places the thread in the internal and otherwise inaccessible wait set associated with the target object.
The synchronization lock for the target object is released, but all other locks held by the thread are retained. A full release is obtained even if the lock is re-entrantly held due to nested synchronized calls on the target object. Upon later resumption, the lock status is fully restored.
Notify
A notify invocation results in the following actions:
If one exists, an arbitrarily chosen thread, say T, is removed by the JVM from the internal wait set associated with the target object. There is no guarantee about which waiting thread will be selected when the wait set contains more than one thread – see �3.4.1.5.
T must re-obtain the synchronization lock for the target object, which will always cause it to block at least until the thread calling notify releases the lock. It will continue to block if some other thread obtains the lock first.
T is then resumed from the point of its wait.
NotifyAll
A notifyAll works in the same way as notify except that the steps occur (in effect, simultaneously) for all threads in the wait set for the object. However, because they must acquire the lock, threads continue one at a time. 
Interrupt
If Thread.interrupt is invoked for a thread suspended in a wait, the same notify mechanics apply, except that after re-acquiring the lock, the method throws an InterruptedException and the thread’s interruption status is set to false. If an interrupt and a notify occur at about the same time, there is no guarantee about which action has precedence, so either result is possible. (Future revisions of JLS may introduce deterministic guarantees about these outcomes.) 
Timed Waits
The timed versions of the wait method, wait(long msecs) and wait(long msecs, int nanosecs), take arguments specifying the desired maximum time to remain in the wait set. They operate in the same way as the untimed version except that if a wait has not been notified before its time bound, it is released automatically. There is no status indication differentiating waits that return via notifications versus time-outs. Counterintuitively, wait(0) and wait(0, 0) both have the special meaning of being equivalent to an ordinary untimed wait().A timed wait may resume an arbitrary amount of time after the requested bound due to thread contention, scheduling policies, and timer granularities. (There is no guarantee about granularity. Most JVM implementations have observed response times in the 1-20ms range for arguments less than 1ms.)The Thread.sleep(long msecs) method uses a timed wait, but does not tie up the current object’s synchronization lock. It acts as if it were defined as:
    if (msecs != 0)  {
      Object s = new Object(); 
      synchronized(s) { s.wait(msecs); }
    }
Of course, a system need not implement sleep in exactly this way. Note that sleep(0) pauses for at least no time, whatever that means.
