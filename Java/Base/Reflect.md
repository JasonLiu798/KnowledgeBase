
[反射获取一个方法中的参数名（不是类型）](http://www.cnblogs.com/guangshan/p/4660564.html)


```java
import org.springframework.core.LocalVariableTableParameterNameDiscoverer;

    public static String[] getParameterNames(Method method){
        LocalVariableTableParameterNameDiscoverer discoverer = new LocalVariableTableParameterNameDiscoverer();
        return discoverer.getParameterNames(method);
    }
```

[reflect gc](http://mp.weixin.qq.com/s/5H6UHcP6kvR2X5hTj_SBjA)


# 值拷贝
## dozer
http://dozer.sourceforge.net/
[Advanced dozer mappings](https://www.tikalk.com/posts/2013/06/11/advanced-dozer-mappings/)




