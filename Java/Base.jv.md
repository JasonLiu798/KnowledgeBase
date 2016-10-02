#Java Basis
---
[关于Java你可能不知道的10件事](https://github.com/oldratlee/translations/blob/master/10-things-you-didnt-know-about-java/README.md)
[class文件结构](http://blog.csdn.net/dc_726/article/details/7944154)

[jvm se7 Specification](http://docs.oracle.com/javase/specs/jvms/se7/html/index.html)
[instance of ](http://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html#jvms-6.5.instanceof)
[Java程序员不要错过的7款新工具](https://www.evget.com/article/2014/7/8/21289.html)


---
#技术栈
##Java语言
基础, 基本类型, 操作符, 运算符, 表达式
面向对象, 类, 继承, 多态, 重写, 重载
String, Object, Array, Enum
集合, List, ArrayList, Set, HashSet, Map, HashMap, HashTable
File, IO, NIO, InputStream, OutputStream, Reader, Writer, Selector
多线程, 并发, Thread, Runnable, Future
注解
反射
JDBC
IOC依赖注入, AOP 面向切面编程
##JavaEE
Servlet
JSP, JSTL, EL
Tomcat

##框架与库
Spring
Hibernate,IBatis
SpringMVC, Struts
Quartz
Ehcache
apache commons

##开发工具
Eclipse
IDea

##包管理
maven
gradle
ant

##设计模式
工厂模式
工厂方法模式
策略模式
门面模式
代理模式
桥接模式
单例模式
多例模式
装饰器模式
迭代模式

##测试
覆盖率
[JAVA代码覆盖率采集与分析方案](http://blog.csdn.net/smile0102/article/details/48688763)
Arquillian
TestNG
JUnit
Mockito
Powermock

4.1.2. 虚拟化

https://linuxcontainers.org/
http://www.linux-kvm.org/page/Main_Page
http://www.xenproject.org/
https://www.docker.io/

　　4.1.3. 监控

http://www.nagios.org/
http://ganglia.info/

　　4.1.4. 负载均衡

http://www.linuxvirtualserver.org/

　　4.1.5. 学习使用git

https://github.com/
https://git.oschina.net/

　　4.1.6. 学习使用maven

http://maven.apache.org/

　　4.1.7. 学习使用gradle

http://www.gradle.org/

　　4.1.8. 学习一个小语种语言

Groovy
Scala
LISP, Common LISP, Schema, Clojure
R
Julia
Lua
Ruby

　　4.1.9. 尝试了解编码的本质

了解以下概念
ASCII, ISO-8859-1
GB2312, GBK, GB18030
Unicode, UTF-8
不使用 String.getBytes() 等其他工具类/函数完成下面功能

public static void main(String[] args) throws IOException {
    String str = "Hello, 我们是中国人。";
    byte[] utf8Bytes = toUTF8Bytes(str);
    FileOutputStream fos = new FileOutputStream("f.txt");
    fos.write(utf8Bytes);
    fos.close();
}
public static byte[] toUTF8Bytes(String str) {
    return null; // TODO
}
想一下上面的程序能不能写一个转GBK的？
写个程序自动判断一个文件是哪种编码





----
#变量
##基本类型
[自动拆箱装箱](http://www.cnblogs.com/danne823/archive/2011/04/22/2025332.html)
[自动拆箱装箱原理](http://www.cnblogs.com/dolphin0520/p/3780005.html)
当 "=="运算符的两个操作数都是 包装器类型的引用，则是比较指向的是否是同一个对象，而如果其中有一个操作数是表达式（即包含算术运算）则比较的是数值（即会触发自动拆箱的过程）
另外，对于包装器类型，equals方法并不会进行类型转换。

```
Integer a = 1;或Integer a = Integer.valueOf(1); //值介于-128至127直接时，作为基本类型
Integer a = new Integer(1); //无论值是多少，都作为对象
```

##引用类型
类、接口类型、数组类型、枚举类型、注解类型




[share/vm/oops下的代码做fast subtype check的问题](http://hllvm.group.iteye.com/group/topic/26896)
[OpenJDK / jdk7u / jdk7u / langtools](http://hg.openjdk.java.net/jdk7u/jdk7u/langtools/file/tip/src/share/classes/com/sun/tools/javac/parser/Token.java)

##数组
http://blog.csdn.net/orzlzro/article/details/7017435


##static
[Java中的static关键字解析](http://www.cnblogs.com/dolphin0520/p/3799052.html)


---
#编码
https://github.com/alibaba/dubbo
[中文编码](http://www.ibm.com/developerworks/cn/java/j-lo-chinesecoding/)
[git example](https://github.com/alibaba/dubbo/tree/master/dubbo-test/dubbo-test-examples/src/main/java/com/alibaba/dubbo/examples)
[java字符串编码及转换](http://blog.csdn.net/songdexv/article/details/7471189)
class文件采用utf8的编码方式
JVM运行时采用utf16
Java的字符串是unicode编码的

从外部资源读取数据：
JVM的默认字符集，这个默认字符集在虚拟机启动时决定，通常根据语言环境和底层操作系统的 charset来确定。可以通过以下方式得到JVM的默认字符集：
Charset.defaultCharset();

native2ascii工具使用
native2ascii -encoding UTF-8 displaytag_zh_CN.properties displaytag_zh_CN_2.properties


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

[hashmap](http://www.jameswxx.com/java/hashmap%E6%B7%B1%E5%85%A5%E5%88%86%E6%9E%90/)



##hashmap
[Java HashMap的死循环](http://coolshell.cn/articles/9606.html)



---
#序列化
[对比](https://github.com/eishay/jvm-serializers/tree/master/protowar)
[对比](http://blog.csdn.net/smallnest/article/details/38847653)
[对比](http://www.oschina.net/question/54100_91827)

[高性能序列化框架FST](http://itindex.net/detail/51375-%E6%80%A7%E8%83%BD-%E5%BA%8F%E5%88%97%E5%8C%96-%E6%A1%86%E6%9E%B6)

[fast-serialization](https://github.com/RuedigerMoeller/fast-serialization)
[kryo](https://github.com/EsotericSoftware/kryo)

[kryo jdk fst Serializable 使用对比](http://my.oschina.net/chenleijava/blog/198721)

fst增加字段
https://github.com/RuedigerMoeller/fast-serialization/issues/103
General remark:

Versioning is always an issue which needs to be handled explicitely, there is no magical solution. "serialversionId" is a bad and slow approach as it puts a penalty for each object written (even tiny ones), in addition it enlarges message size (+ ~8 bytes per object ref).
serialversionId just throws an exception in case it does not match, so what have you gained ?.
even half baked handling of versioning requires extra tags inside the binary object representations, approaches like "extension blocks" destroy linear memory write access (=cache misses).
more advanced handling of versioning requires additional metadata such as with SBE or protobuf message files. Both libraries have significant limitations in message structure, often leading to an additional transfer step in order to create application-level objects from message objects. This overhead usually is not included in benchmarks.
You need to plan ahead regarding version issues, there are several aproaches which do not impose a performance/message size penalty:

for RPC, at connect time put in a version checking at application level.
for persistence: write a version id first before writing your objects.
strategies for backward compatibility:
1) Do not modify classes but instead subclass from version 1. E.g. MyDataV1 extends MyData. 
2) I have also used package renaming to deal with different versions (my.package.v1, mypackage.v2). 
3) put in a "Object extraData", which can be used as a container for additions later on (simple cases)

There is no such thing like automatical versioning, you have to deal with it explicitely at application level most of the time.

I'll still try to figure out a scheme to solve the issue without hurting use cases of fst handling versioning e.g. at connect time.



##Java序列化缺点
* 序列化后码流太大
* 性能太低

##protobuf
[Protostuff序列化](http://www.cnblogs.com/549294286/p/4612601.html)
* 结构化数据存储格式（XML，JSON等）
* 搞笑的编解码性能
* 语言无关、平台无关、扩展性好
* 官方支持Java、C++、Python
优点：
* 文本化数据结构，平台无关
* 通过表示字段的顺序，实现协议前向兼容
* 自动代码生成，不需要手工编写同样数据结构的C++和Java版本
* 方便后续管理和维护

##thrift



---
#钩子
[关闭钩子](http://blog.csdn.net/jaune161/article/details/46422881)

---
#IO
[深入分析 Java I/O 的工作机制](http://www.ibm.com/developerworks/cn/java/j-lo-javaio/)
[IO的阻塞与非阻塞、同步与异步以及Java网络IO交互方式](http://www.cnblogs.com/zhuYears/archive/2012/09/28/2690194.html)
[JAVA 中BIO,NIO,AIO的理解](http://my.oschina.net/hanruikai/blog/294108)
[Java的通用I/O API设计](https://github.com/oldratlee/translations/blob/master/generic-io-api-in-java-and-api-design/README.md)
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
#[泛型](./Generics.jv.md)





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
#Exception
[深入理解java异常处理机制](http://blog.csdn.net/hguisu/article/details/6155636)
```
Throwable
    Exception
        RuntimeException
            NullPointerException
            IndexOutOfBoundsException
            ArithmeticException
                MathArithmeticException
        IOException
        ...
    Error
        Abort
        FatalError
        InternalError
        NoSuchClassError
        ReflectionError
        VirtualMachineError
            StackOverflowError
            OutOfMemoryError

```
Error:
1．总是不可控制的(unchecked)。
2．经常用来用于表示系统错误或低层资源的错误。 
3．如何可能的话，应该在系统级被捕捉。
这些错误表示故障发生于虚拟机自身、或者发生在虚拟机试图执行应用时，如Java虚拟机运行错误（Virtual MachineError）、类定义错误（NoClassDefFoundError）等。这些错误是不可查的，因为它们在应用程序的控制和处理能力之 外，而且绝大多数是程序运行时不允许出现的状况。对于设计合理的应用程序来说，即使确实发生了错误，本质上也不应该试图去处理它所引起的异常状况。

Exception：
[检查异常和未检查异常不同之处](http://blog.csdn.net/randomnet/article/details/7764579)
1．可以是可被控制(checked) 或不可控制的(unchecked)。
2．表示一个由程序员导致的错误。
3．应该在应用程序级被处理。

##checked exception(检查异常)
除了RuntimeException，其他的异常都是checked exception )的几种处理方式：
1、继续抛出，消极的方法，一直可以抛到java虚拟机来处理
2、用try...catch捕获
注意，对于检查的异常必须处理，或者必须捕获或者必须抛出

##unchecked exception(未检查异常)对于未检查异常也叫RuntimeException(运行时异常).
对未检查的异常(unchecked exception )的几种处理方式：
1、捕获
2、继续抛出
3、不处理


##unchecked异常,即 RuntimeException（运行时异常） 
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

##trick:JVM不理会受检异常
```java
public class Test {
    // 方法没有声明throws
    public static void main(String[] args) {
        doThrow(new SQLException());
    }

    static void doThrow(Exception e) {
        Test.<RuntimeException> doThrow0(e);
    }

    @SuppressWarnings("unchecked")
    static <E extends Exception>
    void doThrow0(Exception e) throws E {
        throw (E) e;
    }
}
```




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



































