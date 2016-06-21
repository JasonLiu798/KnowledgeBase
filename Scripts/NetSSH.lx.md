#Network 网络相关 
---
#网卡，网络配置
##网络配置
```bash
service start&stop&restart
sudo /etc/init.d/networking restart 

paralle desktop 无网络：http://bbs.feng.com/read-htm-tid-6881868-page-3.html

#DNS-linux
cat /etc/resolv.conf
echo 'nameserver 10.33.176.66' >/etc/resolv.conf
search localdomain
#DNS-mac
sudo dscacheutil -flushcache

#hostname
[ubuntu]
/etc/hostname 

```

##网卡配置
```bash
/etc/network/interfaces
auto eth0                  #设置自动启动eth0接口
iface eth0 inet static     #配置静态IP
address 192.168.11.88      #IP地址
netmask 255.255.255.0      #子网掩码
gateway 192.168.11.1        #默认网关

sudo ifconfig eth0 192.168.1.81 netmask 255.255.255.0
sudo route add default gw 192.168.1.1
sudo ifconfig eth0 down
sudo ifconfig eth0 up
```

##代理配置
###linux
PROXY=http://proxy.xj.petrochina:8080
http_proxy=$PROXY
https_proxy=$PROXY
ftp_proxy=$PROXY
no_proxy=10.,192.
export http_proxy https_proxy ftp_proxy no_proxy
http://os.51cto.com/art/200908/141449.htm
###mac
mac terminal add proxy
http://codelife.me/blog/2012/09/02/how-to-set-proxy-for-terminal/
export http_proxy='http://192.168.1.160:1080'
export https_proxy='http://192.168.1.160:1080'

unset http_proxy
unset https_proxy

##测网速
sar -n DEV 1 100 
1代表一秒统计并显示一次 
100代表统计一百次

---
#网络状态查看
##端口
find listen process 查看端口进程
lsof -Pnl +M -i4
lsof -Pnl +M -i6
lsof -Pni4 | grep LISTEN | grep php

##tcpdump
tcpdump -i eth0 -A tcp port 1414 and host 10.185.234.14
tcpdump -i eth0 -d tcp port 1414 and host 10.185.234.14
host 10.185.234.14 tcp port 1414

tcpdump -nt -s 500 port domain 



---
#http请求，下载
##curl
curl -H "Content-type: application/json" -X POST -d '{"account":"$RANDOM","password":"123345"}'  http://bbb

