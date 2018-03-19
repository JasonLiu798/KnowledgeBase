
# 配置时可能出现的问题
* 检查实际读取的配置文件 logback.xml，确定改的文件是正在使用的



# 过滤掉第三方包中的日志显示

Logback 的配置文件是 logback.xml，曾经在里面给 <appender> 加的 <pattern> 是：
<pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n</pattern>
logger 名显示 35 字符，类名优先显示全，类全限名超过总长度则取前面若干包名的首字母连接起来，于是产生了像下面那样的日志输出：
7937 [main] DEBUG o.s.b.f.s.DefaultListableBeanFactory - Returning cached instance of singleton
7781 [main] DEBUG o.h.loader.entity.EntityLoader - Static select for entity

这在 Log4J 中是未曾见过的。当时还以为日志名就是 o.s.b.f 这样的东西，于是在 logback.xml 中用
```xml
<logger name="o.s.b" level="WARN"/>
<logger name="o.h" level="WARN"/>
```
这样的代码来进行封锁，根本就无济于事，大量的 spring、hibernate 的 DEBUG、INFO 等日志照样输出。这时惦记起 Logback 的 filter 功能来了，配置上：
```xml
  <filter>      
      <evaluator> <!-- defaults to type ch.qos.logback.classic.boolex.JaninoEventEvaluator -->
          <expression><![CDATA[
             event.getThreadName().contains("Catalina")
             || event.getLoggerName().contains("o.s.b.f")
             || event.getLoggerName().contains("o.h.")
          ]]></expression>
      </evaluator>
      <OnMismatch>NEUTRAL</OnMismatch>
      <OnMatch>DENY</OnMatch>
  </filter>
```
也是没有效果的。想来 Logback 与 Log4J 相比不会这么差劲的，再怎么也是出自一人之手，想来思路应是一致的，还是该回到 <logger> 的配置上来。

还是 Google 威武，找到答案了：logback per-logger configuration is not working。原来像 "o.s.b.f" 和 "o.h." 这样的东西只是神马浮云，假象而已，它们实际所代表的 logger 名并未变，分别是:

org.springframework.beans.factory.support.DefaultListableBeanFactory
org.hibernate.loader.entity.EntityLoader

所以呢，在 logback.xml 中像 Log4J 一样写上
 <logger name="org.hibernate" level="WARN"/>
 <logger name="org.springframework" level="WARN"/>
就把 Spring 和 Hibernate 的日志输出稍加过滤了，都是 %logger{35}中的那个{35}惹的祸，不过也靠它多了解了一点东西。如果只写成 %logger 话那时候当然可以很快的解决问题的。

参考
1. logback per-logger configuration is not working
2. 在 Java Web 项目中选择使用 Slf4J 通用日志框架(在这篇中用的就是繁琐的 <filter> 配置，现在要稍微解放一下了)







#logback1:logback1.1.13配置文件加载顺序
http://feitianbenyue.iteye.com/blog/2205482
logback 前阵子升级到1.1.13, 和1.1.12还是有些变化的,具体的变化, 参看 
http://logback.qos.ch/news.html
 
在配置文件上, 加载顺序中, 多了使用 ServiceLoader 查找Configurator接口的第一个实现类

目前完整的加载顺序是:
1. 如果配置了 指定了 logback.configurationFile属性,将使用这个属性的地址 
比如 启动的时候,指定了  java -Dlogback.configurationFile=/path/to/config.xml  xxxxxx
2.如果没有配置上面的属性, 将会在classpath中查找  logback.groovy 文件
3.如果没有找到文件, 将会在classpath中查找  logback-test.xml 文件
4.如果没有找到文件, 将会在classpath中查找  logback.xml 文件
5.如果没有找到文件, 如果是 jdk6+,那么会调用ServiceLoader 查找 com.qos.logback.classic.spi.Configurator接口的第一个实现类
6.如果上面都没有,将自动使用ch.qos.logback.classic.BasicConfigurator,在控制台输出日志 

```java
private URL findConfigFileURLFromSystemProperties(ClassLoader classLoader, boolean updateStatus) {  
    String logbackConfigFile = OptionHelper.getSystemProperty(CONFIG_FILE_PROPERTY);  
    if (logbackConfigFile != null) {  
      URL result = null;  
      try {  
        result = new URL(logbackConfigFile);  
        return result;  
      } catch (MalformedURLException e) {  
        // so, resource is not a URL:  
        // attempt to get the resource from the class path  
        result = Loader.getResource(logbackConfigFile, classLoader);  
        if (result != null) {  
          return result;  
        }  
        File f = new File(logbackConfigFile);  
        if (f.exists() && f.isFile()) {  
          try {  
            result = f.toURI().toURL();  
            return result;  
          } catch (MalformedURLException e1) {  
          }  
        }  
      } finally {  
        if (updateStatus) {  
          statusOnResourceSearch(logbackConfigFile, classLoader, result);  
        }  
      }  
    }  
    return null;  
  }  
```
参见 :http://logback.qos.ch/manual/configuration.html












