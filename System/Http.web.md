#Http protocol
---
#tcp
TCP时延：
tcp连接建立握手（syn-sync/ack-ack/GET....），只传少量数据会造成延迟
tcp慢启动拥塞控制，每接收一个分组，发送端就
数据聚集nagle算法
捎带确认tcp延迟确认算法(延迟100~200ms同数据分组，捎带回复)
timd_wait时延和短裤耗尽


# 幂等率
[HTTP幂等性概念和应用](http://coolshell.cn/articles/4787.html)
绝大部分网络上对幂等性的解释类似于:
"幂等性是指重复使用同样的参数调用同一方法时总能获得同样的结果。比如对同一资源的GET请求访问结果都是一样的。"
我认为这种解释是非常错误的, 幂等性强调的是外界通过接口对系统内部的影响, 外界怎么看系统和幂等性没有关系. 就上面这种解释, System.getCPULoad(), 这两次调用返回能一样吗？ 但因为是只读接口, 对系统内部状态没有影响, 所以这个函数还是幂等性的.
首先了解一下什么是幂等性，如果你没有兴趣可以直接跳过这段代数概念解释 :)

##定义
幂等(idempotence)是来自于高等代数中的概念。
定义如下(加入了自己理解)：
单目运算, x为某集合内的任意数, f为运算子如果满足f(x)=f(f(x)), 那么我们称f运算为具有幂等性(idempotent)

比如在实数集中,绝对值运算就是一个例子: abs(a)=abs(abs(a))
双目运算，x为某集合内的任意数, f为运算子如果满足f(x,x)=x, f运算的前提是两个参数都同为x, 那么我们也称f运算为具有幂等性

比如在实数集中,求两个数的最大值的函数: max(x,x) = x, 还有布尔代数中,逻辑运算 "与", "或" 也都是幂等运算, 因为他们符合AND(0,0) = 0, AND(1,1) = 1, OR(0,0) = 0, OR(1,1) = 1

在将幂等性应用到软件开发中,需要一些更深的理解. 我的理解如下:
数学处理的是运算和数值, 程序开发中往往处理的是对象和函数. 但是我们不能简单地理解为数学幂等中的运算就是函数,而数值就是对象!!

比如有Person对象有两个属性weight和age,但是所有的function只能对其中一个属性操作. 所以从这个层面我们可以理解为: 函数只对该函数所操作的对象某个属性具有幂等性, 而不是说对整个对象有运算幂等性.
```java
Person {  
 private int weight;  
 private int age;  
 //是幂等函数  
 public void setAge(int v){  
     this.age = v;   
 }  
 //不是幂等函数  
 public void increaseAge(){  
     this.age++;  
 }   
 //是幂等函数  
 public void setWeight(int v){  
     this.weight=v+10;//故意加10斤!!  
 }  
}
```
还有一点必须要澄清的是: 幂等性所表达的概念关注的是数学层面的运算和数值, 并没有提及到数值的安全性问题.
比如上面的Person的setAge函数, 有两种case不是幂等性所关心的, 但程序开发却又必须要关心的:
1. 两个线程同时调用
2. 因为age从业务上讲不可能递减, 如果前一次调用设置是30岁, 后一次调用变成了10岁或是更离谱的 -1 岁
所以RESTful设计中将幂等性和安全性是作为两个不同的指标来衡量POST,PUT,GET,DELETE操作的:

重要方法 |  安全? | 幂等 
---------|--------|----------
GET      |  是    |  是
DELETE   |  否    |  是
PUT      |  否    |  是
POST     |  否    |  否

幂等性是系统的接口对外一种承诺(而不是实现), 承诺只要调用接口成功, 外部多次调用对系统的影响是一致的. 声明为幂等的接口会认为外部调用失败是常态, 并且失败之后必然会有重试.
就象cache有cache基本实现范式一样, 幂等也有自己的固定外部调用范式
cache实现范式:
```java
value getValue(key){  
    value = getValueFromCache(key);  
  
    if( value == null ){  
        value = readFromPersistence(key);  
        saveValueIntoCache(key,value);  
    }  
  
    return value;  
}
```
幂等外部调用范式
```java
client.age = 30;
while(一些退出条件){
    try{  
        if(socket.setPersonAge(person,client.age) == FAILED){
            int newAge = socket.getPersonAge();  
            //处理冲突问题: 因为age只可能越来越大,所以将client的age更新为server端更大的age  
            if(newAge>30){ 
              client.age = newAge;  
              break;
            }
        } else {
            //无法进行冲突解决,再次尝试  
        }  
        //} else return;  
    } catch(Exception){  
        //发生网络异常, 再次尝试  
    }
}
```
幂等接口的内部实现需要有对内保护机制, 一般情况是用类似于乐观锁的版本机制.版本重点是体现时间的先后.







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



---
#cache C7缓存
HTTP1.1(RFC2616)详细展开地描述了Cache机制，详见13节
## 解决问题
带宽、网络瓶颈
    服务器带宽
    距离延时
瞬间拥塞

冗余的数据传输，同样的数据被多次传递


## 命中/未命中
新鲜度检测
    GET If-modified-Since
    304 not modified
字节命中率 大文档

文档过期
服务器再验证






---







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






---
# 前沿
## http2
https://www.gitbook.com/book/ye11ow/http2-explained/details









