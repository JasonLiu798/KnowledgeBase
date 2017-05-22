


[CAS实现过滤掉某些URL不走单点登录](http://wangyangqq2008.iteye.com/blog/2043018)
覆写org.jasig.cas.client.authentication.AuthenticationFilter，该类继承了AbstractCasFilter类，你从新定义一个AuthenticationFilterWithExcludeUrl继承AbstractCasFilter，在新类中完全复制AuthenticationFilter中的代码，但需要改造，如下：
```java
private String[] excludePaths;//要排除的url路径
protected void initInternal(final FilterConfig filterConfig) throws ServletException {
        super.initInternal(filterConfig);
        //从web.xml中解析出init-param要排除的url配置
        String _excludePaths = getPropertyFromInitParams(filterConfig, "excludePaths", null);// filterConfig.getInitParameter("excludePaths");
        if(CommonUtils.isNotBlank(_excludePaths)){
        	setExcludePaths(_excludePaths.trim().split(","));
        }
		///……
}
```
在方法
```java
public final void doFilter(final ServletRequest servletRequest, final ServletResponse servletResponse, final FilterChain filterChain) throws IOException, ServletException {
……

String uri = request.getRequestURI();
       
        boolean isInWhiteList = false;
        
        if(excludePaths!=null && excludePaths.length>0 && uri!=null){
        	for(String path : excludePaths){
        	if(CommonUtils.isNotBlank(path)){
        	isInWhiteList = uri.indexOf(path.trim())>-1;
        	if(isInWhiteList){
        	break;
        	}
        	}
        	}
        }
        
        
        if(isInWhiteList){
        	System.out.println("请求wlist："+uri);
        }else if (CommonUtils.isBlank(ticket) && assertion == null && !wasGatewayed) {
                       ……
               }
……
  
}
```

在web.xml中配置
```xml
<filter>
<filter-name>CAS Authentication Filter</filter-name>
<!-- 
<filter-class>org.jasig.cas.client.authentication.AuthenticationFilter</filter-class>
 -->
<filter-class>com.qec.biFrame.common.cas.AuthenticationFilterWithExcludeUrl</filter-class>
<init-param>
<param-name>casServerLoginUrl</param-name>
<!-- <param-value>http://uuap.baidu.com/login</param-value> -->
<param-value>http://itebeta.baidu.com:8100/login</param-value>
</init-param>
<init-param>
    <description>客户端应用服务地址</description>
<param-name>serverName</param-name>
<!-- <param-value>http://mbudata.baidu.com</param-value> -->
<param-value>http://localhost:8080</param-value>
</init-param>
<init-param>
    <description>客户端应用服务地址</description>
<param-name>excludePaths</param-name>
<param-value>/services/AuthService,/servlet/authServiceCall,/interfaceCall/</param-value>
</init-param>
</filter>
<filter-mapping>
<filter-name>CAS Authentication Filter</filter-name>
<url-pattern>/*</url-pattern>
</filter-mapping>
```








