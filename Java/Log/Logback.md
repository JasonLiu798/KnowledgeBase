

# 根节点<configuration>包含的属性
## scan
当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true。
## scanPeriod
设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。默认的时间间隔为1分钟。
## debug
当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。
```xml
<configuration scan="true" scanPeriod="60 seconds" debug="false">  
      <!-- 其他配置省略-->  
</configuration>
```

---
# <configuration>的子节点
## 设置上下文名称：<contextName>
每个logger都关联到logger上下文，默认上下文名称为default。但可以使用<contextName>设置成其他名字，用于区分不同应用程序的记录。一旦设置，不能修改。
```xml
<!-- lang: xml-->
<configuration scan="true" scanPeriod="60 seconds" debug="false">  
      <contextName>myAppName</contextName>  
      <!-- 其他配置省略-->  
</configuration>
```

## 设置变量： <property>
用来定义变量值的标签，<property> 有两个属性name和value；
name: 变量的名称
value: 的值时变量定义的值。
通过<property>定义的值会被插入到logger上下文中。定义变量后，可以使“${}”来使用变量。
例:使用<property>定义上下文名称，然后在<contentName>设置logger上下文时使用。
```xml
<configuration scan="true" scanPeriod="60 seconds" debug="false">  
      <property name="APP_Name" value="myAppName" />   
      <contextName>${APP_Name}</contextName>  
      <!-- 其他配置省略-->  
</configuration>
```

## 获取时间戳字符串：<timestamp>
两个属性:
key: 标识此<timestamp> 的名字；
datePattern: 设置将当前时间（解析配置文件的时间）转换为字符串的模式，遵循java.txt.SimpleDateFormat的格式。
例如将解析配置文件的时间作为上下文名称：
```xml
<configuration scan="true" scanPeriod="60 seconds" debug="false">  
      <timestamp key="bySecond" datePattern="yyyyMMdd'T'HHmmss"/>   
      <contextName>${bySecond}</contextName>  
      <!-- 其他配置省略-->  
</configuration>
```

## 2.4设置loger
### <loger>
用来设置某一个包或者具体的某一个类的日志打印级别、以及指定<appender>。<loger>仅有一个name属性，一个可选的level和一个可选的addtivity属性。
name: 用来指定受此loger约束的某一个包或者具体的某一个类。
level: 用来设置打印级别，大小写无关：TRACE, DEBUG, INFO,WARN,ERROR,ALL和OFF，还有一个特俗值INHERITED或者同义词NULL`，代表强制执行上级的级别。 如果未设置此属性，那么当前loger将会继承上级的级别。
addtivity: 是否向上级loger传递打印信息。默认是true。

### <root>
也是<loger>元素，但是它是根loger。只有一个level属性，应为已经被命名为"root".
level: 用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，不能设置为INHERITED或者同义词NULL。 默认是DEBUG。
<loger>和<root>可以包含零个或多个<appender-ref>元素，标识这个appender将会添加到这个loger。

例如： LogbackDemo.java类
```java
package logback;  
  
import org.slf4j.Logger;  
import org.slf4j.LoggerFactory;  
  
public class LogbackDemo {  
    private static Logger log = LoggerFactory.getLogger(LogbackDemo.class);  
    public static void main(String[] args) {  
        log.trace("======trace");  
        log.debug("======debug");  
        log.info("======info");  
        log.warn("======warn");  
        log.error("======error");  
    }  
}
```

---
# logback.xml配置文件
## 第1种：只配置root
```xml
<configuration>   
   <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">   
    <!-- encoder 默认配置为PatternLayoutEncoder -->   
    <encoder>   
      <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>   
    </encoder>   
  </appender>   
   
  <root level="INFO">             
    <appender-ref ref="STDOUT" />   
  </root>
</configuration>
```
其中appender的配置表示打印到控制台(稍后详细讲解appender )； <root level="INFO">将root的打印级别设置为“INFO”，指定了名字为“STDOUT”的appender。
当执行logback.LogbackDemo类的main方法时，root将级别为“INFO”及大于“INFO”的日志信息交给已经配置好的名为“STDOUT”的appender处理，“STDOUT”appender将信息打印到控制台；
打印结果如下：
```
13:30:38.484 [main] INFO  logback.LogbackDemo - ======info  
13:30:38.500 [main] WARN  logback.LogbackDemo - ======warn  
13:30:38.500 [main] ERROR logback.LogbackDemo - ======error 
```

## 第2种：带有loger的配置，不指定级别，不指定appender：
```xml
<configuration>   
  <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">   
    <!-- encoder 默认配置为PatternLayoutEncoder -->   
    <encoder>   
      <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>   
    </encoder>   
  </appender>   
   
  <!-- logback为java中的包 -->   
  <logger name="logback"/>   
   
  <root level="DEBUG">             
    <appender-ref ref="STDOUT" />   
  </root>     
     
