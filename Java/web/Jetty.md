#Jetty
---
#doc
[Jetty 的工作原理以及与 Tomcat 的比较](http://www.ibm.com/developerworks/cn/java/j-lo-jetty/index.html)
[从Jetty、Tomcat和Mina中提炼NIO构架网络服务器的经典模式（一）](http://blog.csdn.net/cutesource/article/details/6192016)

##与tomcat性能对比
Jetty 可以同时处理大量连接而且可以长时间保持这些连接
Jetty 默认使用的是 NIO 技术在处理 I/O 请求上更占优势
Tomcat 在处理少数非常繁忙的连接上更有优势，也就是说连接的生命周期如果短的话，Tomcat 的总体性能更高
Tomcat 默认使用的是 BIO，在处理静态资源时，Tomcat 的性能不如 Jetty



#jsp支持
https://stackoverflow.com/questions/9350391/using-embedded-jetty-using-jsp-gives-error-web-jsptaglibrary-1-2-dtd-not-found
PWC6181: File /javax/servlet/jsp/resources/web-jsptaglibrary_1_2.dtd

5
down vote
accepted
I found out that the problem with the missing dtd-file was that I needed Jetty JSP JARs.

I was using these dependencies for JSP-support when it did not work:

<dependency>
        <groupId>javax.servlet.jsp</groupId>
        <artifactId>jsp-api</artifactId>
        <version>2.2</version>
    </dependency>
    <dependency>
        <groupId>org.glassfish.web</groupId>
        <artifactId>jsp-impl</artifactId>
        <version>2.2</version>
    </dependency>
Jetty-runner always worked for me so I looked at the dependencies in that jar-file.

<dependency>
    <groupId>org.eclipse.jetty.orbit</groupId>
    <artifactId>javax.servlet.jsp</artifactId>
    <version>2.2.0.v201112011158</version>
</dependency>
<dependency>
    <groupId>org.eclipse.jetty.orbit</groupId>
    <artifactId>org.apache.jasper.glassfish</artifactId>
    <version>2.2.2.v201112011158</version>
</dependency>
In the javax.servlet.jsp dependency the missing dtd-files exist, so the problem went away when I started using them.

So I guess the problem was that I needed the Jetty specific JSP dependencies and not the general ones. Can anyone explain why Jetty is implemented that way?

---
#jetty plugin
https://github.com/eclipse-jetty/eclipse-jetty-plugin


reload
default:automatic
manual
scanIntervalSeconds

manual

[在maven多模块结构中，并且使用overlay的情况下使用jetty热部署](http://www.cnblogs.com/firejava/p/6269138.html)


---
#maven 多模块部署
[maven多模块jetty如何热部署](http://www.oschina.net/question/1383717_129478)
[Maven jetty plugin - automatic reload using a multi-module project](https://stackoverflow.com/questions/25725552/maven-jetty-plugin-automatic-reload-using-a-multi-module-project)
mvn -pl webapp jetty:run
```xml
<plugins>
   <plugin>
       <groupId>org.mortbay.jetty</groupId>
       <artifactId>jetty-maven-plugin</artifactId>
       <version>8.0.1.v20110908</version>
       <configuration>
           <!--<webAppSourceDirectory>./lease-web/src/main/webapp</webAppSourceDirectory>-->
           <!--<classesDirectory>./lease-web/target/classes</classesDirectory>-->
           <reload>automatic</reload>
           <scanIntervalSeconds>1</scanIntervalSeconds>
           <stopKey>foo</stopKey>
           <stopPort>9999</stopPort>
           <connectors>
               <connector implementation="org.eclipse.jetty.server.nio.SelectChannelConnector">
                   <port>8080</port>
                   <maxIdleTime>60000</maxIdleTime>
               </connector>
           </connectors>
           <scanTargets>
               <scanTarget>./target/classes</scanTarget>
               <scanTarget>../lease-core/target/classes</scanTarget>
           </scanTargets>

           <webAppConfig>
               <contextPath>/</contextPath>
               <!--<extraClasspath>./lease-core/target/classes</extraClasspath>-->
               <defaultsDescriptor>E:\servers\jetty-distribution-9.0.6.v20130930\etc\webdefault.xml</defaultsDescriptor>
           </webAppConfig>

       </configuration>
   </plugin>
   </plugins>
```

```xml
<project xmlns=\"http://maven.apache.org/POM/4.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
    xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd\">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.google.code.garbagecan.jettystudy</groupId>
    <artifactId>jettystudy</artifactId>
    <packaging>jar</packaging>
    <version>1.0-SNAPSHOT</version>
    <name>jettystudy</name>
    <url>http://maven.apache.org</url>
    <build>
        <plugins>
            <plugin>
                <artifactId>maven-compiler-plugin</artifactId>
                <inherited>true</inherited>
                <version>2.3.1</version>
                <configuration>
                    <source>1.6</source>
                    <target>1.6</target>
                    <debug>true</debug>
                </configuration>
            </plugin>
        </plugins>
    </build>
    <dependencies>
        <!-- Spring support -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring</artifactId>
            <version>2.5.6</version>
        </dependency>
 
        <!-- Jetty -->
        <dependency>
            <groupId>org.eclipse.jetty.aggregate</groupId>
            <artifactId>jetty-all</artifactId>
            <version>8.0.4.v20111024</version>
        </dependency>
 
        <!-- Jetty Webapp -->
        <dependency>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-webapp</artifactId>
            <version>8.0.4.v20111024</version>
        </dependency>
 
        <!-- JSP Support -->
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>javax.servlet.jsp</artifactId>
            <version>2.2.3</version>
        </dependency>
 
        <!-- EL Support -->
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>javax.el</artifactId>
            <version>2.2.3</version>
        </dependency>
 
        <!-- JSTL Support -->
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>javax.servlet.jsp.jstl</artifactId>
            <version>1.2.1</version>
            <exclusions>
                <exclusion>
                    <artifactId>jstl-api</artifactId>
                    <groupId>javax.servlet.jsp.jstl</groupId>
                </exclusion>
            </exclusions>
        </dependency>
    </dependencies>

</project>
```




---
#Q
##js css无法修改
Jetty会使用内存映射文件来缓存静态文件,包括js,css文件。
在Windows下，使用内存映射文件会导致文件被锁定，所以当Jetty启动的时候无法在编辑器对js或者css文件进行编辑。
http://blog.csdn.net/hj7jay/article/details/53579445
<configuration>  
    ...  
    <webAppConfig>  
       <defaultsDescriptor>src/test/resources/webdefault.xml</defaultsDescriptor>  
    </webAppConfig>  
<configuration>

<init-param>  
     <param-name>useFileMappedBufferparam-name>  
     <param-value>false<param-value>  
<init-param>  

##
javax.servlet.jar 和 javax.servlet.jsp.jar

Unable to compile class for JSP


