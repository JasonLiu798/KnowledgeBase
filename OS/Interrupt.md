



#中断（广义）

	 | 产生的位置			| 发生的时刻 			| 时序
-----|----------------------|-----------------------|----------------
中断 | CPU外部				| 随机					| 异步
异常 | CPU正在执行的程序	| 一条指令终止执行后	| 同步

由中断或异常执行的代码不是一个进程，而是一个内核控制路径，代表中断发生时正在运行的进程的执行
中断处理程序与正在运行的程序无关
引起异常处理程序的进程正是异常处理程序运行时的当前进程

##特点
1.（1）尽可能快
（2）能以嵌套的方式执行，但是同种类型的中断不可以嵌套
（3）尽可能地限制临界区，因为在临界区中，中断被禁止

2.大部分异常发生在用户态，缺页异常是唯一发生于内核态能触发的异常
缺页异常意味着进程切换，因此中断处理程序从不执行可以导致缺页的操作

3.中断处理程序运行于内核态
中断发生于用户态时，要把进程的用户空间堆栈切换到进程的系统空间堆栈，刚切换时，内核堆栈是空的
中断发生于内核态时， 不需要堆栈空间的切换

##分类
1.中断的分类：可屏蔽中断、不可屏蔽中断
2.异常的分类：

分类	 | 解决异常的方法			| 举例
---------|--------------------------|--------------------------------
故障	 | 那条指令会被重新执行		| 缺页异常处理程序
陷阱	 | 会从下一条指令开始执行	| 调试程序
异常中止 | 强制受影响的进程终止		| 发生了一个严重的错误



----
#IRQ
1.硬件设备控制器通过IRQ线向CPU发出中断，可以通过禁用某条IRQ线来屏蔽中断。
2.被禁止的中断不会丢失，激活IRQ后，中断还会被发到CPU
3.激活/禁止IRQ线 ！= 可屏蔽中断的 全局屏蔽/非屏蔽


##高级可编程中断控制器
APIC
多CPU的 静态分发，动态分发（轮转）
IPI 处理器间中断


---------
#IDT 
中断描述符表是一个系统表，它与每一个中断或异常向量相联系，每一个向量在表中有相应的中断或异常处理程序入口地址。
在允许发生中断以前，必须适当地初始化IDT
TSS只能位于GDT中，IDT能位于内存的任何的地方


##中断描述符
硬件提供的中断描述符：
（1）任务门：中断信号发生时，必须取代当前进程的那个进程的TSS选择符存放在任务门中
（2）中断门：包含段选择符和中断处理程序的段内偏移
（3）陷阱门：与中断门的唯一区别是，通过中断门进入服务程序后，自动关中断，而通过陷阱门进入服务程序不自动关中断


中断描述符的类型|用户态能否访问	|	用户态的访问方式	|能激活的程序
----------------|---------------|------------------------|-----------------
中断门			|否 		   	| 			|	 所有的Linux中断处理程序
系统门			|是				|into、bound、int $0x80	| 向量号为4，5，128的三个Linux异常处理程序
系统中断门		|是				| int 3		| 与向量3相关的异常处理程序
陷阱门			|否				| 			| 大部分Linux异常处理程序
任务门			|否				|		 	| Linux对Double fault异常的处理程序


##初始化
1.两次初始化
 	运行模式	初始值	使用者
第一次	实模式	空处理程序	BIOS例程
第二次	保护模式	有意义的中断处理程序或异常处理程序	Linux系统

2.在IDT表的初始化完成之初，每个中断处理队列都是空的，此时即使打开中断并且某个外设中断真的发生了，也得不到实际的服务，因为没有执行具体的中断处理程序。
真正的中断服务要到具体设备的初始化程序将其中断处理程序ISR挂入某个中断请求队列后才会发生

3.在允许发生中断以前，必须适当地初始化IDT




----
#异常处理
标准结构
1.在内核堆栈中保存大多数寄存器内容
2.用高级的C函数处理异常
3.通过ret_from_exception()函数从异常处理程序退出


---
#中断处理
中断类型：
I/O中断
时钟中断
处理器间中断

##I/O中断处理
IRQ共享
中断程序执行多个ISR(interrupt service routine)
IRQ动态分配
一条IRQ线最后时刻才与一个设备驱动程序相关联

