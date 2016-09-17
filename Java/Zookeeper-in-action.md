








---
#shell
##zkclient
```bash
zkServer.sh status
zkCli.sh -server 192.168.143.4:2181
ls /
get /zk
set /zk "zsl"
delete /zk
```



[zookeeper日志清理，转换](http://w.gdu.me/wiki/Cloud/zookeeper_log_snapshot.)html
zklog2txt /opt/zookeeper/zookeeperdir/logs/version-2/log.300000001 /opt/zookeeper|more

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




---
#command
[zookeeper的部署和使用](http://wangwei.cao.blog.163.com/blog/static/102362526201022414553362/)
pssh -h /root/all -l root -i 'zkServer.sh start'
pssh -h /root/zk.txt -l root -i 'zkServer.sh stop'
pssh -h /root/zk.txt -l root -i 'zkServer.sh status'

##查看状况
１、ruok - The server will respond with imok if it is running. Otherwise it will not respond at all.
２、kill - When issued from the local machine, the server will shut down.
３、dump - Lists the outstanding sessions and ephemeral nodes. This only works on the leader.
４、stat - Lists statistics about performance and connected clients.
例如：
$echo ruok | nc 172.19.1.222 2181
Imok$





---

#Q
##临时节点不消失
如果客户端与服务器的时间相差比较大，客户端退出后，创建的临时节点不会自动删除

##监听事件不起效
zk未启动，程序先启动，虽然能自动重连，但之前创建的节点和监听事件不会起效


