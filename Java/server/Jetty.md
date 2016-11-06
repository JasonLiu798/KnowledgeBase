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


---
#jetty plugin
https://github.com/eclipse-jetty/eclipse-jetty-plugin


---
#maven
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
##
javax.servlet.jar 和 javax.servlet.jsp.jar

Unable to compile class for JSP


