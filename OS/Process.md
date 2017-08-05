

#进程描述符
##进程内核栈结构：union task_union
在../include/linux/sched.h中定义了如下一个联合结构用来创建内核栈空间。
```c
//../include/linux/sched.h
union task_union {
      struct thread_info        thread_info;
      unsigned long             stack[THREAD_SIZE/sizeof(long)];
}:
```

##线程描述符：struct thread_info
每一个进程都有一个进程描述符task_struct，且有一个用来定位它的结构thread_info，thread_info位于其进程内核栈中(有些实现没有用到thread_info，而是使用一个寄存器来记录进程描述符的地址)，操作系统使用这个结构中的task指针字段找到进程的进程描述符，从而得到执行一个进程所需的全部信息
```c
//../arch/xtensa/include/asm
struct thread_info {
	struct task_struct          *task; //指向当前进程内核栈对应的进程的进程描述符

	struct exec_domain          *exec_domain;
	__u32                       flags;
	__u32                       status;
	__u32                       cpu;
	int                         preempt_count;
	mm_segment_t                addr_limit;
	struct restart_block        restart_block;
	void                        *sysenter_return;
	int                         uaccess_err;
};
```


##进程描述符：task_struct
从内核观点看，进程的目的就是担当分配系统资源(CPU 时间、内存等)的实体。为此目的，操作系统为每个进程维持着一个进程描述符。

在../include/linux/sched.h中定义了task_struct，其中包含了一个进程所需的全部信息。其结构体实例在内存中的大小一般在1KB以上。
```c
//../include/linux/sched.h
//---------------------------------------------------进程描述符结构定义---------------------------------------------------

struct task_struct
{
//---------------------------------------------------------进程状态------------------------------------------------------------ 
  long                  state;           //任务的运行状态
//---------------------------------------------------------进程标识信息--------------------------------------------------------- 
  pid_t                 pid;  //进程ID
  pid_t                 pgrp; //进程组标识,表示进程所属的进程组，等于进程组的领头进程的pid
  pid_t                 tgid;  //进程所在线程组的ID，等于线程组的领头线程的pid，getpid()系统调用返回tgid值。 
  pid_t                 session; //进程的登录会话标识，等于登录会话领头进程的pid。 
  struct pid            pids[PIDTYPE_MAX]; //PIDTYPE_MAX=4，一共4个hash表。
  char                  comm[TASK_COMM_LEN];  //记录进程的名字，即进程正在运行的可执行文件名 
  int                   leader; //标志,表示进程是否为会话主管(会话领头进程)。

//-------------------------------------------------------进程调度相关信息-------------------------------------------------------
  long                          nice;//进程的初始优先级，范围[-20,+19]，默认0，nice值越大优先级越低，分配的时间片
  //可能越少。
  int                           static_prio;//静态优先级。
  int                           prio;//存放调度程序要用到的优先级。
    /*
    0-99 -> Realtime process
    100-140 -> Normal process
  */
  unsigned int                  rt_priority;//实时优先级，默认情况下范围[0,99]
    /*
    0 -> normal
    1-99 -> realtime
    */
  unsigned long                 sleep_avg;//这个字段的值用来支持调度程序对进程的类型(I/O消耗型 or CPU消耗型)进行
  //判断，值越大表示睡眠的时候更多，更趋向于I/O消耗型，反之，更趋向于CPU消耗型。
  unsigned long                 sleep_time;//进程的睡眠时间   
  unsigned int                  time_slice;//进程剩余时间片，当一个任务的时间片用完之后，要根据任务的静态优先级
  //static_prio重新计算时间片。task_timeslice()为给定的任务返回一个新的时间片。对于交互性强的进程，时间片用完之后，它
  //会被再放到活动数组而不是过期数组，该逻辑在scheduler_tick()中实现。
#if defined(CONFIG_SCHEDSTATS)||define(CONFIG_TASK_DELAY_ACCT)  
  unsigned int                  policy;//表示该进程的进程调度策略。调度策略有:
//SCHED_NORMAL 0, 非实时进程, 用基于优先权的轮转法。
//SCHED_FIFO 1, 实时进程, 用先进先出算法。
//SCHED_RR 2, 实时进程, 用基于优先权的轮转法
#endif
  struct list_head              tasks;//任务队列，通过这个寄宿于PCB(task_struct)中的字段构成的双向循环链表将宿主
  //PCB链接起来。
  struct list_head              run_list;//该进程所在的运行队列。这个队列有一个与之对应的优先级k，所有位于这个队列中
  //的进程的优先级都是k，这些k优先级进程之间使用轮转法进行调度。k的取值是0~139。这个位于宿主PCB中的struct list_head类
  //型的run_list字段将构成一个优先级为k的双向循环链表，像一条细细的绳子一样，将所有优先级为k的处于可运行状态的进程的
  //PCB(task_struct)链接起来。
  prio_array_t                  *array; //typedef struct prio_array prio_array_t; 可以说，这个指针包含了操作
  //系统现有的所有按PCB的优先级进行整理了的PCB的信息。 


//---------------------------------------------------------进程链接信息---------------------------------------------------------
  struct task_struct            *real_parent;//指向创建了该进程的进程的进程描述符，如果父进程不再存在，就指向进程
  //1(init)的进程描述符。
  struct task_struct            *parent;//recipient of SIGCHLD, wait4() reports.　parent是该进程现在的父进程，
  //有可能是“继父”
  struct list_head              children;//list of my children.  children指的是该进程孩子的链表，使用
  //list_for_each和list_entry，可以得到所有孩子的进程描述符。  
  struct lsit_head              sibling;//linkage in my parent's children list.
//sibling为该进程的兄弟的链表，也就是其父亲的所有孩子的链表。用法与children相似。  
  struct task_struct            *group_leader;//threadgroup leader，主线程描述符
  struct list_head              thread_group;  //线程组链表，也就是该进程所有线程的链表。

//----------------------------------------------------------......------------------------------------------------------------

};
```



