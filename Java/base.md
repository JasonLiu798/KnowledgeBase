#Java Basis
---



----
#编码
https://github.com/alibaba/dubbo
[中文编码](http://www.ibm.com/developerworks/cn/java/j-lo-chinesecoding/)
[git example](https://github.com/alibaba/dubbo/tree/master/dubbo-test/dubbo-test-examples/src/main/java/com/alibaba/dubbo/examples)

---
#Collection 集合
[Vector和ArrayList的本质区别到底是什么？](http://www.iteye.com/topic/924440)

##Java集合类框架的最佳实践
根据应用的需要正确选择要使用的集合的类型对性能非常重要，比如：假如元素的大小是固定的，而且能事先知道，我们就应该用Array而不是ArrayList。
有些集合类允许指定初始容量。因此，如果我们能估计出存储的元素的数目，我们可以设置初始容量来避免重新计算hash值或者是扩容。
为了类型安全，可读性和健壮性的原因总是要使用泛型。同时，使用泛型还可以避免运行时的ClassCastException。
使用JDK提供的不变类(immutable class)作为Map的键可以避免为我们自己的类实现hashCode()和equals()方法。
编程的时候接口优于实现。
底层的集合实际上是空的情况下，返回长度是0的集合或者是数组，不要返回null。


---
##序列化
[Protostuff序列化](http://www.cnblogs.com/549294286/p/4612601.html)
[对比](https://github.com/eishay/jvm-serializers/tree/master/protowar)
[对比](http://blog.csdn.net/smallnest/article/details/38847653)
[对比](http://www.oschina.net/question/54100_91827)

[高性能序列化框架FST](http://itindex.net/detail/51375-%E6%80%A7%E8%83%BD-%E5%BA%8F%E5%88%97%E5%8C%96-%E6%A1%86%E6%9E%B6)
[ kryo jdk fst Serializable对比](http://my.oschina.net/chenleijava/blog/198721)


---
#IO
[深入分析 Java I/O 的工作机制](http://www.ibm.com/developerworks/cn/java/j-lo-javaio/)
[IO的阻塞与非阻塞、同步与异步以及Java网络IO交互方式](http://www.cnblogs.com/zhuYears/archive/2012/09/28/2690194.html)
[JAVA 中BIO,NIO,AIO的理解](http://my.oschina.net/hanruikai/blog/294108)

##同步异步
A synchronous I/O operation causes the requesting process to be blocked until that I/O operation completes;
An asynchronous I/O operation does not cause the requesting process to be blocked;
判断同步和异步的标准在于：一个IO操作直到完成，是否导致程序进程的阻塞。如果阻塞就是同步的，没有阻塞就是异步的。这里的IO操作指的是真实的IO操作，也就是数据从内核拷贝到系统进程（读）的过程。
同步能够保证程序的可靠性，而异步可以提升程序的性能。
##阻塞（blocking）与非阻塞（non-blocking）IO
非阻塞IO会在发出IO请求后立即得到回应，即使数据包没有准备好，也会返回一个错误标识，使得操作进程不会阻塞在那里。操作进程会通过多次请求的方式直到数据准备好，返回成功的标识。

##nio
[在 Java 7 中体会 NIO.2 异步执行的快乐](http://www.ibm.com/developerworks/cn/java/j-lo-nio2/)

##BIO、NIO、AIO适用场景分析
BIO方式适用于连接数目比较小且固定的架构，这种方式对服务器资源要求比较高，并发局限于应用中，JDK1.4以前的唯一选择，但程序直观简单易理解。 
NIO方式适用于连接数目多且连接比较短（轻操作）的架构，比如聊天服务器，并发局限于应用中，编程比较复杂，JDK1.4开始支持。 
AIO方式使用于连接数目多且连接比较长（重操作）的架构，比如相册服务器，充分调用OS参与并发操作，编程比较复杂，JDK7开始支持。 

##文件
File 并不代表一个真实存在的文件对象，代表路径描述符


[深入分析 Java I/O 的工作机制](https://www.ibm.com/developerworks/cn/java/j-lo-javaio/)

synchronous
A synchronous I/O operation causes the requesting process to be blocked until that I/O operation completes;
asynchronous
An asynchronous I/O operation does not cause the requesting process to be blocked;


---
#泛型
http://blog.csdn.net/jinuxwu/article/details/6771121

---
## 引用
[理解Java的GC与幽灵引用](http://www.iteye.com/topic/401478)


---
#annotation
[Java Annotation入门](http://www.blogjava.net/ericwang/archive/2005/12/13/23743.html)

---
#interface abstract class
接口和抽象类都按照“不为实现写代码”的设计原则，这是为了增加代码的灵活性，以应付不断变化的要求。下面是一些帮助你回答这个问题的指南：

在Java中，你只能继承一个类，但实现多个接口。所以你继承一个类的时候就无法再继承别的类了。
接口是用来代表形容词或行为，例如Runnable、Clonable、Serializable等。因此，如果您使用一个抽象类来实现Runnable和Clonacle，你就不可以使你的类同时实现这两个功能，而如果接口的话就没问题。
抽象类是比接口稍快，所以很在乎时间的应用尽量使用抽象类。
如果多个继承层次的共同行为在在同一个地方编写更好，那么抽象类会是更好的选择。有时候可以在接口里定义函数但是在抽象类里默认功能就能实现接口和抽象类共同工作了。

---
#log
##slf4j
http://www.tuicool.com/articles/IfeUfq

---
#内存管理
[java memory model](https://www.cs.umd.edu/users/pugh/java/memoryModel/)

[java内存泄露](http://www.ibm.com/developerworks/cn/java/l-JavaMemoryLeak/)
##gc
垃圾回收不会发生在永久代，如果永久代满了或者是超过了临界值，会触发完全垃圾回收(Full GC)。如果你仔细查看垃圾收集器的输出信息，就会发现永久代也是被回收的。这就是为什么正确的永久代大小对避免Full GC是非常重要的原因。

---
#Exception异常处理规范
##unchecked异常,即RuntimeException（运行时异常） 
常见RuntimeException:
ArithmeticException int a=0; 
int b= 3/a;
 ClassCastException：    Object x = new Integer(0); 
System.out.println((String)x);
  IndexOutOfBoundsExceptio n 
       ArrayIndexOutOfBoundsExc eption, 
       StringIndexOutOfBoundsEx ception  
int [] numbers = { 1, 2, 3 }; 
int sum = numbers[3];
IllegalArgumentException 
       NumberFormatException 
int a = Interger.parseInt("test"); 
NullPointerExceptionexte nds 

##其他继承自java.lang.Exception得异常统称为Checked Exception
代码效率低，耦合度过高。

##异常处理原则：
使用unchecked异常，也就是RuntimeException
使用异常来表达不期望的各种事件流
##异常处理规范：
使用unchecked异常，要在文档中明确说明会抛出的异常
/**
* 通过<code>key</code>，获取其关联缓存的内容
*
* @param key 缓存key，不能为空<code>null</code>
* @return 如果没有关联缓存，或缓存的内容已过期的话，返回为<code>null</code>
* @throws CacheException 操作超时，或是Cache出错，比如连接失败
* @throws NullPointerException 参数key为<code>null</code>
*/
Serializable get(String key);
##不允许丢弃捕捉到的异常
既然捕获了异常，就要对它进行适当的处理。不要捕获异常之后又把它丢弃，不予理睬。
public void doSomething() {
    try {
        FileInputStream fis = new FileInputStream("/tmp/bugger");
    } catch (IOException ioe) {
        // 1、处理异常。2、重抛异常。3、转成另一种异常  
    }
}
##指定具体的异常，不要使用catch(Exception ex)
在catch语句中尽可能指定具体的异常类型，必要时使用多个catch。
public void doSomething() {
    try {
        FileInputStream fis = new FileInputStream("/tmp/bugger");
    } catch (IOException ioe) {
        // 1、处理异常。2、重抛异常。3、转成另一种异常  
    }
}

##转换后的异常要处理
转换后的异常要去掉caused by原异常。在抛出的异常中，把底层异常的message带进去。
throw new CacheException("Fail to get, cause:  " + e.getMessage());

##在finally程序块中关闭或者释放资源
充分运用finally，保证所有资源都被正确释放。编写finally块时，特别是要注意在finally块之内抛出的异常——这是执行清理任务的最后机会，尽量不要再有难以处理的错误。 

##避免过于庞大的try块 
尽量减小try块的体积

##提供关于异常的有意义的完整的信息
消息 1: "Incorrect argument for method"
消息 2: "Illegal value for ${argument}: ${value}
第一条消息仅说明了参数是非法的或者不正确，但第二条消息包括了参数名和非法值。

---
#junit






---
#BOOK
1 克服盲点看TheJavaLanguageSpecification，2Ed+		Inside the Java Virtual Machine(深入Java虚拟机)
2 学习面向对象		DesignPattern		Refactoring	
3 学习API 		IO，New IO，Collection Framework，Network，RMI，XML..........
		GUI类：JavaBeans-Swing-JavaHelp-Java2D-ImageIO-JAI-Java3D....
		Enterprise类: JDBC-JDO-Servlet-JSP-EJB-JMS-JTA/JTS....
		J2ME类：
学习开发工具的用法：JBuilder，VisualAge，VisualCafe

O'Reilly

David Flanagan        			 Java in Nutshell
Jonathan （专长Java2D）			Java密码学	Java2D图像技术	乐高可编程积木
BruceEckel 					Think in Java C++
Elliotte Rusty Harold 			Java Network Programming  JavaI/O  XML Bible
						Cafe Au Lait网站					
面向对象大师 Grady Booch
Martin Fowler  深入浅出   	Refactoring	UML Distilled		AnalysisPatterns（OOA）
Bill Day	（Java3D）
Alistair Cockburn  	Writing Effictive Use Cases 		Surviving Object-Oriented Projects
Scott Oaks 	JavaThreads		JavaSecurity		Jini in a Nutshell
James Gosling 
Bertrand Meyer		ObjectOrientedSoftwareConstruction（面向对象经典）
Guido van Rossum  	Python语言原创者
Carl Sassenrath		
Charles Petzold		Programming Windows			Code
JefferyRichter			Applied Microsoft .Net Framework Programming(.net经典)
Jeff Prosise  			How。。。。Works  浅显
Ted Neward			Core OWL	AdvancedOWL


知不知，上；
不知不知，病；
是以圣人不病，以其病病，是以不病
企者不立，跨者不行，自见者不明，自是者不彰，自伐者无功，自矜者这不长

Java in a Nutshell:A Desktop Quick Reference		David Flanagan
Java Examples in a Nutshell
Java Threads,2nd Ed
Database Programming with JDBC and Java,2nd Edtion
	JDBC API Tutorial and Reference,
	Understanding SQL and Java Together
Java Swing,2ndEd	Robert Eckstein,Marc Loy,Dave Wood
Java 2D Graphics	Jonathan Knudsen
	Java2D API Graphics	Vincent J.Hardy
JavaVirtualMachine（细说Java虚拟机）
Enterprice JavaBeans,2nd Edition(EJB技术)		Richard Monson-Haefel
Java Internationalization
	Java I/O		JavaNIO
Java Message Service（Java 消息服务）
	
J2EE Blueprint



----
#注解
[@SuppressWarnings的使用、作用、用法](http://blog.csdn.net/mddy2001/article/details/8291484)
rawtypes to suppress warnings relative to un-specific types when using generics on class params





------
#多态
当使用多态方式调用方法时，首先检查父类中是否有该方法，如果没有，则编译错误；
如果有，再去调用子类的该同名方法。























































