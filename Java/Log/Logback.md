


        <layout class="ch.qos.logback.classic.PatternLayout">
            <pattern>%d{MM-dd HH:mm} %msg%n</pattern>
        </layout>

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












