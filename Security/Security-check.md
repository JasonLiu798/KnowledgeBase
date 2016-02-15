1、Linux服务器应安装安全的文件系统，DOS FAT、OS/2、HPFS或NTFS等文件系统不应安装在Linux服务器上。
检查：df –T

2、所有对Linux服务器控制台进行的访问应经过严格的身份鉴别与验证，对每个被授权访问的用户应采取用户名及密码的认证手段，或者采取其他有效的身份鉴别与验证手段。
检查修改方法：
Cat /etc/passwd
Cat /etc/shadow

3、禁止直接以root登录，而是采用su命令临时切换。除管理员外，禁止一切用户通过Linux服务器控制台进行shell级的访问。
检查修改方法：直接输入cat /etc/ssh/sshd_config文件cat /etc/ssh/sshd_config |grep PermitRootLogin 
如是PermitRootLogin yes，用vi /etc/ssh/sshd_config命令修改成PermitRootLogin no。
修改完重启ssh，service ssh restart。

4、任何密码设置应符合公司的密码管理制度中的要求。
检查修改方法：more /etc/login.defs检查，是否以下设置都符合。
cat /etc/login.defs |grep PASS_MAX_DAYS  密码最长使用天数 30
cat /etc/login.defs |grep PASS_MIN_DAYS  密码最短使用天数0
cat /etc/login.defs |grep PASS_MIN_LEN   设置密码最小长度 8
cat /etc/login.defs |grep PASS_WARN_AGE   提前多少天警告用户密码过期   7
如果不对用vi /etc/login.defs命令进入，修改。

5、使用shadow密码功能，防止存储在密码文件中的加密密码被非授权访问。
——在Linux中加密后的口令信息存在一个文件里，通常是/etc/passwd。应维护好这个文件的安全性。应保证只有root用户才能访问该文件。
——口令文件在显示时应是加密的，这种显示叫做Shadow口令，应只有root有权访问“／etc／shadow”文件。
检查修改方法：使用"/usr/sbin/authconfig"工具打开shadow功能。如果你想把已有的密码和组转变为shadow格式，可以分别使用"pwcov,grpconv"命令。
pwcov 注：同步用户从/etc/passwd 到/etc/shadow
grpconv 注：通过/etc/group和/etc/gshadow 的文件内容来同步或创建/etc/gshadow ，如果/etc/gshadow 不存在则创建；

6、删除所有不用的缺省用户和组帐号
检查修改方法：  删除用户：
[root@kapil　/]#　userdel　LP
删除组：
[root@kapil　/]#　groupdel　LP
/etc/group
/etc/passwd
查找出已有组，查看是否有新组新用户添加

7、取消普通用户的控制台访问权限，比如shutdown、reboot、halt等命令
检查修改方法：
 [root@kapil　/]#　rm　–f /etc/security/console.apps/是你要注销的程序名

8、取消并反安装所有不用的服务
用chkconfig –list |grep 3:启用
检查所有开启的服务。不用的服务用chkconfig xxx on/off关闭      
9、所有Linux系统都应激活用户帐户登录请求日志记录功能。
Who、w、finger、id、last
ac -p //查看每个用户的连接时间
ac -a //查看所有用户的连接时间
ac -d //查看用户每天的连接时间
Cd /var/log
less secure

9、对Linux服务器的远程管理访问应经过授权和验证。
检查SSH是否限制IP登录，查看/etc/hosts.allow文件
如没有限制，用命令vi /etc/hosts.allow修改。
lucious
Changing password for user lucious.
New UNIX password:

[root@localhost ~]# passwd lucious
Changing password for user lucious.
New UNIX password:
Retype new UNIX password:
passwd: all authentication tokens updated successfully.
[root@localhost ~]# pa

hosts.allow与hosts.deny
两个文件均在/etc/目录下
优先级为先检查hosts.deny，再检查hosts.allow， 后者设定可越过前者限制
/etc/hosts.allow 的设定优先于 /etc/hosts.deny 啰！了解了吗？基本上，只要 hosts.allow 也就够了，因为我们可以将allow 与 deny 都写在同一个档案内，只是这样一来似乎显得有点杂乱无章，因此，通常我们都是：
1. 允许进入的写在 /etc/hosts.allow 当中
2. 不许进入的则写在 /etc/hosts.deny 当中
命令格式
server_name:hosts-list[:command]
例如： 
1.限制所有的ssh， 
除非从218.64.87.0——127上来
hosts.deny:
in.sshd:ALL
hosts.allow:
in.sshd:218.64.87.0/255.255.255.128

2.封掉218.64.87.0——127的telnet
hosts.deny
in.sshd:218.64.87.0/255.255.255.128

3.只允许 140.116.44.0/255.255.255.0 与 140.116.79.0/255.255.255.0 这两个网域，及 140.116.141.99 这个主机可以进入我们的 telnet 服务器；
此外，其它的 IP 全部都挡掉！
这样则首先可以设定 /etc/hosts.allow 这个档案成为：　
[root @test root]# vi /etc/hosts.allow
telnetd: 140.116.44.0/255.255.255.0 : allow
telnetd: 140.116.79.0/255.255.255.0 : allow
telnetd: 140.116.141.99 : allow　
再来，设定 /etc/hosts.deny 成为『全部都挡掉』的状态：　
[root @test root]# vi /etc/hosts.deny
telnetd: ALL : deny　

4.通过spawn选项，我们还可以根据匹配情况执行各种命令。如发邮件或记录日志等。下面是一个示例：
ALL:ALL : spawn (/bin/echo Security Alter from %a on %d on `date`| \
tee -a /var/log/Security_alter | mail jims.yang@gmail.com )

4.当有其它人扫瞄我的 telnet port 时，我就将他的 IP 记住！以做为未来的查询与认证之用！那么你可以将 /etc/hosts.deny 这个档案改成这个样子：　
[root @test root]# vi /etc/hosts.deny
telnetd: ALL : spawn (echo Security notice from host `/bin/hostname`; \
echo; /usr/sbin/safe_finger @%h ) | \
/bin/mail -s "%d-%h security" root & \
: twist ( /bin/echo -e "\n\nWARNING connection not allowed. Your attempt has been logged.
\n\n\n警告您尚未允许登入，您的联机将会被纪录，并且作为以后的参考\n\n ". )


3.限制所有人的TCP连接，除非从218.64.87.0——127访问 
hosts.deny
ALL:ALL
hosts.allow
ALL:218.64.87.0/255.255.255.128

4.限制218.64.87.0——127对所有服务的访问 
hosts.deny
ALL:218.64.87.0/255.255.255.128

其中冒号前面是TCP daemon的服务进程名称，通常系统 
进程在/etc/inetd.conf中指定，比如in.ftpd，in.telnetd，in.sshd

其中IP地址范围的写法有若干中，主要的三种是： 
1.网络地址——子网掩码方式： 
218.64.87.0/255.255.255.0
2.网络地址方式（我自己这样叫，呵呵） 
218.64.（即以218.64打头的IP地址） 
3.缩略子网掩码方式，既数一数二进制子网掩码前面有多少个“1”比如： 
218.64.87.0/255.255.255.0《====》218.64.87.0/24
_______________________________
设置好后，要重新启动

# /etc/rc.d/init.d/xinetd restart

# /etc/rc.d/init.d/network restart