</configuration>
```
其中appender的配置表示打印到控制台(稍后详细讲解appender )； <logger name="logback" />将控制logback包下的所有类的日志的打印，但是并没用设置打印级别，所以继承他的上级<root>的日志级别“DEBUG”； 没有设置addtivity，默认为true，将此loger的打印信息向上级传递； 没有设置appender，此loger本身不打印任何信息。 <root level="DEBUG">将root的打印级别设置为“DEBUG”，指定了名字为“STDOUT”的appender。

当执行logback.LogbackDemo类的main方法时，因为LogbackDemo 在包logback中，所以首先执行<logger name="logback" />，将级别为“DEBUG”及大于“DEBUG”的日志信息传递给root，本身并不打印； root接到下级传递的信息，交给已经配置好的名为“STDOUT”的appender处理，“STDOUT”appender将信息打印到控制台；

打印结果如下：

13:19:15.406 [main] DEBUG logback.LogbackDemo - ======debug  
13:19:15.406 [main] INFO  logback.LogbackDemo - ======info  
13:19:15.406 [main] WARN  logback.LogbackDemo - ======warn  
13:19:15.406 [main] ERROR logback.LogbackDemo - ======error

## 第3种：带有多个loger的配置，指定级别，指定appender:
```xml
<configuration>   
   <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">   
    <!-- encoder 默认配置为PatternLayoutEncoder -->   
    <encoder>   
      <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>   
    </encoder>   
  </appender>   
   
  <!-- logback为java中的包 -->   
  <logger name="logback"/>   
  <!--logback.LogbackDemo：类的全路径 -->   
  <logger name="logback.LogbackDemo" level="INFO" additivity="false">  
    <appender-ref ref="STDOUT"/>  
  </logger>   
    
  <root level="ERROR">             
    <appender-ref ref="STDOUT" />   
  </root>     
</configuration>
```
其中appender的配置表示打印到控制台(稍后详细讲解appender )；
<logger name="logback" />将控制logback包下的所有类的日志的打印，但是并没用设置打印级别，所以继承他的上级<root>的日志级别“DEBUG”； 没有设置addtivity，默认为true，将此loger的打印信息向上级传递； 没有设置appender，此loger本身不打印任何信息。
<logger name="logback.LogbackDemo" level="INFO" additivity="false">控制logback.LogbackDemo类的日志打印，打印级别为“INFO”； additivity属性为false，表示此loger的打印信息不再向上级传递， 指定了名字为“STDOUT”的appender。
<root level="DEBUG">将root的打印级别设置为“ERROR”，指定了名字为“STDOUT”的appender。
当执行logback.LogbackDemo类的main方法时，先执行<logger name="logback.LogbackDemo" level="INFO" additivity="false">，将级别为“INFO”及大于“INFO”的日志信息交给此loger指定的名为“STDOUT”的appender处理，在控制台中打出日志，不再向次loger的上级 <logger name="logback"/> 传递打印信息； <logger name="logback"/>未接到任何打印信息，当然也不会给它的上级root传递任何打印信息；

打印结果如下：
14:09:01.531 [main] INFO  logback.LogbackDemo - ======info  
14:09:01.531 [main] INFO  logback.LogbackDemo - ======info  
14:09:01.531 [main] WARN  logback.LogbackDemo - ======warn  
14:09:01.531 [main] WARN  logback.LogbackDemo - ======warn  
14:09:01.531 [main] ERROR logback.LogbackDemo - ======error  
14:09:01.531 [main] ERROR logback.LogbackDemo - ======error


























```xml
        <layout class="ch.qos.logback.classic.PatternLayout">
            <pattern>%d{MM-dd HH:mm} %msg%n</pattern>
        </layout>
```




----
# logback1:logback1.1.13配置文件加载顺序
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

---











