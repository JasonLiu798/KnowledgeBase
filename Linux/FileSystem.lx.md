#filesystem
---
#
[Linux内核源码阅读之打开文件篇](http://blog.csdn.net/adc0809608/article/details/7256505)
#linux打开文件最大数量
[fd最大值和限制 linux 下 file-max 的最大值计算方法 ](http://blog.itpub.net/90618/viewspace-772571/)
[linux最大文件句柄数量总结](http://jameswxx.iteye.com/blog/2096461)

一般情况下，最大打开文件数比较合理的设置为每4M物理内存256，比如256M内存能设为16384，而最大的使用的i节点的数目应该是最大打开文件数目的3倍到4倍。

文件描述符的范围是0~OPEN_MAX，在目前常用的linux系统中，是32位整形所能表示的整数，即65535，64位机上则更多。  

32位编译器：
	char ：1个字节
	char*（即指针变量）: 4个字节（32位的寻址空间是2^32, 即32个bit，也就是4个字节。同理64位编译器）
	short int : 2个字节
	int：  4个字节
	unsigned int : 4个字节
	float:  4个字节
	double:   8个字节
	long:   4个字节
	long long:  8个字节
	unsigned long:  4个字节
64位编译器：
	char ：1个字节
	char*(即指针变量): 8个字节
	short int : 2个字节
	int：  4个字节
	unsigned int : 4个字节
	float:  4个字节
	double:   8个字节
	long:   8个字节
	long long:  8个字节
	unsigned long:  8个字节

* ulimit -n       
网上很多人说，ulimit -n限制用户单个进程的问价打开最大数量。严格来说，这个说法其实是错误的。看看ulimit官方描述：
Provides control over the resources available to the shell and to processes started by  it,  on  systems that allow such control.  The -H and -S options specify that the hard or soft limit is set for the given resource. A hard limit cannot be increased once it is set; a soft limit may  be  increased  up  to  the value of the hard limit. If neither -H nor -S is specified, both the soft and hard limits are set. The value of limit can be a number in the unit specified for the resource or one of the special values hard, soft,  or  unlimited,  which  stand  for  the  current hard limit, the current soft limit, and no limit,  respectively.
If limit is omitted, the current value of the soft limit  of  the  resource  is  printed,  unless  the  -H  option is given.  When more than one resource is specified, the limit name and unit are  printed before the value.

第一行为：限制当前shell以及该shell启动的进程打开的文件数量。
非root用户只能越设置越小，不能越设置越大；root用户不受限制

ulimit里的最大文件打开数量的默认值：
如果在limits.conf里没有设置，则默认值是1024，如果limits.con有设置，则默认值以limits.conf为准

* /etc/security/limits.conf     
root用户是可以超过 limits.conf里设定的文件打开数（即soft nofile）
非root用户是不能超出limits.conf的设定

* /proc/sys/fs/file-max
/proc/sys/fs/file-max是系统给出的建议值，系统会计算资源给出一个和合理值，一般跟内存有关系，内存越大，改值越大，但是仅仅是一个建议值，limits.conf的设定完全可以超过/proc/sys/fs/file-max。

* 总结
/proc/sys/fs/file-max限制不了/etc/security/limits.conf
只有root用户才有权限修改/etc/security/limits.conf
对于非root用户， /etc/security/limits.conf会限制ulimit -n，但是限制不了root用户
对于非root用户，ulimit -n只能越设置越小，root用户则无限制
任何用户对ulimit -n的修改只在当前环境有效，退出后失效，重新登录新来后，ulimit -n由limits.conf决定
如果limits.conf没有做设定，则默认值是1024
当前环境的用户所有进程能打开的最大问价数量由ulimit -n决定


---
#Zero-Copy
[Zero-Copy&sendfile浅析](http://blog.csdn.net/jiangbo_hit/article/details/6146502)
[sendfile:Linux中的"零拷贝"](http://blog.csdn.net/caianye/article/details/7576198)

##典型IO调用
```
[HardDriver]-----DMA copy---->
[KernelBuffer]/Kernel ---CPU copy------->
[user buffer]/user----CPU copy------>
[socket buffer]/kernel----DMA copy------->
[protocol engine]
```
1当调用read系统调用时，通过DMA（Direct Memory Access）将数据copy到内核模式[1 disk->Kernel]
2然后由CPU控制将内核模式数据copy到用户模式下的 buffer中[2 kernel->user buffer]
3read调用完成后，write调用首先将用户模式下 buffer中的数据copy到内核模式下的socket buffer中[3 user buffer->socket buffer]
4最后通过DMA copy将内核模式下的socket buffer中的数据copy到网卡设备中传送。[4 socket buffer->network card]
数据白白从内核模式到用户模式走了一 圈，浪费了两次copy，而这两次copy都是CPU copy，即占用CPU资源。

##Zero-copy
Linux 2.1
```
1[HardDriver]-----DMA copy---->
2[KernelBuffer]/Kernel ---append dscr(位置/偏移量)------->3
					   ---DMA gather copy------->4

3[socket buffer]/kernel---DMA gather copy------->4
4[protocol engine]
```
sendfile传送文件只需要一次系统调用，当调用 sendfile时：
1。首先通过DMA copy将数据从磁盘读取到kernel buffer中[1 disk->kernel buffer]
2。然后通过CPU copy将数据从kernel buffer copy到sokcet buffer中[2 kernel buffer->socket buffer]
3。最终通过DMA copy将socket buffer中数据copy到网卡buffer中发送[3 socket buffer->network buffer]
sendfile与read/write方式相比，少了一次模式切换一次CPU copy。但是从上述过程中也可以发现从kernel buffer中将数据copy到socket buffer是没必要的。

linux 2.4 改进后
```
[HardDriver]-----DMA copy---->
[KernelBuffer]/Kernel ---CPU copy------->

[socket buffer]/kernel----DMA copy------->
[protocol engine]
```
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












