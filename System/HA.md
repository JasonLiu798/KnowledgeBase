#HA
---

1.1避免单点
	* 负载均衡技术
	* 热备
	* 使用多机房
1.2提高应用可用性
    1.2.1尽可能的避免故障
    1.2.2及时发现故障
    	* 报警系统
		* 日志记录和分析系统
	1.2.3访问量和数据量不断上涨的应对策略
		* 水平伸缩
		* 拆分--
			1.应用拆分；2.拆分数据库；拆分表。
        * 读写分离
        * 垂直伸缩
        * 其他

平均无故障时间(MTTF)来度量
计算机系统平均能够正常运行多长时间，才会发生一次故


可维护性用平均维修时间(MTTR)来度量
系统发生故障后维修和重新恢复正常运行平均花费时间。

计算机系统的可用性定义为
MTTF/(MTTF+MTTR)*100%


高可用性的衡量指标
可用性的计算公式：
availability=(Total Elapsed Time－Sum of Inoperative Times)/ Total Elapsed Time 　
elapsed time为operating time+downtime。
Total Elapsed Time 为系统总时间，包括可提供服务时间+停止服务时间。
Sum of Inoperative Times 为停止服务时间，包括宕机时间+维护时间。 　　
可用性和系统组件的失败率相关。衡量系统设备失败率的一个指标是“失败间隔平均时间”MTBF（mean time between failures）。
通常这个指标衡量系统的组件，如磁盘。
	MTBF=Total Operating Time / Total No. of Failures 　　
Operating time为系统在使用的时间（不包含停机情况）。


高可用性系统的设计
系统的可用性，最重要的是满足用户的需求。系统的失败只有当其导致服务的失效性足以影响到系统用户的需求时才会影响其可用性的指标。用户的敏感性决定于系统提供的应用。例如，在一个能在1秒钟之内被修复的失败在一些联机事务处理系统中并不会被感知到，但如果是对于一个实时的科学计算应用系统，则是不可被接受的。
　　系统的高可用性设计决定于您的应用。例如，如果几个小时的计划停机时间是可接受的，也许存储系统就不用设计为磁盘可热插拔的。反之，你可能就应该采用可热插拔、热交换和镜像的磁盘系统。
　　所以涉及高可用系统需要考虑：
　　决定业务中断的持续时间。根据公式计算出的衡量HA的指标，可以得到一段时间内可以中断的时间。但可能很大量的短时间中断是可以忍受的，而少量长时间的中断却是不可忍受的。
　　在统计中表明，造成非计划的宕机因素并非都是硬件问题。硬件问题只占40%，软件问题占30%，人为因素占20%，环境因素占10%。您的高可用性系统应该能尽可能地考虑到上述所有因素。
　　当出现业务中断时，尽快恢复的手段。

导致计划内的停机因素有：
　　周期性的备份
　　软件升级
　　硬件扩充或维修
　　系统配置更改
　　数据更改
导致计划外停机的因素有：
　　硬件失败
　　文件系统满错误
　　内存溢出
　　备份失败
　　磁盘满
　　供电失败
　　网络失败
　　应用失败
　　自然灾害
　　操作或管理失误
　　通过有针对性的设计，可以避免上述全部或部分因素带来的损失。当然，100%的高可用系统是不存在的。
创建高可用性的计算机系统
在UNIX系统上创建高可用性计算机系统，业界的通行做法，也是非常有效的做法，就是采用群集系统（Cluster），将各个主机系统通过网络或其他手段有机地组成一个群体，共同对外提供服务。创建群集系统，通过实现高可用性的软件将冗余的高可用性的硬件组件和软件组件组合起来，消除单点故障：
　　消除供电的单点故障
　　消除磁盘的单点故障
　　消除SPU（System Process Unit）单点故障
　　消除网络单点故障
　　消除软件单点故障
　　尽量消除单系统运行时的单点故障




























