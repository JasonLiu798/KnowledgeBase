



---
#定时器
##RTC Real Time Clock
位置：独立芯片，电池供电
频率：2~8192hz 周期性中断
使用：可编程激活IRQ8线
Linux：用来获取时间 日期
/dev/rtc
端口： 0x70 0x71

##TSC Time Stamp Counter
CPU的CLK输入引线接收外部振荡器时钟信号，信号到来加1，存储的计数器即64位TSC寄存器
位置：CPU内
使用：通过汇编指令rdtsc读取
Linux：获得更精确的时间测量

##PIT Programmable Interval Timer
类似于闹钟，发出时钟中断timer interrupt通知内核，以内核确定的固定频率发出中断
位置：外部芯片
端口：0x40~0x43

##CPU本地定时器 
位置：CPU的APIC中
32位，PIC 16位
中断只发送给自己的处理器，PIT发送全局中断

##HPET 高精度事件定时器
位置：定时器芯片
8个32位或64位独立计数器
最少100ns增长一次，最多与32个定时器相关联
比较器，比较时间产生中断

##ACPI 电源管理定时器 PMT
位置：时钟设备，主板上
3.58MHZ固定频率

#Linux计时体系结构
单处理器：所有计时活动都有全局定时器产生的中断触发
多处理器：所有普通活动（如软定时器的处理）都由全局定时器产生的中断触发，具体CPU活动（如监控当前进程执行时间）由本地APIC产生的中断触发

##计时体系数据结构
##定时器对象
timer_opts类型的一个描述符
name           | 标示定时器源的一个字符串 
mark_offset    | 上一个节拍的准确时间，由时钟中断处理程序调用
get_offset     | 返回自上一个节拍开始所经过的时间 μs
monotonic_clock| 返回自内核初始化开始经过的纳秒数
delay          | 等待指定数目的“循环”  延迟函数

cur_timer存放了某个定时器对象的地址，指向最好的
80x86典型定时器对象，以优先权顺序排列：
timer_hpet | 
timer_pmtmr
timer_tsc
timer_pit
timer_none

##jiffies变量
记录自系统启动以来产生的节拍总数，每次时钟中断+1
32位，每隔50天回绕到0
jiffies_64 需要顺序锁

##xtime变量
当前时间和日期
tv_sec 存放1970.1.1午夜经过的秒数
tv_nsec 纳秒

##单处理器
IRQ线0上的可编程间隔定时器产生的中断触发
###初始化阶段
* 初始化xtime
* 初始化wall_to_monotonic，单向增长
* 如支持HPET，每秒1000次引发IRQ0处中断
* select_timer挑选系统中可利用的最好的定时器资源，设置cur_timer指向
* 调用setup_irq(0,&irq0)创建与IRQ0相应的中断门

###时钟中断处理程序
timer_interrupt()

##多处理器
初始化 time_init()
全局中断处理函数
timer_interrupt()

#软定时器
##动态定时器 dynamic timer
内核使用
```c
struct time_list{
    struct list_head entry;//用于插入双向队列中
    unsigned long expires;//到期时间
    spinlock_t lock;
    unsigned long magic;
    void (* function) (unsigned long); //定时器到期执行的函数
    unsigned long data;//函数参数
    tvec_base_t *base;
}
```
##间隔定时器 interval timer
用户态创建













