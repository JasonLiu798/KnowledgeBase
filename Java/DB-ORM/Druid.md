

java -cp druid-1.0.16.jar com.alibaba.druid.filter.config.ConfigTools passwd123 >> pass.md


#加密
[Druid连接池自定义数据库密码加解密的实现](http://kengun.iteye.com/blog/2342115)

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<beans xmlns="http://www.springframework.org/schema/beans"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"  
    xmlns:tx="http://www.springframework.org/schema/tx"  
    xsi:schemaLocation="  
            http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.5.xsd  
            http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-2.5.xsd  
            http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-2.5.xsd">  
  
    <!-- 引入jdbc配置文件 -->  
    <bean id="propertyConfigurer"  
        class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">  
        <property name="locations">  
            <list>  
                <value>classpath*:jdbc.properties</value>  
            </list>  
        </property>  
    </bean>  
  
    <!--数据源加密操作 -->  
    <bean id="dbPasswordCallback" class="com.waukeen.util.DBPasswordCallback"  
        lazy-init="true" />  
  
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource"  
        init-method="init" destroy-method="close" lazy-init="true">  
        <property name="url" value="${url}" />  
        <property name="username" value="${username}" />  
        <property name="password" value="${password}" />  
        <property name="driverClassName" value="${driver}" />  
        <property name="initialSize" value="${initialSize}" />  
        <property name="maxActive" value="${maxActive}" />  
        <property name="maxWait" value="${maxWait}" />  
        <property name="filters" value="stat" />  
        <property name="connectionProperties" value="password=${password}" />  
        <property name="passwordCallback" ref="dbPasswordCallback" />  
    </bean>  
  
</beans>
```

#创建DruidPasswordCallback子类
创建DBPasswordCallback类继承DruidPasswordCallback，并重写setProperties方法
```java
package com.waukeen.util;  
  
import java.util.Properties;  
  
import com.alibaba.druid.util.DruidPasswordCallback;  
import com.waukeen.security.Encode;  
  
/** 
 * 数据库回调密码解密 
 *  
 * @author 
 * 
 */  
@SuppressWarnings("serial")  
public class DBPasswordCallback extends DruidPasswordCallback {  
  
    public void setProperties(Properties properties) {  
        super.setProperties(properties);  
        String password = properties.getProperty("password");  
        if (!Tools.isEmpty(password)) {  
            // 解密数据库连接密码  
            String pwd = Encode.decode(password);  
            setPassword(pwd.toCharArray());  
        }  
    }  
  
    public static void main(String[] args) {  
                // 生成加密后的密码，放到jdbc.properties  
        String pwd = Encode.encode("pwd");  
        System.out.println(pwd);  
    }  
}
```

#jdbc.properties的内容
```
#数据库连接地址  
url=jdbc:mysql://127.0.0.1:3306/test  
#用户名  
username=root  
#密码，这里的密码是你加密之后的密码！！！  
password=XXXXX  
#数据库连接驱动类  
driver=com.mysql.jdbc.Driver  
#定义初始连接数  
initialSize=10  
#定义最大连接数  
maxActive=12  
#定义最长等待时间  
maxWait=5000  
```

#config


```xml
<!--数据源加密操作 -->  
<bean id="dbPasswordCallback" class="com.waukeen.util.DBPasswordCallback" lazy-init="true" />
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource"  
    init-method="init" destroy-method="close" lazy-init="true">  
    <property name="url" value="${url}" />  
    <property name="username" value="${username}" />  
    <property name="password" value="${password}" />  
    <property name="driverClassName" value="${driver}" />  
    <property name="initialSize" value="${initialSize}" />
    <property name="maxActive" value="${maxActive}" />  
    <property name="maxWait" value="${maxWait}" />  
    <property name="filters" value="stat" />  
    <!--传递password加密后的值到DBPasswordCallback，不能遗漏 -->  
    <property name="connectionProperties" value="password=${password}" />  
    <property name="passwordCallback" ref="dbPasswordCallback" />  
</bean>
```
















