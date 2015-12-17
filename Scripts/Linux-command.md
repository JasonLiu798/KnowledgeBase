#linux command notes
---
#bash快捷键
习惯使用编辑的快捷键可以大大提高效率，记忆学习过程要有意识的忽略功能键、方向键和数字小键盘。以下快捷键适用在bash处于默认的Emacs模式下。如果你有set -o vi，就处于 vi 模式就不适用了。
另外下面的内容并不包含所有快捷键，只是我个人适用频率最高的几种，但相信已经可以大大提高工作效率了：

Ctrl + l ：清除屏幕，同clear
Ctrl + a ：将光标定位到命令的开头
Ctrl + e ：与上一个快捷键相反，将光标定位到命令的结尾
Ctrl + u ：剪切光标之前的内容，在输错命令或密码
Ctrl + k ：与上一个快捷键相反，剪切光标之后的内容
Ctrl + y ：粘贴以上两个快捷键所剪切的内容。Alt+y粘贴更早的内容
Ctrl + w ：删除光标左边的参数（选项）或内容（实际是以空格为单位向前剪切一个word）
Ctrl + / ：撤销，同Ctrl+x u
Ctrl + f ：按字符前移（右向），同→
Ctrl + b ：按字符后移（左向），同←
Alt + f ：按单词前移，标点等特殊字符与空格一样分隔单词（右向），同Ctrl+→
Alt + b ：按单词后移（左向），同Ctrl+←
Alt + d ：从光标处删除至字尾。可以Ctrl+y粘贴回来
Alt + \ ：删除当前光标前面所有的空白字符
Ctrl + d ：删除光标处的字符，同Del键。没有命令是表示注销用户
Ctrl + h ：删除光标前的字符
Ctrl + r ：逆向搜索命令历史，比history好用
Ctrl + g ：从历史搜索模式退出，同ESC
Ctrl + p ：历史中的上一条命令，同↑
Ctrl + n ：历史中的下一条命令，同↓
Alt + .：同!$，输出上一个命令的最后一个参数（选项or单词）。
还有如Alt+0 Alt+. Alt+.，表示输出上上一条命令的的第一个单词（即命令）。
另外有一种写法 !:n，表示上一命令的第n个参数，如你刚备份一个配置文件，马上编辑它：cp nginx.conf nginx.conf，vi !:1，同vi !^。!^表示命令的第一个参数，!$最后一个参数（一般是使用Alt + .代替）。
这里提一下按字符或字符串，向左向后搜索字符串的命令：

Ctrl + ]　c ：从当前光标处向右定位到字符 c 处
Esc　Ctrl + ]　c ：从当前光标向左定位到字符 c 处。（ bind -P 可以看到绑定信息）
Ctrl + r　str ：可以搜索历史，也可以当前光标处向左定位到字符串 str，Esc后可定位继续编辑
Ctrl -s　str ：从当前光标处向右定位到字符串 str 处，Esc 退出。注意，Ctrl + S默认被用户控制 XON/XOFF ，需要在终端里执行stty -ixon或加入profile。
注意上述所有涉及Alt键的实际是Meta键，在xshell中默认是没有勾选“Use Alt key as Meta key”，要充分体验这些键带来的快捷，请在对应的terminal设置。

#putty
http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html

---
#系统相关
##type
type命令用来显示指定命令的类型。一个命令的类型可以是如下之一
alias 别名
keyword 关键字，Shell保留字
function 函数，Shell函数
builtin 内建命令，Shell内建命令
file 文件，磁盘文件，外部命令
unfound 没有找到
它是Linux系统的一种自省机制，知道了是那种类型，我们就可以针对性的获取帮助。比如内建命令可以用help命令来获取帮助，外部命令用man或者info来获取帮助。

常用参数
type命令的基本使用方式就是直接跟上命令名字。
type -a可以显示所有可能的类型，比如有些命令如pwd是shell内建命令，也可以是外部命令。
type -p只返回外部命令的信息，相当于which命令。
type -f只返回shell函数的信息。
type -t 只返回指定类型的信息。


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

##wc
wc -w 统计单词数量.
wc -l 统计行数量.
wc -c 统计字节数量.
wc -m 统计字符数量.
wc -L 给出文件中最长行的长度

##flex
取代lex
##bison
取代yacc

#jot, seq
这些工具用来生成一系列整数, 用户可以指定生成范围.
每个产生出来的整数一般都占一行, 但是可以使用-s选项来改变这种设置.
seq -s : 5
1:2:3:4:5

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

## mount
mount -o loop disk1.iso /mntmount/iso


## type
-t  ：当加入 -t 参数时，type 会将 name 以底下这些字眼显示出他的意义：      
    file    ：表示为外部命令；      
    alias   ：表示该命令为命令别名所配置的名称；      
    builtin ：表示该命令为 bash 内建的命令功能；
-p  ：如果后面接的 name 为外部命令时，才会显示完整文件名；
-a  ：会由 PATH 变量定义的路径中，将所有含 name 的命令都列出来，包含 alias


##strace

##ltrace
库跟踪工具(Library trace): 跟踪给定命令的调用库的相关信息.

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
##curl
curl -H "Content-type: application/json" -X POST -d '{"account":"$RANDOM","password":"123345"}'  http://bbb

##wget
http://java-er.com/blog/wget-useage-x/


###with post
wget -q -O- --post-data="account=$RANDOM&password=123345"  http://aaaa

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


#cowsay
http://hz.togogo.net/BrainJam/wenxian/2013/0716/818.html



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
































