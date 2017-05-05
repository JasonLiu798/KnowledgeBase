


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
#分布式session
按ID hash到同一台机器，一致性hash解决机器增减、故障情况


----
#存储系统
##直连式存储DAS
##网络存储NAS SAN
NAS并发访问同一个文件，会导致读写速度大幅下降
##分布式文件系统




