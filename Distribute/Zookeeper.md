#Zookeeper
---


















#安装
wget -P /opt/rpm http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz &
pscp -h other.txt -l root /opt/rpm/zookeeper-3.4.6.tar.gz /opt/rpm
pssh -h other.txt -l root -i 'tar -zpxvf /opt/rpm/zookeeper-3.4.6.tar.gz -C /opt/rpm'
pssh -h other.txt -l root -i 'ln -sfv /opt/rpm/zookeeper-3.4.6 /opt/zookeeper'
pssh -h /root/all -l root -i 'ln -sfv /opt/tools/zookeeper-3.3.6 /opt/zookeeper'
pssh -h other.txt -l root -i 'ls -l /opt/rpm'
pssh -h other.txt -l root -i 'df -h'
myid

#运维i










---
#运维
##启动、关闭
```
zkServer.sh start
zkServer.sh stop
zkServer.sh status

pssh -h /root/zk.txt -l root -i 'zkServer.sh start'
pssh -h /root/zk.txt -l root -i 'zkServer.sh stop'
pssh -h /root/zk.txt -l root -i 'zkServer.sh status'
```

[zookeeper日志清理，转换](http://w.gdu.me/wiki/Cloud/zookeeper_log_snapshot.)html
zklog2txt /opt/zookeeper/zookeeperdir/logs/version-2/log.300000001 /opt/zookeeper|more

```
#!/bin/sh
# scriptname: zkLog2txt
# zookeeper事务日志为二进制格式，使用LogFormatter方法转换为可阅读的日志
if [ -z "$1" -o "$1" = "-h" ];then
    echo "Useage: $0 <LogFile> [zkDir]"
    echo "eg:
$0 /opt/zpdata/version-2/log.3000002c7 /opt/Timasync/zookeeper \\
|grep '^7/24/13'|grep -A 10 -B 10 GAEI_AF_NotifyServer|more"
    exit 0
fi
#LogFile=/dfs/zpdata/version-2/log.100000001
LogFile=$1
zkDir=$2
[ -z "$zkDir" ] && zkDir=/opt/zookeeper
[ ! -f "$LogFile" ] && echo "LogFile:$LogFile not exist!" && exit 1
[ ! -d "$zkDir" ] && echo "zkDir:$zkDir not exist!" && exit 1
[ ! -d "$zkDir/lib" ] && echo "zkDir:$zkDir/lib not exist!" && exit 1
#java -cp $zkDir/zookeeper.jar:$zkDir/lib/slf4j-api-1.6.1.jar:$zkDir/lib/slf4j-log4j12-1.6.1.jar:$zkDir/lib/log4j-1.2.15.jar \
#org.apache.zookeeper.server.LogFormatter "$LogFile"
JAVA_OPTS="$JAVA_OPTS -Djava.ext.dirs=$zkDir:$zkDir/lib"
java $JAVA_OPTS org.apache.zookeeper.server.LogFormatter "$LogFile"
```


































