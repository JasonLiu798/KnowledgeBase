# RabbitMQ
---
#theory
[RabbitMQ基础概念详细介绍](http://blog.csdn.net/whycold/article/details/41119807)
[RabbitMQ从入门到精通](http://blog.csdn.net/column/details/rabbitmq.html)
[百度百科](http://baike.baidu.com/link?url=1GP4QquZg-KldH-p-_hxshzDhc4zFuIe9jgu5f17g9ftf0IjKH26FwxARjomqOVcj1KmATXHjTfSlImrSbxoeK)

##场景
AMQP
1.信息的发送者和接收者如何维持这个连接，如果一方的连接中断，这期间的数据如何方式丢失？
2.如何降低发送者和接收者的耦合度？
3.如何让Priority高的接收者先接到数据？
4.如何做到load balance？有效均衡接收者的负载？
5.如何有效的将数据发送到相关的接收者？也就是说将接收者subscribe不同的数据，如何做有效的filter。
6.如何做到可扩展，甚至将这个通信模块发到cluster上？
7.如何保证接收者接收到了完整，正确的数据？


多个消费者可以订阅同一个Queue-平均分摊

##RabbitMQ Server(broker server)
###交换机
routing keys
Direct交换机 完全根据key进行投递的叫做
 
Topic交换机 key进行模式匹配后进行投递的叫做
    符号”#”匹配一个或多个词，符号”*”匹配正好一个词

Fanout交换机
    不需要key的，它采取广播模式，一个消息进来时，投递到与该交换机绑定的所有队列

header
headers类型的Exchange不依赖于routing key与binding key的匹配规则来路由消息，而是根据发送的消息内容中的headers属性进行匹配。

##Message
payload（有效载荷）和label（标签）

Exchanges are where producers publish their messages.
 
Queues are where the messages end up and are received by consumers
Bindings are how the messages get routed from the exchange to particular queues.

##Connection
    RabbitMQ的socket链接，它封装了socket协议相关部分逻辑。
##ConnectionFactory
    为Connection的制造工厂
##Channel
    大部分的业务操作是在Channel这个接口中完成的，包括定义Queue、定义Exchange、绑定Queue与Exchange、发布消息等。



##持久化
（1）exchange持久化，在声明时指定durable => 1
（2）queue持久化，在声明时指定durable => 1
（3）消息持久化，在投递时指定delivery_mode => 2（1是非持久化）
如果exchange和queue都是持久化的，那么它们之间的binding也是持久化的。如果exchange和queue两者之间有一个持久化，一个非持久化，就不允许建立绑定。


##消息确认
[RabbitMQ消息队列（九）：Publisher的消息确认机制](http://blog.csdn.net/anzhsoft/article/details/21603479)




---
#setup
##ubuntu
```bash
apt-get update
apt-get install erlang
apt-get install rabbitmq-server
```
##centos
```
yum install erlang  
yum install rabbitmq-server
/etc/init.d/rabbitmq-server start 
启动:
rabbitmq-server –detached
关闭:
rabbitmqctl stop
```
##其他Linux
```bash
#erlang依赖于ncurses-devel,安装ncurses-devel
yum install ncurses-devel
#erlang依赖于gcc-c++,安装gcc-c++
yum install gcc-c++
#erlang依赖于openssl-devel,安装 openssl-devel
yum install openssl-devel
#erlang依赖于openssl-devel,安装 unixODBC-devel
yum install unixODBC-devel
#安装erlang 
tar -zxvf otp_src_17.0.tar.gz
cd otp_src_17.0
./configure
make
make install
#校验erlang安装成功与否, 退出erlang shell ==> halt().
erl
    Eshell ...
    1>halt().
#安装rabbitmq
#rabbitmq依赖于xmlto,安装xmlto
yum -y install xmlto
#安装rabbitmq
tar -zxvf rabbitmq-server-3.5.0.tar.gz
cd rabbitmq-server-3.5.0
export TARGET_DIR=/usr/local/rabbitmq
export SBIN_DIR=/usr/local/sbin
export MAN_DIR=/usr/local/man
make
make install
#启动RabbitMQ界面管理功能插件,由于此插件默认安装于/etc/rabbitmq,故先新建/etc/rabbitmq目录
mkdir /etc/rabbitmq
rabbitmq-plugins enable rabbitmq_management
```

##集群部署
```
#主机名修改及主机文件配置，三个节点A,B,C分别修改主机名
vi /etc/sysconfig/network
 A节点机器配置为：HOSTNAME=RabbitMQ_Node1
 B节点机器配置为：HOSTNAME=RabbitMQ_Node1
 C节点机器配置为：HOSTNAME=RabbitMQ_Node1
三个节点ABC都修改主机映射文件，将三节点IP映射配置到/etc/hosts文件尾部中。
vi /etc/hosts
 IP_A RabbitMQ_Node1
 IP_B RabbitMQ_Node2 
 IP_C RabbitMQ_Node3
example：     
192.168.137.99 RabbitMQ_Node1
192.168.137.133 RabbitMQ_Node2 
192.168.137.144 RabbitMQ_Node3
 
三个节点都要操作此步骤,处理完后重启网络服务。
service network restart

将A节点中的.erlang.cookie内容覆盖B和C节点.erlang.cookie内容，由于此文件是400的权限，所以先将其权限改为777，之后修改内容后，再改回为400。
.erlang.cookie一般在/var/lib/rabbitmq/.erlang.cookie 或者 $HOME/.erlang.cookie目录下，Centos系统位于$HOME/.erlang.cookie目录下。

节点B和C操作一次如下步骤：
BC节点：
chmod 777 /root/.erlang.cookie
A节点：
scp /root/.erlang.cookie RabbitMQ_Node2:/root
scp /root/.erlang.cookie RabbitMQ_Node3:/root
BC节点：
chmod 400 /root/.erlang.cookie
    
搭建集群环境
A节点
vi /etc/rabbitmq/rabbitmq.config （文件内容如下：）

%% -*- mode: erlang -*-
%% ----------------------------------------------------------------------------
%% RabbitMQ Sample Configuration File.
%%
%% See http://www.rabbitmq.com/configure.html for details.
%% ----------------------------------------------------------------------------
[
 {rabbit,
  [
   {cluster_partition_handling, pause_minority}
  ]}
].

nohup rabbitmq-server --detached > /dev/null 2>&1 &
B节点
scp rabbitmq_node1:/etc/rabbitmq/rabbitmq.config  /etc/rabbitmq/rabbitmq.config 
nohup rabbitmq-server --detached > /dev/null 2>&1 &
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl join_cluster rabbit@RabbitMQ_Node2
rabbitmqctl start_app
C节点         
scp rabbitmq_node1:/etc/rabbitmq/rabbitmq.config  /etc/rabbitmq/rabbitmq.config 
nohup rabbitmq-server --detached > /dev/null 2>&1 &
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl join_cluster --ram  rabbit@RabbitMQ_Node3
rabbitmqctl start_app
        
3.4创建rabbitmq远程管理用户：用户名为 user1 密码为123456，administrator权限。
rabbitmqctl add_user user1 123456     
rabbitmqctl set_user_tags user1 administrator
rabbitmqctl set_permissions -p / user1 ".*" ".*" ".*"

3.5 rabbitmq队列高可用
rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'


移除集群节点 
# rabbitmqctl forget_cluster_node rabbit@rabbitmq_node2
增加集群节点  --ram参数表面此节点为内存节点，默认是硬盘节点
# rabbitmqctl join cluster --ram rabbit@New_Node
后台启动RabbitMQ服务
# nohup rabbitmq-server --detached > /dev/null 2>&1 &
查看RabbitMQ集群状态
# rabbitmqctl cluster_status
将RabbitMQ节点类型变为硬盘节点/内存节点 rabbitmqctl change_cluster_node_type disc/ram
# rabbitmqctl change_cluster_node_type disc
```



##管理
```bash
#插件
rabbitmq-plugins enable rabbitmq_management
[ubuntu]
/usr/lib/rabbitmq/lib/rabbitmq_server-2.7.1/sbin/rabbitmq-plugins enable rabbitmq_management
#重启
service rabbitmq-server restart

http://192.168.145.200:15672
http://192.168.145.200:55672
guest/guest

#启动
rabbitmq-server –detached
#关闭
rabbitmqctl stop
#状态
rabbitmqctl status

service rabbitmq-server restart  
http://127.0.0.1:15672

#virtual_host管理
rabbitmqctl add_vhost  xxx
rabbitmqctl delete_vhost xxx

#用户管理
rabbitmqctl add_user test test
rabbitmqctl delete_user test
rabbitmqctl change_password {username} {newpassword}
rabbitmqctl set_user_tags {username} {tag ...} #Tag可以为 administrator,monitoring, management

#权限管理
set_permissions [-pvhostpath] {user} {conf} {write} {read}
               Vhostpath
               Vhost路径
               user
      用户名
              Conf
      一个正则表达式match哪些配置资源能够被该用户访问。
              Write
      一个正则表达式match哪些配置资源能够被该用户读。
               Read
      一个正则表达式match哪些配置资源能够被该用户访问。

#状态查看
rabbitmqctl list_queues[-p vhostpath] [queueinfoitem ...]
                Queueinfoitem可以为：name，durable，auto_delete，arguments，messages_ready，
                messages_unacknowledged，messages，consumers，memory
       Exchange信息：rabbitmqctllist_exchanges[-p vhostpath] [exchangeinfoitem ...]
                 Exchangeinfoitem有：name，type，durable，auto_delete，internal，arguments.
       Binding信息：rabbitmqctllist_bindings[-p vhostpath] [bindinginfoitem ...]       
                 Bindinginfoitem有：source_name，source_kind，destination_name，destination_kind，routing_key，arguments
       Connection信息：rabbitmqctllist_connections [connectioninfoitem ...]
       Connectioninfoitem有：recv_oct，recv_cnt，send_oct，send_cnt，send_pend等。
       Channel信息：rabbitmqctl  list_channels[channelinfoitem ...]
      Channelinfoitem有consumer_count，messages_unacknowledged，messages_uncommitted，acks_uncommitted，messages_unconfirmed，prefetch_count，client_flow_blocked
```



##erlang
sudo epmd -d -d -d -d -d -d -d -d -d

##epmd
[epmd](http://www.cnblogs.com/me-sa/p/erlang-epmd.html)
epmd 是Erlang Port Mapper Daemon的缩写,全称足够明确表达它的功能了(相比之下,OTP就是一个难以从字面理解的名字);epmd完成Erlang节点和IP,端口的映射关系,
epmd -names



---
#common command
服务器相关命令：
启动
rabbitmq-server start
关闭
rabbitmq-server stop
查看状态
rabbitmqctl status

[example](http://www.rabbitmq.com/getstarted.html)






---
#虚拟主机及用户权限
RabbitMQ提供了虚拟主机功能，不同的虚拟主机之间直接隔离，可通过不同的用户来操作不同的虚拟主机来做业务隔离
```bash
#----------------v1--------------------
#创建用户
rabbitmqctl add_user user1 123456
#将用户赋予management角色权限 开发只能使用management角色权限
rabbitmqctl set_user_tags user1 management
#创建虚拟主机
rabbitmqctl add_vhost /v1
#将/v1 虚拟主机赋予 user1 用户操作权限
rabbitmqctl set_permissions -p /v1 user1 ".*" ".*" ".*" 
 
#-----------------v2--------------------
#创建用户
rabbitmqctl add_user user2 123456
#将用户赋予management角色权限 开发只能使用management角色权限
rabbitmqctl set_user_tags user2 management
#创建虚拟主机
rabbitmqctl add_vhost /v2
#将/v1 虚拟主机赋予 user1 用户操作权限
rabbitmqctl set_permissions -p /v2 user2 ".*" ".*" ".*" 

#处理完之后，每个用户只能看到它对应的虚拟主机的对应的queue,exchange,其他用户的虚拟主机一概不可见。

#创建一个管理员的用户，将全部虚拟主机的权限都分发给它
#创建用户
rabbitmqctl add_user admin 123456
#将用户赋予administrator角色权限 开发只能使用administrator角色权限
rabbitmqctl set_user_tags admin administrator
#将/v1 /v2 虚拟主机赋予 admin 用户操作权限
rabbitmqctl set_permissions -p /v1 admin  ".*" ".*" ".*" 
rabbitmqctl set_permissions -p /v2 admin  ".*" ".*" ".*" 
rabbitmqctl set_permissions -p / admin  ".*" ".*" ".*" 
```





----
#启动脚本
1./etc/init.d/目录下新建rabbitmq-server脚本
2.添加rabbitmq-server脚本内容
/etc/init.d/rabbitmq-server
```bash
#!/bin/sh
#
# rabbitmq-server RabbitMQ broker
#
# chkconfig: - 80 05
# description: Enable AMQP service provided by RabbitMQ
#
### BEGIN INIT INFO
# Provides:          rabbitmq-server
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Description:       RabbitMQ broker
# Short-Description: Enable AMQP service provided by RabbitMQ broker
### END INIT INFO
# Source function library.
. /etc/init.d/functions
export HOME=/root
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin
NAME=rabbitmq-server
#DAEMON=/usr/sbin/${NAME}
#CONTROL=/usr/sbin/rabbitmqctl
DAEMON=/usr/local/sbin/${NAME}
CONTROL=/usr/local/sbin/rabbitmqctl
DESC=rabbitmq-server
USER=root
INIT_LOG_DIR=/var/log/rabbitmq
PID_FILE=/var/run/rabbitmq/pid
START_PROG="daemon"
LOCK_FILE=/var/lock/subsys/$NAME
test -x $DAEMON || exit 0
test -x $CONTROL || exit 0
RETVAL=0
set -e
[ -f /etc/default/${NAME} ] && . /etc/default/${NAME}
ensure_pid_dir () {
    PID_DIR=`dirname ${PID_FILE}`
    if [ ! -d ${PID_DIR} ] ; then
        mkdir -p ${PID_DIR}
        chown -R ${USER}:${USER} ${PID_DIR}
        chmod 755 ${PID_DIR}
    fi
}
remove_pid () {
    rm -f ${PID_FILE}
    rmdir `dirname ${PID_FILE}` || :
}
start_rabbitmq () {
    echo -n "Starting $DESC: "
    status_rabbitmq quiet
    if [ $RETVAL = 0 ] ; then
        echo RabbitMQ is currently running
    else
        RETVAL=0
        ensure_pid_dir
        set +e
        RABBITMQ_PID_FILE=$PID_FILE $START_PROG $DAEMON \
            > "${INIT_LOG_DIR}/startup_log" \
            2> "${INIT_LOG_DIR}/startup_err" \
            0<&- &
        $CONTROL wait $PID_FILE >/dev/null 2>&1
        RETVAL=$?
        set -e
        case "$RETVAL" in
            0)
                echo SUCCESS
                if [ -n "$LOCK_FILE" ] ; then
                    touch $LOCK_FILE
                fi
                ;;
            *)
                remove_pid
                echo FAILED - check ${INIT_LOG_DIR}/startup_\{log, _err\}
                RETVAL=1
                ;;
        esac
    fi
}
stop_rabbitmq () {
    echo -n "Stopping $DESC: "
    status_rabbitmq quiet
    if [ $RETVAL = 0 ] ; then
        set +e
        $CONTROL stop ${PID_FILE} > ${INIT_LOG_DIR}/shutdown_log 2> ${INIT_LOG_DIR}/shutdown_err
        RETVAL=$?
        set -e
        if [ $RETVAL = 0 ] ; then
     echo SUCCESS
            remove_pid
            if [ -n "$LOCK_FILE" ] ; then
                rm -f $LOCK_FILE
            fi
        else
            echo FAILED - check ${INIT_LOG_DIR}/shutdown_log, _err
        fi
    else
        echo RabbitMQ is not running
        RETVAL=0
    fi
}
status_rabbitmq() {
    set +e
    if [ "$1" != "quiet" ] ; then
        $CONTROL status 2>&1
    else
        $CONTROL status > /dev/null 2>&1
    fi
    if [ $? != 0 ] ; then
        RETVAL=3
    fi
    set -e
}
restart_running_rabbitmq () {
    status_rabbitmq quiet
    if [ $RETVAL = 0 ] ; then
        restart_rabbitmq
    else
        echo RabbitMQ is not runnning
        RETVAL=0
    fi
}
restart_rabbitmq() {
    stop_rabbitmq
    start_rabbitmq
}
case "$1" in
    start)
        start_rabbitmq
        ;;
    stop)
        stop_rabbitmq
        ;;
    status)
        status_rabbitmq
        ;;
    restart|reload)
        restart_rabbitmq
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart|reload}" >&2
        RETVAL=1
        ;;
esac
exit $RETVAL

#----------------------------------------------------------------------
#给脚本添加执行权限###
chmod +x /etc/init.d/rabbitmq-server
#启动rabbitmq服务###
service rabbitmq-server start
#查看rabbitmq服务状态###
service rabbitmq-server startus
#停止rabbitmq服务###
service rabbitmq-server stop
##重启rabbitmq服务###
service rabbitmq-server stop
##添加启动服务###
chkconfig --add rabbitmq-server
##添加2345级别开机启动###
chkconfig --level 2345 rabbitmq-server on
```














































