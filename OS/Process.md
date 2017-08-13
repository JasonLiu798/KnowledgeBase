

#����������
##�����ں�ջ�ṹ��union task_union
��../include/linux/sched.h�ж���������һ�����Ͻṹ���������ں�ջ�ռ䡣
```c
//../include/linux/sched.h
union task_union {
      struct thread_info        thread_info;
      unsigned long             stack[THREAD_SIZE/sizeof(long)];
}:
```

##�߳���������struct thread_info
ÿһ�����̶���һ������������task_struct������һ��������λ���Ľṹthread_info��thread_infoλ��������ں�ջ��(��Щʵ��û���õ�thread_info������ʹ��һ���Ĵ�������¼�����������ĵ�ַ)������ϵͳʹ������ṹ�е�taskָ���ֶ��ҵ����̵Ľ������������Ӷ��õ�ִ��һ�����������ȫ����Ϣ
```c
//../arch/xtensa/include/asm
struct thread_info {
	struct task_struct          *task; //ָ��ǰ�����ں�ջ��Ӧ�Ľ��̵Ľ���������

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


##������������task_struct
���ں˹۵㿴�����̵�Ŀ�ľ��ǵ�������ϵͳ��Դ(CPU ʱ�䡢�ڴ��)��ʵ�塣Ϊ��Ŀ�ģ�����ϵͳΪÿ������ά����һ��������������

��../include/linux/sched.h�ж�����task_struct�����а�����һ�����������ȫ����Ϣ����ṹ��ʵ�����ڴ��еĴ�Сһ����1KB���ϡ�
```c
//../include/linux/sched.h
//---------------------------------------------------�����������ṹ����---------------------------------------------------

