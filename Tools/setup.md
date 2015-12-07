
pssh -h /root/all.txt -l root -i 'mkdir -p /home/log'
pssh -h /root/all.txt -l root -i 'ln -sfv /home/log /opt/log'

## iso
[centos](http://www.centos.org/download/)
[centos mirror](http://isoredirect.centos.org/centos/6/isos/x86_64/)

http://www.linuxidc.com/Linux/2012-06/62663.htm


## pssh
wget http://parallel-ssh.googlecode.com/files/pssh-2.2.2.tar.gz
tar zxvf pssh-2.2.2.tar.gz
cd pssh-2.2.2
python setup.py install

http://www.linuxidc.com/Linux/2012-06/62663.htm

all
192.168.1.200:vagrant
192.168.1.202:vagrant
192.168.1.203:vagrant

pssh -h /root/all -l root -i 'ln -sfv /opt/share/jdk1.8.0_20 /opt/java'
pssh -h /root/slave -l root -i 'mkdir -p /opt/zookeeper/data'
pssh -h /root/slave -l root -i 'rm -rf /opt/java'

##user script
pscp -h /root/all.txt -l root scps /opt/bin/
pscp -h /root/all.txt -l root ftps /opt/bin/

##git
pscp -h /root/all.txt -l root git233.tar.gz /opt/rpm/
pssh -h /root/all.txt -l root -i 'tar -zpxvf /opt/rpm/git233.tar.gz -C /opt/rpm/'
pssh -h /root/all.txt -l root -i '/opt/rpm/git-2.3.3/configure'

##gcc rpm安装包
rpm -ivh glibc-2.12-1.132.el6.x86_64.rpm glibc-common-2.12-1.132.el6.x86_64.rpm glibc-devel-2.12-1.132.el6.x86_64.rpm glibc-headers-2.12-1.132.el6.x86_64.rpm kernel-headers-2.6.32-431.el6.x86_64.rpm libgcc-4.4.7-4.el6.x86_64.rpm libgomp-4.4.7-4.el6.x86_64.rpm ppl-0.10.2-11.el6.x86_64.rpm cloog-ppl-0.15.7-1.2.el6.x86_64.rpm mpfr-devel-2.4.1-6.el6.x86_64.rpm cpp-4.4.7-4.el6.x86_64.rpm gmp-devel-4.3.1-7.el6_2.2.x86_64.rpm mpfr-2.4.1-6.el6.x86_64.rpm gcc-4.4.7-4.el6.x86_64.rpm --force
rpm -ivh gcc-4.4.7-4.el6.x86_64.rpm


## rhel yum(centos)
[setting](http://blog.itpub.net/25313300/viewspace-708509)
[rhel use centos](http://www.centoscn.com/CentOS/config/2014/1119/4143.html)

rpm -ivh yum-updatesd-0.9-2.el5.noarch.rpm 
yum-metadata-parser-1.1.2-3.el5.centos.i386.rpm
yum-3.2.22-20.el5.centos.noarch.rpm 
yum-fastestmirror-1.1.16-13.el5.centos.noarch.rpm

## redis linux
http://download.redis.io/releases/redis-3.0.2.tar.gz
pssh -h /root/other.txt -l root -i 'wget -P /opt/rpm http://download.redis.io/releases/redis-3.0.2.tar.gz'

pscp -h /root/all.txt -l root /root/all.txt /root/
pssh -h /root/all.txt -l root -i 'mkdir -p /opt/rpm/redis'
pssh -h /root/all.txt -l root -i 'tar -zpxvf /opt/rpm/redis-3.0.2.tar.gz -C /opt/rpm/redis'
pssh -h /root/all.txt -l root -i 'ln -sfv /opt/rpm/redis/redis-3.0.2 /opt/redis'
pssh -h /root/all.txt -l root -i 'make -f /opt/redis/Makefile'

make 
Q1
    zmalloc.h:50:31: error: jemalloc/jemalloc.h: No such file or directory
    zmalloc.h:55:2: error: #error "Newer version of jemalloc required"
    make[1]: *** [adlist.o] Error 1
    make[1]: Leaving directory `/data0/src/redis-2.6.2/src'
    make: *** [all] Error 2

make MALLOC=libc

pssh -h /root/all.txt -l root -i 'mkdir -p /opt/log/redis'
pssh -h /root/all.txt -l root -i 'mkdir -p /etc/redis'

### /etc/redis/redis.conf
daemonize yes
logfile "/opt/log/redis/redis.log"
databases 8

pscp -h /root/all.txt -l root /etc/redis/redis.conf /etc/redis

### run
redis-server /etc/redis/redis.conf

redis-cli




# IOS
## 固件
http://www.taigpro.com/archives/category/firmware#iPadmini2






