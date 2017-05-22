#Web
---
#常用容器，默认servlet名字
Tomcat, Jetty, JBoss, and GlassFish 默认 Servlet的名字 – “default”
Google App Engine 默认 Servlet的名字 – “_ah_default”
Resin 默认 Servlet的名字 – “resin-file”
WebLogic 默认 Servlet的名字 – “FileServlet”
WebSphere 默认 Servlet的名字 – “SimpleFileServlet”

Terracotta，JVM级集群框架，共享JVM堆对象

#servlet
[为什么不应该重写service方法？](http://my.oschina.net/dtkking/blog/89443)
[精研Servlet,HttpServlet的实现追究](http://my.oschina.net/zhaoqian/blog/94670)

servlet还有一些CGI脚本所不具备的独特优点：
1、servlet是持久的。servlet只需Web服务器加载一次，而且可以在不同请求之间保持服务(例如一次数据库连接)。与之相反，CGI脚本是短暂的、瞬态的。每一次对CGI脚本的请求，都会使Web服务器加载并执行该脚本。一旦这个CGI脚本运行结束，它就会被从内存中清除，然后将结果返回到客户端。CGI脚本的每一次使用，都会造成程序初始化过程(例如连接数据库)的重复执行。
2、servlet是与平台无关的。如前所述，servlet是用Java编写的，它自然也继承了Java的平台无关性。
3、servlet是可扩展的。由于servlet是用Java编写的，它就具备了Java所能带来的所有优点。Java是健壮的、面向对象的编程语言，它很容易扩展以适应你的需求。servlet自然也具备了这些特征。
4、servlet是安全的。从外界调用一个servlet的惟一方法就是通过Web服务器。这提供了高水平的安全性保障，尤其是在你的Web服务器有防火墙保护的时候。
5、setvlet可以在多种多样的客户机上使用。由于servlet是用Java编写的，所以你可以很方便地在HTML中使用它们，就像你使用applet一样。


----
#跨域
##jetty
[配置maven jetty 插件允许跨域访问](http://blog.csdn.net/sd4015700/article/details/49852453)
```xml
<dependency>  
    <groupId>org.eclipse.jetty</groupId>  
    <artifactId>jetty-servlets</artifactId>  
    <version>9.3.0.M2</version>  
</dependency>  
```

```xml
<!-- web.xml -->
<filter>  
    <filter-name>cross-origin</filter-name>  
    <filter-class>org.eclipse.jetty.servlets.CrossOriginFilter</filter-class>  
    <init-param>  
        <param-name>allowedOrigins</param-name>  
        <param-value>*</param-value>  
    </init-param>  
    <init-param>  
        <param-name>allowedMethods</param-name>  
        <param-value>GET,POST,HEAD</param-value>  
    </init-param>  
    <init-param>  
        <param-name>allowedHeaders</param-name>  
        <param-value>X-Requested-With,Content-Type,Accept,Origin</param-value>  
    </init-param>  
</filter>  
<!-- 此处表示jetty中的所有url都可以支持跨域 -->  
<filter-mapping>  
    <filter-name>cross-origin</filter-name>  
    <url-pattern>/*</url-pattern>  
</filter-mapping>
```
