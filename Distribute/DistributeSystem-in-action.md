


---
#硬件技术
UHPC
##NUMA
SMP加锁访问共享变量，多CPU访问同一个内存
NUMA内存和核心捆绑，本地内存不用加锁访问

##RDMA
协议SDP direct socket protocol
infiniBand







---
#trace 分布式跟踪
[Dapper，大规模分布式系统的跟踪系统](http://bigbully.github.io/Dapper-translation/)

##watchman
[微博平台的链路追踪及服务质量保障系统——Watchman系统](http://www.infoq.com/cn/articles/weibo-watchman)
[微博平台的链路追踪及服务质量保障系统——Watchman系统](http://blog.csdn.net/alex19881006/article/details/24382393)
###设计目标
* 低侵入性（non-invasivenss）：作为非业务组件，应当尽可能少侵入或者不侵入其他业务系统，保持对使用方的透明性，可以大大减少开发人员的负担和接入门槛。
* 灵活的应用策略（application-policy）：可以决定所收集数据的范围和粒度。
* 时效性（time-efficient）：从数据的收集和产生，到数据计算/处理，再到展现或反馈控制，都要求尽可能得快速。
* 决策支持（decision-support）：这些数据数据是否能在决策支持层面发挥作用，特别是从DevOps的角度。

###实现
#### 埋点
watchman-runtime组件利用字节码增强的方式在载入期织入增强逻辑（load-time weaving），为了跨进程/线程传递请求上下文，对于跨线程watchman-enhance组件通过javaagent的方式在应用启动并载入class时修改了JDK自身的几种线程池（ThreadPool或几类Executor）实现，在客户代码提交（execute或submit）时对传入的runnable/callable对象包上具有追踪能力的实现（proxy-pattern），并且从父线程上去继承或初始化请求上下文（request-context）；

普通Java调用的处理方式（埋点/追踪）则是通过AspectJ的静态织入
阀门策略，

[twitter zipkin](https://twitter.github.io/zipkin/)
[hydra](https://github.com/odenny/hydra)

[鹰眼下的淘宝 - 阿里技术沙龙](http://wenku.baidu.com/link?url=xsorjRmT7vuIedegixzLF5uC4q5KooXqC-ePnPRKm1eunUDfnjU3vDlPkZqWgHbSCUJUIUivM8FnVCsMZcde0xTxCUu9t0DVFhDKLJdBQye###)


[dubbo开发 ](http://dubbo.io/Developer+Guide-zh.htm#DeveloperGuide-zh-%E8%B0%83%E7%94%A8%E6%8B%A6%E6%88%AA%E6%89%A9%E5%B1%95)


---
#分布式session
按ID hash到同一台机器，一致性hash解决机器增减、故障情况


----
#存储系统
##直连式存储DAS
##网络存储NAS SAN
NAS并发访问同一个文件，会导致读写速度大幅下降
##分布式文件系统




