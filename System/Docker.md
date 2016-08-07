
[深入分析Docker镜像原理](http://www.csdn.net/article/2015-08-21/2825511)
[镜像存储结构](http://www.open-open.com/lib/view/open1414222312419.html)

docker history registry.aliyuncs.com/yueber/nginx-php
镜像文件内容 /var/lib/docker/aufs/diff/
json 文件的存储路径为 /var/lib/docker/graph

docker pull mongo
docker run --name some-mongo -d mongo
https://dev.aliyun.com/detail.html?spm=5176.1971733.2.10.h9vQJm&repoId=1237

https://dev.aliyun.com/detail.html?spm=5176.1971733.2.16.h9vQJm&repoId=1256
docker pull rabbitmq


#toolkit
docker pull registry.aliyuncs.com/alicloudhpc/toolkit

#docker-machine
docker-machine create --driver "virtualbox" --virtualbox-cpu-count "-1" --virtualbox-disk-size "30000" --virtualbox-memory "2560" --virtualbox-hostonly-cidr "192.168.59.3/24" dev.aliyun.com

固定IP
https://github.com/docker/machine/issues/1709
docker-machine create --driver virtualbox --virtualbox-hostonly-cidr "192.168.59.3/24" dev

$ VBoxManage dhcpserver modify --ifname vboxnet0 --disable
$ VBoxManage dhcpserver modify --ifname vboxnet0 --ip 192.168.59.3 --netmask 255.255.255.0 --lowerip 192.168.59.103 --upperip 192.168.59.203
$ VBoxManage dhcpserver modify --ifname vboxnet0 --enable

echo "ifconfig eth1 192.168.99.150 netmask 255.255.255.0 broadcast 192.168.99.255 up" | docker-machine ssh default sudo tee /var/lib/boot2docker/bootsync.sh > /dev/null

.bashrc
[root.83a72d87d4a8]  vi .bashrc
# .bashrc

IP=`ifconfig|grep eth0 -A 4|grep Bcast|awk '{print $2}'|awk -F: '{print $2}'`
PS1='\[\033]0;$IP\007\]
\[\033[33m\][\D{%Y-%m-%d %H:%M.%S}]\[\033[0m\]  \[\033[33m\]\w\[\033[0m\]
\[\033[33m\][\u.\h]\[\033[0m\]  '

---
#docker
eval "$(docker-machine env default)"
eval "$(docker-machine env dev)"

##iso
docker pull registry.cn-hangzhou.aliyuncs.com/mzdeveloper/hadoop_master
docker pull registry.aliyuncs.com/yueber/nginx-php

docker pull registry.aliyuncs.com/gdk/zookeeper
docker run -d -p 2022:22 -p 2181:2181 -v /mnt/share:/mnt/share registry.aliyuncs.com/gdk/zookeeper


##初次启动
端口，映射卷启动后都不能修改
docker run -h="nginx-php" --name nginx-php -d -p 51000:22 -p 51001:80 -v /mnt/share:/usr/share/nginx/html registry.aliyuncs.com/yueber/nginx-php

docker run -h="hadoop" --name hadoop -d registry.cn-hangzhou.aliyuncs.com/3gbug/hadoop

##停止
docker stop [name/id]
##再次启动
docker start hadoop -p 50022:22 -p 50080:80 -p 59000:9000 -p 52181:2181

docker run -d -h="nginx-php" --name nginx-php -p 51000:22 -p 51001:80 -v /mnt/share:/usr/share/nginx/html registry.aliyuncs.com/yueber/nginx-php


##docker ssh
docker exec -it nginx-php bash
docker exec -it hadoop bash
docker exec -it determined_wright bash
docker exec -it gigantic_perlman bash

##删除container
docker rm [container id]