#linux进程的几个状态
* R (TASK_RUNNING)，可执行状态&运行状态(在run_queue队列里的状态)
* S (TASK_INTERRUPTIBLE)，可中断的睡眠状态, 可处理signal
* D (TASK_UNINTERRUPTIBLE)，不可中断的睡眠状态,　可处理signal,　有延迟，比如设备驱动里的一些操作
* T (TASK_STOPPED or TASK_TRACED) 暂停状态或跟踪状态,　不可处理signal,　因为根本没有时间片运行代码
* Z (TASK_DEAD - EXIT_ZOMBIE)，退出状态，进程成为僵尸进程。不可被kill,　即不响应任务信号,　无法用SIGKILL杀死
* EXIT_DEAD 僵死撤消状态，最终状态


----
#双向链表
##进程链表

链接所有进程的描述符
头：init_task描述符，0进程

##TASK_RUNNING状态的 进程链表

##等待队列
```c
//队列头
struct __wait_queue_head {  
        spinlock_t lock;//自旋锁，中断处理程序、主要内核函数 会并发修改
        struct list_head task_list;  
};  
typedef struct __wait_queue_head wait_queue_head_t;  


struct __wait_queue {  
        unsigned int flags;            
		#define WQ_FLAG_EXCLUSIVE      0x01  /* 表示等待进程想要被独占地唤醒  */  
        void *private;               /* 指向等待进程的task_struct实例 */  
        wait_queue_func_t func;      /* 用于唤醒等待进程              */  
        struct list_head task_list;  /* 用于链表元素，将wait_queue_t链接到wait_queue_head_t */  
};  
typedef struct __wait_queue wait_queue_t;  
```
唤醒等待队列中所有睡眠进程，可能会导致惊群问题



---
#pids
4个散列表
PID 进程pid
TGID 线程组领头进程PID
PGID 进程组领头进程PID
SID 会话领头进程PID

链表法处理哈希冲突

pid结构字段
int nr 						pid数值				
struct hlist_node pid_chain	链接散列表的下一个和前一个元素
struct list_head pid_list	每个pid的进程链表头


---------






