struct task_struct
{
//---------------------------------------------------------����״̬------------------------------------------------------------ 
  long                  state;           //���������״̬
//---------------------------------------------------------���̱�ʶ��Ϣ--------------------------------------------------------- 
  pid_t                 pid;  //����ID
  pid_t                 pgrp; //�������ʶ,��ʾ���������Ľ����飬���ڽ��������ͷ���̵�pid
  pid_t                 tgid;  //���������߳����ID�������߳������ͷ�̵߳�pid��getpid()ϵͳ���÷���tgidֵ�� 
  pid_t                 session; //���̵ĵ�¼�Ự��ʶ�����ڵ�¼�Ự��ͷ���̵�pid�� 
  struct pid            pids[PIDTYPE_MAX]; //PIDTYPE_MAX=4��һ��4��hash��
  char                  comm[TASK_COMM_LEN];  //��¼���̵����֣��������������еĿ�ִ���ļ��� 
  int                   leader; //��־,��ʾ�����Ƿ�Ϊ�Ự����(�Ự��ͷ����)��

//-------------------------------------------------------���̵��������Ϣ-------------------------------------------------------
  long                          nice;//���̵ĳ�ʼ���ȼ�����Χ[-20,+19]��Ĭ��0��niceֵԽ�����ȼ�Խ�ͣ������ʱ��Ƭ
  //����Խ�١�
  int                           static_prio;//��̬���ȼ���
  int                           prio;//��ŵ��ȳ���Ҫ�õ������ȼ���
    /*
    0-99 -> Realtime process
    100-140 -> Normal process
  */
  unsigned int                  rt_priority;//ʵʱ���ȼ���Ĭ������·�Χ[0,99]
    /*
    0 -> normal
    1-99 -> realtime
    */
  unsigned long                 sleep_avg;//����ֶε�ֵ����֧�ֵ��ȳ���Խ��̵�����(I/O������ or CPU������)����
  //�жϣ�ֵԽ���ʾ˯�ߵ�ʱ����࣬��������I/O�����ͣ���֮����������CPU�����͡�
  unsigned long                 sleep_time;//���̵�˯��ʱ��   
  unsigned int                  time_slice;//����ʣ��ʱ��Ƭ����һ�������ʱ��Ƭ����֮��Ҫ��������ľ�̬���ȼ�
  //static_prio���¼���ʱ��Ƭ��task_timeslice()Ϊ���������񷵻�һ���µ�ʱ��Ƭ�����ڽ�����ǿ�Ľ��̣�ʱ��Ƭ����֮����
  //�ᱻ�ٷŵ����������ǹ������飬���߼���scheduler_tick()��ʵ�֡�
#if defined(CONFIG_SCHEDSTATS)||define(CONFIG_TASK_DELAY_ACCT)  
  unsigned int                  policy;//��ʾ�ý��̵Ľ��̵��Ȳ��ԡ����Ȳ�����:
//SCHED_NORMAL 0, ��ʵʱ����, �û�������Ȩ����ת����
//SCHED_FIFO 1, ʵʱ����, ���Ƚ��ȳ��㷨��
//SCHED_RR 2, ʵʱ����, �û�������Ȩ����ת��
#endif
  struct list_head              tasks;//������У�ͨ�����������PCB(task_struct)�е��ֶι��ɵ�˫��ѭ����������
  //PCB����������
  struct list_head              run_list;//�ý������ڵ����ж��С����������һ����֮��Ӧ�����ȼ�k������λ�����������
  //�Ľ��̵����ȼ�����k����Щk���ȼ�����֮��ʹ����ת�����е��ȡ�k��ȡֵ��0~139�����λ������PCB�е�struct list_head��
  //�͵�run_list�ֶν�����һ�����ȼ�Ϊk��˫��ѭ��������һ��ϸϸ������һ�������������ȼ�Ϊk�Ĵ��ڿ�����״̬�Ľ��̵�
  //PCB(task_struct)����������
  prio_array_t                  *array; //typedef struct prio_array prio_array_t; ����˵�����ָ������˲���
  //ϵͳ���е����а�PCB�����ȼ����������˵�PCB����Ϣ�� 


//---------------------------------------------------------����������Ϣ---------------------------------------------------------
  struct task_struct            *real_parent;//ָ�򴴽��˸ý��̵Ľ��̵Ľ�������������������̲��ٴ��ڣ���ָ�����
  //1(init)�Ľ�����������
  struct task_struct            *parent;//recipient of SIGCHLD, wait4() reports.��parent�Ǹý������ڵĸ����̣�
  //�п����ǡ��̸���
  struct list_head              children;//list of my children.  childrenָ���Ǹý��̺��ӵ�����ʹ��
  //list_for_each��list_entry�����Եõ����к��ӵĽ�����������  
  struct lsit_head              sibling;//linkage in my parent's children list.
//siblingΪ�ý��̵��ֵܵ�����Ҳ�����丸�׵����к��ӵ������÷���children���ơ�  
  struct task_struct            *group_leader;//threadgroup leader�����߳�������
  struct list_head              thread_group;  //�߳�������Ҳ���Ǹý��������̵߳�����

//----------------------------------------------------------......------------------------------------------------------------

};
```



#linux���̵ļ���״̬
* R (TASK_RUNNING)����ִ��״̬&����״̬(��run_queue�������״̬)
* S (TASK_INTERRUPTIBLE)�����жϵ�˯��״̬, �ɴ���signal
* D (TASK_UNINTERRUPTIBLE)�������жϵ�˯��״̬,���ɴ���signal,�����ӳ٣������豸�������һЩ����
* T (TASK_STOPPED or TASK_TRACED) ��ͣ״̬�����״̬,�����ɴ���signal,����Ϊ����û��ʱ��Ƭ���д���
* Z (TASK_DEAD - EXIT_ZOMBIE)���˳�״̬�����̳�Ϊ��ʬ���̡����ɱ�kill,��������Ӧ�����ź�,���޷���SIGKILLɱ��
* EXIT_DEAD ��������״̬������״̬


----
#˫������
##��������

�������н��̵�������
ͷ��init_task��������0����

##TASK_RUNNING״̬�� ��������

##�ȴ�����
```c
//����ͷ
struct __wait_queue_head {  
        spinlock_t lock;//���������жϴ��������Ҫ�ں˺��� �Ტ���޸�
        struct list_head task_list;  
};  
typedef struct __wait_queue_head wait_queue_head_t;  


struct __wait_queue {  
        unsigned int flags;            
		#define WQ_FLAG_EXCLUSIVE      0x01  /* ��ʾ�ȴ�������Ҫ����ռ�ػ���  */  
        void *private;               /* ָ��ȴ����̵�task_structʵ�� */  
        wait_queue_func_t func;      /* ���ڻ��ѵȴ�����              */  
        struct list_head task_list;  /* ��������Ԫ�أ���wait_queue_t���ӵ�wait_queue_head_t */  
};  
typedef struct __wait_queue wait_queue_t;  
```
���ѵȴ�����������˯�߽��̣����ܻᵼ�¾�Ⱥ����

�������
flags�ֶ�Ϊ1 �ں���ѡ��Ļ���

�ǻ������
flags�ֶ�Ϊ0 ���ں����¼�����ʱ����

---
#pids
4��ɢ�б�
PID ����pid
TGID �߳�����ͷ����PID
PGID ��������ͷ����PID
SID �Ự��ͷ����PID

���������ϣ��ͻ

pid�ṹ�ֶ�
int nr 						pid��ֵ				
struct hlist_node pid_chain	����ɢ�б����һ����ǰһ��Ԫ��
struct list_head pid_list	ÿ��pid�Ľ�������ͷ


---------

[Linux ���̿��ơ����ȴ��������](http://blog.csdn.net/lizuobin2/article/details/51785812)
wait_event
```c
#define wait_event(wq, condition)                   \  
do {                                    \  
    if (condition)                          \  
        break;                          \  
    __wait_event(wq, condition);                    \  
} while (0)  

