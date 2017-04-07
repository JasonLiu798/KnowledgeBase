#trace 分布式跟踪
----
#doc
[Dapper，大规模分布式系统的跟踪系统](http://bigbully.github.io/Dapper-translation/)

故障位置
性能优化

[对监控系统的一些思考](http://geek.csdn.net/news/detail/126337)


---
#dapper
##设计目标
1.低消耗：跟踪系统对在线服务的影响应该做到足够小。在一些高度优化过的服务，即使一点点损耗也会很容易察觉到，而且有可能迫使在线服务的部署团队不得不将跟踪系统关停。
2.应用级的透明：对于应用的程序员来说，是不需要知道有跟踪系统这回事的。如果一个跟踪系统想生效，就必须需要依赖应用的开发者主动配合，那么这个跟踪系统也太脆弱了，往往由于跟踪系统在应用中植入代码的bug或疏忽导致应用出问题，这样才是无法满足对跟踪系统“无所不在的部署”这个需求。面对当下想Google这样的快节奏的开发环境来说，尤其重要。
3.延展性：Google至少在未来几年的服务和集群的规模，监控系统都应该能完全把控住。

采样率
安全
负载影响
异常监控





---
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
