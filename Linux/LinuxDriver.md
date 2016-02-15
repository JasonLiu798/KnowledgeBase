#Linux设备驱动开发详解
---
#C1 
安全：
* 任何从用户进程接收的输入应当以极大的怀疑态度来对待; 
* 除非你能核实它, 否则不要信任它.
* 小心对待未初始化的内存; 
* 从内核获取的任何内存应当清零或者在其对用户进程或设备可用之前进行初始化. 否则, 可能发生信息泄漏( 数据, 密码的暴露等等 ). 
* 如果你的设备解析发送给它的数据, 要确保用户不能发送任何能危及系统的东西. 
* 最后, 考虑一下设备操作的可能后果; 
* 如果有特定的操作( 例如, 加载一个适配卡的固件或者格式化一个磁盘 ), 能影响到系统的, 这些操作应该完全确定地要限制在授权的用户中. 


#C2 硬件基础
Flash 的编程原理都是只能将 1 写为 0，而不能将 0 写为 1
SDRAM、DDR SDRAM 皆属于 DRAM 的范畴，它们采用与 CPU 外存控制器同步的时钟工作（注意，不是 CPU 的工作频率）
DDR SDRAM 同时利用了时钟脉冲的上升沿和下降沿传输数据，因此在时钟频率不变的情况下，数据传输频率加倍

##串口
最简单的 RS-232C 串口只需要连接 RxD、 TxD、SG 这 3 个信号，使用 XON/XOFF 软件流控

##与应用程序区别：
Linux 内核代码, 包括驱动代码, 必须是可重入的 -- 它必须能够同时在多个上下文中运行.数据结构必须小心设计以保持多个执行线程分开, 并且代码必须小心存取共享数据, 避免数据的破坏.
内核, 相反, 有一个非常小的堆栈; 它可能小到一个, 4096 字节的页
以双下划线(__)开始的函数名. 这样标志的函数名通常是一个低层的接口组件, 应当小心使用.
</li>
<li>
初始化
首先第一的事情是决定模块是否能够无论如何继续初始化它自己，如功能降级
特别类型的失败后完全不能加载, 你必须取消任何在失败前注册的动作
goto在错误恢复中的作用
</li>
<li>
用户空间设备驱动：
优点：
完整的 C 库；程序员可以在驱动代码上运行常用的调试器；如果一个用户空间驱动挂起了, 你可简单地杀掉它；用户内存是可交换的；一个精心设计的驱动程序仍然可以, 如同内核空间驱动, 允许对设备的并行存取；方便必源控制；
缺点：
中断在用户空间无法用
只可能通过内存映射 /dev/mem 来使用 DMA, 而且只有特权用户可以这样做
存取 I/O 端口只能在调用 ioperm 或者 iopl 之后
响应时间慢 如果驱动已被交换到硬盘, 响应时间会长到不可接受
最重要的设备不能在用户空间处理, 包括但不限于, 网络接口和块设备




---
#C3 Linux内核编程
module-init-tools
modutils 工具包

---
#C11内存与IO访问

DMA
DMA与Cache一致性
DMA针对内存的目的地址与Cache缓存的对象 重叠区域
解决方法：直接禁止DMA目标地址范围内内存的Cache功能。

#define _ _get_dma_pages(gfp_mask, order) \ 
        _ _get_free_pages((gfp_mask) | GFP_DMA,(order)) 
static unsigned long dma_mem_alloc(int size) 
{ 
  int order = get_order(size);//大小->指数 
  return _ _get_dma_pages(GFP_KERNEL, order); 
} 

DMA的硬件使用总线地址而非物理地址，总线地址是从设备角度上看到的内存地址，物理地址则是从CPU角度上看到的未经转换的内存地址（经过转换的为虚拟地址）

虚拟地址/总线地址转换： 
unsigned long virt_to_bus(volatile void *address); 
void *bus_to_virt(unsigned long address);

DMA映射
分配一片DMA缓冲区
为这片缓冲区产生设备可访问的地址
分配函数
void * dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp);
返回值：void*  为DMA缓冲区的虚拟地址
参数：
dma_addr_t * handle 返回DMA缓冲区的总线地址
释放函数
void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr_t handle); 

分配写合并缓冲区
void * dma_alloc_writecombine(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp);
释放写合并
#define dma_free_writecombine(dev,size,cpu_addr,handle) \ 
      dma_free_coherent(dev,size,cpu_addr,handle)

PCI设备 DMA缓冲区
void *  pci_alloc_consistent(struct pci_dev  *pdev, size_t size, dma_addr_t *dma_addrp); 
void pci_free_consistent(struct pci_dev *pdev, size_t size, void *cpu_addr,     dma_addr_t dma_addr); 

流式DMA映射
dma_addr_t   dma_map_single  (struct device *dev, void *buffer, size_t size, enum dma_data_direction direction); 
返回的是总线地址，否则，返回NULL
void             dma_unmap_single  (struct device *dev, dma_addr_t dma_addr, size_t size, enum dma_data_direction direction);
获取流式DMA缓冲区所有权
void  dma_sync_single_for_cpu(struct  device  *dev,  dma_handle_t bus_addr, size_t size, enum dma_data_direction direction); 
返回所有权
void  dma_sync_single_for_device(struct  device  *dev,  dma_handle_t bus_addr, size_t size, enum dma_data_direction direction);

映射SG： 
int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents, enum dma_data_direction direction);
int nents 是散列表（scatterlist）入口的数量，该函数的返回值是DMA缓冲区的数量，可能小于nents
struct scatterlist 
{ 
  struct page *page; 
  unsigned int offset; 
  dma_addr_t dma_address; 
  unsigned int length; 
}; 
dma_addr_t sg_dma_address(struct scatterlist *sg); //返回scatterlist对应缓冲区的总线地址
unsigned int sg_dma_len(struct scatterlist *sg); //返回scatterlist对应缓冲区的长度
取消映射
void dma_unmap_sg(struct device *dev, struct scatterlist *list, int nents, enum dma_data_direction direction); 
SG映射属于流式DMA映射
设备驱动要访问
void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nents, enum dma_data_direction direction); 
void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nents, enum dma_data_direction direction); 


申请DMA通道
int request_dma(unsigned int dmanr, const char * device_id); 
void free_dma(unsigned int dmanr); 






















































