#性能测试
-----
#docs
[性能测试应该怎么做？](http://coolshell.cn/articles/17381.html)


---
#名词
##QPS Queries Per Second
每秒查询率QPS是对一个特定的查询服务器在规定时间内所处理流量多少的衡量标准。

##TPS Transactions Per Second
事务数/秒
它是软件测试结果的测量单位。一个事务是指一个客户机向服务器发送请求然后服务器 做出反应的过程。客户机在发送请求时开始计时，收到服务器响应后结束计时，以此来计算使用的时间和完成的事务个数，最终利用这些信息来估计得分。客户机使 用加权协函数平均方法来计算客户机的得分，测试软件就是利用客户机的这些信息使用加权协函数平均方法来计算服务器端的整体TPS得分。

QPS（TPS）= 并发数/平均响应时间

无思考时间（T_think），测试所得的TPS值和并发虚拟用户数(U_concurrent)、Loadrunner读取的交易响应时间（T_response）之间有以下关系（稳定运行情况下）：
TPS=U_concurrent / (T_response+T_think)。


##并发数
系统同时处理的request/事务数

##响应时间


##wall clock time
系统时间(wall clock time, elapsed time)
一段程序从运行到终止，系统时钟走过的时间

##monotonic time
单调递增时间







---
#测量
对症下药
不合适的测量
* 在错误的时间启动和停止测量
* 测量的是聚合后的信息，而不是目标活动本身


performance profiling
基于时间分析
    执行耗费
基于等待分析
    资源、阻塞

被掩藏的细节
    突刺数据，通过直方图、百分比、标准差、偏差指数等多个参数来判断

##压测工具
siege & tsung
Siege是一个压力测试和评测工具，设计用于WEB开发这评估应用在压力下的承受能力：可以根据配置对一个WEB站点进行多用户的并发访问，记录每个用户所有请求过程的相应时间，并在一定数量的并发访问下重复进行。

Tsung 是一个压力测试工具，可以测试包括HTTP, WebDAV, PostgreSQL, MySQL, LDAP, and XMPP/Jabber等服务器。针对 HTTP 测试，Tsung 支持 HTTP 1.0/1.1 ，包含一个代理模式的会话记录、支持 GET、POST 和 PUT 以及 DELETE 方法，支持 Cookie 和基本的 WWW 认证，同时还支持 SSL。

参看：十个免费的Web压力测试工具
http://coolshell.cn/articles/2589.html



---
#原因
资源被过度使用，余量已经不足以正常工作
资源没有被正确配置
资源已经损坏或者失灵


----



#循环展开
减少了不直接有助于程序结果的操作数量
减少整个计算关键路径上的操作数量























