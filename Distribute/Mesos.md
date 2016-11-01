#Mesos
---
#doc
[董的博客](http://dongxicheng.org/tag/mesos/)
[mesos优缺点有哪些](https://www.zhihu.com/question/20043233)




##历史
先八卦一下Mesos的历史，其实Mesos并不是为Docker而生的，它产生的初衷是为spark做集群管理。而且，Mesos有自己的容器隔离，后来，随着Docker的崛起，Mesos就开始支持Docker容器了。再后来，google一哥们儿发了篇paper，对比google内部的borg(Omega?)，Mesos和Yarn（是不是Yarn）三个集群管理工具的性能，大致结论就是Mesos跟google内部的集群管理工具有异曲同工之妙。有了Docker助力，再加上google的paper，大家就开始去尝试Mesos了。据我在网上搜罗的消息，国外的twitter，apple（用Mesos管理siri的集群），uber（uber的开发在Mesos的mail-list说他们已经使用Mesos有一段时间了，同时准备把更多的东西迁到Mesos集群上），国内的爱奇艺（视频转码），数人科技（敝公司）都已经或正在使用Mesos集群。

##优点
资源管理策略Dominant Resource Fairness(DRF), 这是Mesos的核心，也是我们把Mesos比作分布式系统Kernel的根本原因。通俗讲，Mesos能够保证集群内的所有用户有平等的机会使用集群内的资源，这里的资源包括CPU，内存，磁盘等等。很多人拿Mesos跟k8s相比，我对k8s了解不深，但是，我认为这两者侧重点不同不能做比较，k8s只是负责容器编排而不是集群资源管理。不能因为都可以管理docker，我们就把它们混为一谈。
轻量级。相对于 Yarn，Mesos 只负责offer资源给framework，不负责调度资源。这样，理论上，我们可以让各种东西使用Mesos集群资源，而不像yarn只拘泥于hadoop，我们需要做的是开发调度器（mesos framework）。
提高分布式集群的资源利用率：这是一个 generic 的优点。从某些方面来说，所有的集群管理工具都是为了提高资源利用率。VM的出现，催生了IaaS；容器的出现，催生了k8s, Mesos等等。简单讲，同样多的资源，我们利用IaaS把它们拆成VM 与 利用k8s/Mesos把它们拆成容器，显然后者的资源利用率更高。(这里我没有讨论安全的问题，我们假设内部子网环境不需要考虑这个。)
##缺点
门槛太高。只部署一套Mesos，你啥都干不了，为了使用它，你需要不同的mesos framework，像Marathon，chronos，spark等等。或者自己写framework来调度Mesos给的资源，这让大家望而却步。
目前对stateful service的支持不够。Mesos集群目前无法进行数据持久化。即将发布的0.23版本增加了persistent resource和dynamic reserver，数据持久化问题将得到改善。
脏活累活不会少。Team在使用Mesos前期很乐观，认为搞定了Mesos，我们的运维同学能轻松很多。然而，根本不是那么回事儿，集群节点的优化，磁盘，网络的设置，等等这些，Mesos是不会帮你干的。使用初期，运维的工作量不仅没有减轻，反而更重了。
Mesos项目还在紧锣密鼓的开发中，很多功能还不完善。譬如，集群资源抢占还不支持。



