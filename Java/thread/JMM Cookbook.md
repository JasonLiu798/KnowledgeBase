
# 指令重排
对于编译器的编写者来说，Java内存模型（JMM）主要是由禁止指令重排的规则所组成的，其中包括了字段（包括数组中的元素）的存取指令和监视器（锁）的控制指令。

## Volatile与监视器

JMM中关于volatile和监视器主要的规则可以被看作一个矩阵。这个矩阵的单元格表示在一些特定的后续关联指令的情况下，指令不能被重排。下面的表格并不是JMM规范包含的，而是一个用来观察JMM模型对编译器和运行系统造成的主要影响的工具。


能否重排	第二个操作
第一个操作	Normal Load
Normal Store	Volatile load
MonitorEnter	Volatile store
MonitorExit
Normal Load
Normal Store			No
Volatile load
MonitorEnter	No	No	No
Volatile store
MonitorExit		No	No
关于上面这个表格一些术语的说明：

Normal Load指令包括：对非volatile字段的读取，getfield，getstatic和array load；
Normal Store指令包括：对非volatile字段的存储，putfield，putstatic和array store；
Volatile load指令包括：对多线程环境的volatile变量的读取，getfield，getstatic；
Volatile store指令包括：对多线程环境的volatile变量的存储，putfield，putstatic；
MonitorEnters指令（包括进入同步块synchronized方法）是用于多线程环境的锁对象；
MonitorExits指令（包括离开同步块synchronized方法）是用于多线程环境的锁对象。
在JMM中，Normal Load指令与Normal store指令的规则是一致的，类似的还有Volatile load指令与MonitorEnter指令，以及Volatile store指令与MonitorExit指令，因此这几对指令的单元格在上面表格里都合并在了一起（但是在后面部分的表格中，会在有需要的时候展开）。在这个小节中，我们仅仅考虑那些被当作原子单元的可读可写的变量，也就是说那些没有位域（bit fields），非对齐访问（unaligned accesses）或者超过平台最大字长（word size)的访问。

任意数量的指令操作都可被表示成这个表格中的第一个操作或者第二个操作。例如在单元格[Normal Store, Volatile Store]中，有一个No，就表示任何非volatile字段的store指令操作不能与后面任何一个Volatile store指令重排， 如果出现任何这样的重排会使多线程程序的运行发生变化。

JSR-133规范规定上述关于volatile和监视器的规则仅仅适用于可能会被多线程访问的变量或对象。因此，如果一个编译器可以最终证明（往往是需要很大的努力）一个锁只被单线程访问，那么这个锁就可以被去除。与之类似的，一个volatile变量只被单线程访问也可以被当作是普通的变量。还有进一步更细粒度的分析与优化，例如：那些被证明在一段时间内对多线程不可访问的字段。

在上表中，空白的单元格代表在不违反Java的基本语义下的重排是允许的（详细可参考JLS中的说明）。例如，即使上表中没有说明，但是也不能对同一个内存地址上的load指令和之后紧跟着的store指令进行重排。但是你可以对两个不同的内存地址上的load和store指令进行重排，而且往往在很多编译器转换和优化中会这么做。这其中就包括了一些往往不认为是指令重排的例子，例如：重用一个基于已经加载的字段的计算后的值而不是像一次指令重排那样去重新加载并且重新计算。然而，JMM规范允许编译器经过一些转换后消除这些可以避免的依赖，使其可以支持指令重排。

在任何的情况下，即使是程序员错误的使用了同步读取，指令重排的结果也必须达到最基本的Java安全要求。所有的显式字段都必须不是被设定成0或null这样的预构造值，就是被其他线程设值。这通常必须把所有存储在堆内存里的对象在其被构造函数使用前进行归零操作，并且从来不对归零store指令进行重排。一种比较好的方式是在垃圾回收中对回收的内存进行归零操作。可以参考JSR-133规范中其他情况下的一些关于安全保证的规则。

这里描述的规则和属性都是适用于读取Java环境中的字段。在实际的应用中，这些都可能会另外与读取内部的一些记账字段和数据交互，例如对象头，GC表和动态生成的代码。

Final 字段

Final字段的load和store指令相对于有锁的或者volatile字段来说，就跟Normal load和Normal store的存取是一样的，但是需要加入两条附加的指令重排规则：

如果在构造函数中有一条final字段的store指令，同时这个字段是一个引用，那么它将不能与构造函数外后续可以让持有这个final字段的对象被其他线程访问的指令重排。例如：你不能重排下列语句：
1
x.finalField = v;
2
... ;
3
sharedRef = x;
这条规则会在下列情况下生效，例如当你内联一个构造函数时，正如“…”的部分表示这个构造函数的逻辑边界那样。你不能把这个构造函数中的对于这个final字段的store指令移动到构造函数外的一条store指令后面，因为这可能会使这个对象对其他线程可见。（正如你将在下面看到的，这样的操作可能还需要声明一个内存屏障）。类似的，你不能把下面的前两条指令与第三条指令进行重排：

