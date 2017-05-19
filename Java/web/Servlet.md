#J2EE Server
---
#Theory
##Servlet工作原理
[Servlet 工作原理解析](http://www.ibm.com/developerworks/cn/java/j-lo-servlet/index.html)

##生命周期
Servlet生命周期分为三个阶段：
1，初始化阶段  调用init()方法
2，响应客户请求阶段　　调用service()方法
3，终止阶段　　调用destroy()方法
PS:注意：
在正常情况下，Servlet只会初始化一次，而处理服务会调用多次，销毁也只会调用一次；但是如果一个Servlet长时间不使用的话，也会被容器自动销毁，而如果需要再次使用时会重新进行初始化的操作，即在特殊情况下初始化可能会进行多次，销毁也可能进行多次。
 对于service()方法，一般来说这个方法是不需要重写的，因为在HttpServlet中已经有了很好的实现，它会根据请求的方式，调用doGet()，doPost()方法，也就是说service()是用来转向的，所以我们一般写一个Servlet，只需要重写doGet()或者doPost()就可以了。如果重写了service()方法，那么Servlet容器就会把请求交给这个方法来处理，倘若你重写的service()方法没有调用doXXX()，即使你在Servlet中又重写了其它doGet(), doPost()等也是不会被调用的，因为Servlet的service()被自动调用（就像init()和destory()方法一样），所以如果你由于某种需要，需要重写service()方法，并且根据不同的method调用doPost()，doGet()方法时，就要在末尾加上一句super.service()，这样就可以解决问题了。

---
##Servlet启动过程
###初始化 Servlet
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

###Request和Respone转变过程
            HttpProcessor                            TomcatContainer容器
    Socket-> org.apache.coyote.Request --Connector--> Request Response
         org.apache.coyote.Response
                            
                                基于Servlet应用
    --ApplicationFilterChain--> RequestFacade ResponseFacade

---
##Servlet 如何工作
tomcat  org.apache.tomcat.util.http.mapper 
映射 请求的 hostnane 和 contextpath 将 host 和 context 容器设置到 Request 的 mappingData 属性中
只要任何一个容器发生变化，MapperListener 都将会被通知，相应的保存容器关系的 MapperListener 的 mapper 属性也会修改


###Cookie Session
三种方式能可以让 Session 正常工作：
#####1.基于 URL Path Parameter，默认就支持 
当浏览器不支持 Cookie 功能时，浏览器会将用户的 SessionCookieName 重写到用户请求的 URL 参数中，它的传递格式如 /path/Servlet;name=value;name2=value2? Name3=value3，其中“Servlet；”后面的 K-V 对就是要传递的 Path Parameters，服务器会从这个 Path Parameters 中拿到用户配置的 SessionCookieName。关于这个 SessionCookieName，如果你在 web.xml 中配置 session-config 配置项的话，其 cookie-config 下的 name 属性就是这个 SessionCookieName 值，如果你没有配置 session-config 配置项，默认的 SessionCookieName 就是大家熟悉的“JSESSIONID”。接着 Request 根据这个 SessionCookieName 到 Parameters 拿到 Session ID 并设置到 request.setRequestedSessionId 中。
#####基于 Cookie，如果你没有修改 Context 容器个 cookies 标识的话，默认也是支持的
客户端也支持 Cookie 的话，Tomcat 仍然会解析 Cookie 中的 Session ID，并会覆盖 URL 中的 Session ID。
#####基于 SSL，默认不支持，只有 connector.getAttribute("SSLEnabled") 为 TRUE 时才支持
根据 javax.servlet.request.ssl_session 属性值设置 Session ID。
[根据sessionid获取session的被Servlet2.1抛弃getsession方法的解决方案](http://wangyong31893189.iteye.com/blog/1355284)
[浏览器端session id浅析](http://blog.csdn.net/anialy/article/details/38554993)


###Listener
Listener
    EventListener
        ServletContextAttributeListener 属性修改时触发
        ServletRequestAttributeListener
        ServletRequestListener
        HttpSessionSttributeListener
    LifecycleListeners
        ServletContextListner 创建StandardContext时，contextInitialized方法被调用
        HttpSessionListener 创建session时，sessionCreate方法被调用


---
##重定向
servlet请求转发与重定向的区别：
request.setAttribute("test","hello");
request.getRequestDispacther("/test.jsp").forword(request,response); 

###请求转发（RequestDispatcher）
客户首先发送一个请求到服务器端，服务器端发现匹配的servlet，并指定它去执行，当这个servlet执行完之后，它要调用getRequestDispacther()方法，把请求转发给指定的test.jsp
*整个流程都是在服务器端完成的*，而且是在同一个请求里面完成的
因此servlet和jsp共享的是同一个request，在servlet里面放的所有东西，在jsp中都能取出来，因此，jsp能把结果getAttribute()出来，getAttribute()出来后执行完把结果返回给客户端。整个过程是一个请求，一个响应。

###重定向（sendRedirect）
response.sendRedirect("test.jsp");
客户发送一个请求到服务器，服务器匹配servlet，这都和请求转发一样，servlet处理完之后调用了sendRedirect()这个方法
这个方法是response的方法，所以，当这个servlet处理完之后，看到response.senRedirect()方法，立即向客户端返回这个响应，响应行告诉客户端你必须要再发送一个请求，去访问test.jsp，紧接着客户端受到这个请求后，立刻发出一个新的请求，去请求test.jsp
*这里两个请求互不干扰，相互独立*，在前面request里面setAttribute()的任何东西，在后面的request里面都获得不了。可见，在sendRedirect()里面是两个请求，两个响应。



---
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


















