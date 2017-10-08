# Java security 相关
---
#spring security
[DOC](http://projects.spring.io/spring-security)
[spring security3.2](http://docs.spring.io/spring-security/site/docs/3.2.0.RELEASE/reference/htmlsingle/#preface)
[Spring Security 与 Oauth2 整合步骤](http://blog.csdn.net/monkeyking1987/article/details/16828059)
[简单配置schema版](http://liukai.iteye.com/blog/982088)
[包含角色权限配置](http://www.cnblogs.com/fangfan/archive/2013/02/21/2921219.html)
[SpringMVC 3.1集成Spring Security 3.1](http://www.cnblogs.com/Beyond-bit/p/SpringMVC_And_SpringSecurity.html)
[【JavaEE】SSH+Spring Security+Spring oauth2环境方法及example](http://www.tuicool.com/articles/B3MNFjr)
[【JavaEE】SSH+Spring Security+Spring oauth2整合及example](http://www.cnblogs.com/smarterplanet/p/4088479.html?utm_source=tuicool)

[Spring Security3.1 最新配置实例](http://blog.csdn.net/k10509806/article/details/6369131)

## 基本配置
### web.xml
    <filter>
        <filter-name>springSecurityFilterChain</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>springSecurityFilterChain</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    <context-param>
        <param-name>contextConfigLocation</param-name>  
        <param-value>
        /WEB-INF/spring-security.xml  
        <param-value>
    </context-param>
Ps:DelegatingFilterProxy最好在Dispatcher之前

### spring-security.xml
    <http access-denied-page="/tiles/jsp/403.jsp">
        <!-- 当访问被拒绝时，会转到403.jsp -->
        <intercept-url pattern="/login.jsp" filters="none" />
        <!-- session-management是针对session的管理. 这里可以不配置. 如有需求可以配置. -->
        <!-- id登陆唯一. 后登陆的账号会挤掉第一次登陆的账号 error-if-maximum-exceeded="true" 禁止2次登陆; session-fixation-protection="none" 防止伪造sessionid攻击. 用户登录成功后会销毁用户当前的session. 创建新的session,并把用户信息复制到新session中. <concurrency-control max-sessions="1" expired-url="/tiles/jsp/sessionTimeout.jsp"/> 
        -->
        <session-management session-fixation-protection="none">
            <concurrency-control />
        </session-management>
        <form-login login-page="/tiles/jsp/login.jsp"
            authentication-failure-url="/tiles/jsp/login.jsp?error=true"
            authentication-success-handler-ref="loginSuccessHandler"
            default-target-url="/" />
        <logout invalidate-session="true" logout-success-url="/tiles/jsp/login.jsp" />
        <http-basic />
        <!-- 增加一个filter，这点与Acegi是不一样的，不能修改默认的filter了，这个filter位于FILTER_SECURITY_INTERCEPTOR之前 -->
        <custom-filter before="FILTER_SECURITY_INTERCEPTOR" ref="myFilter" />
    </http>
    <!-- 自定义的filter，必须包含authenticationManager,accessDecisionManager,securityMetadataSource三个属性，我们的所有控制将在这三个类中实现 -->
    <beans:bean id="myFilter" class="cn.com.cnpc.security.MyFilterSecurityInterceptor">
        <beans:property name="authenticationManager" ref="authenticationManager" />
        <beans:property name="accessDecisionManager" ref="myAccessDecisionManagerBean" />
        <beans:property name="securityMetadataSource" ref="securityMetadataSource" />
    </beans:bean>

myfilter extends AbstractSecurityInterceptor
[Class AbstractSecurityInterceptor](http://docs.spring.io/spring-security/site/docs/3.1.7.RELEASE/apidocs/org/springframework/security/access/intercept/AbstractSecurityInterceptor.html)

authenticationManager 
myAccessDecisionManagerBean extends AccessDecisionManager
securityMetadataSource implements
        FilterInvocationSecurityMetadataSource

##版本变更
http://www.lssrc.com/archives/899.html
org.springframework.security.web.util.AntUrlPathMatcher;
org.springframework.security.web.util.UrlMatcher;
->
org.springframework.security.web.util.matcher.RequestMatcher;
org.springframework.security.web.util.matcher.AntPathRequestMatcher;


---
#权限设计
[基于角色-功能-资源的权限控制模型的设计与实现-引子](http://www.cnblogs.com/Hedonister/archive/2006/11/21/567383.html)


---
#Shiro
[Shiro简介](http://jinnianshilongnian.iteye.com/blog/2018936)
认证 - 用户身份识别，常被称为用户“登录”；
授权 - 访问控制；
密码加密 - 保护或隐藏数据防止被偷窥；
会话管理 - 每用户相关的时间敏感的状态。


