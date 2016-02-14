

spout龙卷
源处读取数据并放入topology
当Storm接收失败时
    可靠的Spout会对tuple（元组，数据项组成的列表）进行重发
    不可靠的Spout不会考虑接收成功与否只发射一次


bolt雷电
Topology中所有的处理都由Bolt完成。
Bolt可以完成任何事，比如：连接的过滤、聚合、访问文件/数据库、等等。
Bolt从Spout中接收数据并进行处理，如果遇到复杂流的处理也可能将tuple发送给另一个Bolt进行处理。而Bolt中最重要的方法是execute（），以新的tuple作为参数接收。
不管是Spout还是Bolt，如果将tuple发射成多个流，这些流都可以通过declareStream（）来声明

#nimbus 雨云
主节点的守护进程，负责为工作节点分发任务。

#topology 拓扑结构
Storm的一个任务单元

#define field(s) 定义域
由spout或bolt提供，被bolt接收

#Stream Groupings
1. 随机分组（Shuffle grouping）：随机分发tuple到Bolt的任务，保证每个任务获得相等数量的tuple。
2. 字段分组（Fields grouping）：根据指定字段分割数据流，并分组。例如，根据“user-id”字段，相同“user-id”的元组总是分发到同一个任务，不同“user-id”的元组可能分发到不同的任务。
3. 全部分组（All grouping）：tuple被复制到bolt的所有任务。这种类型需要谨慎使用。
4. 全局分组（Global grouping）：全部流都分配到bolt的同一个任务。明确地说，是分配给ID最小的那个task。
5. 无分组（None grouping）：你不需要关心流是如何分组。目前，无分组等效于随机分组。但最终，Storm将把无分组的Bolts放到Bolts或Spouts订阅它们的同一线程去执行（如果可能）。
6. 直接分组（Direct grouping）：这是一个特别的分组类型。元组生产者决定tuple由哪个元组处理者任务接收。
当然还可以实现CustomStreamGroupimg接口来定制自己需要的分组。

#临界分析
瞬间临界值监测(instant thershold)：一个字段的值在那个瞬间超过了预设的临界值，如果条件符合的话则触发一个trigger。举个例子当车辆超越80公里每小时，则触发trigger。
时间序列临界监测(time series threshold)：字段的值在一个给定的时间段内超过了预设的临界值，如果条件符合则触发一个触发器。比如：在5分钟类，时速超过80KM两次及以上的车辆。






















