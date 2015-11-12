#Http protocol
---
#Theory
# 幂等率
[HTTP幂等性概念和应用](http://coolshell.cn/articles/4787.html)
操作本身幂等
##方法1
如果是对参数X（比如5），我们只允许减一次，后面重复的，我们就直接返回。
   void D(int x){
          if(atomic_inc(x) > 1){
               return ;
         }
          g_value -= x;
}
##方法2
假如我们允许x多次被减，但是调用方为了确保成功，会尝试多次。换句话说调用方掉N次才认为是调用一次成功，这时就需要操作时的一个唯一标示，唯一标示可以理解操作流水号，这时就要改造函数的参数。

    void D(int x, string s){
          if(atomic_inc(s) > 1){
               return ;
         }
          g_value -= x;
          /**如果失败了，则要回滚**/
         /**atomic_dec(s)**/
    }
方法2会出现记录的流水号太多，导致占用很多的空间，因此我们要对s设置生命周期，过来生命周期就直接删除掉。
因此，这里要考虑一个变态的调用，调用方会不会在很长的时间内调用同一流水的调用，如果会，这时要改造下函数：

    void D(int x, string s，time_t t){
         if(difftime(time(), t) > XXXX){
                 return ;
         }
          if(atomic_inc(s) > 1){
               return ;
         }
          g_value -= x;
          /**如果失败了，则要回滚**/
         /**atomic_dec(s)**/
    }
atomic_inc:这个是原子加操作，可以利用redis的原子加操作。即利用中央服务器提供的某个操作来保证。
##唯一标示从哪里来？
1：如果参数X，可以确定为唯一标示，那么直接对X算MD5，或者CRC，或者直接用X（X是一个字符串，整形）。
2：如果参数X不可以确定为唯一标示，比如同一个用户多次购买同一个商品。这是X就无法确认唯一标示，那这时，我们加入操作流水号，标明我们要保证用户在这个时间段买的商品，减库存的幂等性。
3：加入时间戳，可以拒绝一些非法的调用，同时可以清除历史记录。
##建议
1：幂等性的作用：就是防止别人多次调用造成的业务异常问题，所以唯一标识要优先从业务情况获取。
 （1）比如根据订单号进去扣库存，订单号是全局唯一的。
 （2）有的可以根据自己业务的唯一主键进行幂等性保证。
2：有些业务天生是幂等性的，可以不考虑。比如通过mysql 数据库的主键唯一性来确保。

# http2
https://www.gitbook.com/book/ye11ow/http2-explained/details

---
# 缓存
## 解决问题
带宽瓶颈
瞬间拥塞
距离延时

## 命中/未命中
新鲜度检测
    GET If-modified-Since
    304 not modified
字节命中率 大文档

文档过期
服务器再验证

---
#REST
[理解本真的REST架构风格](http://www.infoq.com/cn/articles/understanding-restful-style#anch101041)
[RESTful API 设计最佳实践](http://www.oschina.net/translate/best-practices-for-a-pragmatic-restful-api)
[架构风格与基于网络应用软件的架构设计（中文修订版）](http://www.infoq.com/cn/minibooks/web-based-apps-archit-design)

POST     |     /uri     |     创建     |       非幂等     |     与GET区别，主要是为了提交
DELETE  |     /uri/xxx      |     删除        |     幂等
PUT       |     /uri/xxx      |     更新/创建  |     幂等    |    创建与POST区别，uri可以在客户端确定
GET       |     /uri/xxx      |     查看       |     幂等 

##无状态
REST 架构要求客户端的所有的操作在本质上是无状态的，即从客户到服务器的每个 Request 都必须包含理解该 Request 的所有必需信息。这种无状态性的规范提供了如下几点好处：
无状态性使得客户端和服务器端不必保存对方的详细信息，服务器只需要处理当前 Request，而不必了解前面 Request 的历史。
无状态性减少了服务器从局部错误中恢复的任务量，可以非常方便地实现 Fail Over 技术，从而很容易地将服务器组件部署在集群内。
无状态性使得服务器端不必在多个 Request 中保存状态，从而可以更容易地释放资源。
无状态性无需服务组件保存 Request 状态，因此可让服务器充分利用 Pool 技术来提高稳定性和性能。


---
#http1.0 与1.1的区别
http://blog.csdn.net/forgotaboutgirl/article/details/6936982
HTTP1.1的协议标准RFC2616
下面是看到的一些它跟HTTP1.0的差别
##Persistent Connection(持久连接)
在HTTP1.0中，每对Request/Response都使用一个新的连接。
HTTP 1.1则支持Persistent Connection, 并且默认使用persistent connection.
##Host 域
HTTP1.1在Request消息头里头多了一个Host域，比如：

       GET /pub/WWW/TheProject.html HTTP/1.1
       Host: www.w3.org

HTTP1.0则没有这个域。
可能HTTP1.0的时候认为，建立TCP连接的时候已经指定了IP地址，这个IP地址上只有一个host。

##date/time stamp (日期时间戳)
(接收方向)
无论是HTTP1.0还是HTTP1.1，都要能解析下面三种date/time stamp：
 
      Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
      Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
      Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format

(发送方向)
    HTTP1.0要求不能生成第三种asctime格式的date/time stamp；
    HTTP1.1则要求只生成RFC 1123(第一种)格式的date/time stamp。

##Transfer Codings
HTTP1.1支持chunked transfer，所以可以有Transfer-Encoding头部域:
Transfer-Encoding: chunked
HTTP1.0则没有。

##Quality Values
HTTP1.1多了个qvalue域：
 
       qvalue  = ( "0" [ "." 0*3DIGIT ] )
             | ( "1" [ "." 0*3("0") ] )
 
##Entity Tags
用于Cache。

##Range 和 Content-Range
HTTP1.1支持传送内容的一部分。比方说，当客户端已经有内容的一部分，为了节省带宽，可以只向服务器请求一部分。

##100 (Continue) Status
100 (Continue) 状态代码的使用，允许客户端在发request消息body之前先用request header试探一下server，看server要不要接收request body，再决定要不要发request body。
客户端在Request头部中包含
Expect: 100-continue
Server看到之后呢如果回100 (Continue) 这个状态代码，客户端就继续发request body。
这个是HTTP1.1才有的。
 
##Request method
HTTP1.1增加了OPTIONS, PUT, DELETE, TRACE, CONNECT这些Request方法.

       Method         = "OPTIONS"                ; Section 9.2
                      | "GET"                    ; Section 9.3
                      | "HEAD"                   ; Section 9.4
                      | "POST"                   ; Section 9.5
                      | "PUT"                    ; Section 9.6
                      | "DELETE"                 ; Section 9.7
                      | "TRACE"                  ; Section 9.8
                      | "CONNECT"                ; Section 9.9
                      | extension-method
       extension-method = token

##状态码Status code
1xx(临时响应)
2xx (成功)
3xx (重定向)
4xx(请求错误)
5xx(服务器错误)
常用：200 - 服务器成功返回网页，404 - 请求的网页不存在，503 - 服务器超时

HTTP1.1 增加的新的status code：
(HTTP1.0没有定义任何具体的1xx status code, HTTP1.1有2个)
100 Continue
101 Switching Protocols

203 Non-Authoritative Information
205 Reset Content
206 Partial Content

302 Found (在HTTP1.0中有个 302 Moved Temporarily)
303 See Other
305 Use Proxy
307 Temporary Redirect
 
405 Method Not Allowed
406 Not Acceptable
407 Proxy Authentication Required
408 Request Timeout
409 Conflict
410 Gone
411 Length Required
412 Precondition Failed
413 Request Entity Too Large
414 Request-URI Too Long
415 Unsupported Media Type
416 Requested Range Not Satisfiable
417 Expectation Failed
 
504 Gateway Timeout
505 HTTP Version Not Supported
 
 
##Content Negotiation
    HTTP1.1增加了Content Negotiation，分为Server-driven Negotiation，Agent-driven Negotiation和Transparent Negotiation三种。

##Cache (缓存)
HTTP1.1(RFC2616)详细展开地描述了Cache机制，详见13节。




---
# 前沿
## http2
https://www.gitbook.com/book/ye11ow/http2-explained/details