中断要执行的操作三类：
紧急的 critical
非紧急的 Noncritical
非紧急可延迟的 Noncritical deferrable

四个基本操作：
1.在内核态堆栈中保存IRQ的值和寄存器的内容
2.为正在给IRQ线服务的PIC发送一个应答，将允许PIC进一步发出中断
3.执行共享这个IRQ的所有设备的ISR
4.跳到ret_from_intr()的地址后终止

###中断向量

###IRQ数据结构
irq_desc_t

定义PIC对象的数据结构
hw_interrupt_type

irqaction描述符

###IRQ在多处理器上的分发

###多种类型的内核栈
异常栈
硬中断请求栈
软中断请求栈

###为中断处理程序保存寄存器的值

###do_IRQ()函数
irq_enter()宏

__do_IRQ函数


###挽救丢失的中断

###中断服务例程

###IRQ线的动态分配


---
#软中断 tasklet 工作队列
[Linux内核中的软中断、tasklet和工作队列详解](http://blog.csdn.net/godleading/article/details/52971179)
软中断、tasklet和工作队列并不是Linux内核中一直存在的机制，而是由更早版本的内核中的“下半部”（bottom half）演变而来。下半部的机制实际上包括五种，但2.6版本的内核中，下半部和任务队列的函数都消失了，只剩下了前三者。本文重点在于介绍这三者之间的关系。（函数细节将不会在本文中出现，可以参考文献，点这里）


##上半部和下半部的区别
上半部指的是中断处理程序
下半部则指的是一些虽然与中断有相关性但是可以延后执行的任务
举个例子：在网络传输中，网卡接收到数据包这个事件不一定需要马上被处理，适合用下半部去实现；但是用户敲击键盘这样的事件就必须马上被响应，应该用中断实现。

两者的主要区别在于：中断不能被相同类型的中断打断，而下半部依然可以被中断打断；中断对于时间非常敏感，而下半部基本上都是一些可以延迟的工作。由于二者的这种区别，所以对于一个工作是放在上半部还是放在下半部去执行，可以参考下面四条：
a）如果一个任务对时间非常敏感，将其放在中断处理程序中执行。
b）如果一个任务和硬件相关，将其放在中断处理程序中执行。
c）如果一个任务要保证不被其他中断（特别是相同的中断）打断，将其放在中断处理程序中执行。
d）其他所有任务，考虑放在下半部去执行。

##为什么要使用软中断？
软中断作为下半部机制的代表，是随着SMP（share memory processor）的出现应运而生的，它也是tasklet实现的基础（tasklet实际上只是在软中断的基础上添加了一定的机制）。软中断一般是“可延迟函数”的总称，有时候也包括了tasklet（请读者在遇到的时候根据上下文推断是否包含tasklet）。它的出现就是因为要满足上面所提出的上半部和下半部的区别，使得对时间不敏感的任务延后执行，而且可以在多个CPU上并行执行，使得总的系统效率可以更高。它的特性包括：
a）产生后并不是马上可以执行，必须要等待内核的调度才能执行。软中断不能被自己打断，只能被硬件中断打断（上半部）。
b）可以并发运行在多个CPU上（即使同一类型的也可以）。所以软中断必须设计为可重入的函数（允许多个CPU同时操作），因此也需要使用自旋锁来保护其数据结构。

##为什么要使用tasklet？（tasklet和软中断的区别）
由于软中断必须使用可重入函数，这就导致设计上的复杂度变高，作为设备驱动程序的开发者来说，增加了负担。而如果某种应用并不需要在多个CPU上并行执行，那么软中断其实是没有必要的。因此诞生了弥补以上两个要求的tasklet。它具有以下特性：
a）一种特定类型的tasklet只能运行在一个CPU上，不能并行，只能串行执行。
b）多个不同类型的tasklet可以并行在多个CPU上。
c）软中断是静态分配的，在内核编译好之后，就不能改变。但tasklet就灵活许多，可以在运行时改变（比如添加模块时）。
tasklet是在两种软中断类型的基础上实现的，但是由于其特殊的实现机制（将在4.3节详细介绍），所以具有了这样不同于软中断的特性。而由于这种特性，所以降低了设备驱动程序开发者的负担，因此如果不需要软中断的并行特性，tasklet就是最好的选择。

##可延迟函数（软中断及tasklet）的使用
一般而言，在可延迟函数上可以执行四种操作：初始化/激活/执行/屏蔽。屏蔽我们这里不再叙述，前三个则比较重要。下面将软中断和tasklet的三个步骤分别进行对比介绍。

###1 初始化
初始化是指在可延迟函数准备就绪之前所做的所有工作。一般包括两个大步骤：首先是向内核声明这个可延迟函数，以备内核在需要的时候调用；然后就是调用相应的初始化函数，用函数指针等初始化相应的描述符。
如果是软中断则在内核初始化时进行，其描述符定义如下：
```c
struct softirq_action
{
	void (*action)(struct softirq_action *);
	void*data;
};
```
在\kernel\softirq.c文件中包括了32个描述符的数组
static struct softirq_action softirq_vec[32]
但实际上只有前6个已经被内核注册使用（包括tasklet使用的HI_SOFTIRQ/TASKLET_SOFTIRQ和网络协议栈使用的NET_TX_SOFTIRQ/NET_RX_SOFTIRQ，还有SCSI存储和系统计时器使用的两个），剩下的可以由内核开发者使用。需要使用函数：
```c
         void open_softirq(int nr, void (*action)(struct softirq_action*), void *data)
```
初始化数组中索引为nr的那个元素。需要的参数当然就是action函数指针以及data。例如网络子系统就通过以下两个函数初始化软中断（net_tx_action/net_rx_action是两个函数）：
```c
open_softirq(NET_TX_SOFTIRQ,net_tx_action);
open_softirq(NET_RX_SOFTIRQ,net_rx_action);
```
这样初始化完成后实际上就完成了一个一一对应的关系：当内核中产生到NET_TX_SOFTIRQ软中断之后，就会调用net_tx_action这个函数。
tasklet则可以在运行时定义，例如加载模块时。定义方式有两种：
```c
//静态声明
DECLARE_TASKET(name, func, data)
DECLARE_TASKLET_DISABLED(name, func, data)
//动态声明
void tasklet_init(struct tasklet_struct *t, void (*func)(unsigned long), unsigned long data)
```
其参数分别为描述符，需要调用的函数和此函数的参数—必须是unsigned long类型。也需要用户自己写一个类似net_tx_action的函数指针func。初始化最终生成的结果就是一个实际的描述符，假设为my_tasklet（将在下面用到）。

###2 激活
激活标记一个可延迟函数为挂起（pending）状态，表示内核可以调用这个可延迟函数（即使在中断过程中也可以激活可延迟函数，只不过函数不会被马上执行）；这种情况可以类比处于TASK_RUNNING状态的进程，处在这个状态的进程只是准备好了被CPU调度，但并不一定马上就会被调度。
软中断使用raise_softirq()函数激活，接收的参数就是上面初始化时用到的数组索引nr。
tasklet使用tasklet_schedule()激活，该函数接受tasklet的描述符作为参数，例如上面生成的my_tasklet：
```c
tasklet_schedule(& my_tasklet)
```

###3 执行
执行就是内核运行可延迟函数的过程，但是执行只发生在某些特定的时刻（叫做检查点，具体有哪些检查点？详见《深入》p.177）。
每个CPU上都有一个32位的掩码__softirq_pending，表明此CPU上有哪些挂起（已被激活）的软中断。此掩码可以用local_softirq_pending()宏获得。所有的挂起的软中断需要用do_softirq()函数的一个循环来处理。
而对于tasklet，由于软中断初始化时，就已经通过下面的语句初始化了当遇到TASKLET_SOFTIRQ/HI_SOFTIRQ这两个软中断所需要执行的函数：
```c
	open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
	open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
```
因此，这两个软中断是要被区别对待的。tasklet_action和tasklet_hi_action内部实现就是为什么软中断和tasklet有不同的特性的原因（当然也因为二者的描述符不同，tasklet的描述符要比软中断的复杂，也就是说内核设计者自己多做了一部分限制的工作而减少了驱动程序开发者的工作）。

##为什么要使用工作队列work queue？（work queue和软中断的区别）
上面我们介绍的可延迟函数运行在中断上下文中（软中断的一个检查点就是do_IRQ退出的时候），于是导致了一些问题：软中断不能睡眠、不能阻塞。由于中断上下文出于内核态，没有进程切换，所以如果软中断一旦睡眠或者阻塞，将无法退出这种状态，导致内核会整个僵死。但可阻塞函数不能用在中断上下文中实现，必须要运行在进程上下文中，例如访问磁盘数据块的函数。因此，可阻塞函数不能用软中断来实现。但是它们往往又具有可延迟的特性。
因此在2.6版的内核中出现了在内核态运行的工作队列（替代了2.4内核中的任务队列）。它也具有一些可延迟函数的特点（需要被激活和延后执行），但是能够能够在不同的进程间切换，以完成不同的工作。

##软中断使用的数据结构
```c
//软中断描述符 
struct softirq_action{ void (*action)(struct softirq_action *);}; 

//软中断全局数据和类型
static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;  
    enum  
    {  
       HI_SOFTIRQ=0, /*用于高优先级的tasklet*/  
       TIMER_SOFTIRQ, /*用于定时器的下半部*/  
       NET_TX_SOFTIRQ, /*用于网络层发包*/  
       NET_RX_SOFTIRQ, /*用于网络层收报*/  
       BLOCK_SOFTIRQ,  
       BLOCK_IOPOLL_SOFTIRQ,  
       TASKLET_SOFTIRQ, /*用于低优先级的tasklet*/  
       SCHED_SOFTIRQ,  
       HRTIMER_SOFTIRQ,  
       RCU_SOFTIRQ, /* Preferable RCU should always be the last softirq */  
       NR_SOFTIRQS  
   };
```

##处理软中断

软中断的调度时机:
* do_irq完成I/O中断时 或 调用irq_exit。
* 系统使用I/O APIC,当smp_apic_timer_ionterrupt函数处理完本地时钟中断时。
* 内核调用local_bh_enable，即开启本地CPU 软中断时
* SMP系统中，cpu处理完被CALL_FUNCTION_VECTOR处理器间中断所触发的函数时
* ksoftirqd/n线程被唤醒时。 

##do_softirq()函数
```c
asmlinkage void __do_softirq(void)
{
    struct softirq_action *h;
    __u32 pending;
    int max_restart = MAX_SOFTIRQ_RESTART;
    int cpu;

    pending = local_softirq_pending();//取得目前有哪些位存在软件中断
    account_system_vtime(current);

    __local_bh_disable((unsigned long)__builtin_return_address(0));//关闭软中断，其实就是设置正在处理软件中断标记，在同一个CPU上使得不能重入__do_softirq函数。
    lockdep_softirq_enter();

    cpu = smp_processor_id();
restart:
    /* Reset the pending bitmask before enabling irqs */
    set_softirq_pending(0);//重新设置软中断标记为0，这样在之后重新开启中断之后硬件中断中又可以设置软件中断位。

    local_irq_enable();//开启硬件中断。

    h = softirq_vec;

    do {
        if (pending & 1) {
            int prev_count = preempt_count();
            kstat_incr_softirqs_this_cpu(h - softirq_vec);

            trace_softirq_entry(h, softirq_vec);
            h->action(h);
            trace_softirq_exit(h, softirq_vec);
            if (unlikely(prev_count != preempt_count())) {
                printk(KERN_ERR "huh, entered softirq %td %s %p"
                       "with preempt_count %08x,"
                       " exited with %08x?\n", h - softirq_vec,
                       softirq_to_name[h - softirq_vec],
                       h->action, prev_count, preempt_count());
                preempt_count() = prev_count;
            }

            rcu_bh_qs(cpu);
        }
        h++;
        pending >>= 1;
    } while (pending);//遍历pending标志的每一位

    local_irq_disable();//关闭硬件中断

    pending = local_softirq_pending();//查看是否又有软件中断处于pending状态
    if (pending && --max_restart)
        goto restart;

    if (pending)
        wakeup_softirqd();

    lockdep_softirq_exit();

    account_system_vtime(current);
    _local_bh_enable();//开启软中断
}
```

##ksoftirqd内核线程
软中断的内核进程中主要有两个大循环
外层的循环处理有软件中断就处理，没有软件中断就休眠。
内层的循环处理软件中断，每循环一次都试探一次是否过长时间占据了CPU，需要调度就释放CPU给其它进程。
```c
	set_current_state(TASK_INTERRUPTIBLE);
    //外层大循环。
    while (!kthread_should_stop()) {
        preempt_disable();//禁止内核抢占，自己掌握cpu
        if (!local_softirq_pending()) {
            preempt_enable_no_resched();
            //如果没有软中断在pending中就让出cpu
            schedule();
            //调度之后重新掌握cpu
            preempt_disable();
        }

        __set_current_state(TASK_RUNNING);

        while (local_softirq_pending()) {
            /* Preempt disable stops cpu going offline.
               If already offline, we'll be on wrong CPU:
               don't process */
            if (cpu_is_offline((long)__bind_cpu))
                goto wait_to_die;
            //有软中断则开始软中断调度
            do_softirq();
            //查看是否需要调度，避免一直占用cpu
            preempt_enable_no_resched();
            cond_resched();//进程切换
            preempt_disable();
            rcu_sched_qs((long)__bind_cpu);
        }
        preempt_enable();
        set_current_state(TASK_INTERRUPTIBLE);
    }
    __set_current_state(TASK_RUNNING);
    return 0;

wait_to_die:
    preempt_enable();
    /* Wait for kthread_stop */
    set_current_state(TASK_INTERRUPTIBLE);
    while (!kthread_should_stop()) {
        schedule();
        set_current_state(TASK_INTERRUPTIBLE);
    }
    __set_current_state(TASK_RUNNING);
    return 0;
```


---
#tasklet
a）一种特定类型的tasklet只能运行在一个CPU上，不能并行，只能串行执行。 
b）多个不同类型的tasklet可以并行在多个CPU上。 
c）软中断是静态分配的，在内核编译好之后，就不能改变。但tasklet就灵活许多，可以在运行时改变（比如添加模块时）。 
tasklet是软中断的一种特殊用法，即延迟情况下的串行执行

##相关数据结构
```c
//tasklet描述符
struct tasklet_struct
{
      struct tasklet_struct *next;//将多个tasklet链接成单向循环链表
      unsigned long state;//TASKLET_STATE_SCHED(Tasklet is scheduled for execution)  TASKLET_STATE_RUN(Tasklet is running (SMP only))
      atomic_t count;//0:激活tasklet 非0:禁用tasklet
      void (*func)(unsigned long); //用户自定义函数
      unsigned long data;  //函数入参
};

//tasklet链表
static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec);//低优先级
static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec);//高优先级
```

调度原理
```c
static inline void tasklet_schedule(struct tasklet_struct *t)
{
    if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
        __tasklet_schedule(t);
}
void __tasklet_schedule(struct tasklet_struct *t)
{
    unsigned long flags;

    local_irq_save(flags);
    t->next = NULL;
    *__get_cpu_var(tasklet_vec).tail = t;
    __get_cpu_var(tasklet_vec).tail = &(t->next);//加入低优先级列表
    raise_softirq_irqoff(TASKLET_SOFTIRQ);//触发软中断
    local_irq_restore(flags);
}
```

tasklet执行过程 
TASKLET_SOFTIRQ对应执行函数为tasklet_action，HI_SOFTIRQ为tasklet_hi_action，以tasklet_action为例说明，tasklet_hi_action大同小异。
```c
static void tasklet_action(struct softirq_action *a)
{
    struct tasklet_struct *list;

    local_irq_disable();//禁用本地中断
    list = __get_cpu_var(tasklet_vec).head;//获取本地cpu逻辑号
    __get_cpu_var(tasklet_vec).head = NULL;
    __get_cpu_var(tasklet_vec).tail = &__get_cpu_var(tasklet_vec).head;//取得tasklet链表
    local_irq_enable();//开本地中断

    while (list) {
        struct tasklet_struct *t = list;

        list = list->next;

        if (tasklet_trylock(t)) {
            if (!atomic_read(&t->count)) {
                //执行tasklet
                if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
                    BUG();
                t->func(t->data);
                tasklet_unlock(t);
                continue;
            }
            tasklet_unlock(t);
        }
        //如果t->count的值不等于0，说明这个tasklet在调度之后，被disable掉了，所以会将tasklet结构体重新放回到tasklet_vec链表，并重新调度TASKLET_SOFTIRQ软中断，在之后enable这个tasklet之后重新再执行它
        local_irq_disable();
        t->next = NULL;
        *__get_cpu_var(tasklet_vec).tail = t;
        __get_cpu_var(tasklet_vec).tail = &(t->next);
        __raise_softirq_irqoff(TASKLET_SOFTIRQ);
        local_irq_enable();
    }
}
```

---
#工作队列
软中断运行在中断上下文中，因此不能阻塞和睡眠，而tasklet使用软中断实现，当然也不能阻塞和睡眠。但如果某延迟处理函数需要睡眠或者阻塞呢？没关系工作队列就可以如您所愿了。 
把推后执行的任务叫做工作（work），描述它的数据结构为work_struct ，这些工作以队列结构组织成工作队列（workqueue），其数据结构为workqueue_struct ，而工作线程就是负责执行工作队列中的工作。系统默认的工作者线程为events。 
工作队列(work queue)是另外一种将工作推后执行的形式。工作队列可以把工作推后，交由一个内核线程去执行—这个下半部分总是会在进程上下文执行，但由于是内核线程，其不能访问用户空间。最重要特点的就是工作队列允许重新调度甚至是睡眠。 

通常，在工作队列和软中断/tasklet中作出选择非常容易。可使用以下规则： 
- 如果推后执行的任务需要睡眠，那么只能选择工作队列。 
- 如果推后执行的任务需要延时指定的时间再触发，那么使用工作队列，因为其可以利用timer延时(内核定时器实现)。 
- 如果推后执行的任务需要在一个tick之内处理，则使用软中断或tasklet，因为其可以抢占普通进程和内核线程，同时不可睡眠。 
- 如果推后执行的任务对延迟的时间没有任何要求，则使用工作队列，此时通常为无关紧要的任务。 
实际上，工作队列的本质就是将工作交给内核线程处理，因此其可以用内核线程替换。但是内核线程的创建和销毁对编程者的要求较高，而工作队列实现了内核线程的封装，不易出错，所以我们也推荐使用工作队列。


##相关数据结构
```c
//正常工作结构体
struct work_struct {
    atomic_long_t data; //传递给工作函数的参数
#define WORK_STRUCT_PENDING 0       /* T if work item pending execution */
#define WORK_STRUCT_FLAG_MASK (3UL)
#define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
    struct list_head entry; //链表结构，链接同一工作队列上的工作。
    work_func_t func; //工作函数，用户自定义实现
#ifdef CONFIG_LOCKDEP
    struct lockdep_map lockdep_map;
#endif
};
//工作队列执行函数的原型：
void (*work_func_t)(struct work_struct *work);
//该函数会由一个工作者线程执行，因此其在进程上下文中，可以睡眠也可以中断。但只能在内核中运行，无法访问用户空间。


//延迟工作结构体(延迟的实现是在调度时延迟插入相应的工作队列)
struct delayed_work {
    struct work_struct work;
    struct timer_list timer; //定时器，用于实现延迟处理
};

//工作队列结构体
struct workqueue_struct {
    struct cpu_workqueue_struct *cpu_wq; //指针数组，其每个元素为per-cpu的工作队列
    struct list_head list;
    const char *name;
    int singlethread; //标记是否只创建一个工作者线程
    int freezeable;     /* Freeze threads during suspend */
    int rt;
#ifdef CONFIG_LOCKDEP
    struct lockdep_map lockdep_map;
#endif
};

//每cpu工作队列(每cpu都对应一个工作者线程worker_thread)
struct cpu_workqueue_struct {
    spinlock_t lock;
    struct list_head worklist;//挂起链表头结点
    wait_queue_head_t more_work;//等待队列
    struct work_struct *current_work;
    struct workqueue_struct *wq;
    struct task_struct *thread;
} ____cacheline_aligned;
```

##实现原理

工作队列的组织结构 
即workqueue_struct、cpu_workqueue_struct与work_struct的关系。 
一个工作队列对应一个work_queue_struct，工作队列中每cpu的工作队列由cpu_workqueue_struct表示，而work_struct为其上的具体工作。 

---
#从中断和异常返回












