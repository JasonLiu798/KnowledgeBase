


---
#服务端
[CXF 在Spring中开发服务端步骤](http://blog.csdn.net/xpsharp/article/details/12582225)
```xml
<dependency>  
    <groupId>org.apache.cxf</groupId>  
    <artifactId>cxf-api</artifactId>  
    <version>2.7.7</version>  
</dependency>  
<dependency>  
    <groupId>org.apache.cxf</groupId>  
    <artifactId>cxf-rt-frontend-jaxws</artifactId>  
    <version>2.7.7</version>  
</dependency>  
<dependency>  
    <groupId>org.apache.cxf</groupId>  
    <artifactId>cxf-rt-bindings-soap</artifactId>  
    <version>2.7.7</version>  
</dependency>  
<dependency>  
    <groupId>org.apache.cxf</groupId>  
    <artifactId>cxf-rt-transports-http</artifactId>  
    <version>2.7.7</version>  
</dependency>  
<dependency>  
    <groupId>org.apache.cxf</groupId>  
    <artifactId>cxf-rt-ws-security</artifactId>  
    <version>2.7.7</version>  
</dependency>  
<dependency>  
    <groupId>org.apache.httpcomponents</groupId>  
    <artifactId>httpcore</artifactId>  
    <version>4.3</version>  
</dependency>  
<dependency>  
    <groupId>org.apache.httpcomponents</groupId>  
    <artifactId>httpcore-nio</artifactId>  
    <version>4.3</version>  
</dependency>  
<dependency>  
    <groupId>org.apache.httpcomponents</groupId>  
    <artifactId>httpasyncclient</artifactId>  
    <version>4.0-beta4</version>  
</dependency>  
```

接口
```java
package com.sharp.hibernatedemo.ws;  
  
import javax.jws.WebService;  
import javax.jws.soap.SOAPBinding;  
  
import com.sharp.hibernatedemo.domain.User;  
  
@WebService  
@SOAPBinding(style = SOAPBinding.Style.RPC, use = SOAPBinding.Use.LITERAL)  
public interface IUserServiceWs  
{  
    void addUser(User user);  
}
```

实现类
```java
package com.sharp.hibernatedemo.ws.impl;  
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.stereotype.Component;  
import com.sharp.hibernatedemo.domain.User;  
import com.sharp.hibernatedemo.service.IUserService;  
import com.sharp.hibernatedemo.ws.IUserServiceWs;  
@Component("userServiceWs")  
public class UserServiceWsImpl implements IUserServiceWs  
{  
    @Autowired  
    private IUserService userService;  
    public void addUser(User user)  
    {  
        userService.addUser(user);  
    }  
  
}
```

配置
```xml
<?xml version="1.0" encoding="UTF-8"?>  
<beans xmlns="http://www.springframework.org/schema/beans"   
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
    xmlns:p="http://www.springframework.org/schema/p"  
    xmlns:jaxws="http://cxf.apache.org/jaxws"  
    xsi:schemaLocation="http://www.springframework.org/schema/beans   
                        http://www.springframework.org/schema/beans/spring-beans-3.2.xsd  
                        http://cxf.apache.org/jaxws  
                        http://cxf.apache.org/schemas/jaxws.xsd">  
    <import resource="classpath:META-INF/cxf/cxf.xml" />  
    <import resource="classpath:META-INF/cxf/cxf-servlet.xml" />  
    <jaxws:server id="userServiceWss"  
        serviceClass="com.sharp.hibernatedemo.ws.IUserServiceWs"  
        address="/userServiceWs">  
        <jaxws:serviceBean>  
            <ref bean="userServiceWs" /> <!-- 和上面的id名字一定不要重复了 -->  
        </jaxws:serviceBean>  
    </jaxws:server>  
</beans>  
```







---
#客户端

[通过CXF的jaxws:client调用SOAP服务](http://blog.csdn.net/littlechenlin/article/details/50887428)

```java
package com.cc.service;
import com.cc.entity.User;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;

@WebService(name = "UserService", targetNamespace = "http://impl.service.cc.com")
public interface UserService {
    @WebMethod(operationName = "getName", action = "urn:GetName")
    public User getName(@WebParam(name="userName") String userName);
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:jaxws="http://cxf.apache.org/jaxws"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
          http://www.springframework.org/schema/beans
          http://www.springframework.org/schema/beans/spring-beans.xsd
          http://cxf.apache.org/jaxws
          http://cxf.apache.org/schemas/jaxws.xsd">
    <jaxws:client id="client"
                  serviceClass="com.cc.service.UserService"
                  address="http://localhost:9000/serviceTest/service/userService">
    </jaxws:client>
</beans>
```

```java
import com.cc.entity.User;
import com.cc.service.UserService;
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;
import org.springframework.context.support.ClassPathXmlApplicationContext;


public class Main {

    public static void main(String[] args) {
        //使用JaxWsProxyFactoryBean调用soap服务，但是这种方式需要需要生成接口文件
        System.out.println("***********JaxWsProxyFactoryBean***********");
        JaxWsProxyFactoryBean factory = new JaxWsProxyFactoryBean();
        factory.setServiceClass(UserService.class);
        factory.setAddress("http://localhost:9000/serviceTest/service/userService");
        UserService userServiceJaxBean = (UserService)factory.create();
        User userJaxBean = userServiceJaxBean.getName("zhangsan");
        System.out.println(userJaxBean.getTelephone());

        //测试jaxws:client，soap服务client调用
        System.out.println("******************soap jaxws:client**************");
        ClassPathXmlApplicationContext cxt = new ClassPathXmlApplicationContext(new String[]{"client.xml"});
        UserService us = (UserService)cxt.getBean("client");
        User user = us.getName("aaa");
        System.out.println(user.getTelephone());
    }
}
```









