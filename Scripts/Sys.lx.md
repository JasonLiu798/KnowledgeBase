---
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










