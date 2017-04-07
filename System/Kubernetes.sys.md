#Kubernetes
---
#docs
[Kubernetes初探：原理及实践应用](http://www.csdn.net/article/2014-10-31/2822393)
[github](https://github.com/kubernetes/kubernetes)

---
#concepts
##操作对象
##Cluster
A cluster is a set of physical or virtual machines and other infrastructure resources used by Kubernetes to run your applications. Kubernetes can run anywhere!

##Node
A node is a physical or virtual machine running Kubernetes, onto which pods can be scheduled.

##Pod
容器集合，部署调度基本单元
Pods are a colocated group of application containers with shared volumes. They're the smallest deployable units that can be created, scheduled, and managed with Kubernetes. Pods can be created individually, but it's recommended that you use a replication controller even if creating a single pod.
##Service
pod访问代理抽象，负载均衡
Services provide a single, stable name and address for a set of pods. They act as basic load balancers.
##Replication controller
pod的复制抽象
Replication controllers manage the lifecycle of pods. They ensure that a specified number of pods are running at any given time, by creating or killing pods as required.

##Label
service和replicationController通过label来与pod关联的
Labels are used to organize and select groups of objects based on key:value pairs.

##功能组件
master
    apiserver
        系统的入口，封装了核心对象的增删改查操作，以RESTFul接口方式提供给外部客户和内部组件调用。它维护的REST对象将持久化到etcd（一个分布式强一致性的key/value存储）
    scheduler
        集群的资源调度，为新建的pod分配机器。这部分工作分出来变成一个组件，意味着可以很方便地替换成其他的调度器。
    controller-manager
        endpoint-controller
            定期关联service和pod(关联信息由endpoint对象维护)，保证service到pod的映射总是最新的。
        replication-controller
            定期关联replicationController和pod，保证replicationController定义的复制数量与实际运行pod的数量总是一致的。
slave
    kubelet
        负责管控docker容器，如启动/停止、监控运行状态等。它会定期从etcd获取分配到本机的pod，并根据pod信息启动或停止相应的容器。同时，它也会接收apiserver的HTTP请求，汇报pod的运行状态
    proxy
        负责为pod提供代理。它会定期从etcd获取所有的service，并根据service信息创建代理。当某个客户pod要访问其他pod时，访问请求会经过本机proxy做转发。

##功能特性
资源调度-scheduler
部署启动-kubelet
运行监控-kubelet
服务发现-proxy
错误处理-controller-manager
扩容缩容-controller-manager


---
#使用示例
单机示例(所有组件运行在一台机器上)，旨在打通基本流程
##环境搭建
第一步，我们需要Kuberntes各组件的二进制可执行文件。有以下两种方式获取： 
下载源代码自己编译：
git clone https://github.com/GoogleCloudPlatform/kubernetes.git  
cd kubernetes/build  
./release.sh  
直接下载人家已经编译打包好的tar文件：
wget https://storage.googleapis.com/kubernetes/binaries.tar.gz
自己编译源码需要先安装好golang，编译完之后在kubernetes/_output/release-tars文件夹下可以得到打包文件。直接下载的方式不需要安装其他软件，但可能得不到最新的版本。

第二步，我们还需要etcd的二进制可执行文件，通过如下方式获取：
wget https://github.com/coreos/etcd/releases/download/v0.4.6/etcd-v0.4.6-linux-amd64.tar.gz 
tar xvf etcd-v0.4.6-linux-amd64.tar.gz  
第三步，就可以启动各个组件了：
etcd
```
cd etcd-v0.4.6-linux-amd64  
./etcd  
```
apiserver
```
./apiserver \  
-address=127.0.0.1 \  
-port=8080 \  
-portal_net="172.0.0.0/16" \  
-etcd_servers=http://127.0.0.1:4001 \  
-machines=127.0.0.1 \  
-v=3 \  
-logtostderr=false \  
-log_dir=./log  
```
scheduler
```
./scheduler -master 127.0.0.1:8080 \  
-v=3 \  
-logtostderr=false \  
-log_dir=./log  
```
controller-manager
```
./controller-manager -master 127.0.0.1:8080 \  
-v=3 \  
-logtostderr=false \  
-log_dir=./log  
```
kubelet
```
./kubelet \  
-address=127.0.0.1 \  
-port=10250 \  
-hostname_override=127.0.0.1 \  
-etcd_servers=http://127.0.0.1:4001 \  
-v=3 \  
-logtostderr=false \  
-log_dir=./log  
```
创建pod
搭好了运行环境后，就可以提交pod了。首先编写pod描述文件，保存为redis.json：
```javascript
{  
  "id": "redis",  
  "desiredState": {  
    "manifest": {  
      "version": "v1beta1",  
      "id": "redis",  
      "containers": [{  
        "name": "redis",  
        "image": "dockerfile/redis",  
        "imagePullPolicy": "PullIfNotPresent",  
        "ports": [{  
          "containerPort": 6379,  
          "hostPort": 6379  
        }]  
      }]  
    }  
  },  
  "labels": {  
    "name": "redis"  
  }  
}
```
然后，通过命令行工具kubecfg提交：
./kubecfg -c redis.json create /pods
提交完后，通过kubecfg查看pod状态：
```
>./kubecfg list /pods  
ID                  Image(s)            Host                Labels              Status  
----------          ----------          ----------          ----------          ----------  
redis               dockerfile/redis    127.0.0.1/          name=redis          Running    
```
Status是Running表示pod已经在容器里运行起来了，可以用"docker ps"命令来查看容器信息：
```
# docker ps  
CONTAINER ID        IMAGE                     COMMAND                CREATED             STATUS              PORTS                    NAMES  
ae83d1e4b1ec        dockerfile/redis:latest   "redis-server /etc/r   19 seconds ago      Up 19 seconds                                k8s_redis.caa18858_redis.default.etcd_1414684622_1b43fe35  
```
创建replicationController
```
{  
    "id": "redisController",  
    "apiVersion": "v1beta1",  
    "kind": "ReplicationController",  
    "desiredState": {  
      "replicas": 1,  
      "replicaSelector": {"name": "redis"},  
      "podTemplate": {  
        "desiredState": {  
           "manifest": {  
             "version": "v1beta1",  
             "id": "redisController",  
             "containers": [{  
               "name": "redis",  
               "image": "dockerfile/redis",  
               "imagePullPolicy": "PullIfNotPresent",  
               "ports": [{  
                   "containerPort": 6379,  
                   "hostPort": 6379  
               }]  
             }]  
           }  
         },  
         "labels": {"name": "redis"}  
        }},  
    "labels": {"name": "redis"}  
  }  
```
然后，通过命令行工具kubecfg提交：
```
./kubecfg -c redisController.json create /replicationControllers 
```
提交完后，通过kubecfg查看replicationController状态：
```
# ./kubecfg list /replicationControllers  
ID                  Image(s)            Selector            Replicas  
----------          ----------          ----------          ----------  
redisController     dockerfile/redis    name=redis          1 
```
同时，1个pod也将被自动创建出来，即使我们故意删除该pod，replicationController也将保证创建1个新pod。 












