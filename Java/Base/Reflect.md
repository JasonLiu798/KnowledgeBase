
[反射获取一个方法中的参数名（不是类型）](http://www.cnblogs.com/guangshan/p/4660564.html)


```java
import org.springframework.core.LocalVariableTableParameterNameDiscoverer;

    public static String[] getParameterNames(Method method){
        LocalVariableTableParameterNameDiscoverer discoverer = new LocalVariableTableParameterNameDiscoverer();
        return discoverer.getParameterNames(method);
    }
```


