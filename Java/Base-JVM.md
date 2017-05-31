#JVM
---
#doc
##原理
[Understanding Java Garbage Collection and What You Can Do about It](https://www.infoq.com/presentations/Understanding-Java-Garbage-Collection)
[内存模型barrier](http://ifeve.com/jmm-cookbook-mb/)


[编程语言与高级语言虚拟机杂谈](http://zhuanlan.zhihu.com/hllvm)
[IntelliJ IDEA设置JVM运行参数](http://blog.csdn.net/sdujava2011/article/details/50086933)

[ JCONSOLE的连接问题](http://blog.csdn.net/blade2001/article/details/7742574)

##C4
[C4 Attila Szegedi on JVM and GC Performance Tuning at Twitter](https://www.infoq.com/interviews/szegedi-performance-tuning)


---
#theory
[栈式虚拟机和寄存器式虚拟机](http://www.zhihu.com/question/35777031)
[寄存器分配问题](http://www.zhihu.com/question/29355187)

[JVM系列三:JVM参数设置、分析](http://www.cnblogs.com/redcreen/archive/2011/05/04/2037057.html)




##procedure
编译
装载class
执行class




---
#memory
方法区，堆，方法栈，本地方法栈，PC寄存器
[The Java Memory Model](http://www.cs.umd.edu/~pugh/java/memoryModel/)

##永久代->Metaspace
[Java永久代去哪儿了](http://www.infoq.com/cn/articles/Java-PERMGEN-Removed)
随着Java8的到来，我们再也见不到永久代了。但是这并不意味着类的元数据信息也消失了。这些数据被移到了一个与堆不相连的本地内存区域，这个区域就是我们要提到的元空间
因为对永久代进行调优是很困难的。永久代中的元数据可能会随着每一次Full GC发生而进行移动。并且为永久代设置空间大小也是很难确定的，因为这其中有很多影响因素，比如类的总数，常量池的大小和方法数量等。

同时，HotSpot虚拟机的每种类型的垃圾回收器都需要特殊处理永久代中的元数据。将元数据从永久代剥离出来，不仅实现了对元空间的无缝管理，还可以简化Full GC以及对以后的并发隔离类元数据等方面进行优化。

准确的来说，每一个类加载器的存储区域都称作一个元空间，所有的元空间合在一起就是我们一直说的元空间。当一个类加载器被垃圾回收器标记为不再存活，其对应的元空间会被回收。在元空间的回收过程中没有重定位和压缩等操作。但是元空间内的元数据会进行扫描来确定Java引用。




###分配
栈上
TLAB分配
堆上分配

###GC
分代回收
    新生代
        串行copying
        并行回收copying
        并行copying
    MinorGC出发机制及日志格式
    旧生代可用GC
        串行Mark-Sweep-Compact
        并行Compacting
        并发Mark-Sweep
    FullGC出发机制以及日志格式
G1

---
#Classloader
[Java ClassLoader 原理详细分析](http://www.codeceo.com/article/java-classloader.html)
##Bootstrap ClassLoader
启动类加载器，是Java类加载层次中最顶层的类加载器，负责加载JDK中的核心类库，如：rt.jar、resources.jar、charsets.jar等，可通过如下程序获得该类加载器从哪些地方加载了相关的jar或class文件：
```java
URL[] urls = sun.misc.Launcher.getBootstrapClassPath().getURLs();
for (int i = 0; i < urls.length; i++) {
    System.out.println(urls[i].toExternalForm());
}
System.out.println(System.getProperty("sun.boot.class.path"));
```
##Extension ClassLoader
扩展类加载器，负责加载Java的扩展类库，默认加载JAVA_HOME/jre/lib/ext/目下的所有jar




##App ClassLoader
系统类加载器，负责加载应用程序classpath目录下的所有jar和class文件

##自定义 ClassLoader
除了Java默认提供的三个ClassLoader之外，用户还可以根据需要定义自已的ClassLoader，而这些自定义的ClassLoader都必须继承自java.lang.ClassLoader类，也包括Java提供的另外二个ClassLoader（Extension ClassLoader和App ClassLoader）在内，但是Bootstrap ClassLoader不继承自ClassLoader，因为它不是一个普通的Java类，底层由C++编写，已嵌入到了JVM内核当中，当JVM启动后，Bootstrap ClassLoader也随着启动，负责加载完核心类库后，并构造Extension ClassLoader和App ClassLoader类加载器。

##ClassLoader加载类的原理
* 原理介绍
ClassLoader使用的是双亲委托模型来搜索类的，每个ClassLoader实例都有一个父类加载器的引用（不是继承的关系，是一个包含的关系），虚拟机内置的类加载器（Bootstrap ClassLoader）本身没有父类加载器，但可以用作其它ClassLoader实例的的父类加载器。
当一个ClassLoader实例需要加载某个类时，它会试图亲自搜索某个类之前，先把这个任务委托给它的父类加载器，这个过程是 *由上至下依次检查* 的，
首先由最顶层的类加载器Bootstrap ClassLoader试图加载，
如果没加载到，则把任务转交给Extension ClassLoader试图加载，
如果也没加载到，则转交给App ClassLoader 进行加载，
如果它也没有加载得到的话，则返回给委托的发起者，由它到指定的文件系统或网络等URL中加载该类。
如果它们都没有加载到这个类时，则抛出ClassNotFoundException异常。
否则将这个找到的类生成一个类的定义，并将它加载到内存当中，最后返回这个类在内存中的Class实例对象。

* 为什么要使用双亲委托这种模型
因为这样可以避免重复加载，当父亲已经加载了该类的时候，就没有必要子ClassLoader再加载一次。考虑到安全因素，我们试想一下，如果不使用这种委托模式，那我们就可以随时使用自定义的String来动态替代java核心api中定义的类型，这样会存在非常大的安全隐患，而双亲委托的方式，就可以避免这种情况，因为String已经在启动时就被引导类加载器（Bootstrcp ClassLoader）加载，所以用户自定义的ClassLoader永远也无法加载一个自己写的String，除非你改变JDK中ClassLoader搜索类的默认算法。

* 但是JVM在搜索类的时候，又是如何判定两个class是相同
JVM在判定两个class是否相同时，
  不仅要判断两个类名是否相同
  而且要判断是否由同一个类加载器实例加载的。
只有两者同时满足的情况下，JVM才认为这两个class是相同的。就算两个class是同一份class字节码，如果被两个不同的ClassLoader实例所加载，JVM也会认为它们是两个不同class。比如网络上的一个Java类org.classloader.simple.NetClassLoaderSimple，javac编译之后生成字节码文件NetClassLoaderSimple.class，ClassLoaderA和ClassLoaderB这两个类加载器并读取了NetClassLoaderSimple.class文件，并分别定义出了java.lang.Class实例来表示这个类，对于JVM来说，它们是两个不同的实例对象，但它们确实是同一份字节码文件，如果试图将这个Class实例生成具体的对象进行转换时，就会抛运行时异常java.lang.ClassCaseException，提示这是两个不同的类型。
现在通过实例来验证上述所描述的是否正确：
1）、在web服务器上建一个org.classloader.simple.NetClassLoaderSimple.java类
```java
package org.classloader.simple;
public class NetClassLoaderSimple {
    private NetClassLoaderSimple instance;
    public void setNetClassLoaderSimple(Object obj) {
        this.instance = (NetClassLoaderSimple)obj;
    }
}
```

org.classloader.simple.NetClassLoaderSimple类的setNetClassLoaderSimple方法接收一个Object类型参数，并将它强制转换成org.classloader.simple.NetClassLoaderSimple类型。

2）、测试两个class是否相同（NetWorkClassLoader.java）
```java
package classloader;
public class NewworkClassLoaderTest {
    public static void main(String[] args) {
        try {
            //测试加载网络中的class文件
            String rootUrl = "http://localhost:8080/httpweb/classes";
            String className = "org.classloader.simple.NetClassLoaderSimple";
            NetworkClassLoader ncl1 = new NetworkClassLoader(rootUrl);
            NetworkClassLoader ncl2 = new NetworkClassLoader(rootUrl);
            Class<?> clazz1 = ncl1.loadClass(className);
            Class<?> clazz2 = ncl2.loadClass(className);
            Object obj1 = clazz1.newInstance();
            Object obj2 = clazz2.newInstance();
            clazz1.getMethod("setNetClassLoaderSimple", Object.class).invoke(obj1, obj2);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

首先获得网络上一个class文件的二进制名称，然后通过自定义的类加载器NetworkClassLoader创建两个实例，并根据网络地址分别加载这份class，并得到这两个ClassLoader实例加载后生成的Class实例clazz1和clazz2，最后将这两个Class实例分别生成具体的实例对象obj1和obj2，再通过反射调用clazz1中的setNetClassLoaderSimple方法。
结论：从结果中可以看出，虽然是同一份class字节码文件，但是由于被两个不同的ClassLoader实例所加载，所以JVM认为它们就是两个不同的类。

##定义自已的ClassLoader
既然JVM已经提供了默认的类加载器，为什么还要定义自已的类加载器呢？
因为Java中提供的默认ClassLoader，只加载指定目录下的jar和class，如果我们想加载其它位置的类或jar时，比如：我要加载网络上的一个class文件，通过动态加载到内存之后，要调用这个类中的方法实现我的业务逻辑。在这样的情况下，默认的ClassLoader就不能满足我们的需求了，所以需要定义自己的ClassLoader。

定义自已的类加载器分为两步：
1、继承java.lang.ClassLoader
2、重写父类的findClass方法
读者可能在这里有疑问，父类有那么多方法，为什么偏偏只重写findClass方法？
因为JDK已经在loadClass方法中帮我们实现了ClassLoader搜索类的算法，当在loadClass方法中搜索不到类时，loadClass方法就会调用findClass方法来搜索类，所以我们只需重写该方法即可。如没有特殊的要求，一般不建议重写loadClass搜索类的算法。
```java
package classloader;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;

/**
 * 加载网络class的ClassLoader
 */
public class NetworkClassLoader extends ClassLoader {

    private String rootUrl;

    public NetworkClassLoader(String rootUrl) {
        this.rootUrl = rootUrl;
    }

    @Override
    protected Class<?> findClass(String name) throws ClassNotFoundException {
        Class clazz = null;//this.findLoadedClass(name); // 父类已加载
        //if (clazz == null) {  //检查该类是否已被加载过
            byte[] classData = getClassData(name);  //根据类的二进制名称,获得该class文件的字节码数组
            if (classData == null) {
                throw new ClassNotFoundException();
            }
            clazz = defineClass(name, classData, 0, classData.length);  //将class的字节码数组转换成Class类的实例
        //}
        return clazz;
    }

    private byte[] getClassData(String name) {
        InputStream is = null;
        try {
            String path = classNameToPath(name);
            URL url = new URL(path);
            byte[] buff = new byte[1024*4];
            int len = -1;
            is = url.openStream();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            while((len = is.read(buff)) != -1) {
                baos.write(buff,0,len);
            }
            return baos.toByteArray();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
               try {
                  is.close();
               } catch(IOException e) {
                  e.printStackTrace();
               }
            }
        }
        return null;
    }

    private String classNameToPath(String name) {
        return rootUrl + "/" + name.replace(".", "/") + ".class";
    }

}
```







---
#tools
##jinfo
jinfo 33673|more
可以输出并修改运行时的java 进程的opts。

##jps
与unix上的ps类似，用来显示本地的java进程，可以查看本地运行着几个java程序，并显示他们的进程号。

##jps
-q only lvmid
-m parameter passed to main()
-l class full name
-v init parameter
jps -lv

##jconsole

##visualvm

##jmap
输出所有内存中对象的工具，甚至可以将VM 中的heap，以二进制输出成文本
jmap -dump:format=b,file=heap.bin <pid>

###jstat
监视VM内存工具。可以用来监视VM内存内的各种堆和非堆的大小及其内存使用量
```bash
jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]
```
* 常用选项
jstat -gccapacity 33673 1000 10
可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小，如：PGCMN显示的是最小perm的内存使用量，PGCMX显示的是perm的内存最大使用量，PGC是当前新生成的perm内存占用量，PC是但前perm内存占用量。其他的可以根据这个类推， OC是old内纯的占用量。

jstat -gcutil {pid} {interval} {count}
jstat -gcutil 529 1000 30
```
   S0: Survivor space 0 utilization as a percentage of the space's current capacity.

   S1: Survivor space 1 utilization as a percentage of the space's current capacity.

   E: Eden space utilization as a percentage of the space's current capacity.

   O: Old space utilization as a percentage of the space's current capacity.

   M: Metaspace utilization as a percentage of the space's current capacity.

   CCS: Compressed class space utilization as a percentage.

   YGC: Number of young generation GC events.

   YGCT: Young generation garbage collection time.

   FGC: Number of full GC events.

   FGCT: Full garbage collection time.

   GCT: Total garbage collection time.
```
jstat -class pid:显示加载class的数量，及所占空间等信息。
jstat -compiler pid:显示VM实时编译的数量等信息。
jstat -gc pid:可以显示gc的信息，查看gc的次数，及时间。其中最后五项，分别是young gc的次数，young gc的时间，full gc的次数，full gc的时间，gc的总时间。
jstat -gccapacity:可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小，如：PGCMN显示的是最小perm的内存使用量，PGCMX显示的是perm的内存最大使用量，PGC是当前新生成的perm内存占用量，PC是但前perm内存占用量。其他的可以根据这个类推， OC是old内纯的占用量。
jstat -gcnew pid:new对象的信息。
jstat -gcnewcapacity pid:new对象的信息及其占用量。
jstat -gcold pid:old对象的信息。
jstat -gcoldcapacity pid:old对象的信息及其占用量。
jstat -gcpermcapacity pid: perm对象的信息及其占用量。
jstat -util pid:统计gc信息统计。
jstat -printcompilation pid:当前VM执行的信息。

##jhat

##MAT
mat: eclipse memory analyzer, 基于eclipse RCP的内存分析工具。
详细信息参见：http://www.eclipse.org/mat/
jhat：JDK自带的java heap analyze tool


##jstack
[jstack和线程dump分析](http://jameswxx.iteye.com/blog/1041173)
[Java自带的性能监测工具用法简介——jstack、jconsole、jinfo、jmap、jdb、jsta、jvisualvm](http://blog.csdn.net/feihong247/article/details/7874063)

32598

top -Hp 32598
32678 work      20   0 4539m 456m 6036 S  0.0 11.9  23:36.49 java
32614 work      20   0 4539m 456m 6036 S  0.3 11.9  16:57.43 java
32627 work      20   0 4539m 456m 6036 S  0.0 11.9   7:42.35 java

printf "%x\n" 32678
7fa6

jstack 100093 |grep 1876f


###TDA



---
#GC
##minor gc
因为young GC只收集young gen，但full GC会收集整个GC堆。
HotSpot VM的full GC会收集整个Java堆，包括其中的young gen与old gen；
同时也会顺便收集不属于Java堆的perm gen。
Young + old + perm构成了HotSpot VM的整个GC堆。

##标记-清除算法
[标记-清除算法](http://www.jianshu.com/p/b0f5d21fe031)
collector指的就是垃圾收集器
mutator是指除了垃圾收集器之外的部分，比如说我们应用程序本身
mutator的职责一般是NEW(分配内存),READ(从内存中读取内容),WRITE(将内容写入内存)，而collector则就是回收不再使用的内存来供mutator进行NEW操作的使用。

在标记阶段，collector从mutator根对象开始进行遍历，对从mutator根对象可以访问到的对象都打上一个标识，一般是在对象的header中，将其记录为可达对象。
而在清除阶段，collector对堆内存(heap memory)从头到尾进行线性的遍历，如果发现某个对象没有标记为可达对象-通过读取对象的header信息，则就将其回收。

下面是mutator进行NEW操作的伪代码：
```
New():
    ref <- allocate()  //分配新的内存到ref指针
    if ref == null
       collect()  //内存不足，则触发垃圾收集
       ref <- allocate()
       if ref == null
          throw "Out of Memory"   //垃圾收集后仍然内存不足，则抛出Out of Memory错误
          return ref

atomic collect():
    markFromRoots()
    sweep(HeapStart,HeapEnd)
```
而下面是对应的mark算法:
```
markFromRoots():
    worklist <- empty
    for each fld in Roots  //遍历所有mutator根对象
        ref <- *fld
        if ref != null && isNotMarked(ref)  //如果它是可达的而且没有被标记的，直接标记该对象并将其加到worklist中
           setMarked(ref)
           add(worklist,ref)
           mark()
mark():
    while not isEmpty(worklist)
          ref <- remove(worklist)  //将worklist的最后一个元素弹出，赋值给ref
          for each fld in Pointers(ref)  //遍历ref对象的所有指针域，如果其指针域(child)是可达的，直接标记其为可达对象并且将其加入worklist中
          //通过这样的方式来实现深度遍历，直到将该对象下面所有可以访问到的对象都标记为可达对象。
                child <- *fld
                if child != null && isNotMarked(child)
                   setMarked(child)
                   add(worklist,child)
```
在mark阶段结束后，sweep算法就比较简单了，它就是从堆内存起始位置开始，线性遍历所有对象直到堆内存末尾，如果该对象是可达对象的（在mark阶段被标记过的），那就直接去除标记位（为下一次的mark做准备），如果该对象是不可达的，直接释放内存。
```
sweep(start,end):
    scan <- start
   while scan < end
       if isMarked(scan)
          setUnMarked(scan)
      else
          free(scan)
      scan <- nextObject(scan)
```

###缺点
垃圾收集后有可能会造成大量的内存碎片，像上面的图片所示，垃圾收集后内存中存在三个内存碎片，假设一个方格代表1个单位的内存，如果有一个对象需要占用3个内存单位的话，那么就会导致Mutator一直处于暂停状态，而Collector一直在尝试进行垃圾收集，直到Out of Memory。





##Serial gc
扫描，复制均为单线程

minor gc
eden---(存活)---->To space(s0)
minor gc
To space(s1) From space(s0)

To space满

多次minro gc存活 ->old



##并行回收GC Parallel Scavenge
扫描，复制多线程
server级（CPU核数>2，内存>2G）默认GC方式
eden空间不够，对象大小等于enden space一半大小，直接在旧生代分配

##并行GC ParNew
必须配合旧生代使用CMS GC
CMS回收旧生代的时候有些过程为并发进行，此时发送Minor GC需要相应处理，并行回收GC 无此操作，因此ParNew不可以与并行的旧生代GC同时使用

##旧生代
* 串行GC
三色着色标记
遍历未标记，回收
滑动压缩（sliding compaction）

* 并行GC
Mark-Compact
划分并行region
三色着色标记
大部分情况下，左边region为活跃对象，压缩移动不值得，继续向右扫描到值得压缩移动的region，找到后 region左边作为高密度区dense prefix，这些区域不回收，继续向右扫描，压缩移动

* 并发GC CMS
free-list记录空闲
I.Initial Marking ，暂停应用
II.Concurrent Marking
标记对象
Mod Union Table记录 Minor GC后修改的Card信息
浮动垃圾
III.final Marking (remark)
IV.Concurrent Sweeping


---
#CMS
CMS在并发模式工作的时候是只收集old gen的。但一旦并发模式失败（发生concurrent mode failure）就有选择性的会进行全堆收集，也就是退回到full GC。

##过程
初始标记 ：在这个阶段，需要虚拟机停顿正在执行的任务，官方的叫法STW(Stop The Word)。这个过程从垃圾回收的"根对象"开始，只扫描到能够和"根对象"直接关联的对象，并作标记。所以这个过程虽然暂停了整个JVM，但是很快就完成了。
并发标记 ：这个阶段紧随初始标记阶段，在初始标记的基础上继续向下追溯标记。并发标记阶段，应用程序的线程和并发标记的线程并发执行，所以用户不会感受到停顿。
并发预清理 ：并发预清理阶段仍然是并发的。在这个阶段，虚拟机查找在执行并发标记阶段新进入老年代的对象(可能会有一些对象从新生代晋升到老年代， 或者有一些对象被分配到老年代)。通过重新扫描，减少下一个阶段"重新标记"的工作，因为下一个阶段会Stop The World。
重新标记 ：这个阶段会暂停虚拟机，收集器线程扫描在CMS堆中剩余的对象。扫描从"跟对象"开始向下追溯，并处理对象关联。
并发清理 ：清理垃圾对象，这个阶段收集器线程和应用程序线程并发执行。
并发重置 ：这个阶段，重置CMS收集器的数据结构，等待下一次垃圾回收。

##缺点
* CMS回收器采用的基础算法是Mark-Sweep
所有CMS不会整理、压缩堆空间。这样就会有一个问题：经过CMS收集的堆会产生空间碎片。 CMS不对堆空间整理压缩节约了垃圾回收的停顿时间，但也带来的堆空间的浪费。为了解决堆空间浪费问题，CMS回收器不再采用简单的指针指向一块可用堆空 间来为下次对象分配使用。而是把一些未分配的空间汇总成一个列表，当JVM分配对象空间的时候，会搜索这个列表找到足够大的空间来hold住这个对象。
* 需要更多的CPU资源
从上面的图可以看到，为了让应用程序不停顿，CMS线程和应用程序线程并发执行，这样就需要有更多的CPU，单纯靠线程切 换是不靠谱的。并且，重新标记阶段，为空保证STW快速完成，也要用到更多的甚至所有的CPU资源。当然，多核多CPU也是未来的趋势！
* CMS的另一个缺点是它需要更大的堆空间
因为CMS标记阶段应用程序的线程还是在执行的，那么就会有堆空间继续分配的情况，为了保证在CMS回 收完堆之前还有空间分配给正在运行的应用程序，必须预留一部分空间。也就是说，CMS不会在老年代满的时候才开始收集。相反，它会尝试更早的开始收集，已 避免上面提到的情况：在回收完成之前，堆没有足够空间分配！默认当老年代使用68%的时候，CMS就开始行动了。 – XX:CMSInitiatingOccupancyFraction =n 来设置这个阀值。
总得来说，CMS回收器减少了回收的停顿时间，但是降低了堆空间的利用率。

##适用场景
如果你的应用程序对停顿比较敏感，并且在应用程序运行的时候可以提供更大的内存和更多的CPU(也就是硬件牛逼)，那么使用CMS来收集会给你带来好处。还有，如果在JVM中，有相对较多存活时间较长的对象(老年代比较大)会更适合使用CMS。





---
#G1
[JVM中的G1垃圾回收器](http://www.importnew.com/15311.html)
jvm heap划分为 多个固定大小region
扫描采用Snapshot-at-the-beginning 并发marking算法对整个heap中region进行mark



---
#gc触发时间
##minorgc


##FullGC






----
#gc调优
[Attila Szegedi on JVM and GC Performance Tuning at Twitter](https://www.infoq.com/interviews/szegedi-performance-tuning)
[Sun以前出的HotSpot VM的GC调优白皮书](http://www.oracle.com/technetwork/java/javase/memorymanagement-whitepaper-150215.pdf)
[Gil Tene谈GC](http://www.infoq.com/presentations/Understanding-Java-Garbage-Collection)
[JVM调优总结 -Xms -Xmx -Xmn -Xss](http://www.cnblogs.com/likehua/p/3369823.html)
##新生代和老年代 比例
[新生代和老年代怎样的比例比较合适呢](http://hllvm.group.iteye.com/group/topic/34664)
大小分配怎样才合理取决于某个具体应用的对象的存活模式
堆大小
-Xms    初始堆大小
-Xmx    最大堆大小
年轻代
-Xmn    年轻代大小(1.4or lator)

java object demography

举例：可能很多人都有一种印象，young gen应该比old gen小。
笼统说确实如此，因为在最坏情况下young gen里可能所有对象都还活着，而如果它们全部都要晋升到old gen的话，那old gen里的剩余空间必须能容纳下这些对象才行，这就需要old gen比young gen大（否则young GC就无法进行，而必须做full GC才能应付了）。
实际上却不总是这样的。所谓“最坏情况”在很多系统里是永远不会出现的。
调优就是要针对实际应用里对象的存活模式来破除这些“最坏情况”的假设带来的限制。

许多Web应用里对象会有这样的特征：
·(a) 有一部分对象几乎一直活着。这些可能是常用数据的cache之类的
·(b) 有一部分对象创建出来没多久之后就没用了。这些很可能会响应一个请求时创建出来的临时对象
·(c) 最后可能还有一些中间的对象，创建出来之后不会马上就死，但也不会一直活着。

如果是这样的模式，那young gen可以设置得非常大，大到每次young GC的时候里面的多数对象(b)最好已经死了。
想像一下，如果young gen太小，每次满了就触发一次young GC，那么young GC就会很频繁，或许很多临时对象(b)正好还在被是使用（还没死），这样的话young GC的收集效率就会比较低。要避免这样的情况，最好是就是把young gen设大一些。

那old gen怎么办？如果是上面说的情况，那old gen至少要足以装下所有长期存活的对象(a)；同时也要留出一定的余地用来容纳young GC没能清理掉的临时对象。

这样，最后调整出来的结果很可能young GC反而比old gen大许多。这完全没问题。

只有(a)和(b)的话就完美了，现实中最头疼的就是针对(c)对象的调优。它们或许会经历多次young GC之后仍然存活，于是晋升到old gen；但晋升上去之后或许很快就又死掉了。
这种对象最好能不让晋升到old gen（可以让它们在survivor space里多来回倒腾几次再晋升，也就是想办法增加tenuring threshold；不过HotSpot VM里的GC不让外界对此多插手，想减小MaxTenuringThreshold很容易，想增加实际有效的tenuring threshold就没那么容易了）。
但如果真的不让它们晋升，young GC的暂停时间就会增长（在survivor space里来回倒腾对象意味着要来回拷贝，这会花时间）。
所以有一种策略是尽量让这种对象的大部分在young GC中消耗掉（在保持young GC的暂停时间不超过某个预期值的前提下），而“漏”到old gen的那些让诸如CMS之类的并发GC来解决。
总之这里要做一定的tradeoff就是了。

实践
首先得了解硬性限制：某个服务器总共有多少内存，其中最多可以分配多少给某个应用程序；有没有一些服务对响应时间有严格要求，有的话限制是多少，之类的。

然后看看应用的特征是怎样的。可以借助一些工具来了解对象的存活情况，例如NetBeans的profiler就有这样的功能（老文档）；许多其它主流Java profiler也有类似的功能。
这些工具的精度和性能开销各异，总之自己摸索下看看吧。

情况了解清楚了就可以开始迭代调整各种参数看实际运行的表现如何。迭代到满意为止。
要分析实际GC的运行状况，首要切入点就是分析GC日志。



So when go and deal with a performance problem with some team within Twitter, are you looking at the code first or do you tend to look at the way the garbage collector's configured or where do you start?

Well, a garbage collector is a global service for a particular JVM and as such, its own operation is affected by the operation of all the code in the JVM which is the Java libraries, third party libraries that have been used and so on, which means that, you can’t really, or, let me put it this way: if you need to look at the application code in order to tune the garbage collector, then you are doing it wrong because from the point of view of the application, garbage collectors are a blackbox and vice-versa.

From the point of view of the garbage collector, the application is a blackbox. You only just see the statistical behavior basically: allocation rates, the typical duration of life of the objects and so on. So, the correct way to tune the GC is to actually inspect the GC logs, see the overall utilization of memory, memory patterns, GC frequencies - observe it over time and tune with that in mind.


.What are the main factors that contribute to that within HotSpot. Do you use HotSpot? So within the HotSpot collector?
Yes. So, within HotSpot, the frequency and duration of the garbage collector pauses; well, generally: if you had a JVM with infinite memory, then you will never have to GC, right? And if you have a JVM with a single byte of free memory then you are GC-ing all the time. And between the two extremes, you have an asymptotically decreasing proportion of your CPU going towards GC which basically means that the best way to minimize the frequencies of your GC is to give your JVM as much memory as you can. Specifically, the frequency of minor GCs is pretty much exactly inversely proportional to the size of the new generation. And as for the old generation GCs, but you really want to avoid those altogether. So, you want to tune your systems so that those never happen. It’s another question whether it’s actually possible to achieve in a non-trivial system with a HotSpot, it’s hard.




##tools
[Gchisto](https://java.net/projects/gchisto/)
[twitter jvmgcprof](git@github.com:twitter/jvmgcprof.git)


---
#参数调优
http://www.cnblogs.com/redcreen/archive/2011/05/04/2037057.html
[从一次 FULL GC 卡顿谈对服务的影响](http://blog.csdn.net/weiguang_123/article/details/48577175)


----
#JVM参数
##常用
###测试用例性能测试用
-Xmx1500m -Xms768m -Xmn512m -Xss128k
-ea -Xmx1500m -Xms768m -Xmn512m -Xss128k

-Xmx3550m -Xms3550m -Xmn2g -Xss128k
-Xmx3550m -Xms3550m -Xss128k -XX:NewRatio=4 -XX:SurvivorRatio=4 -XX:MaxPermSize=16m -XX:MaxTenuringThreshold=0

并行GC
java -Xmx3800m -Xms3800m -Xmn2g -Xss128k -XX:+UseParallelGC -XX:ParallelGCThreads=20
-XX:+UseParallelGC：选择垃圾收集器为并行收集器。此配置仅对年轻代有效。即上述配置下，年轻代使用并发收集，而年老代仍旧使用串行收集。
-XX:ParallelGCThreads=20：配置并行收集器的线程数，即：同时多少个线程一起进行垃圾回收。此值最好配置与处理器数目相等。

java -Xmx3550m -Xms3550m -Xmn2g -Xss128k -XX:+UseParallelGC -XX:ParallelGCThreads=20 -XX:+UseParallelOldGC
-XX:+UseParallelOldGC：配置年老代垃圾收集方式为并行收集。JDK6.0支持对年老代并行收集。

java -Xmx3550m -Xms3550m -Xmn2g -Xss128k -XX:+UseParallelGC  -XX:MaxGCPauseMillis=100
-XX:MaxGCPauseMillis=100:设置每次年轻代垃圾回收的最长时间，如果无法满足此时间，JVM会自动调整年轻代大小，以满足此值。

java -Xmx3550m -Xms3550m -Xmn2g -Xss128k -XX:+UseParallelGC  -XX:MaxGCPauseMillis=100 -XX:+UseAdaptiveSizePolicy
-XX:+UseAdaptiveSizePolicy：设置此选项后，并行收集器会自动选择年轻代区大小和相应的Survivor区比例，以达到目标系统规定的最低相应时间或者收集频率等，此值建议使用并行收集器时，一直打开。

响应时间优先的并发收集器
如上文所述，并发收集器主要是保证系统的响应时间，减少垃圾收集时的停顿时间。适用于应用服务器、电信领域等。
典型配置：
java -Xmx3550m -Xms3550m -Xmn2g -Xss128k -XX:ParallelGCThreads=20 -XX:+UseConcMarkSweepGC -XX:+UseParNewGC
-XX:+UseConcMarkSweepGC：设置年老代为并发收集。测试中配置这个以后，-XX:NewRatio=4的配置失效了，原因不明。所以，此时年轻代大小最好用-Xmn设置。
-XX:+UseParNewGC:设置年轻代为并行收集。可与CMS收集同时使用。JDK5.0以上，JVM会根据系统配置自行设置，所以无需再设置此值。

java -Xmx3550m -Xms3550m -Xmn2g -Xss128k -XX:+UseConcMarkSweepGC -XX:CMSFullGCsBeforeCompaction=5 -XX:+UseCMSCompactAtFullCollection
-XX:CMSFullGCsBeforeCompaction：由于并发收集器不对内存空间进行压缩、整理，所以运行一段时间以后会产生“碎片”，使得运行效率降低。此值设置运行多少次GC以后对内存空间进行压缩、整理。
-XX:+UseCMSCompactAtFullCollection：打开对年老代的压缩。可能会影响性能，但是可以消除碎片

辅助信息
JVM提供了大量命令行参数，打印信息，供调试使用。主要有以下一些：
-XX:+PrintGC
输出形式：[GC 118250K->113543K(130112K), 0.0094143 secs]
                [Full GC 121376K->10414K(130112K), 0.0650971 secs]
-XX:+PrintGCDetails
输出形式：[GC [DefNew: 8614K->781K(9088K), 0.0123035 secs] 118250K->113543K(130112K), 0.0124633 secs]
                [GC [DefNew: 8614K->8614K(9088K), 0.0000665 secs][Tenured: 112761K->10414K(121024K), 0.0433488 secs] 121376K->10414K(130112K), 0.0436268 secs]
-XX:+PrintGCTimeStamps -XX:+PrintGC：PrintGCTimeStamps可与上面两个混合使用
输出形式：11.851: [GC 98328K->93620K(130112K), 0.0082960 secs]
-XX:+PrintGCApplicationConcurrentTime:打印每次垃圾回收前，程序未中断的执行时间。可与上面混合使用
输出形式：Application time: 0.5291524 seconds
-XX:+PrintGCApplicationStoppedTime：打印垃圾回收期间程序暂停的时间。可与上面混合使用
输出形式：Total time for which application threads were stopped: 0.0468229 seconds
-XX:PrintHeapAtGC:打印GC前后的详细堆栈信息
输出形式：
34.702: [GC {Heap before gc invocations=7:
 def new generation   total 55296K, used 52568K [0x1ebd0000, 0x227d0000, 0x227d0000)
eden space 49152K,  99% used [0x1ebd0000, 0x21bce430, 0x21bd0000)
from space 6144K,  55% used [0x221d0000, 0x22527e10, 0x227d0000)
  to   space 6144K,   0% used [0x21bd0000, 0x21bd0000, 0x221d0000)
 tenured generation   total 69632K, used 2696K [0x227d0000, 0x26bd0000, 0x26bd0000)
the space 69632K,   3% used [0x227d0000, 0x22a720f8, 0x22a72200, 0x26bd0000)
 compacting perm gen  total 8192K, used 2898K [0x26bd0000, 0x273d0000, 0x2abd0000)
   the space 8192K,  35% used [0x26bd0000, 0x26ea4ba8, 0x26ea4c00, 0x273d0000)
    ro space 8192K,  66% used [0x2abd0000, 0x2b12bcc0, 0x2b12be00, 0x2b3d0000)
    rw space 12288K,  46% used [0x2b3d0000, 0x2b972060, 0x2b972200, 0x2bfd0000)
34.735: [DefNew: 52568K->3433K(55296K), 0.0072126 secs] 55264K->6615K(124928K)Heap after gc invocations=8:
 def new generation   total 55296K, used 3433K [0x1ebd0000, 0x227d0000, 0x227d0000)
eden space 49152K,   0% used [0x1ebd0000, 0x1ebd0000, 0x21bd0000)
  from space 6144K,  55% used [0x21bd0000, 0x21f2a5e8, 0x221d0000)
  to   space 6144K,   0% used [0x221d0000, 0x221d0000, 0x227d0000)
 tenured generation   total 69632K, used 3182K [0x227d0000, 0x26bd0000, 0x26bd0000)
the space 69632K,   4% used [0x227d0000, 0x22aeb958, 0x22aeba00, 0x26bd0000)
 compacting perm gen  total 8192K, used 2898K [0x26bd0000, 0x273d0000, 0x2abd0000)
   the space 8192K,  35% used [0x26bd0000, 0x26ea4ba8, 0x26ea4c00, 0x273d0000)
    ro space 8192K,  66% used [0x2abd0000, 0x2b12bcc0, 0x2b12be00, 0x2b3d0000)
    rw space 12288K,  46% used [0x2b3d0000, 0x2b972060, 0x2b972200, 0x2bfd0000)
}
, 0.0757599 secs]
-Xloggc:filename:与上面几个配合使用，把相关日志信息记录到文件以便分析。




#param
##-Xms
初始堆大小初始堆的大小，也是堆大小的最小值，默认值是总共的物理内存/64（且小于1G），默认情况下，当堆中可用内存小于40%(这个值可以用-XX: MinHeapFreeRatio 调整，如-X:MinHeapFreeRatio=30)时，堆内存会开始增加，一直增加到-Xmx的大小；

##-Xmx 最大堆大小
堆的最大值，默认值是总共的物理内存/64（且小于1G），如果Xms和Xmx都不设置，则两者大小会相同，默认情况下，当堆中可用内存大于70%（这个值可以用-XX: MaxHeapFreeRatio 调整，如-X:MaxHeapFreeRatio=60）时，堆内存会开始减少，一直减小到-Xms的大小；

整个堆的大小=年轻代大小+年老代大小，堆的大小不包含持久代大小，如果增大了年轻代，年老代相应就会减小，官方默认的配置为年老代大小/年轻代大小=2/1左右（使用-XX:NewRatio可以设置-XX:NewRatio=5，表示年老代/年轻代=5/1）；

建议在开发测试环境可以用Xms和Xmx分别设置最小值最大值，但是在线上生产环境，Xms和Xmx设置的值必须一样，原因与年轻代一样——防止抖动；

-Xmn    年轻代大小(1.4or lator)
-XX:NewSize 设置年轻代大小(for 1.3/1.4)
-XX:MaxNewSize  年轻代最大值(for 1.3/1.4)
##-XX:PermSize   
设置持久代(perm gen)初始值
##-XX:MaxPermSize 设置持久代最大值
##-XX:MaxMetaspaceSize
默认情况下，-XX:MaxMetaspaceSize的值没有限制，因此元空间甚至可以延伸到交换区，但是这时候当我们进行本地内存分配时将会失败。
64位的服务器端JVM来说，其默认的–XX:MetaspaceSize值为21MB
-XX:MinMetaspaceFreeRatio和-XX:MaxMetaspaceFreeRatio，他们类似于GC的FreeRatio选项，用来设置元空间空闲比例的最大值和最小值。

##-Xss 每个线程的堆栈大小
这个参数用于设置每个线程的栈内存，默认1M，一般来说是不需要改的。除非代码不多，可以设置的小点，另外一个相似的参数是-XX:ThreadStackSize，这两个参数在1.6以前，都是谁设置在后面，谁就生效；1.6版本以后，-Xss设置在后面，则以-Xss为准，-XXThreadStackSize设置在后面，则主线程以-Xss为准，其它线程以-XX:ThreadStackSize为准。

##-Xrs
减少JVM对操作系统信号（OS Signals）的使用（JDK1.3.1之后才有效），当此参数被设置之后，jvm将不接收控制台的控制handler，以防止与在后台以服务形式运行的JVM冲突（这个用的比较少，参考：http://www.blogjava.net/midstr/archive/2008/09/21/230265.html）。

##-Xprof
跟踪正运行的程序，并将跟踪数据在标准输出输出；适合于开发环境调试。

##-Xnoclassgc
关闭针对class的gc功能；因为其阻止内存回收，所以可能会导致OutOfMemoryError错误，慎用；

##-Xincgc
开启增量gc（默认为关闭）；这有助于减少长时间GC时应用程序出现的停顿；但由于可能和应用程序并发执行，所以会降低CPU对应用的处理能力。

##-Xloggc:file
与-verbose:gc功能类似，只是将每次GC事件的相关情况记录到一个文件中，文件的位置最好在本地，以避免网络的潜在问题。

若与verbose命令同时出现在命令行中，则以-Xloggc为准。


-XX:ThreadStackSize Thread Stack Size
-XX:NewRatio    年轻代(包括Eden和两个Survivor区)与年老代的比值(除去持久代)
-XX:SurvivorRatio   Eden区与Survivor区的大小比值
-XX:LargePageSizeInBytes    内存页的大小不可设置过大， 会影响Perm的大小
-XX:+UseFastAccessorMethods 原始类型的快速优化
-XX:+DisableExplicitGC      关闭System.gc()
-XX:MaxTenuringThreshold    垃圾最大年龄  串行GC时才有效
-XX:+AggressiveOpts     加快编译
-XX:+UseBiasedLocking   锁机制的性能改善
-Xnoclassgc             禁用垃圾回收
-XX:SoftRefLRUPolicyMSPerMB     每兆堆空闲空间中SoftReference的存活时间  1s
-XX:PretenureSizeThreshold      对象超过多大是直接在旧生代分配，另一种直接在旧生代分配的情况是大的数组对象,且数组中无外部引用对象
-XX:TLABWasteTargetPercent      TLAB占eden区的百分比  1%
-XX:+CollectGen0First           FullGC时是否先YGC   false

##并行收集器相关参数
-XX:+UseParallelGC      Full GC采用parallel MSC
-XX:+UseParNewGC        设置年轻代为并行收集 JDK5.0以上,无需再设置此值
-XX:ParallelGCThreads   并行收集器的线程数，此值最好配置与处理器数目相等
-XX:+UseParallelOldGC   年老代垃圾收集方式为并行收集(Parallel Compacting)
-XX:MaxGCPauseMillis    每次年轻代垃圾回收的最长时间(最大暂停时间)
-XX:+UseAdaptiveSizePolicy  自动选择年轻代区大小和相应的Survivor区比例
-XX:GCTimeRatio         设置垃圾回收时间占程序运行时间的百分比，公式为1/(1+n)
-XX:+ScavengeBeforeFullGC   Full GC前调用YGC   true

##CMS相关参数
-XX:+UseConcMarkSweepGC     使用CMS内存收集
-XX:+AggressiveHeap         试图是使用大量的物理内存，长时间大内存使用的优化，能检查计算资源（内存， 处理器数量）至少需要256MB内存，大量的CPU／内存， （在1.4.1在4CPU的机器上已经显示有提升）
-XX:CMSFullGCsBeforeCompaction      多少次后进行内存压缩      由于并发收集器不对内存空间进行压缩,整理,所以运行一段时间以后会产生"碎片",使得运行效率降低.此值设置运行多少次GC以后对内存空间进行压缩,整理.

-XX:+CMSParallelRemarkEnabled       降低标记停顿
-XX+UseCMSCompactAtFullCollection   在FULL GC的时候， 对年老代的压缩        CMS是不会移动内存的， 因此， 这个非常容易产生碎片， 导致内存不够用， 因此， 内存的压缩这个时候就会被启用。 增加这个参数是个好习惯。
可能会影响性能,但是可以消除碎片
-XX:+UseCMSInitiatingOccupancyOnly  使用手动定义初始化定义开始CMS收集      禁止hostspot自行触发CMS GC
-XX:CMSInitiatingOccupancyFraction=70   使用cms作为垃圾回收，使用70％后开始CMS收集，为了保证不出现promotion failed(见下面介绍)错误,值的设置需要满足以下公式CMSInitiatingOccupancyFraction计算公式
-XX:CMSInitiatingPermOccupancyFraction  设置Perm Gen使用到达多少比率时触发
-XX:+CMSIncrementalMode     设置为增量模式     用于单CPU情况
-XX:+CMSClassUnloadingEnabled

##辅助信息
### -XX:+PrintGC
输出形式:
[GC 118250K->113543K(130112K), 0.0094143 secs]
[Full GC 121376K->10414K(130112K), 0.0650971 secs]

### -XX:+PrintGCDetails
输出形式:[GC [DefNew: 8614K->781K(9088K), 0.0123035 secs] 118250K->113543K(130112K), 0.0124633 secs]
[GC [DefNew: 8614K->8614K(9088K), 0.0000665 secs][Tenured: 112761K->10414K(121024K), 0.0433488 secs] 121376K->10414K(130112K), 0.0436268 secs]

### -XX:+PrintGCTimeStamps
### -XX:+PrintGC:PrintGCTimeStamps
可与-XX:+PrintGC -XX:+PrintGCDetails混合使用
输出形式:11.851: [GC 98328K->93620K(130112K), 0.0082960 secs]
### -XX:+PrintGCApplicationStoppedTime
打印垃圾回收期间程序暂停的时间.可与上面混合使用
输出形式:Total time for which application threads were stopped: 0.0468229 seconds
### -XX:+PrintGCApplicationConcurrentTime
打印每次垃圾回收前,程序未中断的执行时间.可与上面混合使用
输出形式:Application time: 0.5291524 seconds
### -XX:+PrintHeapAtGC
打印GC前后的详细堆栈信息
### -Xloggc:filename    把相关日志信息记录到文件以便分析.
与上面几个配合使用
### -XX:+PrintClassHistogram
garbage collects before printing the histogram.
### -XX:+PrintTLAB
查看TLAB空间的使用情况
### XX:+PrintTenuringDistribution
查看每次minor GC后新的存活周期的阈值
Desired survivor size 1048576 bytes, new threshold 7 (max 15)
new threshold 7即标识新的存活周期的阈值为7。


## 堆快照
###-XX:+HeapDumpOnOutOfMemoryError     设定当发生OOM时自动dump出堆信息。不过该方法需要JDK5以上版本。
路径
###-XX:HeapDumpPath
-verbose
三个子标志： gc、 class 和 jni

-Xint，在解释模式下运行 JVM（对于测试 JIT 编译器实际上是否对您的代码起
作用或者验证是否 JIT 编译器中有一个 bug， 这都很有用）。
-Xloggc:，和 -verbose:gc 做同样的事，但是记录一个文件而不输出到命令行窗口。



---
#GC
##CMS
Mark-Sweep
第一次标记（Initial Marking）
该步聚须暂停整个应用，扫描从根集合对象到旧生代中可直接访问的对象，并对这些对象进行着色。对于着色的对象CMS采用一个外部的bit数组来进行记录。







---
#dev
空闲内存：
Runtime.getRuntime().freeMemory()
总内存：
Runtime.getRuntime().totalMemory()
最大内存：
Runtime.getRuntime().maxMemory()
已占用的内存：
Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()




---
#OOM分析
[深入理解OutOfMemoryError](http://blog.csdn.net/wisgood/article/details/21939495)
[plumbr](https://plumbr.eu/)
##I.OutOfMemoryError： PermGen space
发生这种问题的原意是程序中使用了大量的jar或class，使java虚拟机装载类的空间不够，与Permanent Generation space有关。

解决这类问题有以下两种办法：
1. 增加java虚拟机中的XX:PermSize和XX:MaxPermSize参数的大小，其中XX:PermSize是初始永久保存区域大小，XX:MaxPermSize是最大永久保存区域大小。如针对tomcat6.0，在catalina.sh 或catalina.bat文件中一系列环境变量名说明结束处（大约在70行左右） 增加一行：
JAVA_OPTS=" -XX:PermSize=64M -XX:MaxPermSize=128m"
如果是windows服务器还可以在系统环境变量中设置。感觉用tomcat发布sprint+struts+hibernate架构的程序时很容易发生这种内存溢出错误。使用上述方法，我成功解决了部署ssh项目的tomcat服务器经常宕机的问题。
2. 清理应用程序中web-inf/lib下的jar，如果tomcat部署了多个应用，很多应用都使用了相同的jar，可以将共同的jar移到tomcat共同的lib下，减少类的重复加载。这种方法是网上部分人推荐的，我没试过，但感觉减少不了太大的空间，最靠谱的还是第一种方法。

##II.OutOfMemoryError：  Java heap space
发生这种问题的原因是java虚拟机创建的对象太多，在进行垃圾回收之间，虚拟机分配的到堆内存空间已经用满了，与Heap space有关。
1.内存中加载的数据量过于庞大，如一次从数据库取出过多数据；
2.集合类中有对对象的引用，使用完后未清空，使得JVM不能回收；
3.代码中存在死循环或循环产生过多重复的对象实体；
4.使用的第三方软件中的BUG；
5.启动参数内存值设定的过小；

解决这类问题有两种思路：
  1)检查代码中是否有死循环或递归调用。
  2)检查是否有大循环重复产生新对象实体。
  3)检查对数据库查询中，是否有一次获得全部数据的查询。一般来说，如果一次取十万条记录到内存，就可能引起内存溢出。这个问题比较隐蔽，在上线前，数据库中数据较少，不容易出问题，上线后，数据库中数据多了，一次查询就有可能引起内存溢出。因此对于数据库查询尽量采用分页的方式查询。
  4)检查List、MAP等集合对象是否有使用完后，未清除的问题。List、MAP等集合对象会始终存有对对象的引用，使得这些对象不能被GC回收。
增加Java虚拟机中Xms（初始堆大小）和Xmx（最大堆大小）参数的大小。如：set JAVA_OPTS= -Xms256m -Xmx1024m

##III.OutOfMemoryError：unable to create new native thread
这种错误在Java线程个数很多的情况下容易发生
这个限制的大小跟平台相关，如果你对这个限制的大小好奇的话，可以用下面这小段代码做下试验。在我的64位的Mac OSX上使用最新的JDK7，当创建的线程到2032时的就会报错。
```
while(true){
    new Thread(new Runnable(){
        public void run() {
            try {
                Thread.sleep(10000000);
            } catch(InterruptedException e) { }
        }
    }).start();
}
```


##IV.java.lang.OutOfMemoryError: GC overhead limit exceeded
这个问题有点特殊。这里没有提示说堆还是持久代有问题，虚拟机只是告诉你你的程序花在垃圾回收上的时间太多了，却没有什么见效。默认的话，如果你98%的时间都花在GC上并且回收了才不到2%的空间的话，虚拟机才会抛这个异常。这是一个快速失败的安全保障的很好的实践。一般来说禁用它也没有太大用处，如果需要的话你可以把-XX:-UseGCOverheadLimit加到启动脚本里。

##V.java.lang.OutOfMemoryError: nativeGetNewTLA
指当虚拟机不能分配新的线程本地空间(Thread Local Area）的时候错误信息。
这个异常只有在jRockit虚拟机时才会碰到。
线程本地空间是多线程程序里面为了更有效的进行内存分配而建立的缓存。每一个线程都有一份自己的缓存，当这个线程要创建对象的时候，就在这上面分配。如果你有很多线程同时并发，又要创建大量的对象，可能会出现这个问题，这种情况下你可以调整一下-XXtlaSize这个参数。


##VI.java.lang.OutOfMemoryError: Requested array size exceeds VM limit
当你正准备创建一个超过虚拟机允许的大小的数组时，这条错误就会出现在你眼前。在我的64位Mac系统上的最新的JDK7，我发现如果数组的长度是Integer.MAXINT-2的时候，是正常的，但只要再增加一个，也就是Integer.MAXINT-1,就成为那最后一根稻草了。在老的32位机器上，由于堆比较小，限制数组的大小是有好处的。不过在现代的64位机器上感觉有点多余。

##VII.java.lang.OutOfMemoryError: request bytes for . Out of swap space？
这个错误是当虚拟机向本地操作系统申请内存失败时抛出的。
这和你用完了堆或者持久化中的内存的情况有些不同。这个错误通常是在你的程序已经逼近平台限制的时候产生的。这个信息告诉你的是你可能已经用光了物理内存以及虚拟内存了。由于虚拟内存通常是用磁盘作为交换分区，因此你最先想到的解决方法可能是先增加交换分区的大小。不过我从没见过一个程序在频繁进行内存交换还能正常运行的，所以这个方法可能不会起到什么作用。

##IX.java.lang.OutOfMemoryError: (Native method)
，现在是时候找你开发C语言的小伙伴请求帮助了。因为现在你看到的错误信息是来自本地代码的，相对于刚才的出错信息，这次异常是在JNI或者 本地方法中检测到的，而不是在虚拟机执行的代码中。


##X.OOM但老年区还有空间
Native Memory的例外，如果你在以下场景：
* 使用了NIO或者NIO框架（Mina/Netty）
* 使用了DirectByteBuffer分配字节缓冲区
* 使用了MappedByteBuffer做内存映射
由于Native Memory只能通过FullGC（或是CMS GC）回收，所以除非你非常清楚这时真的有必要，否则不要轻易调用System.gc()，且行且珍惜。







----
#safepoint
[safepoint时如何让Java线程全部阻塞](http://blog.csdn.net/iter_zc/article/details/41892567?utm_source=tuicool&utm_medium=referral)





---
#内存分析
[使用 Eclipse Memory Analyzer 进行堆转储文件分析](http://www.ibm.com/developerworks/cn/opensource/os-cn-ecl-ma/index.html)
```
0x01b6d627: call   0x01b2b210         ; OopMap{[60]=Oop off=460}
                                       ;*invokeinterface size
                                       ; - Client1::main@113 (line 23)
                                       ;   {virtual_call}
 0x01b6d62c: nop                       ; OopMap{[60]=Oop off=461}
                                       ;*if_icmplt
                                       ; - Client1::main@118 (line 23)
 0x01b6d62d: test   %eax,0x160100      ;   {poll}
 0x01b6d633: mov    0x50(%esp),%esi
 0x01b6d637: cmp    %eax,%esi
```
test  %eax,0x160100 就是一个safepoint polling page操作。当JVM要停止所有的Java线程时会把一个特定内存页设置为不可读，那么当Java线程读到这个位置的时候就会被挂起

[Points on Safepoints](http://javaagile.blogspot.jp/2012/11/points-on-safepoints.html) 这篇文章说明了一些问题。首先是关于一些safepoint的观点

* All commercial GCs use safepoints.
* The GC reigns in all threads at safepoints. This is when it has exact knowledge of things touched by the threads.
* They can also be used for non-GC activity like optimization.
* A thread at a safepoint is not necessarily idle but it often is.
* Safepoint opportunities should be frequent.
* All threads need to reach a global safepoint typically every dozen or so instructions (for example, at the end of loops).

safepoint机制可以stop the world，不仅仅是在GC的时候用，
有很多其他地方也会用它来stop the world，阻塞所有Java线程，从而可以安全地进行一些操作。

OpenJDK里面关于safepoint的一些说明
```
// Begin the process of bringing the system to a safepoint.
// Java threads can be in several different states and are
// stopped by different mechanisms:
//
//  1. Running interpreted
//     The interpeter dispatch table is changed to force it to
//     check for a safepoint condition between bytecodes.
//  2. Running in native code
//     When returning from the native code, a Java thread must check
//     the safepoint _state to see if we must block.  If the
//     VM thread sees a Java thread in native, it does
//     not wait for this thread to block.  The order of the memory
//     writes and reads of both the safepoint state and the Java
//     threads state is critical.  In order to guarantee that the
//     memory writes are serialized with respect to each other,
//     the VM thread issues a memory barrier instruction
//     (on MP systems).  In order to avoid the overhead of issuing
//     a mem barrier for each Java thread making native calls, each Java
//     thread performs a write to a single memory page after changing
//     the thread state.  The VM thread performs a sequence of
//     mprotect OS calls which forces all previous writes from all
//     Java threads to be serialized.  This is done in the
//     os::serialize_thread_states() call.  This has proven to be
//     much more efficient than executing a membar instruction
//     on every call to native code.
//  3. Running compiled Code
//     Compiled code reads a global (Safepoint Polling) page that
//     is set to fault if we are trying to get to a safepoint.
//  4. Blocked
//     A thread which is blocked will not be allowed to return from the
//     block condition until the safepoint operation is complete.
//  5. In VM or Transitioning between states
//     If a Java thread is currently running in the VM or transitioning
//     between states, the safepointing code will wait for the thread to
//     block itself when it attempts transitions to a new state.
```



---















