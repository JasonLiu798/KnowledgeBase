---
#system setting
##system version
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



