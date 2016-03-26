#server setup & setting
---
#java容器
#tomcat
JAVA_HOME，CATALINA_HOME
## user & permission
tomcat-users.xml 
```xml
<tomcat-users>
  <role rolename="manager"/>
  <role rolename="admin"/>
  <user username="admin" password="xxzx2012" roles="admin,manager"/>
</tomcat-users>
```

##　虚拟目录配置
Server.xml中<Host>之上
<Context path="/demo" docBase="D:\">

## 中文乱码
Server.xml
```xml
    <Connector>添加URIEncoding="UTF-8"
    <Connector port="80" protocol="HTTP/1.1"
                   connectionTimeout="20000"
                   redirectPort="8443"
                   URIEncoding="UTF-8"/>
```

## 自动加载
context.xml
<Context>改为<Context reloadable="true">
目的：Tomcat识别新修改的文件，自动重新加载web应用
注：修改后对运行性能有影响，产品阶段改为
<Context reloadable="false">

## 列出目录下所有文件，开发阶段
web.xml
```xml
<init-param>
      <param-name>listings</param-name>
      <param-value>true</param-value>
</init-param>
```

#域名
godaddy
https://www.godaddy.com/


---
#nginx
ps -ef|grep nginx
/usr/local/var/run/nginx.pid