#define __wait_event(wq, condition)                     \  
do {                                    \  
    DEFINE_WAIT(__wait);                        \  
                                    \  
    for (;;) {                          \  
        prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);    \  
        if (condition)                      \  
            break;                      \  
        schedule();                     \  
    }                               \  
    finish_wait(&wq, &__wait);                  \  
} while (0)  

#define DEFINE_WAIT(name)                       \  
    wait_queue_t name = {                       \  
        .private    = current,              \  
        .func       = autoremove_wake_function,     \  
        .task_list  = LIST_HEAD_INIT((name).task_list), \  
    }

typedef struct __wait_queue wait_queue_t;     
struct __wait_queue {  
    unsigned int flags;  
#define WQ_FLAG_EXCLUSIVE   0x01  
    void *private;  
    wait_queue_func_t func;  
    struct list_head task_list;  
};  
```

������һ���� __wait �ĵȴ����У�private ָ��ǰ���̵� task_struct �ṹ�壨���ѵ�ʱ���֪�����ĸ����̣���Ȼ����� prepare_to_wait ���ȴ�����ͷ���뵽�ȴ�������ȥ�������õ�ǰ���̵�״̬ΪTASK_UNINTERRUPTIBLE��Ȼ����� condition Ϊ�٣���schedule()�����̵��ȵ�ʱ�򣬵�ǰ���̵�״̬���� TASK_RUNNING ��ȻҪ���Ƴ� �����ж��С���Ҳ����Զ���ᱻ���ȳ���ֱ����������� condition Ϊ�棬��ôfinish_wait ���֮ǰ�Ĺ�������ԭ ����ִ��

```c
void fastcall  
prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)  
{  
    unsigned long flags;  
  
    wait->flags &= ~WQ_FLAG_EXCLUSIVE;  
    spin_lock_irqsave(&q->lock, flags);  
    if (list_empty(&wait->task_list))  
        __add_wait_queue(q, wait);  
    /* 
     * don't alter the task state if this is just going to 
     * queue an async wait queue callback 
     */  
    if (is_sync_wait(wait))  
        set_current_state(state);  
    spin_unlock_irqrestore(&q->lock, flags);  
}  
void fastcall finish_wait(wait_queue_head_t *q, wait_queue_t *wait)  
{  
    unsigned long flags;  
  
    __set_current_state(TASK_RUNNING);  
  
    if (!list_empty_careful(&wait->task_list)) {  
        spin_lock_irqsave(&q->lock, flags);  
        list_del_init(&wait->task_list);  
        spin_unlock_irqrestore(&q->lock, flags);  
    }  
}  
```

����
```c
#define wake_up(x) __wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, 1, NULL)  
void fastcall __wake_up(wait_queue_head_t *q, unsigned int mode,  
            int nr_exclusive, void *key)  
{  
    unsigned long flags;  
  
    spin_lock_irqsave(&q->lock, flags);  
    __wake_up_common(q, mode, nr_exclusive, 0, key);  
    spin_unlock_irqrestore(&q->lock, flags);  
}  
static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,  
                 int nr_exclusive, int sync, void *key)  
{  
    struct list_head *tmp, *next;  
  
    //list_for_each_safe ��ɨ��˫������q->task_list����������ȴ�������������
    list_for_each_safe(tmp, next, &q->task_list) {
        wait_queue_t *curr = list_entry(tmp, wait_queue_t, task_list);  
        unsigned flags = curr->flags;  
  
        if (curr->func(curr, mode, sync, key) &&  
                (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)  
            break;  
    }  
}  

//��ʱ����õ��������ڵȴ�������ָ�����Ǹ� func ������Ҳ���� autoremove_wake_function

int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)  
{  
    int ret = default_wake_function(wait, mode, sync, key);  
  
    if (ret)  
        list_del_init(&wait->task_list);  
    return ret;  
}  
int default_wake_function(wait_queue_t *curr, unsigned mode, int sync,  
              void *key)  
{  
    return try_to_wake_up(curr->private, mode, sync);  
}  
```
���յ��õ� default_wake_function ������ �ȴ������� private ��ָ�����Ǹ����̡�Ȼ���Ƴ����ȴ�����ͷ�Ƴ��ȴ����С�try_to_wake_up ���Ὣ Ҫ���ѽ��̵� ����״̬����Ϊ TASK_RUNNING ,Ȼ��ŵ� �����ж��С��С�

1�������ȴ����С��ȴ�����ͷ
2�����ȴ�����ͷ���뵽�ȴ�������ȥ
3�����õ�ǰ���̵Ľ���״̬
4�����̵���~


-------------------
#ִ�н����л�
�л�ȫ��Ŀ¼�԰�װһ���µĵ�ַ�ռ�
�л��ں�̬��ջ��Ӳ��������

switch_to��









