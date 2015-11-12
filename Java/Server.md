#J2EE Server
---
#Theory
##Servlet工作原理
[Servlet 工作原理解析](http://www.ibm.com/developerworks/cn/java/j-lo-servlet/index.html)
###生命周期
Servlet生命周期分为三个阶段：
1，初始化阶段  调用init()方法
2，响应客户请求阶段　　调用service()方法
3，终止阶段　　调用destroy()方法
PS:注意：
在正常情况下，Servlet只会初始化一次，而处理服务会调用多次，销毁也只会调用一次；但是如果一个Servlet长时间不使用的话，也会被容器自动销毁，而如果需要再次使用时会重新进行初始化的操作，即在特殊情况下初始化可能会进行多次，销毁也可能进行多次。
 对于service()方法，一般来说这个方法是不需要重写的，因为在HttpServlet中已经有了很好的实现，它会根据请求的方式，调用doGet()，doPost()方法，也就是说service()是用来转向的，所以我们一般写一个Servlet，只需要重写doGet()或者doPost()就可以了。如果重写了service()方法，那么Servlet容器就会把请求交给这个方法来处理，倘若你重写的service()方法没有调用doXXX()，即使你在Servlet中又重写了其它doGet(), doPost()等也是不会被调用的，因为Servlet的service()被自动调用（就像init()和destory()方法一样），所以如果你由于某种需要，需要重写service()方法，并且根据不同的method调用doPost()，doGet()方法时，就要在末尾加上一句super.service()，这样就可以解决问题了。

###Servlet启动过程
####初始化 Servlet
Servlet InstanceManager
ServletWrapper
StandardContext

Servlet 主动关联的是三个类ServletConfig、ServletRequest 和 ServletResponse
“握手型的交互式”运行模式
StandardWrapper 和 StandardWrapperFacade 都实现了 ServletConfig 
org.apache.catalina.servlets.DefaultServlet load-on-startup 1 
org.apache.jasper.servlet.JspServlet load-on-startup 3

Servlet 的运行模式是一个典型的“握手型的交互式”运行模式,交换数据通常都会准备一个交易场景，这个场景一直跟随个这个交易过程直到这个交易完成为止

StandardContext ServletResponse
ServletConfit   ServletRequest
Servlet

####Request和Respone转变过程
            HttpProcessor                            TomcatContainer容器
    Socket-> org.apache.coyote.Request --Connector--> Request Response
         org.apache.coyote.Response
                            
                                基于Servlet应用
    --ApplicationFilterChain--> RequestFacade ResponseFacade

####Servlet 如何工作
tomcat  org.apache.tomcat.util.http.mapper 
映射 请求的 hostnane 和 contextpath 将 host 和 context 容器设置到 Request 的 mappingData 属性中
只要任何一个容器发生变化，MapperListener 都将会被通知，相应的保存容器关系的 MapperListener 的 mapper 属性也会修改

####Cookie Session
三种方式能可以让 Session 正常工作：
#####1.基于 URL Path Parameter，默认就支持 
当浏览器不支持 Cookie 功能时，浏览器会将用户的 SessionCookieName 重写到用户请求的 URL 参数中，它的传递格式如 /path/Servlet;name=value;name2=value2? Name3=value3，其中“Servlet；”后面的 K-V 对就是要传递的 Path Parameters，服务器会从这个 Path Parameters 中拿到用户配置的 SessionCookieName。关于这个 SessionCookieName，如果你在 web.xml 中配置 session-config 配置项的话，其 cookie-config 下的 name 属性就是这个 SessionCookieName 值，如果你没有配置 session-config 配置项，默认的 SessionCookieName 就是大家熟悉的“JSESSIONID”。接着 Request 根据这个 SessionCookieName 到 Parameters 拿到 Session ID 并设置到 request.setRequestedSessionId 中。
#####基于 Cookie，如果你没有修改 Context 容器个 cookies 标识的话，默认也是支持的
客户端也支持 Cookie 的话，Tomcat 仍然会解析 Cookie 中的 Session ID，并会覆盖 URL 中的 Session ID。
#####基于 SSL，默认不支持，只有 connector.getAttribute("SSLEnabled") 为 TRUE 时才支持
根据 javax.servlet.request.ssl_session 属性值设置 Session ID。
[根据sessionid获取session的被Servlet2.1抛弃getsession方法的解决方案](http://wangyong31893189.iteye.com/blog/1355284)
[浏览器端session id浅析](http://blog.csdn.net/anialy/article/details/38554993)

####Listener
Listener
    EventListener
        ServletContextAttributeListener 属性修改时触发
        ServletRequestAttributeListener
        ServletRequestListener
        HttpSessionSttributeListener
    LifecycleListeners
        ServletContextListner 创建StandardContext时，contextInitialized方法被调用
        HttpSessionListener 创建session时，sessionCreate方法被调用

##servlet新特性
[Servlet 3.0 新特性详解](http://www.ibm.com/developerworks/cn/java/j-lo-servlet30/)
[Servlet API 2.2 的新特征](http://www.ibm.com/developerworks/cn/java/servlet_new/)
[Servlet API 和 NIO: 最终组合在一起](http://www.ibm.com/developerworks/cn/java/j-nioserver/)
###servlet3.0新特性
####异步处理支持
<servlet> 
    <servlet-name>DemoServlet</servlet-name> 
    <servlet-class>footmark.servlet.Demo Servlet</servlet-class> 
    <async-supported>true</async-supported> 
</servlet>
####新增的注解支持
####可插性支持
####ServletContext 的性能增强
####HttpServletRequest 对文件上传的支持
HttpServletRequest 提供了两个方法用于从请求中解析出上传的文件：
Part getPart(String name)
Collection<Part> getParts()


---
#J2EE Servers
Tomcat 	| 免费 | jsp,servlet
JBoss | 免费，文档收费 | 核心服务不包括支持servlet/JSP的WEB容器，需配合Tomcat,jetty，支持支持EJB 1.1、EJB 2.0和EJB3.0
Weblogic | 开发者，有免费使用一年的许可证 | J2EE全部支持
WebSphere | 收费  | J2EE全部支持

---
#Tomcat
Tomcat 的启动逻辑是基于观察者模式设计的，所有的容器都会继承 Lifecycle 接口
[Tomcat 系统架构与设计模式，第 1 部分: 工作原理](http://www.ibm.com/developerworks/cn/java/j-lo-tomcat1/index.html)
[Tomcat 系统架构与设计模式，第 2 部分: 设计模式分析](http://www.ibm.com/developerworks/cn/java/j-lo-tomcat2/index.html)
##总体架构
Server服务器
    Service服务
        Container
            Engine
                Host
                    Servlet容器
                        Context(Wrapper,Warpper)
        Connector

##Service
一个 Container 可以选择对应多个 Connector。多个 Connector 和一个 Container 就形成了一个 Service
Service(I)
    StandardService

##Lifecycle
Lifecycle接口的方法的实现都在其它组件中，就像前面中说的，组件的生命周期由包含它的父组件控制，所以它的 Start 方法自然就是调用它下面的组件的 Start 方法，Stop 方法也是一样。

##Connector 组件
负责接收浏览器的发过来的 tcp 连接请求，创建一个 Request 和 Response 对象分别用于和请求端交换数据，然后会产生一个线程来处理这个请求并把产生的 Request 和 Response 对象传给处理这个请求的线程，处理这个请求的线程就是 Container 组件要做的事了。

Tomcat5 中默认的 Connector 是 Coyote，这个 Connector 是可以选择替换的。

Tomcat5将这个过程更加细化，它将 Connector 划分成 Connector、Processor、Protocol, 另外 Coyote 也定义自己的 Request 和 Response 对象。

###HttpProcessor
####assign
将请求的 socket 赋给当期处理的 socket，并将 available 设为 true，当 available 设为 true 是 HttpProcessor 的 run 方法将被激活，接下去将会处理这次请求。
####Run

####process
封装成 request 和 response 对象后接下来的事情就交给 Container 来处理

##Container
Engine、Host、Context、Wrapper，这四个组件不是平行的，而是父子关系，Engine 包含 Host,Host 包含 Context，Context 包含 Wrapper。
###Engine 容器
Engine 容器比较简单，它只定义了一些基本的关联关系
它的标准实现类是 StandardEngine，这个类注意一点就是 Engine 没有父容器了，如果调用 setParent 方法时将会报错。添加子容器也只能是 Host 类型的
###Host 容器
Host 是 Engine 的字容器，一个 Host 在 Engine 中代表一个虚拟主机，这个虚拟主机的作用就是运行多个应用，它负责安装和展开这些应用，并且标识这个应用以便能够区分它们。它的子容器通常是 Context，它除了关联子容器外，还有就是保存一个主机应该有的信息。
###Context 容器
Context 代表 Servlet 的 Context，它具备了 Servlet 运行的基本环境，理论上只要有 Context 就能运行 Servlet 了。简单的 Tomcat 可以没有 Engine 和 Host。
Context 找到正确的 Servlet：Tomcat5 以前是通过一个 Mapper 类来管理的，Tomcat5 以后这个功能被移到了 request 中
StandardContext.start
主要是设置各种资源属性和管理组件，还有非常重要的就是启动子容器和 Pipeline。
StandardContext.backgroundProcess
reloadable 设为 true 时，war 被修改后 Tomcat 会自动的重新加载这个应用
backgroundProcess这个方法是在 ContainerBase 类中定义的内部类 ContainerBackgroundProcessor 被周期调用的，这个类是运行在一个后台线程中，它会周期的执行 run 方法，它的 run 方法会周期调用所有容器的 backgroundProcess 方法，因为所有容器都会继承 ContainerBase 类，所以所有容器都能够在 backgroundProcess 方法中定义周期执行的事件。

###Wrapper 容器
Wrapper 代表一个 Servlet，它负责管理一个 Servlet，包括的 Servlet 的装载、初始化、执行以及资源回收。Wrapper 是最底层的容器，它没有子容器了，所以调用它的 addChild 将会报错。
Wrapper 的实现类是 StandardWrapper，StandardWrapper 还实现了拥有一个 Servlet 初始化信息的 ServletConfig，由此看出 StandardWrapper 将直接和 Servlet 的各种信息打交道。
StandardWrapper.loadServlet
调用 Servlet 的 init 方法，同时会传一个 StandardWrapperFacade 对象给 Servlet，这个对象包装了 StandardWrapper，ServletConfig 

##Tomcat用到得设计模式
###门面设计模式
client--->Facade<---subsystems
HttpRequestFacade 类封装了 HttpRequest 接口能够提供数据，通过 HttpRequestFacade 访问到的数据都被代理到 HttpRequest 中，通常被封装的对象都被设为 Private 或者 Protected 访问修饰，以防止在 Façade 中被直接访问。    

###观察者设计模式
Subject抽象主题：它负责管理所有观察者的引用，同时定义主要的事件操作。
ConcreteSubject具体主题：它实现了抽象主题的所有定义的接口，当自己发生变化时，会通知所有观察者。
Observer观察者：监听主题发生变化相应的操作接口。

LifecycleSupport、LifecycleEvent
LifecycleSupport类代理了主题对多观察者的管理，将这个管理抽出来统一实现，以后如果修改只要修改LifecycleSupport类就可以了，不需要去修改所有具体主题，因为所有具体主题的对观察者的操作都被代理给 LifecycleSupport 类了。这可以认为是观察者模式的改进版。
###命令设计模式
Client：创建一个命令，并决定接受者
Command 命令：命令接口定义一个抽象方法
ConcreteCommand：具体命令，负责调用接受者的相应操作
Invoker 请求者：负责调用命令对象执行请求
Receiver 接受者：负责具体实施和执行一次请求

Tomcat 中命令模式在 Connector 和 Container 组件之间有体现，Tomcat 作为一个应用服务器，无疑会接受到很多请求，如何分配和执行这些请求是必须的功能。
Connector 作为抽象请求者，HttpConnector 作为具体请求者。HttpProcessor 作为命令。Container 作为命令的抽象接受者，ContainerBase 作为具体的接受者。客户端就是应用服务器 Server 组件了。Server 首先创建命令请求者 HttpConnector 对象，然后创建命令 HttpProcessor 命令对象。再把命令对象交给命令接受者 ContainerBase 容器来处理命令。命令的最终是被 Tomcat 的 Container 执行的。命令可以以队列的方式进来，Container 也可以以不同的方式来处理请求，如 HTTP1.0 协议和 HTTP1.1 的处理方式就会不同。

###责任链模式
通常责任链模式包含下面几个角色：
Handler（抽象处理者）：定义一个处理请求的接口
ConcreteHandler（具体处理者）：处理请求的具体类，或者传给下家

在 tomcat 中这种设计模式几乎被完整的使用，tomcat 的容器设置就是责任链模式，从 Engine 到 Host 再到 Context 一直到 Wrapper 都是通过一个链传递请求。


## start script
    #!/bin/bash
    case $1 in
    start)
    sh /opt/tomcat/bin/startup.sh
    ;;
    stop)
    sh /opt/tomcat/bin/shutdown.sh
    ;;
    restart)
    sh /opt/tomcat/bin/shutdown.sh
    sh /opt/tomcat/bin/startup.sh
    ;;
    *)
    echo “Usage: start|stop|restart”
    ;;
    esac
    exit 0


---
#Jetty
[Jetty 的工作原理以及与 Tomcat 的比较](http://www.ibm.com/developerworks/cn/java/j-lo-jetty/index.html)


##与tomcat性能对比
Jetty 可以同时处理大量连接而且可以长时间保持这些连接
Jetty 默认使用的是 NIO 技术在处理 I/O 请求上更占优势
Tomcat 在处理少数非常繁忙的连接上更有优势，也就是说连接的生命周期如果短的话，Tomcat 的总体性能更高
Tomcat 默认使用的是 BIO，在处理静态资源时，Tomcat 的性能不如 Jetty



















