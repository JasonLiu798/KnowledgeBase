
[日志：每个软件工程师都应该知道的有关实时数据的统一抽象](https://github.com/oldratlee/translations/tree/master/log-what-every-software-engineer-should-know-about-real-time-datas-unifying)

#分类
##应用日志记录

##数据日志（data logs）
用于程序的访问


更改动作的排序和数据的分发

##状态机复制原理（State Machine Replication Principle）：
如果两个相同的、确定性的进程从同一状态开始，并且以相同的顺序获得相同的输入，那么这两个进程将会生成相同的输出，并且结束在相同的状态。

确定性（deterministic）
意味着处理过程是与时间无关的，而且不让任何其他『带外数据（out of band）』的输入影响处理结果。

进程状态
是进程保存在机器上的任何数据，在进程处理结束的时候，这些数据要么保存在内存里，要么保存在磁盘上。



物理日志（physical logging）
物理日志是指记录每一行被改变的内容
逻辑日志（logical logging）
逻辑日志记录的不是改变的行而是那些引起行的内容改变的SQL语句（insert、update和delete语句）


『状态机器模型』常常被称为
主-主模型（active-active model）， 记录输入请求的日志，各个复本处理每个请求。 

主备模型（primary-backup model），即选出一个副本做为leader，让leader按请求到达的顺序处理请求，并输出它请求处理的状态变化日志。 其他的副本按照顺序应用leader的状态变化日志，保持和leader同步，并能够在leader失败的时候接替它成为leader。


变更日志（changelog）101：表与事件的二象性（duality）

日志可以看作是表每个历史状态的一系列备份


#数据集成
是指 使一个组织的所有数据 对 这个组织的所有的服务和系统 可用。


可伸缩日志系统
日志分片
通过批量读出和写入来优化吞吐量
规避无用的数据拷贝



有状态的实时流处理
1状态保存在内存中
2存储所有的状态到远程的存储系统，通过网络与这些存储关联起来

流处理器可以把它的状态保存在本地的『表』或『索引』中 —— bdb、leveldb 甚至是些更不常见的组件，如Lucene 或fastbit索引。 这样一些存储的内容可以从它的输入流生成（可能做过了各种转换后的输入流）。 通过记录关于本地索引的变更日志，在发生崩溃、重启时也可以恢复它的状态。 这是个通用的机制，用于保持 任意索引类型的分片之间相互协作（co-partitioned）的本地状态 与 输入流数据 一致。