1
x.afield = 1; x.finalField = v; ... ; sharedRef = x;
一个final字段的初始化load指令不能与包含该字段的对象的初始化load指令进行重排。在下面这种情况下，这条规则就会生效：x = shareRef; … ; i = x.finalField;
由于这两条指令是依赖的，编译器将不会对这样的指令进行重排。但是，这条规则会对某些处理器有影响。
上述规则，要求对于带有final字段的对象的load本身是synchronized，volatile，final或者来自类似的load指令，从而确保java程序员对与final字段的正确使用，并最终使构造函数中初始化的store指令和构造函数外的store指令排序。

—————————————————————————————————————————–

Reorderings
For a compiler writer, the JMM mainly consists of rules disallowing reorderings of certain instructions that access fields (where “fields” include array elements) as well as monitors (locks).

Volatiles and Monitors

The main JMM rules for volatiles and monitors can be viewed as a matrix with cells indicating that you cannot reorder instructions associated with particular sequences of bytecodes. This table is not itself the JMM specification; it is just a useful way of viewing its main consequences for compilers and runtime systems.

Can Reorder	2nd operation
1st operation	Normal Load
Normal Store	Volatile load
MonitorEnter	Volatile store
MonitorExit
Normal Load
Normal Store			No
Volatile load
MonitorEnter	No	No	No
Volatile store
MonitorExit		No	No
Where:

Normal Loads are getfield, getstatic, array load of non-volatile fields.
Normal Stores are putfield, putstatic, array store of non-volatile fields
Volatile Loads are getfield, getstatic of volatile fields that are accessible by multiple threads
Volatile Stores are putfield, putstatic of volatile fields that are accessible by multiple threads
MonitorEnters (including entry to synchronized methods) are for lock objects accessible by multiple threads.
MonitorExits (including exit from synchronized methods) are for lock objects accessible by multiple threads.
The cells for Normal Loads are the same as for Normal Stores, those for Volatile Loads are the same as MonitorEnter, and those for Volatile Stores are same as MonitorExit, so they are collapsed together here (but are expanded out as needed in subsequent tables). We consider here only variables that are readable and writable as an atomic unit — that is, no bit fields, unaligned accesses, or accesses larger than word sizes available on a platform.

Any number of other operations might be present between the indicated 1st and 2nd operations in the table. So, for example, the “No” in cell [Normal Store, Volatile Store] says that a non-volatile store cannot be reordered with ANY subsequent volatile store; at least any that can make a difference in multithreaded program semantics.

The JSR-133 specification is worded such that the rules for both volatiles and monitors apply only to those that may be accessed by multiple threads. If a compiler can somehow (usually only with great effort) prove that a lock is only accessible from a single thread, it may be eliminated. Similarly, a volatile field provably accessible from only a single thread acts as a normal field. More fine-grained analyses and optimizations are also possible, for example, those relying on provable inaccessibility from multiple threads only during certain intervals.

Blank cells in the table mean that the reordering is allowed if the accesses aren’t otherwise dependent with respect to basic Java semantics (as specified in theJLS). For example even though the table doesn’t say so, you can’t reorder a load with a subsequent store to the same location. But you can reorder a load and store to two distinct locations, and may wish to do so in the course of various compiler transformations and optimizations. This includes cases that aren’t usually thought of as reorderings; for example reusing a computed value based on a loaded field rather than reloading and recomputing the value acts as a reordering. However, the JMM spec permits transformations that eliminate avoidable dependencies, and in turn allow reorderings.

In all cases, permitted reorderings must maintain minimal Java safety properties even when accesses are incorrectly synchronized by programmers: All observed field values must be either the default zero/null “pre-construction” values, or those written by some thread. This usually entails zeroing all heap memory holding objects before it is used in constructors and never reordering other loads with the zeroing stores. A good way to do this is to zero out reclaimed memory within the garbage collector. See the JSR-133 spec for rules dealing with other corner cases surrounding safety guarantees.

The rules and properties described here are for accesses to Java-level fields. In practice, these will additionally interact with accesses to internal bookkeeping fields and data, for example object headers, GC tables, and dynamically generated code.

Final Fields

Loads and Stores of final fields act as “normal” accesses with respect to locks and volatiles, but impose two additional reordering rules:

A store of a final field (inside a constructor) and, if the field is a reference, any store that this final can reference, cannot be reordered with a subsequent store (outside that constructor) of the reference to the object holding that field into a variable accessible to other threads. For example, you cannot reorder
x.finalField = v; ... ; sharedRef = x;
This comes into play for example when inlining constructors, where “...” spans the logical end of the constructor. You cannot move stores of finals within constructors down below a store outside of the constructor that might make the object visible to other threads. (As seen below, this may also require issuing a barrier). Similarly, you cannot reorder either of the first two with the third assignment in:
v.afield = 1; x.finalField = v; ... ; sharedRef = x;
The initial load (i.e., the very first encounter by a thread) of a final field cannot be reordered with the initial load of the reference to the object containing the final field. This comes into play in:
x = sharedRef; ... ; i = x.finalField;
A compiler would never reorder these since they are dependent, but there can be consequences of this rule on some processors.
These rules imply that reliable use of final fields by Java programmers requires that the load of a shared reference to an object with a final field itself be synchronized, volatile, or final, or derived from such a load, thus ultimately ordering the initializing stores in constructors with subsequent uses outside constructors.












