#Flink
---
#doc
[深入理解Apache Flink核心技术](http://geek.csdn.net/news/detail/56272)

在大数据处理领域，批处理任务与流处理任务一般被认为是两种不同的任务，一个大数据项目一般会被设计为只能处理其中一种任务，例如Apache Storm、Apache Smaza只支持流处理任务，而Aapche MapReduce、Apache Tez、Apache Spark只支持批处理任务。Spark Streaming是Apache Spark之上支持流处理任务的子系统，看似一个特例，实则不然——Spark Streaming采用了一种micro-batch的架构，即把输入的数据流切分成细粒度的batch，并为每一个batch数据提交一个批处理的Spark任务，所以Spark Streaming本质上还是基于Spark批处理系统对流式数据进行处理，和Apache Storm、Apache Smaza等完全流式的数据处理方式完全不同。通过其灵活的执行引擎，Flink能够同时支持批处理任务与流处理任务。


在执行引擎这一层，流处理系统与批处理系统最大不同在于节点间的数据传输方式。
##流处理系统
节点间数据传输的标准模型是：
当一条数据被处理完成后，序列化到缓存中，然后立刻通过网络传输到下一个节点，由下一个节点继续处理。
##批处理系统
其节点间数据传输的标准模型是：
当一条数据被处理完成后，序列化到缓存中，并不会立刻通过网络传输到下一个节点，当缓存写满，就持久化到本地硬盘上，当所有数据都被处理完成后，才开始将处理后的数据通过网络传输到下一个节点。

这两种数据传输模式是两个极端，对应的是流处理系统对低延迟的要求和批处理系统对高吞吐量的要求。

Flink的执行引擎采用了一种十分灵活的方式，同时支持了这两种数据传输模型。
Flink以固定的缓存块为单位进行网络数据传输，用户可以通过缓存块超时值指定缓存块的传输时机。
如果缓存块的超时值为0，则Flink的数据传输方式类似上文所提到流处理系统的标准模型，此时系统可以获得最低的处理延迟。
如果缓存块的超时值为无限大，则Flink的数据传输方式类似上文所提到批处理系统的标准模型，此时系统可以获得最高的吞吐量。
同时缓存块的超时值也可以设置为0到无限大之间的任意值。缓存块的超时阈值越小，则Flink流处理执行引擎的数据处理延迟越低，但吞吐量也会降低，反之亦然。通过调整缓存块的超时阈值，用户可根据需求灵活地权衡系统延迟和吞吐量。


