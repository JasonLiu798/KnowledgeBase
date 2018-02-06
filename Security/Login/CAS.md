#CAS
---
#doc
[JAVA CAS单点登录(SSO)](http://blog.csdn.net/kuangkunkui/article/details/7902822)
[CAS单点登录原理以及debug跟踪登录流程](http://www.cnblogs.com/notDog/p/5252973.html)

---
#CAS 原理和协议
基础模式 SSO 访问流程主要有以下步骤：
1. 访问服务： SSO 客户端发送请求访问应用系统提供的服务资源。
2. 定向认证： SSO 客户端会重定向用户请求到 SSO 服务器。
3. 用户认证：用户身份认证。
4. 发放票据： SSO 服务器会产生一个随机的 Service Ticket 。
5. 验证票据： SSO 服务器验证票据 Service Ticket 的合法性，验证通过后，允许客户端访问服务。
6. 传输用户信息： SSO 服务器验证票据通过后，传输用户认证结果信息给客户端。

CAS Client 与受保护的客户端应用部署在一起，以 Filter 方式保护 Web 应用的受保护资源，过滤从客户端过来的每一个 Web 请求，同 时， CAS Client 会分析 HTTP 请求中是否包含请求 Service Ticket( ST 上图中的 Ticket) ，如果没有，则说明该用户是没有经过认证的；于是 CAS Client 会重定向用户请求到 CAS Server （ Step 2 ），并传递 Service （要访问的目的资源地址）。 Step 3 是用户认证过程，如果用户提供了正确的 Credentials ， CAS Server 随机产生一个相当长度、唯一、不可伪造的 Service Ticket ，并缓存以待将来验证，并且重定向用户到 Service 所在地址（附带刚才产生的 Service Ticket ） , 并为客户端浏览器设置一个 Ticket Granted Cookie （ TGC ） ； CAS Client 在拿到 Service 和新产生的 Ticket 过后，在 Step 5 和 Step6 中与 CAS Server 进行身份核实，以确保 Service Ticket 的合法性。

在该协议中，所有与 CAS Server 的交互均采用 SSL 协议，以确保 ST 和 TGC 的安全性。协议工作过程中会有 2 次重定向 的过程。但是 CAS Client 与 CAS Server 之间进行 Ticket 验证的过程对于用户是透明的（使用 HttpsURLConnection ）。

CAS 如何实现 SSO
当用户访问另一个应用的服务再次被重定向到 CAS Server 的时候， CAS Server 会主动获到这个 TGC cookie ，然后做下面的事情：
1) 如果 User 持有 TGC 且其还没失效，那么就走基础协议图的 Step4 ，达到了 SSO 的效果；
2) 如果 TGC 失效，那么用户还是要重新认证 ( 走基础协议图的 Step3) 。

以上是在网络上找到的相关描述，详细请参考：
http://www.open-open.com/lib/view/open1432381488005.html


---
#改造

##增加白名单
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








