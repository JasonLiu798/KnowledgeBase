#系统状态
----
#查看磁盘状态
AIX:
powermt display dev=all
lsdev -Cc disk

---
#内存
top
free -m
pmap -d $PID


----
#网络
#netstat
netstat -pan|grep '14:1414'
netstat –an|grep 端口号
netstat -anop |grep 9999
##namp
网络映射(Network mapper)与端口扫描程序
nmap -sT -O localhost

## nc
nc -z -w 10 %IP% %PORT%
-z表示检测或者扫描端口
-w表示超时时间
-u表示使用UDP协议
echo clone | nc thunk.org 5000 > e2fsprogs.dat
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



----
#进程状态
#top

#htop
[index](http://hisham.hm/htop/index.php?page=downloads#sources)

#ps
ps -eLf 
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









