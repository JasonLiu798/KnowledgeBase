


#分布式文件系统
##NFS

##AFS
ptserver 用户和鉴权
vlserver 卷位置记录和查询
fileserver 处理位于AFS卷内的文件和目录

##PVFS
linux开源并行虚拟文件系统
管理节点：元数据服务器，负责文件元数据信息
IO节点：负责分布式文件系统中数据存储和检索
计算节点：处理应用访问，通过专有libpvfs接口库，从底层访问PVFS服务器

##Lustre
专门针对高性能计算机的基于对象存储的分布式文件系统

##gluster fs

##GoogleFS
硬件可以不可靠
文件变化少，追加方式

##HDFS

##ceph
新一代复合型分布式文件系统
支持三种接口：
Object：原生API，兼容Swift 和S3 API
Block：支持精简配置、快照、克隆
File:Posix接口，支持快照

##互联网领域小文件系统
mogileFS 影响最大
FastDFS 穷人解决方案
TFS 淘宝HDFS copy版本
GridFS 用mongodb存储文件的新系统


