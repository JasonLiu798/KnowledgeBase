#linux command notes
---
#用户相关
##sudo add user
##/etc/passwd
用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell
http://os.51cto.com/art/201003/187533.htm

---
#时间相关
ntpdate asia.pool.ntp.org >> /var/log/ntpdate.log
ntpdate time.windows.com
asia.pool.ntp.org
中科院授时中心(西安)
ntpdate -s 210.72.145.44
网通授时中心(北京)
ntpdate 219.158.14.130

date -s '11:16:18 2014-01-07' 

[Linux 下的服务器时间同步方案有哪些](http://www.zhihu.com/question/20089241)
大多数应用场景中,使用ntpd的-g参数令其在启动时允许大步长同步就足够了
（除此之外还可以在配置中使用 iburst来让加速同步）。使用 ntpd 唯一需要注意的是在配置时应配置 ACL，以免成为攻击跳板。

有些人会争辩，在启动 ntpd 之前运行一次ntpdate 的好处是ntpdate退出时，
系统的时间已经调到了比较接近正确的时间。不过，ntp作者已经在文档中明确表示未来ntpdate 会变成一个shell脚本（通过 ntpd -g -q 来实现），事实上，现在也可以在启动时用 ntpq -c rv 来检查 ntpd 的状态了，对于精度要求比较高的应用，系统时间和时钟快慢同等重要，如果不高，也没有太大必要去另外运行 ntpdate 了。

定时运行 ntpdate 的系统很容易受到这样的攻击：如果有人故意调整了某个 ntp 服务器的时间，所有使用 ntpdate 的系统都将跟随其设置。举例来说，假如已知某家公司的系统每天凌晨3点会执行某项非常耗时的任务，同时每4个小时会做一次ntpdate，那么攻陷这台服务器并令其一直返回 凌晨 2:59，就可以很容易地实现四两拨千斤的杠杆式攻击了，而且，由于系统时间也会影响日志，因此观察日志的人员也比较容易受其误导。

与此相反，ntpd 通常会配置为使用多个参考服务器，在运行时会参考多个服务器的时间，并排除明显异常的服务器。而监控多个 ntp 服务器相对来说要容易得多。

用 cron 或类似的任务计划去做 ntpdate 还有个问题是如果系统时间比较准的话，每到某个整点（或者特定的时间）的同步操作就变成了一次对 NTP 服务器的 DDoS。机器多的话，这种放大效应对于集群本身和提供 NTP 服务的机器都是不利的。



---
#磁盘相关
##查看磁盘状态
AIX:
powermt display dev=all
lsdev -Cc disk


##硬链接
### MAC
https://gist.github.com/bao3/8be962381d0c3eae13f9

hlink.c

    #include <unistd.h>
    #include <stdio.h>
    // Build: gcc -o hlink hlink.c -Wall
    int main(int argc, char *argv[]) {
        printf("Usage: assume the program name is hlink\n");
        printf("sudo ./hlink source_directory destination_directory\n");
        if (argc != 3) return 1;
        int ret = link(argv[1], argv[2]);
        if (ret == 0) {
            printf("\n");
            printf("****** Create hard link successful ******\n");
            } else {
            perror("link");
        }
        return ret;
    }
hunlink.c

    #include <stdio.h>
    #include <string.h> /* memset */
    #include <unistd.h> /* close */
    // Build: gcc -o hunlink hunlink.c
    int main(int argc, char *argv[]) {
        printf("Usage: assume the program name is hunlink\n");
        printf("sudo ./hunlink destination_directory\n");
        if (argc != 2) return 1;
        int ret = unlink(argv[1]);
        if (ret == 0) {
            printf("\n");
            printf("****** Delete hard link successful ******\n");
        } else {
            perror("unlink");
        }
        return ret;
    }


---
#file search 文件搜索相关
##find
find /tmp -mtime +30 -type f -name *.sh[ab] -exec rm -f 
find . -mtime +30 -type f | xargs rm -rf
 find /home/oracle/test6 -cmin +20 -type f -name *.xml -exec rm -f
mtime来查找，因为在ls -al显示出来的就是mtime时间戳
ctime(change time, 而不是create time), atime(access time), mtime(modify time)

find . -name "*.c"  -exec grep array /dev/null {} \;
find . -name "message*.xml" -print |xargs grep 'AlertDataQ'

查找最近24小时更新的文件
find . -mtime -1 -type f -print

参数列表过长
find . "*.nasl" | xargs rm -f 
or
find . -name "*.nasl" -exec rm {} \; 

##grep
grep -C 5 foo file 显示file文件里匹配foo字串那行以及上下5行
grep -B 5 foo file 显示foo及前5行
grep -A 5 foo file 显示foo及后5行

##encoding 文件编码
iconv -f encoding -t encoding inputfile
-f From 某个编码
-t To 某个编码
-o 输出到文件
### 查看文件编码
http://54im.com/linux/linux-fileencoding-enca-iconv-enconv-convmv.html



## fuser
fuser -v
文件正在被使用

## 打开文件总数
lsof -n|awk '{print $2}'|sort|uniq -c|sort -nr|more
lsof -n|awk '{print $2}'|uniq -c|awk 'BEGIN{sum=0}{for(i=1;i<NF;i++){sum += $i;}}END{print sum}'

## 设置文件打开总数
临时 ulimit -n 8192
永久
cat /proc/sys/fs/file-max
/etc/sysctl.conf，增加fs.file-max = 8061540
/etc/security/limits.conf
speng soft nofile 10240 
speng hard nofile 10240 
/etc/pam.d/login文件，在文件中添加如下行： 
session required /lib/security/pam_limits.so
/etc/security/limits.conf
* - nofile 2048


---
#system setting
##date
date -s 11:25:00
##thread
ps -eLf 
top H
##内存
top
free -m
pmap -d $PID

## mount
mount -o loop disk1.iso /mntmount/iso


## type
-t  ：当加入 -t 参数时，type 会将 name 以底下这些字眼显示出他的意义：      
    file    ：表示为外部命令；      
    alias   ：表示该命令为命令别名所配置的名称；      
    builtin ：表示该命令为 bash 内建的命令功能；
-p  ：如果后面接的 name 为外部命令时，才会显示完整文件名；
-a  ：会由 PATH 变量定义的路径中，将所有含 name 的命令都列出来，包含 alias


---
#Software setup
## apt setting
https://www.debian.org/doc/manuals/apt-howto/ch-apt-get.zh-cn.html
###source setting
    /etc/apt/apt.conf

sudo apt-get update
apt-cache search
###installs
sudo apt-get install 
###upgrade
apt-get upgrade
###del
apt-get remove package
apt-show-versions -p logrotate
apt-get autoclean

apt-get -u dselect-upgrade

## yum
yum –y install vsftpd


---
#Network 网络相关 
##wget
http://java-er.com/blog/wget-useage-x/
测网速
wget -O /dev/null http://ftp.jaist.ac.jp/pub/eclipse/technology/epp/downloads/release/mars/R/eclipse-jee-mars-R-win32-x86_64.zip
###爬虫
[wget登录-使用 Wget 完成自动 Web 认证（推 portal）](http://www.cnblogs.com/lookbackinside/archive/2012/07/21/2603050.html)
[我写过最简单的爬虫–wget爬虫](http://blog.yikuyiku.com/?p=1296)
[使用wget做站点镜像及wget的高级用法](http://www.ahlinux.com/start/cmd/2700.html)
[wget命令](http://blog.csdn.net/forgotaboutgirl/article/details/6891123)
[用wget做站点镜像](http://blog.chinaunix.net/uid-14735472-id-111049.html)
登录获取cookie
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


##代理
PROXY=http://proxy.xj.petrochina:8080
http_proxy=$PROXY
https_proxy=$PROXY
ftp_proxy=$PROXY
no_proxy=10.,192.
export http_proxy https_proxy ftp_proxy no_proxy
http://os.51cto.com/art/200908/141449.htm

### mac
mac terminal add proxy
http://codelife.me/blog/2012/09/02/how-to-set-proxy-for-terminal/
export http_proxy='http://192.168.1.160:1080'
export https_proxy='http://192.168.1.160:1080'

unset http_proxy
unset https_proxy

##网速
sar -n DEV 1 100 
1代表一秒统计并显示一次 
100代表统计一百次
 

##防火墙
chkconfig iptables off
service iptables start
service iptables stop 

##DNS
cat /etc/resolv.conf
echo 'nameserver 10.33.176.66' >/etc/resolv.conf
search localdomain
###mac
sudo dscacheutil -flushcache

##tcpdump
tcpdump -i eth0 -A tcp port 1414 and host 10.185.234.14
tcpdump -i eth0 -d tcp port 1414 and host 10.185.234.14
host 10.185.234.14 tcp port 1414

tcpdump -nt -s 500 port domain 

### service start&stop&restart
sudo /etc/init.d/networking restart 

## netstat
netstat -pan|grep '14:1414'
netstat –an|grep 端口号
netstat -anop |grep 9999

#### find listen process 查看端口进程
lsof -Pnl +M -i4
lsof -Pnl +M -i6

## hostname
[ubuntu]
/etc/hostname 

### interface
/etc/network/interfaces
auto eth0                  #设置自动启动eth0接口
iface eth0 inet static     #配置静态IP
address 192.168.11.88      #IP地址
netmask 255.255.255.0      #子网掩码
gateway 192.168.11.1        #默认网关

### dns
/etc/resolve.conf
nameserver 114.114.114.114
nameserver 114.114.115.115
sudo /etc/init.d/networking restart
sudo ifconfig eth0 192.168.1.81 netmask 255.255.255.0
sudo route add default gw 192.168.1.1
sudo ifconfig eth0 down
sudo ifconfig eth0 up
paralle desktop 无网络：http://bbs.feng.com/read-htm-tid-6881868-page-3.html

##namp
nmap -sT -O localhost

## nc
nc -z -w 10 %IP% %PORT%
-z表示检测或者扫描端口
-w表示超时时间
-u表示使用UDP协议
### result
端口成功联通返回值是0，提示succeeded；否则返回1，不提示任何数据
假如我们有这样一堆IP和端口。
### batch chk
    file format
    119.181.69.96 8080
    119.181.118.38 8000
    ...
    119.181.69.37 8080

nc.sh
cat file |  while read line
do
  nc -z -w 10 $line > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo $line:ok
  else
    echo $line:fail
  fi
done



---
#SSH
##ssh认证
http://www.cnblogs.com/jdksummer/articles/2521550.html
ssh-keygen -t rsa
chmod o-w ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ps -Af | grep agent 

[ssh多秘钥共存](http://www.111cn.net/sys/linux/71236.htm)

###配置
/etc/ssh/sshd_config 
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

---
#语言相关
##输入法
http://blog.csdn.net/shanshu12/article/details/7339152
##ubuntu 中文
http://www.cnblogs.com/badwood316/archive/2010/03/06/1679965.html
apt-get install language-pack-zh
/etc/environment
LANG="zh_CN.UTF-8"

LANGUAGE="zh_CN:zh:en_US:en"
/var/lib/locales/supported.d/local：
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_CN.GBK GBK
zh_CN GB2312
en_GB.UTF-8 UTF-8
locale-gen
/etc/default/locale
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh:en_US:en"
###切换到应为
LANG=”en_US.UTF-8″
LANGUAGE=”en_US:en”
再在终端下运行：
locale-gen -en_US:en

### 英文
export LANG=en_US.UTF-8


---
#开关机
##shutdown,reboot
shutdown -h now
shutdown -r now



---
# process 进程相关
## PS
ps aux
ps -lA
ps axjf
ps -ef
参数：
    -A 或 -e：所有的 process 
    -a ：不与 terminal 有关的所有 process 
    -u ：有效使用者 (effective user) 相关的 process ；
    x ：通常与 a 这个参数一起使用，可列出较完整信息
输出格式规划：
    l ：较长、较详细的将该 PID 的的信息列出
    j ：工作的格式 (jobs format)
    -f ：做一个更为完整的输出
特别说明：
由于 ps 能够支持的 OS 类型相当的多，所以他的参数多的离谱！而且有没有加上 - 差很多！详细的用法应该要参考 man ps 喔！
 
范例1：将目前属于您自己这次登入的 PID 与相关信息列示出来
[root@linux ~]# ps -l
F S UID PID PPID C PRI NI ADDR SZ WCHAN TTY TIME CMD
0 S 0 5881 5654 0 76 0 - 1303 wait pts/0 00:00:00 su
4 S 0 5882 5881 0 75 0 - 1349 wait pts/0 00:00:00 bash

### result meaning
* F 代表这个程序的旗标 (flag)， 4 代表使用者为 super user；
* S 代表这个程序的状态 (STAT)，关于各 STAT 的意义将在内文介绍；
* PID 没问题吧！？就是这个程序的 ID 啊！底下的 PPID 则上父程序的 ID；
* C CPU 使用的资源百分比
* PRI 这个是 Priority (优先执行序) 的缩写
* NI 这个是 Nice 值
* ADDR 这个是 kernel function，指出该程序在内存的那个部分。如果是个 running的程序，一般就是『 - 』的啦！
* SZ 使用掉的内存大小；
* WCHAN 目前这个程序是否正在运作当中，若为 - 表示正在运作；
* TTY 登入者的终端机位置
* TIME 使用掉的 CPU 时间
* CMD 所下达的指令

范例2：列出目前所有的正在内存当中的程序
[root@linux ~]# ps -aux
USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
root 1 0.0 0.1 1740 540 ? S Jul25 0:01 init [3]
root 2 0.0 0.0 0 0 ? SN Jul25 0:00 [ksoftirqd/0]

• USER：该 process 属于那个使用者账号的
• PID ：该 process 的号码
• %CPU：该 process 使用掉的 CPU 资源百分比；
• %MEM：该 process 所占用的物理内存百分比；
• VSZ ：该 process 使用掉的虚拟内存量 (Kbytes)
• RSS ：该 process 占用的固定的内存量 (Kbytes)
• TTY ：该 process 是在那个终端机上面运作，若与终端机无关，则显示 ?，另外， tty1-tty6 是本机上面的登入者程序，若为 pts/0 等等的，则表示为由网络连接进主机的程序。
• STAT：该程序目前的状态，主要的状态有：
R ：该程序目前正在运作，或者是可被运作；
S ：该程序目前正在睡眠当中 (可说是 idle 状态啦！)，但可被某些讯号 (signal) 唤醒。
T ：该程序目前正在侦测或者是停止了；
Z ：该程序应该已经终止，但是其父程序却无法正常的终止他，造成 zombie (疆尸) 程序的状态
• START：该 process 被触发启动的时间；
• TIME ：该 process 实际使用 CPU 运作的时间。
• COMMAND：该程序的实际指令为何

范例3：以范例一的显示内容，显示出所有的程序
[root@linux ~]# ps -lA
F S UID PID PPID C PRI NI ADDR SZ WCHAN TTY TIME CMD
4 S 0 1 0 0 76 0 - 435 - ? 00:00:01 init
1 S 0 2 1 0 94 19 - 0 ksofti ? 00:00:00 ksoftirqd/0
1 S 0 3 1 0 70 -5 - 0 worker ? 00:00:00 events/0
.....以下省略.....
 
范例4：列出类似程序树的程序显示
[root@linux ~]# ps -axjf
PPID PID PGID SID TTY TPGID STAT UID TIME COMMAND
0 1 0 0 ? -1 S 0 0:01 init [3]
1 2 0 0 ? -1 SN 0 0:00 [ksoftirqd/0]
.....中间省略.....
1 5281 5281 5281 ? -1 Ss 0 0:00 /usr/sbin/sshd
5281 5651 5651 5651 ? -1 Ss 0 0:00 \_ sshd: dmtsai [priv]
5651 5653 5651 5651 ? -1 S 500 0:00 \_ sshd: dmtsai@pts/0
5653 5654 5654 5654 pts/0 6151 Ss 500 0:00 \_ -bash
5654 5881 5881 5654 pts/0 6151 S 0 0:00 \_ su
5881 5882 5882 5654 pts/0 6151 S 0 0:00 \_ bash
5882 6151 6151 5654 pts/0 6151 R+ 0 0:00 \_ ps -axjf
 
范例5：找出与 cron 与 syslog 这两个服务有关的 PID 号码
[root@linux ~]# ps aux | egrep '(cron|syslog)'
root 1539 0.0 0.1 1616 616 ? Ss Jul25 0:03 syslogd -m 0
root 1676 0.0 0.2 4544 1128 ? Ss Jul25 0:00 crond
root 6157 0.0 0.1 3764 664 pts/0 R+ 12:10 0:00 egrep (cron|syslog)
在预设的情况下， ps 仅会列出与目前所在的 bash shell 有关的 PID 而已，所以， 当我使用 ps -l 的时候，只有三个 PID (范例一)。


进程启动时间
ps -A -opid,stime,etime,args 
ps -eo lstart 
ps -eo lstart,pid,etime,args

nohup简单而有用的nohup命令在UNIX/LINUX中，普通进程用&符号放到后台运行，如果启动该程序的控制台logout，则该进程随即终止。

要实现守护进程，一种方法是按守护进程的规则去编程（本站有文章介绍过），比较麻烦；另一种方法是仍然用普通方法编程，然后用nohup命令启动程序： 
nohup <程序名> & 
则控制台logout后，进程仍然继续运行，起到守护进程的作用（虽然它不是严格意义上的守护进程）。
使用nohup命令后，原程序的的标准输出被自动改向到当前目录下的nohup.out文件，起到了log的作用，实现了完整的守护进程功能。
ygwu @ 2005年04月18日 上午10:03 

For example：
如何远程启动WebLogic服务?用telnet远程控制服务器，远程启动WEBLOGIC服务，启动后关闭telnet，WebLogic服务也跟着停止，这是因为使用telnet启动的进程会随着telnet进程的关闭而关闭。所以我们可以使用一些UNIX下的命令来做到不关闭。
使用如下命令：
nohup startWeblogic.sh&
如果想要监控标准输出可以使用：
tail -f nohup.out

访客留言
FreeBSD可以同时运行多个进程，在shell下直接输入命令后，shell将进程放到前台执行。如果要将进程放到后台执行，需要在命令行的结尾加上一个 “&” 符号。下面的命令从后台执行，从ftp.isc.org下载文件。
$ fetch ftp://ftp.isc.org/pub/inn/inn-1.7.2.tar.gz &
当程序已经在前台执行的时候，可以使用^Z将这个程序挂起，暂停执行。然后可以使用bg命令将这个挂起的程序放到后台执行，或者使用fg将某个在后台或挂起的进程放到前台执行。
当在后台运行了程序的时候，可以用jobs命令来查看后台作业的状态。在有多个后台程序时，要使用来参数的fg命令将不同序号的后台作业切换到前台上运行。
$ jobs
[1]+ Running fetch ftp://ftp.isc.org/pub/inn/inn-1.7.2.tar.gz &
$ fg %1
fetch ftp://ftp.isc.org/pub/inn/inn-1.7.2.tar.gz
在启动了多个程序之后，可以使用ps命令来查看这些进程及其状态。
$ ps
PID TT STAT TIME COMMAND
501 p2 Ss 0:00.24 -bash (bash)
988 p2 R+ 0:00.00 ps
765 p3 Is+ 0:00.28 -bash (bash)
230 v0 Is+ 0:00.14 -bash (bash)
显示的结果包括进程的标识号PID，控制终端TT（p0表示控制终端为ttyp0），进程的状态STAT，进程使用的处理器时间TIME和具体的命令。
可以给ps命令加上参数，来获得更多的输出内容，以下命令将输出系统中所有的进程：
$ ps waux
USER PID %CPU %MEM VSZ RSS TT STAT STARTED TIME COMMAND
wb 989 0.0 0.4 400 236 p2 R+ 5:48PM 0:00.00 ps -aux
root 1 0.0 0.1 496 72 ?? Is 10:12PM 0:00.02 /sbin/init --
root 2 0.0 0.0 0 0 ?? DL 10:12PM 0:07.05 (pagedaemon)
root 3 0.0 0.0 0 0 ?? DL 10:12PM 0:00.20 (vmdaemon)
root 4 0.0 0.0 0 0 ?? DL 10:12PM 0:04.27 (syncer)
root 27 0.0 0.0 204 0 ?? IWs - 0:00.00 (adjkerntz)
root 91 0.0 0.5 820 328 ?? Is 2:12PM 0:00.82 syslogd
daemon 100 0.0 0.0 792 0 ?? IWs - 0:00.00 (portmap)
root 131 0.0 0.3 864 164 ?? Is 2:12PM 0:00.06 inetd
root 134 0.0 0.3 980 192 ?? Is 2:12PM 0:00.11 cron
root 138 0.0 0.6 1252 380 ?? Is 2:12PM 0:00.11 sendmail: accepti
wb 230 0.0 1.1 1540 668 v0 Is+ 2:12PM 0:00.14 -bash (bash)
root 231 0.0 0.0 824 0 v1 IWs+ - 0:00.00 (getty)
root 232 0.0 0.0 824 0 v2 IWs+ - 0:00.00 (getty)
root 500 0.0 0.9 876 524 ?? Ss 4:19PM 0:01.78 telnetd
wb 501 0.0 1.4 1540 888 p2 Ss 4:19PM 0:00.24 -bash (bash)
root 698 0.0 1.5 1644 900 ?? Is 4:49PM 0:00.02 /usr/local/sbin/s
root 700 0.0 1.2 1308 748 ?? Ss 4:49PM 0:00.22 /usr/local/sbin/n
root 702 0.0 3.4 2900 2112 ?? S 4:49PM 0:00.32 /usr/local/sbin/s
root 764 0.0 0.9 880 540 ?? Is 5:10PM 0:00.22 telnetd
wb 765 0.0 1.7 1536 1052 p3 Is+ 5:10PM 0:00.28 -bash (bash)
root 0 0.0 0.0 0 0 ?? DLs 10:12PM 0:00.02 (swapper)
当用户启动一个进程的时候，这个进程是运行在前台，使用与相应控制终端相联系的标准输入、输出进行输入和输出。即使将进程的输入输出重定向，并将进程放在后台执行，进程仍然和当前终端设备有关系。正因为如此，在当前的登录会话结束时，控制终端设备将和登录进程相脱离，那么系统就向所有与这个终端相联系的进程发送SIGHUP的信号，通知进程线路已经挂起了，如果程序没有接管这个信号的处理，那么缺省的反应是进程结束。因此普通的程序并不能真正脱离登录会话而运行进程，为了使得在系统登录后还可以正常执行，只有使用命令nohup来启动相应程序。
从上面的ps的输出结果可以看出，有些程序没有控制终端，这些程序通常是一些后台进程。使用命令nohup当然可以启动这样的程序，但nohup启动的程序在进程执行完毕就退出，而常见的一些服务进程通常永久的运行在后台，不向屏幕输出结果。在Unix中这些永久的后台进程称为守护进程（daemon）。守护进程通常从系统启动时自动开始执行，系统关闭时才停止。如果偶然某个守护进程消失了，那么它提供的服务将不再能被使用。
在守护进程中，最重要的一个是超级守护进程inetd，这个进程接管了大部分网络服务，但并不是对每个服务都自己进行处理，而是依据连接请求，启动不同的服务程序与客户机打交道。inetd支持网络服务种类在它的设置文件/etc/inet.conf中定义。inet.conf文件中的每一行就对应一个端口地址，当inetd接受到连接这个端口的连接请求时，就启动相应的进程进行处理。使用inetd的好处是系统不必启动很多守护进程，从而节约了系统资源，然而使用inetd启动守护进程相应反应会迟缓一些，不适合用于被密集访问的服务进程



---
#tar 文件压缩打包备份相关
## gzip
[root@www ~]# gzip [-cdtv#] 檔名 
[root@www ~]# zcat 檔名.gz 
选顷参数： 
-c  ：将压缩癿数据输出到屏幕上，可透过数据流重导向杢处理； 
-d  ：解压缩癿参数； 
-t  ：可以用杢检验一个压缩文件癿一致性～看看档案有无错诨； 
-v  ：可以显示出原档案/压缩文件案癿压缩比等信息； 
-#  ：压缩等级，-1 最忚，但是压缩比最差、-9 最慢，但是压缩比最好！预讴是 
-6 

## bzip2
[root@www ~]# bzip2 [-cdkzv#] 檔名 
[root@www ~]# bzcat 檔名.bz2 
选顷不参数： 
-c  ：将压缩癿过程产生癿数据输出到屏幕上！ 
-d  ：解压缩癿参数 
-k  ：保留源文件，而丌会删除原始癿档案喔！ 
-z  ：压缩癿参数 
-v  ：可以显示出原档案/压缩文件案癿压缩比等信息； 
-#  ：不 gzip 同样癿，都是在计算压缩比癿参数， -9 最佳， -1 最忚！ 

## unzip
    语法：unzip ［选项］ 压缩文件名.zip
    各选项的含义分别为：
    　　-x 文件列表 解压缩文件，但不包括指定的file文件。
    　　-v 查看压缩文件目录，但不解压。
    　　-t 测试文件有无损坏，但不解压。
    　　-d 目录 把压缩文件解到指定目录下。
    　　-z 只显示压缩文件的注解。
    　　-n 不覆盖已经存在的文件。
    　　-o 覆盖已存在的文件且不要求用户确认。
    　　-j 不重建文档的目录结构，把所有文件解压到同一目录下。

## tar
tar -zpcvf xxx.tar.gz --exclude=/root/etc* --exclude=/root/system.tar.bz2 /etc /root
tar -ztvf /root/etc.tar.bz2 

    参数：
    -c  ：建立打包档案，可搭配 -v 杢察看过程中被打包癿档名(filename)
    -t  ：察看打包档案癿内容吨有哪些档名，重点在察看『档名』就是了；
    -x  ：解打包或解压缩癿功能，可以搭配 -C (大写) 在特定目录解开特别留意癿是， -c, -t, -x 不可同时出现在一串挃令列中。
    -j  ：透过 bzip2
    -z  ：透过 gzip 
    -v  ：在压缩/解压缩癿过程中，将正在处理癿文件名显示出杢！
    -f filename：-f 后面要立刻接要被处理癿档名！建议 -f 单独写一个选顷啰！
    -C 目录    ：这个选顷用在解压缩，若要在特定目录解压缩，可以使用这个选
    顷。
    其他后续练习会使用到癿选顷介绍：
    -p  ：保留备份数据癿原本权限不属性，常用亍备份(-c)重要癿配置文件
    -P  ：保留绝对路径，亦即允讲备份数据中吨有根目录存在乊意；
    --exclude=FILE：在压缩癿过程中，丌要将 FILE 打包！  

将文件名中癿(根)目录也备份下杢，并察看一下备份档癿内容档名 
[root@www ~]# tar -jpPcv -f /root/etc.and.root.tar.bz2 /etc 
....中间过程省略.... 
[root@www ~]# tar -jtf /root/etc.and.root.tar.bz2 
/etc/dbus-1/session.conf 
/etc/esd.conf 
/etc/crontab 

### 备份最新
[root@www ~]# tar -jcv -f /root/etc.newer.then.passwd.tar.bz2 --newer-mtime="2008/09/29" /etc/* 

### 备份目录
/etc/ (配置文件)
/home/ (用户癿家目录)
/var/spool/mail/ (系统中，所有账号癿邮件信箱)
/var/spool/cron/ (所有账号癿工作排成配置文件)
/root (系统管理员癿家目录) 

## dump 
dump -S xxx
dump -0u -f /root/boot.dump /boot 
dump -0j -f /root/etc.dump.bz2 /etc 
[root@www ~]# dump [-Suvj] [-level] [-f 备份档] 待备份资料 
[root@www ~]# dump -W 
选顷参数： 
-S    ：仅列出后面癿待备份数据需要多少磁盘空间才能够备份完毕； 
-u    ：将这次 dump 癿时间记录到 /etc/dumpdates 档案中； 
-v    ：将 dump 癿档案过程显示出杢； 
-j    ：加入 bzip2 癿支持！将数据迚行压缩，默认 bzip2 压缩等级为 2
-level：就是我们谈到癿等级，从 -0 ~ -9 共十个等级；
-f    ：有点类似 tar 啦！后面接产生癿档案，亦可接例如 /dev/st0 装置文件名等
-W    ：列出在 /etc/fstab 里面癿具有 dump 讴定癿 partition 是否有备份过？ 


## restore 恢复 dump
-t  ：察看 dump 
-C  ：此模式可以将 dump 内癿数据拿出杢跟实际癿文件系统做比较，最终会列出『在 dump 档案内有记录癿，且目前文件系统丌一样』癿档案；
-i  ：迚入互劢模式，可以仅还原部分档案，用在 dump 目录时癿还原！
-r  ：将整个 filesystem 还原癿一种模式，用在还原针对文件系统癿 dump 备
份；
其他较常用到癿选顷功能：
-h  ：察看完整备份数据中癿 inode 不文件系统 label 等信息
-f  ：后面就接你要处理癿那个 dump 档案啰
-D  ：不 -C 迚行搭配，可以查出后面接癿挂载点不 dump 内有丌同癿档案！ 

[root@www boot]# restore -t -f /root/boot.dump 
[root@www boot]# restore -C -f /root/boot.dump
分卷压缩
压缩
tar cvzpf - 文件夹 | split -db 5000m
获取完整压缩包
cat x*> 文件夹名.tar.gz
解压
tar -zpxvf 文件夹名.tar.gz

 
## dd
dd if="input_file" of="output_file" bs="block_size" count="number" 
选顷不参数： 
if   ：就是 input file 啰～也可以是装置喔！ 
of   ：就是 output file 喔～也可以是装置； 
bs   ：觃划癿一个 block 癿大小，若未挃定则预讴是 512 bytes(一个 sector 癿
大小) 
count：多少个 bs 癿意思。 

dd if=/dev/hdc1 of=/dev/hdc9
mount /dev/hdc9 /mnt
df 
备份磁盘
dd if=/dev/sda of=/dev/sdb
 
## cpio
[root@www ~]# cpio -ovcB  > [file|device] <==备份
[root@www ~]# cpio -ivcdu < [file|device] <==还原
[root@www ~]# cpio -ivct  < [file|device] <==察看 
[root@www ~]# find /boot | cpio -ocvB > /tmp/boot.cpio 
[root@www ~]# cpio -idvc < /tmp/boot.cpio 


----
#自动化
##expect
send：用于向进程发送字符串
expect：从进程接收字符串
spawn：启动新的进程
interact：允许用户交互

###send命令
send命令接收一个字符串参数，并将该参数发送到进程。
expect1.1> send "hello world\n"
hello world
###expect
expect通常是用来等待一个进程的反馈。expect可以接收一个字符串参数，也可以接收正则表达式参数。和上文的send命令结合，现在我们可以看一个最简单的交互式的例子：
expect "hi\n"
send "hello there!\n"
这两行代码的意思是：从标准输入中等到hi和换行键后，向标准输出输出hello there。
tips： $expect_out(buffer)存储了所有对expect的输入，<$expect_out(0,string)>存储了匹配到expect参数的输入。
比如如下程序：
expect "hi\n"
send "you typed <$expect_out(buffer)>"
send "but I only expected <$expect_out(0,string)>"
当在标准输入中输入
test
hi
是，运行结果如下
you typed: test
hi
I only expect: hi
模式-动作
expect最常用的语法是来自tcl语言的模式-动作。这种语法极其灵活，下面我们就各种语法分别说明。

单一分支模式语法：
expect "hi" {send "You said hi"}
匹配到hi后，会输出"you said hi"
多分支模式语法：
expect "hi" { send "You said hi\n" } \
"hello" { send "Hello yourself\n" } \
"bye" { send "That was unexpected\n" }
匹配到hi,hello,bye任意一个字符串时，执行相应的输出。等同于如下写法：

expect {
"hi" { send "You said hi\n"}
"hello" { send "Hello yourself\n"}
"bye" { send "That was unexpected\n"}
}

###spawn命令
上文的所有demo都是和标准输入输出进行交互，但是我们跟希望他可以和某一个进程进行交互。spawm命令就是用来启动新的进程的。spawn后的send和expect命令都是和spawn打开的进程进行交互的。结合上文的send和expect命令我们可以看一下更复杂的程序段了。

set timeout -1
spawn ftp ftp.test.com      //打开新的进程，该进程用户连接远程ftp服务器
expect "Name"             //进程返回Name时
send "user\r"        //向进程输入anonymous\r
expect "Password:"        //进程返回Password:时
send "123456\r"    //向进程输入don@libes.com\r
expect "ftp> "            //进程返回ftp>时
send "binary\r"           //向进程输入binary\r
expect "ftp> "            //进程返回ftp>时
send "get test.tar.gz\r"  //向进程输入get test.tar.gz\r
这段代码的作用是登录到ftp服务器ftp ftp.uu.net上，并以二进制的方式下载服务器上的文件test.tar.gz。程序中有详细的注释。

###interact
到现在为止，我们已经可以结合spawn、expect、send自动化的完成很多任务了。但是，如何让人在适当的时候干预这个过程了。比如下载完ftp文件时，仍然可以停留在ftp命令行状态，以便手动的执行后续命令。interact可以达到这些目的。下面的demo在自动登录ftp后，允许用户交互。
spawn ftp ftp.test.com
expect "Name"
send "user\r"
expect "Password:"
send "123456\r"
interact



#PS1
PS1有那些配置，或者说PS1里头都能配置些命令提示符的什么东西：

    \d ：代表日期，格式为weekday month date，例如："Mon Aug 1"
    \H ：完整的主机名称。例如：我的机器名称为：fc4.linux，则这个名称就是fc4.linux
    \h ：仅取主机的第一个名字，如上例，则为fc4，.linux则被省略
    \t ：显示时间为24小时格式，如：HH：MM：SS
    \T ：显示时间为12小时格式
    \A ：显示时间为24小时格式：HH：MM
    \u ：当前用户的账号名称
    \v ：BASH的版本信息
    \w ：完整的工作目录名称。家目录会以 ~代替
    \W ：利用basename取得工作目录名称，所以只会列出最后一个目录
    \# ：下达的第几个命令
    \$ ：提示字符，如果是root时，提示符为：# ，普通用户则为：$

颜色的问题。我们可以通过设置PS1变量使得提示符变成彩色。在PS1中设置字符序列颜色的格式为：\[\e[F;Bm\]
F 字体颜色，编号30~37
B 为背景色，编号40~47
取消设置 \[\e[m\] 使用来关闭颜色设置的。要是你没有这个的话；那么，你的命令提示符，包括你通过命令提示符输出的东西都是和最后一次的颜色设置相同(除了一些有特殊意义的文件  )。

颜色表

       前景   背景   颜色
    　　30      40      黑色
    　　31      41      红色
    　　32      42      绿色
    　　33      43      黄色
    　　34      44      蓝色
    　　35      45      紫红色
    　　36      46      青蓝色
    　　37      47      白色

        代码      意义
        0            OFF
        1            高亮显示
        4            underline            
        7            反白显示
        8            不可见






---
#ESXi常用
## esxtop
实时的CPU、内存、硬盘和网络使用的历史表现的统计数字


---
#cygwin
## 配置
http://oldratlee.com/post/2012-12-22/stunning-cygwin

##ssh server
[安装Cygwin中的SSH服务](http://www.blogjava.net/Man/archive/2012/11/26/392004.html)
sh-host-config，一路yes，提示CYGWIN值时，输入netsec tty
启动sshd服务用: net start sshd 或 cygrunsrv --start sshd
停止sshd服务用:net stop sshd 或 cygrunsrv --stop sshd
删除 sshd 服务：net stop sshd， cygrunsrv -R sshd 或 sc delete sshd
用ssh yourname@127.0.0.1 或 ssh localhost登陆
可以继续安装配置sftp、scp等
cygwin sshd 配置：
把账户信息导入它的配置文件。
$ mkpasswd -l > /etc/passwd
$ mkgroup -l > /etc/group
$ chmod +r /etc/passwd
$ chmod +r /etc/group
$ chmod +rwx /var
PS:如果用的是域帐户的话，上面的命令中是没有域账户的信息的。
再追加一下当前账户信息：
$ mkpasswd -c >> /etc/passwd
$ mkgroup -c >> /etc/group


## 常用工具
telnet -> 
apt-cyg install inetutils

## 乱码问题
[终极解决方案](http://www.cnblogs.com/yshl-dragon/p/3631056.html)
http://www.blogjava.net/Skynet/archive/2009/05/13/270326.html
LANG=zh_CN.UTF-8
LC_CTYPE="zh_CN.UTF-8"
LC_NUMERIC="zh_CN.UTF-8"
LC_TIME="zh_CN.UTF-8"
LC_COLLATE="zh_CN.UTF-8"
LC_MONETARY="zh_CN.UTF-8"
LC_MESSAGES="zh_CN.UTF-8"
LC_ALL=

## 路径转化
win->linux
cygpath -p "D:\tcode\spring.....ableToListenableFutureAdapter.java" -a -u
linux->win
cygpath -p /usr/bin -a -w
-p==–path：表示（给定的NAME是）path路径（而不是文件）
-a：表示absolute，绝对路径
-u==–unix：表示Unix，即Linux，即Cygwin下面的路径
-w==-windows：表示windows路径

## apt-cyg 包管理
http://zengrong.net/post/1792.htm
https://github.com/transcode-open/apt-cyg
### apt-cyt setup
lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
install apt-cyg /bin
Example use of apt-cyg:
apt-cyg install nano
### 配置
apt-cyg -c /cygdrive/d/downloads/cygwin -m http://mirrors.163.com/cygwin/ find php

### Windows和cygwin路径的转换
cygpath命令来完成转换，相关的选项是：
-a, --absolute        output absolute path
-w, --windows         print Windows form of NAMEs (C:\WINNT)
-u, --unix            (default) print Unix form of NAMEs (/cygdrive/c/winnt)

$ cygpath -au 'C:\Windows\System32\drivers\etc'
/cygdrive/c/Windows/System32/drivers/etc
$ cygpath -aw '/cygdrive/c/Windows/System32/drivers/etc'
C:\Windows\System32\drivers\etc

##Cywin输入、显示中文不正常
解决：修改.inputrc，解除以下几行注释：
set meta-flag on
set convert-meta off
set input-meta on
set output-meta on

## vim输入中文串行
解决：修改.vimrc，加入以下内容：
if &term != "cygwin" 
set ruler 
else 
set noruler
endif

## 修改bash默认颜色方案时提示：dircolors: no SHELL environment variable, and no shell type option given

解决：在.bashrc中设置：export SHELL="bash"





























