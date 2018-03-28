192.168.99.150

rpc error: code = 2 desc = oci runtime error: exec failed: no such file or d

docker is configured to use the default machine with IP 192.168.99.100
For help getting started, check out the docs at https://docs.docker.com

docker-machine ls
docker-machine env default

docker-machine ip default

export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.102:2376"
export DOCKER_CERT_PATH="/Users/liujianlong/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"

eval "$(docker-machine env default)"

usual
docker images



docker pull registry.aliyuncs.com/yueber/nginx-php

docker run [OPTIONS] IMAGE[:TAG] [COMMAND] [ARG...]
docker run -h="nginx-php" --name nginx-php -d -p 51000:22 -p 51001:80 debian02 /etc/rc.local 

##初次启动
docker run -h="nginx-php" --name nginx-php -d -p 51000:22 -p 51001:80 -v /mnt/share:/usr/share/nginx/html registry.aliyuncs.com/yueber/nginx-php

docker run -h="nginx-php" --name nginx-php -d -p 51000:22 -p 51001:80 -v /mnt/share:/usr/share/nginx/html registry.aliyuncs.com/yueber/nginx-php

docker run -h="zookeeper" --name nginx-php -d -p 51000:22 -p 51001:80 -v /mnt/share:/usr/share/nginx/html registry.aliyuncs.com/gdk/zookeeper


##再次启动
docker run -d -h="nginx-php" --name nginx-php -p 51000:22 -p 51001:80 -v /mnt/share:/usr/share/nginx/html registry.aliyuncs.com/yueber/nginx-php



docker exec -it nginx-php bash
docker exec -it determined_wright bash
docker exec -it gigantic_perlman bash

##停止
docker stop nginx-php
docker stop elated_poincare

#docker-machine
docker-machine ssh
docker-machine restart

192.168.99.103
192.168.99.103:51001/proxy/brand.php

更换源
docker-machine create -h
然后能够找到一个参数 --engine-registry-mirror [--engine-registry-mirror option --engine-registry-mirror option] Specify registry mirrors to use
然后随便找一个 daocloud 或是阿里云提供的 docker mirror（需要你申请一个什么阿里云开发者） 服务，配上去就好了


virtual machine 共享文件夹
mount -t vboxsf www /mnt/share/
/etc/fstab中添加一项
www /mnt/share vboxsf rw,gid=110,uid=1100,auto 0 0


docker run
http://doc.okbase.net/vikings-blog/archive/124865.html


mac install
https://docs.docker.com/engine/installation/mac/

常用命令
http://www.csdn123.com/html/mycsdn20140110/77/77f68b74cdb44371b69005cd0239081c.html


#Q
##Error checking TLS connection: Error checking and/or regenerating the certs

##docker pull stuck

>docker pull registry.aliyuncs.com/gdk/zookeeper
Using default tag: latest
latest: Pulling from gdk/zookeeper
8a390d4e7a58: Downloading 1.575 MB/329.3 MB
23590b9e2785: Downloading  1.05 MB/362.7 MB
5f70bf18a086: Download complete
f2dc731dad3c: Downloading 1.209 MB/40.21 MB
cbe30386dd86: Waiting
下了一半，由于有事，提前关机，
>docker info
/mnt/sda1/var/lib/docker

>docker-machine ssh
登录到docker default
/var/lib/docker
lrwxrwxrwx    1 root     root            24 Jun  8 02:26 docker -> /mnt/sda1/var/lib/docker/
是个符号链接
docker@default:/mnt/sda1/var/lib/docker$ sudo ls
aufs        containers  image       network     tmp         trust       volumes
image中并没有此镜像


##Cannot connect to the Docker daemon.






查看所有
docker ps -a





#ip
[2016-06-12 14:24.48]  ~
[liujianlong.JasonMac-2]  VBoxManage dhcpserver modify --ifname vboxnet0 --disable

[2016-06-12 14:25.06]  ~
[liujianlong.JasonMac-2]  VBoxManage dhcpserver modify --ifname vboxnet0 --ip 192.168.59.3 --netmask 255.255.255.0 --lowerip 192.168.59.105 --upperip 192.168.59.203

[2016-06-12 14:25.14]  ~
[liujianlong.JasonMac-2]  VBoxManage dhcpserver modify --ifname vboxnet0 --enable


*/1 * * * * ifconfig eth1 192.168.99.150 netmask 255.255.255.0 broadcast 192.168.99.255 up

dhcp启动脚本





#!/bin/sh
# The DHCP portion is now separated out, in order to not slow the boot down
# only to wait for slow network cards
. /etc/init.d/tc-functions

# This waits until all devices have registered
/sbin/udevadm settle --timeout=5

NETDEVICES="$(awk -F: '/eth.:|tr.:/{print $1}' /proc/net/dev 2>/dev/null)"
for DEVICE in $NETDEVICES; do
        if [ $DEVICE = "eth1" ]; then
                /sbin/udhcpc -b -i eth1 -r 192.168.99.150 -x hostname:$(/bin/hostname) -p /var/run/udhcpc.$DEVICE.pid >/dev/null 2>&1 &
                trap "" 2 3 11
        else
                ifconfig $DEVICE | grep -q "inet addr"
                if [ "$?" != 0 ]; then
                        /sbin/udhcpc -b -i $DEVICE -x hostname:$(/bin/hostname) -p /var/run/udhcpc.$DEVICE.pid >/dev/null 2>&1 &
                        trap "" 2 3 11
                        sleep 1
                fi
        fi
#  ifconfig $DEVICE | grep -q "inet addr"
#  if [ "$?" != 0 ]; then
#   echo -e "\n${GREEN}Network device ${MAGENTA}$DEVICE${GREEN} detected, DHCP broadcasting for IP.${NORMAL}"
#    trap 2 3 11
#    /sbin/udhcpc -b -i $DEVICE -x hostname:$(/bin/hostname) -p /var/run/udhcpc.$DEVICE.pid >/dev/null 2>&1 &
#    trap "" 2 3 11
#    sleep 1
#  fi
done













