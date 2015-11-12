#java libs
#常用容器默认servlet名字
Tomcat, Jetty, JBoss, and GlassFish 默认 Servlet的名字 – “default”
Google App Engine 默认 Servlet的名字 – “_ah_default”
Resin 默认 Servlet的名字 – “resin-file”
WebLogic 默认 Servlet的名字 – “FileServlet”
WebSphere 默认 Servlet的名字 – “SimpleFileServlet”

Terracotta，JVM级集群框架，共享JVM堆对象


---
#server
##undertow
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



---
# 图像图形
SVG
Batik

开源语法分析器 antlr 
javacc语法和词法分析器的生成程序

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

---
#REST
##urlrewrite
    <!-- urlrewrite jar -->
    <dependency>
      <groupId>org.tuckey</groupId>
      <artifactId>urlrewrite</artifactId>
      <version>2.5.2</version>
    </dependency>



----
#序列化
<dependency>
  <groupId>de.ruedigermoeller</groupId>
  <artifactId>fst</artifactId>
  <version>2.04</version>
</dependency>



---
# Thread
<dependency>
    <groupId>concurrent</groupId>
    <artifactId>concurrent</artifactId>
    <version>1.3.4</version>
</dependency>

---
# cache
## ehcache
<dependency>
    <groupId>net.sf.ehcache</groupId>
    <artifactId>ehcache-core</artifactId>
    <version>2.6.11</version>
</dependency>


---
# commons
## core
<dependency>
    <groupId>commons-lang</groupId>
    <artifactId>commons-lang</artifactId>
    <version>2.6</version>
</dependency>

## pool
<dependency>
    <groupId>commons-pool</groupId>
    <artifactId>commons-pool</artifactId>
    <version>1.6</version>
</dependency>


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
<dependency>
    <groupId>org.freemarker</groupId>
    <artifactId>freemarker</artifactId>
    <version>2.3.23</version>
</dependency>
## velocity
<dependency>
    <groupId>org.apache.velocity</groupId>
    <artifactId>velocity</artifactId>
    <version>1.7</version>
</dependency>
## tiles
http://tiles.apache.org/
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
###version
    <org.hibernate.version>4.2.19.Final</org.hibernate.version>
    <hibernate.dialect>org.hibernate.dialect.MysqlDialect</hibernate.dialect>
    <hibernate.showsql>true</hibernate.showsql>
###dependency
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
<dependency>
    <groupId>xalan</groupId>
    <artifactId>xalan</artifactId>
    <version>2.7.2</version>
</dependency>

## xerecesImpl
<dependency>
    <groupId>xerces</groupId>
    <artifactId>xercesImpl</artifactId>
    <version>2.11.0</version>
</dependency>

## xmlapi
<dependency>
    <groupId>xml-apis</groupId>
    <artifactId>xml-apis</artifactId>
    <version>2.0.2</version>
</dependency>


##jsonspring
##jackson
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

##Json Lib
<dependency>
    <groupId>net.sf.json-lib</groupId>
    <artifactId>json-lib</artifactId>
    <version>2.4</version>
</dependency>

##JasonInJava
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20141113</version>
</dependency>

----
# performance
## gcviewer
<dependency>
    <groupId>com.github.chewiebug</groupId>
    <artifactId>gcviewer</artifactId>
    <version>1.34.1</version>
</dependency>



---
# aop
## aspectj pom
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


---
#security
## spring security pom
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

## security rsa pom
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

---
#spring
## spring pom
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


##springredis
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-redis</artifactId>
    <version>1.4.1.RELEASE</version>
</dependency>

---
#webservice
## woden
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







---
#base
##Java Parser and Abstract Syntax Tree
https://github.com/javaparser/javaparser
<dependency>
    <groupId>com.github.javaparser</groupId>
    <artifactId>javaparser-core</artifactId>
    <version>2.2.1</version>
</dependency>




