#Spark
---
#
[与 Hadoop 对比，如何看待 Spark 技术？](http://www.zhihu.com/question/26568496)


[深入浅出Spark（一）什么是Spark](https://zhuanlan.zhihu.com/p/20752673?refer=bittiger)

---
#spark
##BDAS
Spark Streaming[流式计算] SparkSQL[] GraphX[图计算引擎] MLlib[机器学习库]
spark[计算引擎]
tachypon[分布式内存邮件系统]    hdfs[存储层]
mesos[资源管理]


##spark组成
###ClusterManager
standalone模式中为Master，监控整个集群，监控Worker；YARN模式中为资源管理器
###Worker
负责控制计算节点，启动Executor和Driver；YARN模式为NodeManager，计算节点控制
###Driver
运行Application得Main函数，创建SparkContext
###Excutor
某个Application运行在worker node上得一个进程，启动线程池运行任务，每个Application有独立一组executors

spark context:控制应用生命周期
RDD:基本计算单元，有向无环图RDD Graph
DAG Scheduler
TaskScheduler
SparkEnv：线程级别上下文



旧有
重复开发
系统组合
专有系统适用范围局限
资源分配管理

优势：
多计算范式
处理速度
易用性 多语言支持
兼容性 与hdfs兼容
社区活跃度高

##程序示例
输入构造RDD
转换Transformation
输出Action

##弹性分布式数据集RDD
partition(a list of partitions)
compute(function fro computing each split)
dependencies(a list of dependencies on other RDDs)
partitioner
preferredLocation 

##RDD两类基础函数
1)Transformations
延迟计算
map
filter
reduseByKey
2)Actions
触发spark提交作业(Job)，数据输出到系统
redusce(func)
collect
count
first
take

##开发
intellij
SBT插件 Scala插件


