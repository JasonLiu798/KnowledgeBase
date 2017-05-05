#Hadoop
[Hadoop2.6.0中YARN底层状态机实现分析](http://blog.csdn.net/beliefer/article/details/51190842)


----
#deploy
```
10.185.3.238 nameNode
10.185.3.239 secondarynameNode
10.185.3.245 dataNode1
10.185.3.246 dataNode2
```

pssh -h /root/other.txt -l root -i 'service iptables status'
pssh -h /root/zk.txt -l root -i 'zkServer.sh status'
pssh -h /root/zk.txt -l root -i 'cat /opt/hbase/conf/hbase-site.xml'

pssh -h /root/ot.txt -l root -i 'tar -zpxvf /opt/project/lib.tar.gz -C /opt/project/'
pssh -h /root/ot.txt -l root -i 'mkdir -p /home/project'
pssh -h /root/ot.txt -l root -i 'ln -sfv /home/project /opt/project'




## 3 zookeeper
见[zookeeper](../Distribute/Zookeeper.md)


## 1 hadoop 
hadoop fsck / -files -blocks

### chk size
hadoop dfsadmin -report

### file operation
hadoop fs -copyFromLocal localfile hdfs://localhost/xxx

http://zy19982004.iteye.com/blog/2024467



---
# env

#批量拷贝本地文件nrpe.tgz到远端
pscp -h other.txt -l root /home/soft/nrpe.tgz /usr/local/

#批量执行命令
pssh -h other.txt -l root -i 'ls /opt/rpm'
pssh -h other.txt -l root -i 'ls /opt/upload'
pssh -h other.txt -l root -i 'ls /mnt/iso/Packages'

pssh -h other.txt -l root -i hostname
pssh -h other.txt -l root -i 'tar -zpxvf /opt/upload/jdk-7u67-linux-x64.tar.gz -C /home/jdk/'
pssh -h other.txt -l root -i 'mkdir /home/jdk'
pssh -h other.txt -l root -i 'ln -sfv /home/jdk /opt/jdk'
pssh -h other.txt -l root -i 'ln -sfv /opt/jdk/jdk1.7.0_67 /opt/java'
pssh -h /root/all -l root -i 'ln -sfv /opt/share/jdk1.8.0_20 /opt/java'
pssh -h other.txt -l root -i 'java -version'


#ot
pssh -h /root/other.txt -l root -i 'rpm -ivh /mnt/iso/Packages/nc-1.84-22.el6.x86_64.rpm'
pssh -h /root/other.txt -l root -i 'rpm -ivh /mnt/iso/Packages/ftp-0.17-54.el6.x86_64.rpm'
pssh -h /root/other.txt -l root -i 'mkdir -p /home/bin'
pssh -h /root/other.txt -l root -i 'ln -sfv /home/bin /opt/bin'

## sync time
pssh -h /root/other.txt -l root -i 'date -s 21:48:30'
pssh -h /root/all -l root -i 'date -s 21:48:30'

#pssh setuptools setup
pssh -h other.txt -l root -i 'mkdir /home/rpm'
pssh -h other.txt -l root -i 'ln -sfv /home/rpm /opt/rpm'
pscp -h other.txt -l root /opt/rpm/pssh-1.4.3.tar.gz /opt/rpm/
pssh -h other.txt -l root -i 'tar -zpxvf /opt/rpm/pssh-1.4.3.tar.gz -C /opt/rpm'



pssh -h other.txt -l root -i 'python --version'

pssh -h other.txt -l root -i 'wget -P /opt/rpm --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-15.0.tar.gz#md5=2a6b2901b6c265d682139345849cbf03'

pssh -h other.txt -l root -i 'tar -zpxvf /opt/rpm/setuptools-15.0.tar.gz -C /opt/rpm'

pssh -h other.txt -l root -i 'python /opt/rpm/setuptools-15.0/setup.py install'
pssh -h other.txt -l root -i 'python /opt/rpm/pssh-1.4.3/setup.py install'

pscp -h /root/slave -l root remote_operate.sh /root
pscp -h /root/slave -l root batch_sshkey.sh /root

##copy ip.txt
pscp -h other.txt -l root ip.txt /root
pscp -h other.txt -l root other.txt /root
pssh -h other.txt -l root -i '/opt/rpm/batch_sshkey.sh'


#expect setup
pssh -h other.txt -l root -i 'rpm -ivh /mnt/iso/Packages/expect-5.44.1.15-5.el6_4.x86_64.rpm /mnt/iso/Packages/tcl-8.5.7-6.el6.x86_64.rpm /mnt/iso/Packages/tcl-devel-8.5.7-6.el6.x86_64.rpm '

#authorized_keys
pssh -h other.txt -l root -i 'cat /root/.ssh/authorized_keys'
pssh -h other.txt -l root -i 'cat /root/.ssh/id_rsa.pub'
pscp -h other.txt -l root .ssh/authorized_keys /root/.ssh/authorized_keys


#挂盘
pssh -h other.txt -l root -i 'mkdir /mnt/iso'
pssh -h /root/other.txt -l root -i 'mount -o loop /opt/upload/rhel-server-6.5-x86_64.iso /mnt/iso'

#关防火墙
pssh -h other.txt -l root -i 'service iptables stop'
pssh -h other.txt -l root -i 'chkconfig iptables off'


---
##src download & setup

wget -P /opt/rpm http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-2.7.0/hadoop-2.7.0.tar.gz
pscp -h other.txt -l root /opt/rpm/hadoop-2.6.0.tar.gz /opt/rpm
pssh -h other.txt -l root -i 'tar -zpxvf /opt/rpm/hadoop-2.6.0.tar.gz -C /opt/rpm'

pssh -h other.txt -l root -i 'ln -sfv /opt/rpm/hadoop-2.6.0 /opt/hadoop'

pssh -h other.txt -l root -i 'rm -f /opt/hadoop'


##zookeeper



---
#hadoop

## oper
### 启动 
start-dfs.sh
[1] 12:49:02 [SUCCESS] 10.185.3.239 22
1282 SecondaryNameNode
[2] 12:49:02 [SUCCESS] 10.185.3.245 22
6795 NodeManager
6696 DataNode
[3] 12:49:03 [SUCCESS] 10.185.3.246 22
5617 DataNode
5716 NodeManager
[4] 12:49:03 [SUCCESS] 10.185.3.238 22
23500 ResourceManager
23243 NameNode

### format namenode
hdfs namenode -format
### init
pssh -h /root/other.txt -l root -i 'rm -rf /opt/hadoop/dfs/* /opt/hadoop/tmp/* '
pssh -h /root/other.txt -l root -i 'rm -rf /opt/hadoop/dfs/* /opt/hadoop/tmp/* '

---
#conf
##hadoop env 
Hadoop 2.6.0分布式部署参考手册 http://blog.csdn.net/zhu_xun/article/details/42077311

##配置双向ssh无密码登录
### ip.txt
10.185.3.224:hyxt2015
10.185.3.238:hyxt2015
10.185.3.239:hyxt2015
10.185.3.245:hyxt2015
10.185.3.246:hyxt2015

192.168.1.200 namenode
192.168.1.201 secnamenode
192.168.1.202 datanode1
192.168.1.203 datanode2
192.168.1.204 datanode3

### other.txt
10.185.3.224
10.185.3.238
10.185.3.239
10.185.3.245
10.185.3.246

##硬件情况检查
###disk status
10.185.3.238 200G
10.185.3.239 200G 
10.185.3.245 200G
10.185.3.246 100G
###hosts
/etc/hosts
10.185.3.238 nameNode  hmaster2 ResourceManager
10.185.3.239 secondarynameNode hmaster manage manage.cloud.com ganglia
10.185.3.245 dataNode1 nodeManager01 regionServer1 
10.185.3.246 dataNode2 nodeManager02 regionServer2
pscp -h /root/slave -l root /etc/hosts /etc
pssh -h other.txt -l root -i 'cat /etc/hosts'
cp -r /opt/hadoop/etc/hadoop /etc/
### .bashrc
HDP=/opt/hadoop
HADOOP_HOME=$HDP
HADOOP_PREFIX=$HDP
### xml
doc http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
csdn http://blog.csdn.net/zhu_xun/article/details/42077311
./etc/hadoop/core-site.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--Configurations for NameNode(SecondaryNameNode)、DataNode、NodeManager:-->
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://NameNode:9000</value>
    <description>NameNode URI</description>
  </property>
</configuration>
```
./etc/hadoop/hdfs-site.xml
    dfs.namenode.name.dir
    dfs.datanode.data.dir
mapred-site.xml
yarn-site.xml 

hadoop-env.sh
yarn-env.sh
增加 export JAVA_HOME=/opt/java

hadoop dfsadmin -report

### 分发配置文件
pscp -h /root/other.txt -l root /etc/hosts /etc
pscp -h /root/other.txt -l root /root/.bashrc /root
pscp -h /root/other.txt -l root /etc/profile /etc
pscp -h /root/other.txt -l root /etc/hcfg.tar.gz /etc

pscp -h /root/other.txt -l root /etc/hadoop/slaves /etc/hadoop
pssh -h /root/other.txt -l root -i 'rm -rf /opt/hadoop/etc'


pscp -h /root/other.txt -l root /etc/hcfg.tar.gz /etc
pssh -h /root/other.txt -l root -i 'tar -zpxvf /etc/hcfg.tar.gz -C /etc'

pssh -h /root/other.txt -l root -i 'cat /etc/hadoop/hdfs-site.xml'


pssh -h other.txt -l root -i 'ls -l /opt'

pssh -h other.txt -l root -i 'mkdir -p /opt/hadoop/tmp'
pssh -h other.txt -l root -i 'mkdir -p /opt/hadoop/dfs/name'
pssh -h other.txt -l root -i 'mkdir -p /opt/hadoop/dfs/data'

pssh -h other.txt -l root -i 'java -version'
pssh -h other.txt -l root -i 'jps'
 

15/05/12 09:58:57 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable

dfs.namenode.servicerpc-address or dfs.namenode.rpc-address is not configured.

改主机名
/etc/sysconfig/network





### sec namenode
csdn 分开部署namenode http://blog.csdn.net/xichenguan/article/details/27213089
工作机制 http://blog.csdn.net/skywalker_only/article/details/39120455
pscp -h /root/other.txt -l root /etc/hadoop/slaves /etc/hadoop
pscp -h /root/other.txt -l root /etc/hadoop/masters /etc/hadoop
pssh -h /root/other.txt -l root -i 'cat /etc/hadoop/slaves'

pscp -h /root/other.txt -l root /etc/hadoop/hdfs-site.xml /etc/hadoop
pscp -h /root/other.txt -l root /etc/hadoop/core-site.xml /etc/hadoop


    <property>
        <name>fs.checkpoint.period</name>
        <value>3600</value>
    </property>
    <property>
        <name>fs.checkpoint.size</name>
        <value>67108864</value>
    </property>




---
#zookeeper 
## conf
pssh -h /root/other.txt -l root -i 'mkdir -p /opt/zookeeper/zookeeperdir/data'
pssh -h /root/other.txt -l root -i 'mkdir -p /opt/zookeeper/zookeeperdir/logs'
pscp -h /root/other.txt -l root /opt/zookeeper/conf/zoo.cfg /opt/zookeeper/conf
pscp -h /root/slave -l root /opt/zookeeper/conf/zoo.cfg /opt/zookeeper/conf
pscp -h /root/other.txt -l root /root/.bashrc /root
/opt/zookeeper/conf/zoo.cfg








