#java libs
---
#server
##undertow
```html
<dependency>
    <groupId>io.undertow</groupId>
    <artifactId>undertow-core</artifactId>
    <version>1.0.0.Beta29</version>
</dependency>
 
<dependency>
    <groupId>io.undertow</groupId>
    <artifactId>undertow-servlet</artifactId>
    <version>1.0.0.Beta29</version>
</dependency>
```


---
# 图像图形
SVG
Batik

开源语法分析器 antlr 
javacc语法和词法分析器的生成程序

[microsoft 人脸识别](http://www.projectoxford.ai/doc/face/How-To/detectface)


---
#解耦
[java.util.ServiceLoader 的使用](http://tangmingjie2009.iteye.com/blog/1697013)


---
# distribute
## connector
The J2EE Connector architecture provides a Java technology solution to the problem of connectivity between the many application servers and today's enterprise information systems (EIS).
<dependency>
    <groupId>javax.resource</groupId>
    <artifactId>connector</artifactId>
    <version>1.0</version>
</dependency>

---
#excel
##poi
<dependency><groupId>org.apache.poi</groupId>  
    <artifactId>poi-ooxml</artifactId>  
    <version>3.5-FINAL</version>  
</dependency>  

---
# http
## httpclient 
Aug 18, 2007
```html
<dependency>
    <groupId>commons-httpclient</groupId>
    <artifactId>commons-httpclient</artifactId>
    <version>3.1</version>
</dependency>
May 31, 2015
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
    <version>4.5</version>
</dependency>
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient-cache</artifactId>
    <version>4.5</version>
</dependency>
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpcore</artifactId>
    <version>4.4.1</version>
</dependency>

MIME coded entities
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpmime</artifactId>
    <version>4.5</version>
</dependency>
```

---
#REST
##urlrewrite
```html
    <!-- urlrewrite jar -->
    <dependency>
      <groupId>org.tuckey</groupId>
      <artifactId>urlrewrite</artifactId>
      <version>2.5.2</version>
    </dependency>
```


----
#序列化
```html
<dependency>
  <groupId>de.ruedigermoeller</groupId>
  <artifactId>fst</artifactId>
  <version>2.04</version>
</dependency>
```


---
# Thread
```html
<dependency>
    <groupId>concurrent</groupId>
    <artifactId>concurrent</artifactId>
    <version>1.3.4</version>
</dependency>
```

---
# cache
## ehcache
```html
<dependency>
    <groupId>net.sf.ehcache</groupId>
    <artifactId>ehcache-core</artifactId>
    <version>2.6.11</version>
</dependency>
```

---
# commons
## core
```html
<dependency>
    <groupId>commons-lang</groupId>
    <artifactId>commons-lang</artifactId>
    <version>2.6</version>
</dependency>
```

## pool
```html
<dependency>
    <groupId>commons-pool</groupId>
    <artifactId>commons-pool</artifactId>
    <version>1.6</version>
</dependency>
```

## Reflection library
<dependency>
    <groupId>commons-beanutils</groupId>
    <artifactId>commons-beanutils</artifactId>
    <version>1.9.2</version>
</dependency>


## collection
<dependency>
    <groupId>commons-collections</groupId>
    <artifactId>commons-collections</artifactId>
    <version>3.2.1</version>
</dependency>


## other tools
discovering, or finding, implementations for pluggable interfaces.
<dependency>
    <groupId>commons-discovery</groupId>
    <artifactId>commons-discovery</artifactId>
    <version>0.5</version>
</dependency>


## config
### configuration
<dependency>
    <groupId>commons-configuration</groupId>
    <artifactId>commons-configuration</artifactId>
    <version>1.10</version>
</dependency>

### digester
The Digester package lets you configure an XML to Java object mapping module which triggers certain actions called rules whenever a particular pattern of nested XML elements is recognized.
<dependency>
    <groupId>commons-digester</groupId>
    <artifactId>commons-digester</artifactId>
    <version>2.1</version>
</dependency>




## codec
 contains simple encoder and decoders for various formats such as Base64 and Hexadecimal. In addition to these widely used encoders and decoders, the codec package also maintains a collection of phonetic encoding utilities.
<dependency>
    <groupId>commons-codec</groupId>
    <artifactId>commons-codec</artifactId>
    <version>1.10</version>
</dependency>


## log
<dependency>
    <groupId>commons-logging</groupId>
    <artifactId>commons-logging</artifactId>
    <version>1.2</version>
</dependency>

## IO
<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.4</version>
</dependency>

<dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.2.1</version>
</dependency>


## 命令行
<dependency>
    <groupId>commons-cli</groupId>
    <artifactId>commons-cli</artifactId>
    <version>1.3.1</version>
</dependency>


---
#view
## freemaker
```html
<dependency>
    <groupId>org.freemarker</groupId>
    <artifactId>freemarker</artifactId>
    <version>2.3.23</version>
</dependency>
```

## velocity
```html
<dependency>
    <groupId>org.apache.velocity</groupId>
    <artifactId>velocity</artifactId>
    <version>1.7</version>
</dependency>
```

## tiles
http://tiles.apache.org/
```html
<dependency>
    <groupId>org.apache.tiles</groupId>
    <artifactId>tiles-core</artifactId>
    <version>3.0.5</version>
</dependency>
<dependency>
    <groupId>org.apache.tiles</groupId>
    <artifactId>tiles-api</artifactId>
    <version>3.0.5</version>
</dependency>
<dependency>
    <groupId>org.apache.tiles</groupId>
    <artifactId>tiles-jsp</artifactId>
    <version>3.0.5</version>
</dependency>
```

---
# network
## grizzly
in use 2.1.9
<dependency>
    <groupId>org.glassfish.grizzly</groupId>
    <artifactId>grizzly-framework</artifactId>
    <version>2.3.22</version>
</dependency>
sun's in use 2.0.0M3
<dependency>
    <groupId>com.sun.grizzly</groupId>
    <artifactId>grizzly-framework</artifactId>
    <version>2.0.0-M3</version>
</dependency>

## mina
<dependency>
    <groupId>org.apache.mina</groupId>
    <artifactId>mina-core</artifactId>
    <version>3.0.0-M2</version>
</dependency>




---
# cloud
## hadoop
<dependency>
    <groupId>org.apache.hadoop</groupId>
    <artifactId>hadoop-core</artifactId>
    <version>1.2.1</version>
</dependency>



---
# db
## hibernate
```html
    version
    <org.hibernate.version>4.2.19.Final</org.hibernate.version>
    <hibernate.dialect>org.hibernate.dialect.MysqlDialect</hibernate.dialect>
    <hibernate.showsql>true</hibernate.showsql>
    dependency
    <dependency>
        <groupId>org.hibernate</groupId>
        <artifactId>hibernate-core</artifactId>
        <version>${org.hibernate.version}</version>
    </dependency>
    <dependency>
        <groupId>org.hibernate</groupId>
        <artifactId>hibernate-ehcache</artifactId>
        <version>${org.hibernate.version}</version>
    </dependency>
```

##mybatis
###version
3.3.0 May 24, 2015
3.2.8 Oct, 2014
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.3.0</version>
</dependency>
<!--
Jun 15, 2015
Jan 18, 2014-->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
    <version>1.2.3</version>
</dependency>

<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-ehcache</artifactId>
    <version>1.0.0</version>
</dependency>

分页插件 https://github.com/pagehelper/Mybatis-PageHelper
4.0.0 Jul 13, 2015
3.7.6 Jul, 2015
3.6.4 Apr, 2015
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
    <version>4.0.0</version>
</dependency>

<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-migrations</artifactId>
    <version>3.2.0</version>
</dependency>

<dependency>
    <groupId>com.freetmp</groupId>
    <artifactId>dolphin-mybatis-generator</artifactId>
    <version>1.0.0</version>
</dependency>

<dependency>
    <groupId>org.mybatis.caches</groupId>
    <artifactId>mybatis-memcached</artifactId>
    <version>1.0.0</version>
</dependency>

<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-guice</artifactId>
    <version>3.7</version>
</dependency>





---
# middleware
(Dec 07, 2013)
<dependency>
    <groupId>cglib</groupId>
    <artifactId>cglib</artifactId>
    <version>3.1</version>
</dependency>
(Dec 07, 2013)
<dependency>
    <groupId>cglib</groupId>
    <artifactId>cglib-nodep</artifactId>
    <version>3.1</version>
</dependency>

---
#xml 
#json
##jaxb
<dependency>
    <groupId>com.sun.xml.bind</groupId>
    <artifactId>jaxb-impl</artifactId>
    <version>2.2.11</version>
</dependency>
<dependency>
    <groupId>com.sun.xml.bind</groupId>
    <artifactId>jaxb-xjc</artifactId>
    <version>2.2.11</version>
</dependency>
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.2.12</version>
</dependency>

##jibx
xml<->object
<dependency>
    <groupId>org.jibx</groupId>
    <artifactId>jibx-bind</artifactId>
    <version>1.2.6</version>
</dependency>
<dependency>
    <groupId>org.jibx</groupId>
    <artifactId>jibx-extras</artifactId>
    <version>1.2.6</version>
</dependency>
<dependency>
    <groupId>org.jibx</groupId>
    <artifactId>jibx-run</artifactId>
    <version>1.2.6</version>
</dependency>

##xalan
Xalan-Java is an XSLT processor for transforming XML documents into HTML, text, or other XML document types. It implements XSL Transformations (XSLT) Version 1.0 and XML Path Language (XPath) Version 1.0 and can be used from the command line, in an applet or a servlet, or as a module in other program.
```html
<dependency>
    <groupId>xalan</groupId>
    <artifactId>xalan</artifactId>
    <version>2.7.2</version>
</dependency>
```

## xerecesImpl
```html
<dependency>
    <groupId>xerces</groupId>
    <artifactId>xercesImpl</artifactId>
    <version>2.11.0</version>
</dependency>
```

## xmlapi
```html
<dependency>
    <groupId>xml-apis</groupId>
    <artifactId>xml-apis</artifactId>
    <version>2.0.2</version>
</dependency>
```

##jsonspring
##jackson
```html
    <dependency>
        <groupId>org.codehaus.jackson</groupId>
        <artifactId>jackson-mapper-asl</artifactId>
        <version>1.8.4</version>
    </dependency>
    <dependency>
        <groupId>org.codehaus.jackson</groupId>
        <artifactId>jackson-core-asl</artifactId>
        <version>1.8.4</version>
    </dependency>
```

##Json Lib
```html
<dependency>
    <groupId>net.sf.json-lib</groupId>
    <artifactId>json-lib</artifactId>
    <version>2.4</version>
</dependency>
```

##JasonInJava
```html
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20141113</version>
</dependency>
```

----
# performance
## gcviewer
```html
<dependency>
    <groupId>com.github.chewiebug</groupId>
    <artifactId>gcviewer</artifactId>
    <version>1.34.1</version>
</dependency>
```


---
# aop
## aspectj pom
```html
    <org.aspectj.version>1.8.6</org.aspectj.version>

    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjrt</artifactId>
        <version>${org.aspectj.version}</version>
    </dependency>

    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjweaver</artifactId>
        <version>${org.aspectj.version}</version>
    </dependency>

    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjtools</artifactId>
        <version>${org.aspectj.version}</version>
    </dependency>
```

---
#security
## spring security pom
```html
    <properties>
        <org.springframework.security.version>3.2.8.RELEASE</org.springframework.security.version>
    </properties>
    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-core</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-config</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-web</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-taglibs</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>
    


    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-acl</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>

    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-openid</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>

    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-crypto</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>

    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-ldap</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-aspects</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>

    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-cas</artifactId>
        <version>${org.springframework.security.version}</version>
    </dependency>

    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-test</artifactId>
        <version>4.0.2.RELEASE</version>
    </dependency>


http://mvnrepository.com/artifact/org.springframework.security.oauth/spring-security-oauth2

    <dependency>
        <groupId>org.springframework.security.oauth</groupId>
        <artifactId>spring-security-oauth2</artifactId>
        <version>2.0.7.RELEASE</version>
    </dependency>
```

## security rsa pom
```html
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-rsa</artifactId>
    <version>1.0.1.RELEASE</version>
</dependency>

<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-core-tiger</artifactId>
    <version>2.0.8.RELEASE</version>
</dependency>

<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-jwt</artifactId>
    <version>1.0.3.RELEASE</version>
</dependency>
```

---
#spring
## spring pom
```html
    pom.xml
    <properties>
        <org.springframework.version>3.2.13.RELEASE</org.springframework.version>
    </properties>
        <dependencies>
            <!-- spring -->

            <!-- Core utilities used by other modules. Define this if you use Spring 
                Utility APIs (org.springframework.core.*/org.springframework.util.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-core</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Expression Language (depends on spring-core) Define this if you use 
                Spring Expression APIs (org.springframework.expression.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-expression</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Bean Factory and JavaBeans utilities (depends on spring-core) Define 
                this if you use Spring Bean APIs (org.springframework.beans.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-beans</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Aspect Oriented Programming (AOP) Framework (depends on spring-core, 
                spring-beans) Define this if you use Spring AOP APIs (org.springframework.aop.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-aop</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Application Context (depends on spring-core, spring-expression, spring-aop, 
                spring-beans) This is the central artifact for Spring's Dependency Injection 
                Container and is generally always defined -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-context</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Various Application Context utilities, including EhCache, JavaMail, 
                Quartz, and Freemarker integration Define this if you need any of these integrations -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-context-support</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Transaction Management Abstraction (depends on spring-core, spring-beans, 
                spring-aop, spring-context) Define this if you use Spring Transactions or 
                DAO Exception Hierarchy (org.springframework.transaction.*/org.springframework.dao.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-tx</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- JDBC Data Access Library (depends on spring-core, spring-beans, spring-context, 
                spring-tx) Define this if you use Spring's JdbcTemplate API (org.springframework.jdbc.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-jdbc</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Object-to-Relation-Mapping (ORM) integration with Hibernate, JPA, 
                and iBatis. (depends on spring-core, spring-beans, spring-context, spring-tx) 
                Define this if you need ORM (org.springframework.orm.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-orm</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Object-to-XML Mapping (OXM) abstraction and integration with JAXB, 
                JiBX, Castor, XStream, and XML Beans. (depends on spring-core, spring-beans, 
                spring-context) Define this if you need OXM (org.springframework.oxm.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-oxm</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Web application development utilities applicable to both Servlet 
                and Portlet Environments (depends on spring-core, spring-beans, spring-context) 
                Define this if you use Spring MVC, or wish to use Struts, JSF, or another 
                web framework with Spring (org.springframework.web.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-web</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Spring MVC for Servlet Environments (depends on spring-core, spring-beans, 
                spring-context, spring-web) Define this if you use Spring MVC with a Servlet 
                Container such as Apache Tomcat (org.springframework.web.servlet.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-webmvc</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Spring MVC for Portlet Environments (depends on spring-core, spring-beans, 
                spring-context, spring-web) Define this if you use Spring MVC with a Portlet 
                Container (org.springframework.web.portlet.*) -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-webmvc-portlet</artifactId>
                <version>${org.springframework.version}</version>
            </dependency>

            <!-- Support for testing Spring applications with tools such as JUnit 
                and TestNG This artifact is generally always defined with a 'test' scope 
                for the integration testing framework and unit testing stubs -->
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-test</artifactId>
                <version>${org.springframework.version}</version>
                <scope>test</scope>
            </dependency>
        </dependencies>
```

##springredis
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-redis</artifactId>
    <version>1.4.1.RELEASE</version>
</dependency>

---
#webservice
## woden
```html
<dependency>
    <groupId>org.apache.woden</groupId>
    <artifactId>woden</artifactId>
    <version>1.0M9</version>
</dependency>
<dependency>
    <groupId>org.apache.woden</groupId>
    <artifactId>woden-api</artifactId>
    <version>1.0M9</version>
</dependency>
<dependency>
    <groupId>org.apache.woden</groupId>
    <artifactId>woden-impl-commons</artifactId>
    <version>1.0M9</version>
</dependency>
<dependency>
    <groupId>org.apache.woden</groupId>
    <artifactId>woden-impl-dom</artifactId>
    <version>1.0M9</version>
</dependency>
```






---
#base
##Java Parser and Abstract Syntax Tree
https://github.com/javaparser/javaparser
```html
<dependency>
    <groupId>com.github.javaparser</groupId>
    <artifactId>javaparser-core</artifactId>
    <version>2.2.1</version>
</dependency>
```

#log
##log4j 
[log4j日志封装说明—slf4j对于log4j的日志封装-正确获取调用堆栈](http://www.coderli.com/log4j-slf4j-logger-linenumber/)

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



