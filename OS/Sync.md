#内核同步


#内核抢占
[ Linux用户抢占和内核抢占详解(概念, 实现和触发时机)--Linux进程的管理与调度(二十）](http://blog.csdn.net/gatieme/article/details/51872618)
在内核态运行的进程，可能在执行内核函数期间被另一个进程取代


##抢占的条件
内核正在执行异常处理程序（尤其是系统调用），且内核抢占没有被显式禁用，才能抢占
本地CPU必须打开本地中断



#内核抢占的发生时机
条件
* 没持有锁。锁是用于保护临界区的，不能被抢占。
* Kernel code可重入(reentrant)。因为kernel是SMP-safe的，所以满足可重入性。

##时机一般发生在
1.当从中断处理程序正在执行，且返回内核空间之前。当一个中断处理例程退出，在返回到内核态时(kernel-space)。这是隐式的调用schedule()函数，当前任务没有主动放弃CPU使用权，而是被剥夺了CPU使用权。

2.当内核代码再一次具有可抢占性的时候，如解锁（spin_unlock_bh）及使能软中断(local_bh_enable)等, 此时当kernel code从不可抢占状态变为可抢占状态时(preemptible again)。也就是preempt_count从正整数变为0时。这也是隐式的调用schedule()函数

3.如果内核中的任务显式的调用schedule(), 任务主动放弃CPU使用权

4.如果内核中的任务阻塞(这同样也会导致调用schedule()), 导致需要调用schedule()函数。任务主动放弃CPU使用权

以下情况不能发生抢断
1.内核正进行中断处理。在Linux内核中进程不能抢占中断(中断只能被其他中断中止、抢占，进程不能中止、抢占中断)，在中断例程中不允许进行进程调度。进程调度函数schedule()会对此作出判断，如果是在中断中调用，会打印出错信息。

2.内核正在进行中断上下文的Bottom Half(中断下半部，即软中断)处理。硬件中断返回前会执行软中断，此时仍然处于中断上下文中。如果此时正在执行其它软中断，则不再执行该软中断。

3.内核的代码段正持有spinlock自旋锁、writelock/readlock读写锁等锁，处干这些锁的保护状态中。内核中的这些锁是为了在SMP系统中短时间内保证不同CPU上运行的进程并发执行的正确性。当持有这些锁时，内核不应该被抢占。

4.内核正在执行调度程序Scheduler。抢占的原因就是为了进行新的调度，没有理由将调度程序抢占掉再运行调度程序。

5.内核正在对每个CPU“私有”的数据结构操作(Per-CPU date structures)。在SMP中，对于per-CPU数据结构未用spinlocks保护，因为这些数据结构隐含地被保护了(不同的CPU有不一样的per-CPU数据，其他CPU上运行的进程不会用到另一个CPU的per-CPU数据)。但是如果允许抢占，但一个进程被抢占后重新调度，有可能调度到其他的CPU上去，这时定义的Per-CPU变量就会有问题，这时应禁抢占。


#同步原语

##pre-cpu variable
cpu之间复制数据结构 
范围：所有CPU

##原子操作
原子整数操作
原子操作函数接收的操作数类型——atomic_t
```c
//定义
atomic_t v;
//初始化
atomic_t u = ATOMIC_INIT(0);

//操作
atomic_set(&v,4);      // v = 4
atomic_add(2,&v);     // v = v + 2 = 6
atomic_inc(&v);         // v = v + 1 = 7

//实现原子操作函数实现
static inline void atomic_add(int i, atomic_t *v)
{
    unsigned long tmp;
    int result;
    __asm__ __volatile__("@ atomic_add\n"
　　　　"1:      ldrex      %0, [%3]\n"
　　　　"  add %0, %0, %4\n"
　　　　"  strex      %1, %0, [%3]\n"
　　　　"  teq  %1, #0\n"
　　　　"  bne 1b"
    　　: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
    　　: "r" (&v->counter), "Ir" (i)
    　　: "cc");
}
```

原子位操作
```c
//定义
unsigned long word = 0;

//操作
set_bit(0,&word);       //第0位被设置1
set_bit(0,&word);       //第1位被设置1
clear_bit(1,&word);   //第1位被清空0

//原子位操作函数实现
static inline void ____atomic_set_bit(unsigned int bit, volatile unsigned long *p)
{
       unsigned long flags;
       unsigned long mask = 1UL << (bit & 31);

       p += bit >> 5;
       raw_local_irq_save(flags);
       *p |= mask;
       raw_local_irq_restore(flags);
}
```

[linux内核 RCU机制详解](http://blog.csdn.net/xabc3000/article/details/15335131)


##内存屏障
[Linux内核同步机制之（三）：memory barrier](http://www.wowotech.net/kernel_synchronization/memory-barrier.html)


##自旋锁
同一时刻只能被一个可执行线程持有，获得自旋锁时，如果已被别的线程持有则该线程进行循环等待锁重新可用，然后继续向下执行。



使用自旋锁防止死锁：
自旋锁不可递归，自旋处于等待中造成死锁；
中断处理程序中，获取自旋锁前要先禁止本地中断，中断会打断正持有自旋锁的任务，中断处理程序有可能争用已经被持有的自旋锁，造成死锁。
读写自旋锁：将锁的用途直接分为读取和写入。


抢占内核的spin_lock宏
xchgb原子性的交换
若lock原来的值为1，则说明未锁，返回真，表明成功获取锁；否则返回假，获取锁失败。
```c
static inline int _raw_spin_trylock(spinlock_t *lock)
{
    char oldval;
    __asm__ __volatile__(
        "xchgb %b0,%1"
        :"=q" (oldval), "=m" (lock->lock)
        :"0" (0) : "memory");
    return oldval > 0;
}
```


##读/写自旋锁


##顺序锁
读者正在读，写者也能继续运行，不需等待，但读者可能需要读多次
读者需要检查计数器

不能使用的情况：
被保护数据结构不包括 被写者修改和被读者间接引用的指针
读者临界区代码没有副作用

##RCU
读-拷贝-更新
* 只保护动态分配并通过指针引用的数据结构
* 在被RCU保护的临界区内，任何内核控制路径都不能睡眠

##信号量

##读/写信号量

##补充原语

##禁止本地中断

##禁止和激活可延迟函数              


---------------------
#对内核数据结构的同步访问
并发度取决于：
* 同时运转的I/O设备数
* 进行有效工作的CPU数

---
#避免竞争条件的实例
##引用计数器

##大内核锁









