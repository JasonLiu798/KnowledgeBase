#Struts2
---
#Theory
##mvc设计思想
请求-响应 参数-返回值    |   springMVC 
参数-参数   |   servlet 
POJO模式  |    stuts
数据流 控制流

参数map缺点 非强类型 可读性 类型转化 优点：灵活性
控制层 请求数据搜集 业务逻辑处理 响应数据搜集 响应流程控制
处理节点 Interceptor Action Result 事件驱动 ActionProxy ActionInvacation

##struts2流程分析
[Struts2 内核之我见](http://www.ibm.com/developerworks/cn/java/j-lo-struct2/)
* 初始的请求通过一条标准的过滤器链，到达servlet容器 (比如tomcat容器，WebSphere容器)
* 过滤器链包括可选的ActionContextCleanUp过滤器，用于系统整合技术，如 SiteMesh 插件。
* 接着调用FilterDispatcher，FilterDispatcher查找ActionMapper，以确定这个请求是否需要调用某个 Action
* 如果ActionMapper确定需要调用某个Action，FilterDispatcher 将控制权交给ActionProxy。
* ActionProxy依照框架的配置文件(struts.xml)，找到需要调用的 Action 类。
* ActionProxy创建一个ActionInvocation的实例。ActionInvocation先调用相关的拦截器 （Action 调用之前的部分），最后调用Action。
* 一旦Action调用返回结果，ActionInvocation根据struts.xml配置文件，查找对应的转发路径。返回结果通常是（但不总是，也可能是另外的一个 Action 链）JSP 技术或者 FreeMarker 的模版技术的网页呈现。Struts2的标签和其他视图层组件，帮助呈现我们所需要的显示结果。在此，我想说清楚一些，最终的显示结果一定是HTML标签。标签库技术和其他视图层技术只是为了动态生成 HTML 标签。
* 接着按照相反次序执行拦截器链(执行Action调用之后的部分 )。最后，响应通过滤器链返回（过滤器技术执行流程与拦截器一样，都是先执行前面部分，后执行后面部）。如果过滤器链中存在ActionContextCleanUp，FilterDispatcher不会清理线程局部的ActionContext。如果不存在ActionContextCleanUp过滤器，FilterDispatcher会清除所有线程局部变量。

##FilterDispatcher
###init 方法
初始化过滤器，创建默认的 dispatcher 对象并且设置静态资源的包。
###destory 方法
核心业务是调用 dispatcher.cleanup() 方法。cleanup 释放所有绑定到 dispatcher 实例的资源，包括销毁所有的拦截器实例
###doFilter 方法
doFilter 方法的出口有 3 个分支。
首先过滤器尝试把 request 匹配到一个 Action mapping(action mapping 的解释见最后的总结)。若有匹配，执行 path1。否则执行 path2 或者 3。
path 1调用 dispatcher. serviceAction() 方法处理 Action 请求 
如果找到了 mapping，Action 处理被委托给 dispatcher 的 serviceAction 方法。 如果 Action 处理失败了，doFilter 将会通过 dispatcher 创建一个错误页。
path 2处理静态资源 
如果请求的是静态资源。资源被直接拷贝到 response 对象，同时设置对应的头信息。
path 3无处理直接通过过滤器，访问过滤器链的下个资源。

##org.apache.struts2.dispatcher.Dispatcher
###serviceAction 方法
根据 action Mapping 加载 Action 类，调用对应的 Action 方法，转向相应结果。
首先，本方法根据给定参数，创建 Action context。接着，根据 Action 的名称和命名空间，创建 Action 代理。( 注意这代理模式中的代理角色 ) 然后，调用代理的 execute() 方法，输出相应结果。
如果 Action 或者 result 没有找到，将通过 sendError() 报 404 错误。

###cleanup 方法
释放所有绑定到 dispatcher 实例的资源

##拦截器与 ActionContext

##valueStack
                 |--application 
                 | 
                 |--session 
    context map--| 
                 |--value stack(root) 
                 | 
                 |--request 
                 | 
                 |--parameters 
                 | 
                 |--attr (searches page, request,session, then application scopes)
##总结
FilterDispatcher 接到请求，查找对应的 Action Mapping，调用 Dispatcher 类的 serviceAction() 方法。
Dispatcher 类的 serviceAction() 方法中创建并且调用 ActionProxy。
ActionProxy，持有 ActionInvocation 的实例引用。ActionInvocation 代表着 Action 执行的状态，它持有着拦截器和 Action 实例的引用。ActionInvocation 通过反复调用 invoke() 方法，调用沿着拦截器链向下走。
走完拦截器链后运行 Action 实例，最后运行 Result。
大家注意到拦截器链了吗？它才是 Struts2.0 的核心所在。
org.apache.struts2.dispatcher.ActionContextCleanUp 告诉 FilterDispatcher 不要清除值栈，由自己来清除。



---
#REST
[使用 Struts 2 开发 RESTful 服务](http://www.ibm.com/developerworks/cn/java/j-lo-struts2rest/)
Convention 插件
##RestActionMapper
标准 HTML 语言目前根本不支持 PUT 和 DELETE 两个操作，为了弥补这种不足，REST 插件允许开发者提交请求时额外增加一个 _method 请求参数，该参数值可以为 PUT 或 DELETE，用于模拟 HTTP 协议的 PUT 和 DELETE 操作。
##jar
struts2-convention-plugin-2.1.6.jar
struts2-rest-plugin-2.1.6.jar


##返回json
[Struts2返回JSON对象的方法总结](http://kingxss.iteye.com/blog/1622455)


---
#SSH整合
[Struts2、Spring、Hibernate 高效开发的最佳实践](https://www.ibm.com/developerworks/cn/java/j-lo-ssh/)
##ModelDriven 的规约
##权限规约



---
#文件下载
##excel
ByteArrayOutputStream baos = new ByteArrayOutputStream();
try {
    workbook.write(baos);
} catch (IOException e) {
    e.printStackTrace();
}
byte[] ba = baos.toByteArray();
bais = new ByteArrayInputStream(ba);

//downloadFileName
public String getDownloadFileName(){
    String name = null;
    try {
        name = new String("xxx.xls".getBytes(), "ISO8859-1");
    } catch (UnsupportedEncodingException e) {
        name = "vehicles.xml";
        e.printStackTrace();
    }
    return name;
}

<action name="searchVehicles" class="searchVehicleService" method="searchVehicles">
    <result name="success" type="stream">
        <param name="contentType">application/vnd.ms-excel</param>
        <param name="contentDisposition">attachment;filename="${downloadFileName}"</param>
        <param name="inputName">bais</param>
    </result>
</action>

