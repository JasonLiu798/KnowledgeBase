#Tools
---
#log
##slf4j
[SLF4J 教程](http://yangzb.iteye.com/blog/245844)
    final  Logger logger  =  LoggerFactory.getLogger(Wombat. class );

[为什么要使用SLF4J而不是Log4J](http://www.importnew.com/7450.html)
1 在你的开源或内部类库中使用SLF4J会使得它独立于任何一个特定的日志实现，这意味着不需要管理多个日志配置或者多个日志类库，你的客户端会很感激这点。
2 SLF4J提供了基于占位符的日志方法，这通过去除检查isDebugEnabled(), isInfoEnabled()等等，提高了代码可读性。
3 通过使用SLF4J的日志方法，你可以延迟构建日志信息（Srting）的开销，直到你真正需要，这对于内存和CPU都是高效的。
4 作为附注，更少的暂时的字符串意味着垃圾回收器（Garbage Collector）需要做更好的工作，这意味着你的应用程序有为更好的吞吐量和性能。
5 这些好处只是冰山一角，你将在开始使用SL4J和阅读其中代码的时候知道更多的好处。我强烈建议，任何一个新的Java程序员，都应该使用SLF4J做日志而不是使用包括Log4J在内的其他日志API。

###slf4j-api、slf4j-log4j12以及log4j之间的关系
①首先系统包含slf4j-api作为日志接入的接口。compile时slf4j-api中public final class LoggerFactor类中private final static void bind()方法会寻找具体的日志实现类绑定，主要通过StaticLoggerBinder.getSingleton()的语句调用。
②slf4j-log4j12是链接slf4j-api和log4j中间的适配器。它实现了slf4j-apiz中StaticLoggerBinder接口，从而使得在编译时绑定的是slf4j-log4j12的getSingleton()方法。
③log4j是具体的日志系统。通过slf4j-log4j12初始化Log4j，达到最终日志的输出。


##logback
[从Log4j迁移到LogBack的理由](http://www.oschina.net/translate/reasons-to-prefer-logbak-over-log4j)

[logback 配置详解（一）](http://blog.csdn.net/haidage/article/details/6794509)
###<configuration>包含的属性
scan:
当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true。
scanPeriod:
设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。默认的时间间隔为1分钟。
debug:
当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。

###<configuration>-<contextName>设置上下文名称
每个logger都关联到logger上下文，默认上下文名称为“default”。但可以使用<contextName>设置成其他名字，用于区分不同应用程序的记录。一旦设置，不能修改。

    <configuration scan="true" scanPeriod="60 seconds" debug="false">  
          <contextName>myAppName</contextName>  
          <!-- 其他配置省略-->  
    </configuration>  

###<configuration>-<property> 设置变量
用来定义变量值的标签，<property> 有两个属性，name和value；其中name的值是变量的名称，value的值时变量定义的值。通过<property>定义的值会被插入到logger上下文中。定义变量后，可以使“${}”来使用变量。
例如使用<property>定义上下文名称，然后在<contentName>设置logger上下文时使用。

    <configuration scan="true" scanPeriod="60 seconds" debug="false">  
          <property name="APP_Name" value="myAppName" />   
          <contextName>${APP_Name}</contextName>  
          <!-- 其他配置省略-->  
    </configuration>

###<timestamp> 获取时间戳字符串
两个属性 key:标识此<timestamp> 的名字；datePattern：设置将当前时间（解析配置文件的时间）转换为字符串的模式，遵循java.txt.SimpleDateFormat的格式。

###<loger>
<loger>仅有一个name属性，一个可选的level和一个可选的addtivity属性。
name:
用来指定受此loger约束的某一个包或者具体的某一个类。
level:
用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，还有一个特俗值INHERITED或者同义词NULL，代表强制执行上级的级别。
如果未设置此属性，那么当前loger将会继承上级的级别。
addtivity:
是否向上级loger传递打印信息。默认是true。

<loger>可以包含零个或多个<appender-ref>元素，标识这个appender将会添加到这个loger

###<root>
也是<loger>元素，但是它是根loger。只有一个level属性，应为已经被命名为"root".

[logback 常用配置详解（二） <appender>](http://blog.csdn.net/haidage/article/details/6794529)

###<appender>
两个必要属性name和class。name指定appender名称，class指定appender的全限定名



---
#Javassist
[Javassist学习总结](http://blog.csdn.net/sadfishsc/article/details/9999169)
##Javassist代码示例,aop
[javassist学习](http://yonglin4605.iteye.com/blog/1396494)

1.Javassist不支持要创建或注入的类中存在泛型参数
2.Javassist对@类型的注解（Annotation）只支持查询，不支持添加或修改

[javassist 学习笔记 详细版](http://zhxing.iteye.com/blog/1703305)
[Java 编程的动态性， 第四部分: 用 Javassist 进行类转换](http://www.ibm.com/developerworks/cn/java/j-dyn0916/)
javassist.ClassPool 类跟踪和控制所操作的类
javassist.CtClass 类
javassist.CtField 字段
javassist.CtMethod 方法
javassist.CtConstructor 构造函数


---
#校验
[JSR 303](http://beanvalidation.org/1.0/spec/)
http://haohaoxuexi.iteye.com/blog/1812584

