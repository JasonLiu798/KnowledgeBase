---
#monitor
网络流量
/proc/net/dev
平均负载
/proc/loadavg
内存
/proc/meminfo
CPU利用率
/proc/stat

##htop & iotop
htop 和 iotop  用来查看进程，内存和IO负载。


##dstat
可以取代vmstat，iostat，netstat和ifstat
alias dstat='dstat -cdlmnpsy'

-l ：显示负载统计量
-m ：显示内存使用率（包括used，buffer，cache，free值）
-r ：显示I/O统计
-s ：显示交换分区使用情况
-t ：将当前时间显示在第一行
–fs ：显示文件系统统计数据（包括文件总数量和inodes值）
–nocolor ：不显示颜色（有时候有用）
–socket ：显示网络统计数据
–tcp ：显示常用的TCP统计
–udp ：显示监听的UDP接口及其当前用量的一些动态数据

查看全部内存都有谁在占用：
dstat -g -l -m -s --top-mem

显示一些关于CPU资源损耗的数据：
dstat -c -y -l --proc-count --top-cpu

输出到csv
dstat –output /tmp/sampleoutput.csv -cdn

默认输出
CPU状态：CPU的使用率。这项报告更有趣的部分是显示了用户，系统和空闲部分，这更好地分析了CPU当前的使用状况。如果你看到"wait"一栏中，CPU的状态是一个高使用率值，那说明系统存在一些其它问题。当CPU的状态处在"waits"时，那是因为它正在等待I/O设备（例如内存，磁盘或者网络）的响应而且还没有收到。

磁盘统计：磁盘的读写操作，这一栏显示磁盘的读、写总数。

网络统计：网络设备发送和接受的数据，这一栏显示的网络收、发数据总数。

分页统计：系统的分页活动。分页指的是一种内存管理技术用于查找系统场景，一个较大的分页表明系统正在使用大量的交换空间，或者说内存非常分散，大多数情况下你都希望看到page in（换入）和page out（换出）的值是0 0。

系统统计：这一项显示的是中断（int）和上下文切换（csw）。这项统计仅在有比较基线时才有意义。这一栏中较高的统计值通常表示大量的进程造成拥塞，需要对CPU进行关注。你的服务器一般情况下都会运行运行一些程序，所以这项总是显示一些数值。

##sar（System Activity Reporter系统活动情况报告）
目前 Linux 上最为全面的系统性能分析工具之一，可以从多方面对系统的活动进行报告，包括：文件的读写情况、系统调用的使用情况、磁盘I/O、CPU效率、内存使用状况、进程活动及IPC有关的活动等

sar命令常用格式
sar [options] [-A] [-o file] t [n]
其中：
t为采样间隔，n为采样次数，默认值是1；
-o file表示将命令结果以二进制格式存放在文件中，file 是文件名。
options 为命令行选项，sar命令常用选项如下：
-A：所有报告的总和
-u：输出CPU使用情况的统计信息
-v：输出inode、文件和其他内核表的统计信息
-d：输出每一个块设备的活动信息
-r：输出内存和交换空间的统计信息
-b：显示I/O和传送速率的统计信息
-a：文件读写情况
-c：输出进程统计信息，每秒创建的进程数
-R：输出内存页面的统计信息
-y：终端设备活动情况
-w：输出系统交换活动信息

http://www.chinaz.com/server/2013/0401/297942.shtml

##slurm
查看网络流量的一个工具

##multitail
MultiTail是个用来实现同时监控多个文档、类似tail命令的功能的软件。他和tail的区别就是他会在控制台中打开多个窗口，这样使同时监控多个日志文档成为可能。他还可以看log文件的统计，合并log文件，过滤log文件，分屏，


----
#system setting
##system version
发行版本
cat /etc/issue

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



---
#software development
#make
/usr/share/automake-*/config.guess
##strace
##ltrace
库跟踪工具(Library trace): 跟踪给定命令的调用库的相关信息.


#ulimit
增加max open files。先查看一下:
$ sysctl -a | grep files
kern.maxfiles = 12288 kern.maxfilesperproc = 10240
修改为
$ sudo sysctl -w kern.maxfiles=65535 $ sudo sysctl -w kern.maxfilesperproc=65535
增加 max sockets
$ sysctl -a | grep somax
kern.ipc.somaxconn: 128 $ sudo sysctl -w kern.ipc.somaxconn=2048

launchctl limit maxfiles 2048 2048 


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
#开关机
##shutdown,reboot
shutdown -h now
shutdown -r now




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
#crontab
cron
Unix下
cron 进程运行时，会读取/etc/cronlog.conf 配置文件来指定运行日志的存储信息。
如果用户未配置cronlog.conf，则cron进程将运行的日志信息存储在/var/adm/cron/log 文件里


crontab
crontab [ -e [UserName] | -l [UserName] | -r [UserName] | -v [UserName] | File ]
添加
-e 
crontab 命令调用一个编辑会话，允许创建一个 crontab 文件。在这个文件中，为每个 cron 创建条目。每个条目必须是一种 cron 守护进程可接受的格式。要得到创建条目的信息，参阅 crontab 文件条目格式。当创建完条目和退出文件后，crontab 命令将它拷贝到 /var/spool/cron/crontabs 目录，并把它放到一个文件中，此文件的名称是当前的用户名。如果以用户名命名的文件已存在于 crontabs 目录中，crontab 命令会覆盖它。
列出 crontab 文件的内容，就指定 crontab 命令并采用 -l 标志。
删除，采用 -r 标志。


crontab
0 11 * * * /usr/bin/errclear -d S,O 30
0 12 * * * /usr/bin/errclear -d H 90
0 15 * * *  /usr/lib/ras/dumpcheck >/dev/null 2>&1
55 23 * * * /var/perf/pm/bin/pmcfg  >/dev/null 2>&1     #Enable PM Data Collection
# SSA warning : Deleting the next two lines may cause errors in redundant
# SSA warning : hardware to go undetected.
01 5 * * * /usr/lpp/diagnostics/bin/run_ssa_ela 1>/dev/null 2>/dev/null
0 * * * * /usr/lpp/diagnostics/bin/run_ssa_healthcheck 1>/dev/null 2>/dev/null
# SSA warning : Deleting the next line may allow enclosure hardware errors to go undetected
30 * * * * /usr/lpp/diagnostics/bin/run_ssa_encl_healthcheck 1>/dev/null 2>/dev/null
# SSA warning : Deleting the next line may allow link speed exceptions to go undetected
30 4 * * * /usr/lpp/diagnostics/bin/run_ssa_link_speed 1>/dev/null 2>/dev/null
* * * * * iostat >> /jiankong/disk.txt
0 8 * * * nmon -f -s 600 -c 72 -m /tmp/nmonrep


screen, dtach, tmux, byobu
多开






