
# doc
[段选择子与段描述符结构](http://blog.csdn.net/q1007729991/article/details/52538080)

#深入理解linux内核  C2内存寻址

#分段
8086中有4个16位的段寄存器：CS、DS、SS、ES，分别用于存放可执行代码的代码段、数据段、堆栈段和其他段的基地址。


##段寄存器
[段寄存器](http://blog.csdn.net/q1007729991/article/details/52537943)
* 段寄存器的大小是 96 位
* 段寄存器结构可以抽象成以下结构
```c
struct SegMent {
    WORD selector;
    WORD attribute;
    DWORD base;
    DWORD limit;
}
```
selector: 首先可见部分16位对应上面SegMent的selector成员。在 OD 中，可以看到段寄存器后面就跟着一个数字，比如 ds 后面的 0023。而 0023 后面的部分就是，剩余部分不可见部分，不过 OD 也给我们展示出来了。
attribute: attribute 属性记录了该段是否有效，是否可读写等权限。如果往一个不可写的段执行写数据，会报异常。
base: 通常来说，地址0是不可读写的。下面的代码却发现地址0仍然可以读写，原因是gs:[0]的base并不是0，而是0x7ffdf000，这样最终的线性地址为0x7ffdf000，这个地址的内容是可读的。
limit: limit 表示段界限，如果在超出了段界限进行读写，会报错。下面的代码会报错，因为 fs 段界限是 0xfff，如果尝试去读0x1000位置的数据，会报异常。

在 80386中，有6个16位的段寄存器，但是，这些段寄存器中存放的不再是某个段的基地址，而是某个段的选择符（Selector）。因为16位的寄存器 无法存放32位的段基地址，段基地址只好存放在一个叫做描述符表（Descriptor）的表中。因此，在80386中，我们把段寄存器叫做选择符。下面 给出6个段寄存器的名称和用途：
CS 代码段寄存器
DS 数据段寄存器
SS 堆栈段寄存器
ES、FS及GS 附加数据段寄存器

##段寄存器数据来源
GDT 表是全局描述符表，LDT 表是局部描述符表。当我们写段寄存器的时候，只给了16位，剩下80位并未给出，其实这80位的数据将通过查 GDT 表或者 LDT 表来获得。GDT 表和 LDT 表实际上就是一个大数组，数组中的每一项占用 8 个字节。

当填写段寄存器的时候，给出的16位中包含了3部分的信息
是要查GDT表还是LDT表；
要查的信息在GDT表或LDT表中的索引号；
RPL，这个暂时不讨论。
当找到我们需要的描述符（GDT或LDT中的某一表项）后，我们把这个描述符拆解成3个部分，分别是 attribute, base 和 limit。
其中 attribute, base 各占用2字节和4字节，共48位。
剩余32位用 limit 填充。

##段选择符  和 段描述符
[段选择子与段描述符结构](http://blog.csdn.net/q1007729991/article/details/52538080)
* gdt 数组中的每个元素都是一个段描述符
* 数组的索引号是段选择子
* 这个 gdt 数组被称为 gdt 表

###段选择符/段选择子
```
15      3  2  0
 INDEX  |TI|RPL
```
选择符有三个域：
* INDEX 第15~3位 这13位是索引域，表示的数据为0~8192，用于指向全局描述符表中相应的描述符（在GDT数组或LDT数组的索引号）
* TI 选择域，如果 TI=1，就从局部描述符表中选择相应的描述符，如果TI=0，就从全局描述符表中选择描述符。
* RPL 特权级，表示选择符的特权级，被称为请求者特权级RPL(Requestor Privilege Level)。
只有请求者特权级RPL高于(数字低于)或等于相应的描述符特权级DPL，描述符才能被存取，这就可以实现一定程度的保护。

CS寄存器 低2位，指明CPU当前特权级 CPL(current privilege level)
0 最高，3 最低，linux使用0-内核态和3-用户态

###段描述符
[段描述符属性分析](http://blog.csdn.net/q1007729991/article/details/52538353)
```
|   7    |     6       |     5     |   4    |   3    |   2    |   1    |   0    |  字节
7	|76543210|
	|  BASE  |
6	|7 6 5 4 3210 |
	|G|D|0|A|LIMIT|
5	|7 65 4 3210|
	|P|D |S|TYPE|
4-2	|76543210|76543210|76543210|
	|<------- BASE 23-0 ------>|
1-0	|76543210|76543210|
	|<-- LIMIT 15-0 ->|

```
BASE: 段基址，由上图中的两部分(BASE 31-24 和 BSE23-0)组成
LIMIT: 段的界限，单位由G位决定。数值上（经过单位换算后的值）等于段的长度（字节）- 1。

* G LIMIT的单位，该位 0 表示单位是字节，1表示单位是 4KB
* D/B 该位为 0 表示这是一个 16 位的段，1 表示这是一个 32 位段
	+ 对于代码段的影响
	D/B 位会影响指令操作数大小，为 0 时操作数大小为 16位，为 1 时操作大小为 32 位。什么意思呢？
	比如说，执行 push 指令时，16 位操作数下，使用的堆栈指针寄存器是 SP，只有 16 位，PUSH一次 SP 的值减 2. 而 32 位操作数下，使用的堆栈指针寄存器是 ESP，PUSH 一次 ESP 的值减 4.
	+ 对于数据段的影响
	该位为 0 时，段大小最大为 64 KB，该位为 1 时，段大小最大为 4GB。

* AVL 该位是用户位，可以被用户自由使用

P: 段存在位，该位为 0 表示该段不存在，为 1 表示存在。
DPL：段权限

* S 该描述符描述代码段或数据段
S为1 TYPE为不同值时，有以下含义
TYPE: 根据S位的结果，再次对段类型进行细分。
	+ A 访问位，该段是否被访问过。每当处理器将该段选择子置入某个段寄存器时，就将该* 位置1.
	+ W 该数据段是否可写。
	+ E 扩展方向。通常来说，描述符的 [base, base + limit] * 这段空间是可访问的，其它空间不可访问。如果 E = 1，[base, base +limit] * 就变的不可访问，相反，其它空间变的可访问。所以 E 位，有反转有效空间的含义。
	+ C C = 1 表示一致代码段。后面的文章会讲解。
	+ R R = 1 表示该代码段可读。代码段是不可写的。

S为0表示这是一个系统段（比如调用门，中断门等）
TYPE |	含义
-----|-------
0 |	保留
1 |	16位TSS段(可用)
2 |	LDT
3 |	16位TSS段(忙)
4 |	16位调用门
5 |	任务门
6 |	16位中断门
7 |	16位陷阱门
8 |	保留
9 |	32位TSS段(可用)
a |	保留
b |	32位TSS段(忙)
c |	32位调用门
d |	保留
e |	32位中断门
f |	32位陷阱门

###如何分析 limit
limit 的含义是这个段的大小。实际上这么说的点不准确。limit 应该描述为，段大小再减去1字节。(这里的 limit 是换算后的 limit)。后面我用大写的 LIMIT 表示段描述符中的 20bit LIMIT。
如果粒度 G=0，LIMIT= 0x3ff，这意味着该段的大小是 0x3ff+1=0x400 字节。如果 G=1，那意味着该段的大小是(0x3ff+1)*4KB=0x400000字节，所以换算后的 limit = 0x400000-1=0x003fffff.
再举个例子。LIMIT=0xfffff, G=1,则该段的大小是 (0xfffff+1)*4KB=0x100000*0x1000=0x100000000字节，所以换算后的 limit=0x100000000-1=0xffffffff

limit 简算法 
如果 G = 0，把段描述符中的 20 bit LIMIT取出来，比如 0x003ff，然后在前面补 0 至32bit，即 limit = 0x000003ff. 
如果 G=1，把段描述符中的 20 bit LIMIT取出来，比如 0x003ff，然后在后面补 f 至 32bit, 即 LIMIT = 0x003fffff