##wget
http://java-er.com/blog/wget-useage-x/
###with post
wget -q -O- --post-data="account=$RANDOM&password=123345"  http://aaaa
###测网速
wget -O /dev/null http://ftp.jaist.ac.jp/pub/eclipse/technology/epp/downloads/release/mars/R/eclipse-jee-mars-R-win32-x86_64.zip
###爬虫
[wget登录-使用 Wget 完成自动 Web 认证（推 portal）](http://www.cnblogs.com/lookbackinside/archive/2012/07/21/2603050.html)
[我写过最简单的爬虫–wget爬虫](http://blog.yikuyiku.com/?p=1296)
[使用wget做站点镜像及wget的高级用法](http://www.ahlinux.com/start/cmd/2700.html)
[wget命令](http://blog.csdn.net/forgotaboutgirl/article/details/6891123)
[用wget做站点镜像](http://blog.chinaunix.net/uid-14735472-id-111049.html)
###cookie
wget --post-data="os_username=service_guest&os_password=111111" --save-cookies=cookie.txt --keep-session-cookies http://192.168.1.92:8090/dologin.action
爬虫
wget -r -k -c -nc -p -np --load-cookies=cookie.txt http://192.168.1.92:8090/dashboard.action -U "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; GTB5)" 
wget --mirror -p --convert-links --load-cookies=cookie.txt http://192.168.1.92:8090/dashboard.action
-r 表示递归下载,会下载所有的链接,不过要注意的是,不要单独使用这个参数,因为如果你要下载的网站也有别的网站的链接,wget也会把别的网站的东西下载下来,所以要加上-np这个参数,表示不下载别的站点的链接.
-np 表示不下载别的站点的链接.
-k 表示将下载的网页里的链接修改为本地链接.
-p 获得所有显示网页所需的元素,比如图片什么的.
-E  或 --html-extension   将保存的URL的文件后缀名设定为“.html”
-L --relative
Follow relative links only.  Useful for retrieving a specific home page without any distractions, not even those from the same hosts.
-A acclist --accept acclist
-R rejlist --reject rejlist
Specify comma-separated lists of file name suffixes or patterns to
accept or reject. Note that if any of the wildcard characters, *,
?, [ or ], appear in an element of acclist or rejlist, it will be
treated as a pattern, rather than a suffix.  In this case, you have
to enclose the pattern into quotes to prevent your shell from
expanding it, like in -A "*.mp3" or -A '*.mp3'.




---
#安全
##iptables 防火墙
chkconfig iptables off
service iptables start
service iptables stop 

防火墙禁止3306端口，以iptable为例
vi /etc/sysconfig/iptables
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 3306-j ACCEPT
service iptables restart
ps:  iptables设置
1) 重启后生效
开启： chkconfig iptables on
关闭： chkconfig iptables off
2) 即时生效，重启后失效
开启： service iptables start
关闭： service iptables stop



---
#SSH
##ssh认证
http://www.cnblogs.com/jdksummer/articles/2521550.html
[SSH25个命令 + 深入SSH端口转发细节](http://itindex.net/detail/45394-ssh25-%E5%91%BD%E4%BB%A4-ssh)
```bash
ssh-keygen -t rsa
chmod o-w ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ps -Af | grep agent 
```
[ssh多秘钥共存](http://www.111cn.net/sys/linux/71236.htm)

##/etc/ssh配置
/etc/ssh/sshd_config 
PermitRootLogin yes


##~/.ssh/config
###指定不同key
```bash
Host *.workdomain.com  
    IdentityFile ~/.ssh/id_rsa.work  
    User lee  
   
Host github.com  
    IdentityFile ~/.ssh/id_rsa.github  
    User git  
```



###代理，跳板机
```bash
vi ~/.ssh/config
Host dxx.sxx-bastion
    hostname 54.65.xx.2xx
    Port 18330
    User ec2-user
Host dxx.sxx-web1
    hostname 10.0.x.xx
    ProxyCommand ssh dxx.sxx-bastion -W %h:%p
    User ubuntu
```
保存后,进行登录验证
ps:
%h 表示 hostname
%p 表示 portal

```bash
#~/.ssh/config
Host 10.205.*
User javaguest
ProxyCommand ssh -p 123 user@ip -i ~/.ssh/id_rsa -W %h:%p

```

###重启
ubuntu
service ssh start
/etc/init.d/ssh start
centos
/etc/rc.d/init.d/sshd restart

### Q&A
#### 连接缓慢
http://blog.csdn.net/yefengnidie/article/details/8186942
1、在server上/etc/hosts文件中把你本机的ip和hostname加入　
2、在server上
vi /etc/ssh/sshd_config
文件中修改或加入UseDNS=no　
3、注释掉server上/etc/resolv.conf中不使用的IP所有行　
4、修改server上/etc/nsswitch.conf中hosts为hosts：files
5、authentication gssapi-with-mic也有可能出现问题，在server上/etc/ssh/sshd_config文件中修改 GSSAPIAuthentication no。
/etc/init.d/sshd restart
如之前为服务器配置了双网卡，使的在/etc/resolv.conf文件中多了一行目前不使用的IP地址。注释或者删除该行即可。大多数情况修改1和5两项即可解决问题

##pssh 批量ssh
###安装
tar -xvf pssh-2.3.1.tar.gz
cd pssh-2.3.1
python setup.py build
python setup.py install
###配置
1.从结点的IP列表文件；
[ip]:[port] [user]
2.主节点到从节点的ssh无密钥登录
###使用
pssh -h /root/ot.txt -l root -i 'tar -zpxvf /opt/project/lib.tar.gz -C /opt/project/'
pscp -h /root/slave -l root /etc/redis/7001.conf /etc/redis
http://www.theether.org/pssh/
pssh在多个主机上并行地运行命令
-h 执行命令的远程主机列表,文件内容格式[user@]host[:port]
如 test@172.16.10.10:229
-H 执行命令主机，主机格式 user@ip:port
-l 远程机器的用户名
-p 一次最大允许多少连接
-P 执行时输出执行信息
-o 输出内容重定向到一个文件
-e 执行错误重定向到一个文件
-t 设置命令执行超时时间
-A 提示输入密码并且把密码传递给ssh(如果私钥也有密码也用这个参数)
-O 设置ssh一些选项
-x 设置ssh额外的一些参数，可以多个，不同参数间空格分开
-X 同-x,但是只能设置一个参数
-i 显示标准输出和标准错误在每台host执行完毕后

pscp 传输文件到多个hosts，类似scp
    pscp -h hosts.txt -l irb2 foo.txt /home/irb2/foo.txt
pslurp 从多台远程机器拷贝文件到本地
pnuke 并行在远程主机杀进程
    pnuke -h hosts.txt -l irb2 java
prsync 使用rsync协议从本地计算机同步到远程主机
    prsync -r -h hosts.txt -l irb2 foo /home/irb2/foo

repo仓库
http://www.cnblogs.com/51xzdy/archive/2012/03/05/2380198.html

ibus-daemon -d


##自动登录
[Linux使用expect脚本实现远程机器自动登录](http://blog.csdn.net/kongxx/article/details/48675885)
[linux expect详解(ssh自动登录)](http://www.cnblogs.com/lzrabbit/p/4298794.html)
[自动ssh登录的几种方法](http://blueicer.blog.51cto.com/395686/88175)
sshkey-gen,expect,建立ssh/scp通道

[SSH bouncing update – getting rid of Killed by signal 1](http://simon.zekar.com/2013/03/07/ssh-bouncing-update-killed-by-signal-1/)

---
#ping
```
#win
比如发一个1500的包，不允许分片 
ping -l 1500 -f 1.1.1.1

```



