acpid
ACPI（全称 Advanced Configuration and Power Interface）服务是电源管理接口。建议所有的笔记本用户开启它。一些服务器可能不需要 acpi。支持的通用操作有：“电源开关“，”电池监视“，”笔记本 Lid 开关“，“笔记本显示屏亮度“，“休眠”， “挂机”，等等。
anacron, atd, crond
这几个调度程序有很小的差别。 建议开启 cron，如果你的电脑将长时间运行，那就更应该开启它。对于服务器，应该更深入了解以确定应该开启哪个调度程序。大多数情况下，笔记本/台式机应该关闭 atd 和 anacron。注意：一些任务的执行需要 anacron，比如：清理 /tmp 或 /var。
alsasound
Alsa声卡驱动守护程序。Alsa声卡驱动程序本来是为了 一种声卡Gravis UltraSound(GUS)而写的，该程序被证 明很优秀，于是作者就开始为一般的声卡写 驱动程序。 Alsa和OSS/Free 及OSS/Linux兼容，但是有自己的接 口，甚至比OSS优秀。
apmd
一些笔记本和旧的硬件使用 apmd。如果你的电脑支持 acpi，就应该关闭 apmd。如果支持 acpi，那么 apmd 的工作将会由 acpi 来完成。
arptables_jf
为arptables网络的用户控制过滤的守护进程。
arpwatch
记录日志并构建一个在LAN接口上看到的以太网地址和IP地址对数据库 。
atalk
AppleTalk网络守护进程。注意不要在后台运行该程序，该程序的数据结构必须在运行其他进程前先花一定时间初始化。
auditd
审核子系统可以被系统管理员用来监测系统调用和那些符合 CAPP 或其它审核要求的文件系统访问。它的主要内容包括：
· 默认情况下，审核在内核中被禁用。但是，当安装了 auditd 软件后，运行这个软件将会启动审核守护进程（auditd）。
· 当 auditd 运行的时候，审核信息会被发送到一个用户配置日志文件中（默认的文件是 /var/log/audit/audit.log）。如果 auditd 没有运行，审核信息会被发送到 syslog。这是通过默认的设置来把信息放入 /var/log/messages。如果审核子系统没有被启用，没有审核信息会被产生。
· 这些审核信息包括了 SELinux AVC 信息。以前，AVC 信息会被发送到 syslog，但现在会被审核守护进程发送到审核日志文件中。
· 要完全在内核中禁用审核，在启动的时候使用 audit=0 参数。您还需要使用 chkconfig auditd off 2345 来关闭 auditd。您可以在运行时使用 auditctl -e 0 来在内核中关闭审核。
审核守护进程（auditd）从内核的 audit netlink 接口获取审核事件数据。auditd 的配置会不尽相同，如输出文件配置和日志文件磁盘使用参数可以在 /etc/auditd.conf 文件中配置。请注意，如果您设置您的系统来进行 CAPP 风格的审核，您必须设置一个专用的磁盘分区来只供 audit 守护进程使用。这个分区应该挂载在 /var/log/audit。
系统管理员还可以使用 auditctl 工具程序来修改 auditd 守护进程运行时的审核参数、syscall 规则和文件系统的查看。它包括了一个 CAPP 配置样本，您可以把它拷贝到 /etc/audit.rules 来使它起作用。
审核日志数据可以通过 ausearch 工具程序来查看和搜索。
autofs
该服务自动挂载可移动存储器（比如 USB 硬盘）。如果你使用移动介质（比如移动硬盘，U 盘），建议启用这个服务。
avahi-daemon, avahi-dnsconfd
Avahi 是 zeroconf 协议的实现。它可以在没有 DNS 服务的局域网里发现基于 zeroconf 协议的设备和服务。它跟 mDNS 一样。除非你有兼容的设备或使用 zeroconf 协议的服务，否则应该关闭它。
bootparamd
引导参数服务器，为LAN上的无盘工作站提供引导所需的相关信息。
bluetooth, hcid, hidd, sdpd, dund, pand
蓝牙（Bluetooth）是给无线便携设备使用的（非 wifi, 802.11）。很多笔记本提供蓝牙支持。有蓝牙鼠标，蓝牙耳机和支持蓝牙的手机。很多人都没有蓝牙设备或蓝牙相关的服务，所以应该关闭它。其他蓝牙相关 的服务有：hcid 管理所有可见的蓝牙设备，hidd 对输入设备（键盘，鼠标）提供支持， dund 支持通过蓝牙拨号连接网络，pand 允许你通过蓝牙连接以太网。
capi
仅仅对使用 ISDN 设备的用户有用。大多数用户应该关闭它。
chargen
使用tcp协议的chargen server，chargen（Character Generator Protocol）是一种网络服务，主要功能是提供类似远程打字的功能。
chargen-udp
使用UDP协议的chargen server。
chargen-dgram
chargen-stream
conman
cpuspeed
该服务可以在运行时动态调节 CPU 的频率来节约能源（省电）。许多笔记本的 CPU 支持该特性，现在，越来越多的台式机也支持这个特性了。如果你的 CPU 是：Petium-M，Centrino，AMD PowerNow， Transmetta，Intel SpeedStep，Athlon-64，Athlon-X2，Intel Core 2 中的一款，就应该开启它。如果你想让你的 CPU 以固定频率运行的话就关闭它。
cupsd, cups-config-daemon, cups-lpd
打印机相关。
cvs
cvs 是一个版本控制系统。
daytime
使用TCP 协议的Daytime守护进程，该协议为客户机实现从远程服务器获取日期 和时间的功能。预设端口：13。
daytime-udp
使用UDP 协议的Daytime守护进程。
daytime-dgram
daytime-stream
dc_client, dc_server
磁盘缓存（Distcache）用于分布式的会话缓存。主要用在 SSL/TLS 服务器。它可以被 Apache 使用。大多数的台式机应该关闭它。
dhcdbd
这是一个让 DBUS 系统控制 DHCP 的接口。可以保留默认的关闭状态。
diskdump, netdump
磁盘转储（Diskdump）用来帮助调试内核崩溃。内核崩溃后它将保存一个 “dump“ 文件以供分析之用。网络转储（Netdump）的功能跟 Diskdump 差不多，只不过它可以通过网络来存储。除非你在诊断内核相关的问题，它们应该被关闭。
discard-dgram
discard-stream
dnsmasq
DNSmasq是一个轻巧的，容易使用的DNS服务工具，它可以应用在内部网和Internet连接的时候的IP地址NAT转换，也可以用做小型网络的DNS服务。
echo
服务器回显客户数据服务守护进程。
echo-udp
使用UDP协议的服务器回显客户数据服务守护进程。
echo-dgram
echo-stream
eklogin
接受rlogin会话鉴证和用kerberos5加密的一种服务的守护进程。
ekrb5-telnet
firstboot
该服务是 Fedora 安装过程特有的。它执行在安装之后的第一次启动时仅仅需要执行一次的特定任务。它可以被关闭。
functions
gated
网关路由守护进程。它支持各种路由协议，包括RIP版本1和2、DCN HELLO协议、 OSPF版本2以及EGP版本2到4。
gpm
终端鼠标指针支持（无图形界面）。如果你不使用文本终端（CTRL-ALT-F1, F2..），那就关闭它。不过，我在运行级别 3 开启它，在运行级别 5 关闭它。
gssftp
使用kerberos 5认证的ftp守护进程。
haldaemon
halt
hplip, hpiod, hpssd
HPLIP 服务在 Linux 系统上实现 HP 打印机支持，包括 Inkjet，DeskJet，OfficeJet，Photosmart，Business InkJet 和一部分 LaserJet 打印机。这是 HP 赞助的惠普 Linux 打印项目（HP Linux Printing Project）的产物。如果你有相兼容的打印机，那就启用它。
hsqldb
一个java的关系型数据库守护进程，得名于Hypersonic SQL，但这个项目已经没有再继续了。
httpd
Web服务器Apache守护进程，可用来提供HTML文件以 及CGI动态内容服务。
innd
Usenet新闻服务器守护进程。
iiim
中文输入法服务器守护进程。
inetd
因特网操作守护程序。监控网络对各种它管理的服务的需求，并在必要的时候启动相应的服务程序。在Redhat 和Mandrake linux中被xinetd代替。Debian, Slackware, SuSE仍然使用。
ip6tables
如果你不知道你是否在使用 IPv6，大部分情况下说明你没有使用。该服务是用于 IPv6 的软件防火墙。大多数用户都应该关闭它。
ipmi
iptables
它是 Linux 标准的防火墙（软件防火墙）。如果你直接连接到互联网（如，cable，DSL，T1），建议开启它。如果你使用硬件防火墙（比如：D-Link，Netgear，Linksys 等等），可以关闭它。强烈建议开启它。
irda, irattach
IrDA 提供红外线设备（笔记本，PDA’s，手机，计算器等等）间的通讯支持。大多数用户应该关闭它。
irqbalance
在多处理器系统中，启用该服务可以提高系统性能。大多数人不使用多处理器系统，所以关闭它。但是我不知道它作用于多核 CPU’s 或 超线程 CPU’s 系统的效果。在单 CPU 系统中关闭它应该不会出现问题。
isdn
这是一种互联网的接入方式。除非你使用 ISDN 猫来上网，否则你应该关闭它。
keytable
该进程的功能是转载在/etc/sysconfig/keyboards里定义的键盘映射表，该表可以通过kbdconfig工具进行选择。您应该使该程序处于激活状态。
kdump
klogin
远程登陆守护进程。
krb5-telnet
使用kerberos 5认证的telnet守护进程。
kshell
kshell守护进程。
killall
krb524
kudzu
该服务进行硬件探测，并进行配置。如果更换硬件或需要探测硬件更动，开启它。但是绝大部分的台式机和服务器都可以关闭它，仅仅在需要时启动。
ldap
ldap（Lightweight Directory Access Protocol）目录访问协议服务器守护进程。
libvirtd
lm_sensors
该服务可以探测主板感应器件的值或者特定硬件的状态（一般用于笔记本电脑）。你可以通过它来查看电脑的实时状态，了解电脑的健康状况。它在 GKrellM 用户中比较流行。如果没有特殊理由，建议关闭它。
lvm2-monitor
mcstrans
SELinux转换服务，如果你使用 SELinux 就开启它，但你也可以关闭。
mdmonitor
该服务用来监测 Software RAID 或 LVM 的信息。它不是一个关键性的服务，可以关闭它。
mdmpd
该服务用来监测 Multi-Path 设备（该类型的存储设备能被一种以上的控制器或方法访问）。它应该被关闭。
messagebus
这是 Linux 的 IPC（Interprocess Communication，进程间通讯）服务。确切地说，它与 DBUS 交互，是重要的系统服务。强烈建议开启它。
multipathd, microcode_ctl
可编码以及发送新的微代码到内核以更新Intel IA32系列处理器守护进程。
mysqld
一个快速高效可靠的轻型SQL数据库引擎守护进程。
named
DNS（BIND）服务器守护进程。
netconsole
netfs
该服务用于在系统启动时自动挂载网络中的共享文件空间，比如：NFS，Samba 等等。如果你连接到局域网中的其它服务器并进行文件共享，就开启它。大多数台式机和笔记本用户应该关闭它。
netplugd, ifplugd
Netplugd 用于监测网络接口并在接口状态改变时执行指定命令。建议保留它的默认关闭状态。
network
激活/关闭启动时的各个网络接口守护进程。
nfs, nfslock
这是用于 Unix/Linux/BSD 系列操作系统的标准文件共享方式。除非你需要以这种方式共享数据，否则关闭它。
nscd
服务名缓存进程，它为NIS和LDAP等服务提供更快的验证，如果你运行这些服务，那你应该开启它。
ntpd
该服务通过互联网自动更新系统时间。如果你能永久保持互联网连接，建议开启它，但不是必须的。
pcscd
该服务提供智能卡（和嵌入在信用卡，识别卡里的小芯片一样大小）和智能卡读卡器支持。如果你没有读卡器设备，就关闭它。
pcmcia
主要用于支持笔记本电脑接口守护进程。
portmap
该服务是 NFS（文件共享）和 NIS（验证）的补充。除非你使用 NFS 或 NIS 服务，否则关闭它。
postgresql
PostgreSQL 关系数据库引擎。
pppoe
ADSL连接守护进程。
proftpd
proftpd 是Unix下的一个配置灵活的ftp服务器的守护程序。
psacct
该守护进程包括几个工具用来监控进程活动的工具，包括ac,lastcomm, accton和sa。
random
保存和恢复系统的高质量随机数生成器，这些随机数是系统一些随机行为提供的。
rawdevices
在使用集群文件系统时用于加载raw设备的守护进程。
rdisc
readahead_early, readahead_later
该服务通过预先加载特定的应用程序到内存中以提供性能。如果你想程序启动更快，就开启它。
restorecond
用于给 SELinux 监测和重新加载正确的文件上下文（file contexts）。它不是必须的，但如果你使用 SELinux 的话强烈建议开启它。
rhnsd
Red Hat 网络服务守护进程。通知官方的安全信息以及为系统打补丁。
routed
该守护程序支持RIP协议的自动IP路由表维护。RIP主要 使用在小型网络上，大一点的网络就需要复杂一点的协议。
rpcgssd, rpcidmapd, rpcsvcgssd
用于 NFS v4。除非你需要或使用 NFS v4，否则关闭它。
rsync
remote sync远程数据备份守护进程。
rsh
远程主机上启动一个shell，并执行用户命令。
rwhod
允许远程用户获得运行rwho守护程序的机器上所有已登录用户的列表。
rstatd
一个为LAN上的其它机器收集和提供系统信息的守候进程。
ruserd
远程用户定位服务，这是一个基于RPC的服务，它提供关于当前记录到LAN上一个机器日志中的用户信息。
rwalld
激活rpc.rwall服务进程，这是一项基于RPC的服务，允许用户给每个注册到LAN机器上的其他终端写消息。
rwhod：
激活rwhod服务进程，它支持LAN的rwho和ruptime服务。
saslauthd
使用SASL的认证守护进程。
sendmail
除非你管理一个邮件服务器或你想 在局域网内传递或支持一个共享的 IMAP 或 POP3 服务。大多数人不需要一个邮件传输代理。如果你通过网页（hotmail/yahoo/gmail）或使用邮件收发程序（比如：Thunderbird， Kmail，Evolution 等等）收发邮件。你应该关闭它。
setroubleshoot
查看selinux日志的程序
squid
代理服务器squid守护进程。
smartd
SMART Disk Monitoring 服务用于监测并预测磁盘失败或磁盘问题（前提：磁盘必须支持 SMART）。大多数的桌面用户不需要该服务，但建议开启它，特别是服务器。
smb
SAMBA 服务是在 Linux 和 Windows 之间共享文件必须的服务。如果有 Windows 用户需要访问 Linux 上的文件，就启用它。
snmpd
本地简单网络管理守护进程。
sshd
SSH 允许其他用户登录到你的系统并执行程序，该用户可以和你同一网络，也可以是远程用户。开启它存在潜在的安全隐患。如果你不需要从其它机器或不需要从远程登录，就应该关闭它。
syslog
tcpmux-server
tftp
time
该守护进程从远程主机获取时间和日期，采用TCP协议。
time-udp
该守护进程从远程主机获取时间和日期，采用UDP协议。
time-dgram
time-stream
tux
在Linux内核中运行apache服务器的守护进程。
vsftpd
vsftpd服务器的守护进程
vmware-tools
vmware-tools，虚拟机中装了vmware-tools包之后才会有的。
vncserver
VNC （Virtual Network Computing，虚拟网络计算），它提供了一种在本地系统上显示远程计算机整个”桌面”的轻量型协议。
winbind
Winbind 是一款 Samba 组件，在 CentOS 系统下，他被包含在了 samba-common 包中。 Winbind 在Linux上实现了微软的RPC调用、可插式验证模块和名字服务切换，通过 samba 接口与 Windows 域控获得联系，可以使NT域用户能在Linux主机上以Linux用户身份进行操作。通过设定 Linux 服务器的 nss 配置，我们可以让系统通过 Winbind 程序来解析用户信息。
wpa_supplicant
无线网卡上网服务
xend, xendomains
XEN虚拟服务相关
xfs
X Window字型服务器守护进程，为本地和远程X服务器提供字型集。
xinetd
（该服务默认可能不被安装）它是一个特殊的服务。它可以根据特定端口收到的请求启动多个服务。比如：典型的 telnet 程序连接到 23 号端口。如果有 telent 请求在 23 号端口被 xinetd 探测到，那 xinetd 将启动 telnetd 服务来响应该请求。为了使用方便，可以开启它。运行 chkconfig –list， 通过检查 xinetd 相关的输出可以知道有哪些服务被 xinetd 管理。
ypbind
为NIS（网络信息系统）客户机激活ypbind服务进程 。
yppasswdd
NIS口令服务器守护进程。
ypserv
NIS主服务器守护进程。
yum, yum-updatesd
RPM操作系统自动升级和软件包管理守护进程。
ConsoleKit
这个主要是 Gnome 使用的用于 Fedora - Fast User Switching ，主要用于自动加载 device 和 Power Management. 建议 Disable
NetworkManager, NetworkManagerDispatcher
主要用于笔记本的有线网络和无线网络之间的切换，有些 DHCP 用户会用到 . 建议Disable
acpid
高级电源管理，在 Fedora 7 中默认安装的，如果需要可以安装
anacron, atd, cron
Linux 里面的计划任务，cron 建议打开，其它两项关闭
auditd
这个记录 kernel 的审计情况，相当于另外的一个 loggin 服务，用命令 auditctl 查看文件的变化情况，普通用户用不上可以关闭
autofs
自动加裁文件系统，如果你用的移动设备建议打开，不然就关掉咯
avahi-daemon, avahi-dnsconfd
相当于 mDNS 的一个软件，我也不知道干什么用的，建议关闭
bluetooth, hcid, hidd, sdpd, dund, pand
用于蓝牙设备的 deamon ，没有的可以关闭
btseed, bttrack
和 BitTorrent 相关的服务，建议关闭
capi
与ISDN相关的服务，一般用户都可以关闭
cpuspeed
控制CPU的频率用于节省电源， Pentium-M, Centrino, AMD PowerNow, Transmetta, Intel SpeedStep, Athlon-64, Athlon-X2, Intel Core
2 支持，如果你CPU不支持或者，想CPU全速运行都可以关掉它
cupsd, cups-config-daemon
以打印机相关的服务，有打印机可以打开
dc_client, dc_server
主要用以 SSL/TLS 服务，如 Apache Server，不使用就可以关闭
dhcdbd
DHCP相关服务，使用DHCP的人打开，用固定IP的关闭就行了
firstboot
用于第一启动相关的设置，关闭
gpm
对鼠标的支持，如果你用 console 要以打开，常用 x-server 就关闭
haldaemon
HAL (Hardware Abstraction Layer) 这个必须打开
hplip, hpiod, hpssd
HP打印机支持程序，不使就HP打印机的就关闭吧
httpd
Apache HTTP Web Server
iptables
Linux 下的防火墙，好东东啊
ip6tables
IPv6 的防火墙，大部分用户可以半闭了
irda, irattach
IrDA 支持服务，大部分用户都不会用上
irqbalance
对多核多CPU的用户的服务，用VMware的没必要打开了
isdn
ISDN用户用的，关闭
kudzu
如果你不是经常的更换硬件就关闭它
lirc
红外遥控支持，没什么用处
lisa
和网上邻居的功能很像，如果用Samba 或 NFS 可以打开
lm_sensors
主板测试PC健康用的服务，如CPU，硬盘温度之些的，不用可以关掉
mcstrans
用于查看 context 的，用 SELinux 的可打开
mdmonitor
用于监视软 RAID 和 LVM 信息，你也可以关掉
messagebus
IPC (Interprocess Communication) 进程间通信服务，一个重要的服务，必须打开
nasd
声音支持，用于X Windows，不用的就半掉
netconsole
初始化网络控制台登陆，关闭
netfs
用于自动加载NFS，Samba的服务，不用可以关掉
netplugd
监测网络接口用的，普通用户关掉
nfs, nfslock
用于 Unix/Linux/BSD 之间的文件共享，不用就半掉
nmbd
Samba的一个服务，用于NETBeui名称解析用的
nscd
用于缓存密码的，没什么用
ntpd
NTP服务
pcscd
用于对子 Smart Cards 的支持，不用就半掉
readahead_early, readahead_later
优化程序的启动速度用的，果如你想启动的快些就打开
restorecond
用于监控文件用的，如果你用 SELinux 就打开它
rpcbind
RPC服务支持 (像 NFS or NIS). 如果没有服务依赖它可以关掉
rpcgssd, rpcidmapd, rpcsvcgssd
用于 NFS v4. 除非你使用 NFS v4, 关掉
sendmail
Linux 下的邮件服务器
setroubleshoot
这个程序提供信息给 setroubleshoot Browser，如果你用 SELinux 可以打开它
smartd
SMART，用于监测硬盘的，VMware用户关掉
smb
SAMBA 与Windows共享文件用
smolt
用于提供每月的一些统计表，不知什么用，关掉
sshd
用于SSH连接用的
yum-updatesd
用于在线自动升级的，建议打开
NetworkManager 为了自动连接网络的服务 　　　x　　　　对于服务器而言没用　　 
acpid 电源的on/off等的监视/管理 　　■ x 理由同上
anacron 一种计划任务管理 ■ ○ 
apmd 电源管理 ■ ○ 
atd 在指定时间执行命令 ■ x 如果用crond，就可以不用它
auditd 检查demo ■ △ 如果用Seliux，需要开启它 
autofs 文件系统自动加载卸载功能 ■ △ 只在需要的时候使用，可以停止
avahi-daemon 本地网络服务查找 ■ x 对服务器而言，不要
avahi-dnsconfd Avahi DNS demo x 理由同上
bluetooth 蓝牙无线通信 ■ x 对服务器而言，不要
clvmd Cluster LVM ■ ○ 对于非集群的服务器，关掉 
cman ■ ○ 对于非集群的服务器，关掉 
conman the console Manager x 不用那玩意，关掉
cpuspeed 调节cpu速度 ■ x 视情况而言吧，建议关掉
crond 与计划任务相当的功能 ■ ○ 强烈建议开启
cups 印刷demo ■ x 不用，关掉它
dnsmasq dns cache ■ x 不用，关掉它
dund 蓝牙设备相关 ■ x 不用，关掉它
firstboot 系统安装后初期设定工具 ■ x 不用，关掉它
gfs global file system ■ ○ 只有选择集群，集群存储是才有
gfs2 ■ ○ 同上
gpm console环境下的鼠标支持 ■ ○ 建议开启
haldaemon 硬件信息收集服务 ■ ○ 建议开启
hidd 蓝牙设备相关 ■ x 不用，关掉它
httpd apache demo ■ x 我不用，所以关掉它
ibmasm ibm硬件管理 ■ x 不用，关掉它
ip6tables ipv6防火墙 ■ △ 视情况，我不用它
ipmi Intelligent Platform Management Interface ■ △ 视情况
iptables ipv4防火墙 ■ △ 视情况，我不用它
ipvsadm 集群负荷分散相关 ■ ○ 我要用它
irda 红外线通信 ■ x 不用，关掉它
irqbalance cpu负载均衡 ■ ○ 多核cpu以上需要
kdump 内核崩溃时转储内存运行参数用的 ■ x 不用，关掉它
kudzu 硬件变动检测 ■ x 不用，关掉它
lm_sensors cpu温度检测工具(?) ■ △ 视情况，我不用它
luci cluster服务相关 ■ ○ 非集群情况下没有吧
lvm2-monitor lvm相关 ■ ○ 非集群情况下没有吧
mcstrans 在开启Selinux下用于检查context的 ■ x 视情况，我不用它
mdmonitor 软Raid管理工具 ■ ○ 视情况，我要用
mdmpd 软Raid管理监视工具 ■ ○ 视情况，我要用
messagebus D-Bus相关 ■ ○ 不用D-Bus情况下，关掉
microcode_ctl ■ x
modclusterd cluster相关 ■ ○ 视情况，我要用
multipathd ■ ○ 视情况，我要用
netconsole ■ x
netfs NFS相关 ■ x
netplugd 网线热插拔监视 ■ x
network ■ ○ 这个服务对服务器来说是必须的吧
nfs NFS Network File System ■ x
nfslock NFS相关 ■ x
nscd name cache，似乎跟DNS相关 ■ x
ntpd Network Time Protocol demo ■ x
oddjobd 与D-Bus相关 ■ x
openais 与Cluster相关，Heartbeat类似 ■ ○ 我要用
pand BlueZ Bluetooth PAN ■ x 蓝牙相关，不要
pcscd PC/SC smart card daemon ■ x
piranha-gui 与cluster相关 ■ ○ 我要用
portmap 使用NFS、NIS时的port map ■ x 如果用NFS时候，需要开启
psacct 负荷检测，输出什么的 ■ x
pulse ?
qdiskd 与cluster相关 ■ ○ 我要用 
rdisc 自动检测路由器 ■ x 只有一个路由器是不用
readahead_early ■ ○ 建议
readahead_later ■ ○ 建议
restorecond Selinux关联项目 ■ x 我的Selinux关掉了，所以它也over
rgmanager 与cluster相关 ■ ○ 我要用 
ricci 与cluster相关 ■ ○ 我要用 
rpcgssd NFS相关 ■ x 
rpcidmapd RPC name to UID/GID mapper ■ x NFS相关 
rpcsvcgssd NFS相关 ■ x 
saslauthd sasl认证服务相关 ■ x 
scsi_reserve 
sendmail mail demo ■ x 
setroubleshoot Selinux相关 ■ x 我的Selinux关掉了，所以它也over
smartd 硬盘自动检测的守护进程 ■ ○
smb Samba ■ x
snmpd ■ ○ 集群之间时间同步大概需要
snmptrapd ■ ○ 集群之间时间同步大概需要
sshd ssh demo ■ ○ 必须的
syslog ■ ○ 
tog-pegasus ■ ○ 似乎与集群相关
vncserver vncserver x
wdaemon 
winbind samba服务器相关 x
wpa_supplicant 无线认证相关 x
xfs x windows相关 ■ x
ypbind Network Information Service 客户端 ■ x
yum-updatesd yum自动升级 ■ x 对服务器来说开着它比较危险
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
天天用着linux，虽说经常配置php环境，可对于linux本身动的很少，这里就把常见的服务记下来，不用的就可以关闭了，节省资源还加速开关机时间。
不要关闭以下服务（除非你有充足的理由）：
acpid, haldaemon, messagebus, klogd, network, syslogd
请确定修改的是运行级别 3 和 5。
NetworkManager, NetworkManagerDispatcher
NetworkManager是一个后台服务程序，它构建于HAL之上，提供更专注于网络管理的功能。包括网络接口管理和网络状态查询，支持普通网络、拨号网络和无线网络，很多笔记本用户都需要启用该功能，它让你能够在无线网络和有线网络之间切换。大多数台式机用户应该关闭该服务。另外还提供VPN、 DHCP和DNS等附加功能。
主要用于笔记本的有线网络和无线网络之间的切换，有些 DHCP 用户会用到 . 建议 Disable
<http://www.redhat.com/magazine/003jan05/features/networkmanager/>
<http://blog.csdn.net/absurd/archive/2007/05/11/1605200.aspx>
acpid
ACPI（全称 Advanced Configuration and Power Interface）服务是电源管理接口。建议所有的笔记本用户开启它。一些服务器可能不需要 acpi。支持的通用操作有：“电源开关“，”电池监视“，”笔记本 Lid 开关“，“笔记本显示屏亮度“，“休眠”， “挂机”，等等。
高级电源管理，在 Fedora 7 中默认安装的，如果需要可以安装
anacron, atd, crond
这几个调度程序有很小的差别。 建议开启 cron，如果你的电脑将长时间运行，那就更应该开启它。对于服务器，应该更深入了解以确定应该开启哪个调度程序。大多数情况下，笔记本/台式机应该关闭 atd 和 anacron。注意：一些任务的执行需要 anacron，比如：清理 /tmp 或 /var。
Linux 里面的计划任务，cron 建议打开，其它两项关闭
alsasound
Alsa声卡驱动守护程序。Alsa声卡驱动程序本来是为了 一种声卡Gravis UltraSound(GUS)而写的，该程序被证明很优秀，于是作者就开始为一般的声卡写 驱动程序。 Alsa和OSS/Free 及OSS/Linux兼容，但是有自己的接 口，甚至比OSS优秀。
apmd
一些笔记本和旧的硬件使用 apmd。如果你的电脑支持 acpi，就应该关闭 apmd。如果支持 acpi，那么 apmd 的工作将会由 acpi 来完成。
arptables_jf
为arptables网络的用户控制过滤的守护进程。
arpwatch
记录日志并构建一个在LAN接口上看到的以太网地址和IP地址对数据库 。
atalk
AppleTalk网络守护进程。注意不要在后台运行该程序，该程序的数据结构必须在运行其他进程前先花一定时间初始化。
auditd
审核子系统可以被系统管理员用来监测系统调用和那些符合 CAPP 或其它审核要求的文件系统访问。它的主要内容包括：
· 默认情况下，审核在内核中被禁用。但是，当安装了 auditd 软件后，运行这个软件将会启动审核守护进程（auditd）。
· 当 auditd 运行的时候，审核信息会被发送到一个用户配置日志文件中（默认的文件是 /var/log/audit/audit.log）。如果 auditd 没有运行，审核信息会被发送到 syslog。这是通过默认的设置来把信息放入 /var/log/messages。如果审核子系统没有被启用，没有审核信息会被产生。
· 这些审核信息包括了 SELinux AVC 信息。以前，AVC 信息会被发送到 syslog，但现在会被审核守护进程发送到审核日志文件中。
· 要完全在内核中禁用审核，在启动的时候使用 audit=0 参数。您还需要使用 chkconfig auditd off 2345 来关闭 auditd。您可以在运行时使用 auditctl -e 0 来在内核中关闭审核。
审核守护进程（auditd）从内核的 audit netlink 接口获取审核事件数据。auditd 的配置会不尽相同，如输出文件配置和日志文件磁盘使用参数可以在 /etc/auditd.conf 文件中配置。请注意，如果您设置您的系统来进行 CAPP 风格的审核，您必须设置一个专用的磁盘分区来只供 audit 守护进程使用。这个分区应该挂载在 /var/log/audit。
系统管理员还可以使用 auditctl 工具程序来修改 auditd 守护进程运行时的审核参数、syscall 规则和文件系统的查看。它包括了一个 CAPP 配置样本，您可以把它拷贝到 /etc/audit.rules 来使它起作用。
审核日志数据可以通过 ausearch 工具程序来查看和搜索。
这个记录 kernel 的审计情况，相当于另外的一个 loggin 服务，用命令 auditctl 查看文件的变化情况，普通用户用不上可以关闭
autofs
该服务自动挂载可移动存储器（比如 USB 硬盘）。如果你使用移动介质（比如移动硬盘，U 盘），建议启用这个服务。
自动加裁文件系统，如果你用的移动设备建议打开，不然就关掉咯
avahi-daemon, avahi-dnsconfd
Avahi 是 zeroconf 协议的实现。它可以在没有 DNS 服务的局域网里发现基于 zeroconf 协议的设备和服务。它跟 mDNS 一样。除非你有兼容的设备或使用 zeroconf 协议的服务，否则应该关闭它。
相当于 mDNS 的一个软件，我也不知道干什么用的，建议关闭
bootparamd
引导参数服务器，为LAN上的无盘工作站提供引导所需的相关信息。
btseed, bttrack
和 BitTorrent 相关的服务，建议关闭
bluetooth, hcid, hidd, sdpd, dund, pand
蓝牙（Bluetooth）是给无线便携设备使用的（非 wifi, 802.11）。很多笔记本提供蓝牙支持。有蓝牙鼠标，蓝牙耳机和支持蓝牙的手机。很多人都没有蓝牙设备或蓝牙相关的服务，所以应该关闭它。其他蓝牙相关的服务有：hcid 管理所有可见的蓝牙设备，hidd 对输入设备（键盘，鼠标）提供支持， dund 支持通过蓝牙拨号连接网络，pand 允许你通过蓝牙连接以太网。
用于蓝牙设备的 deamon ，没有的可以关闭
capi
仅仅对使用 ISDN 设备的用户有用。大多数用户应该关闭它。
与ISDN相关的服务，一般用户都可以关闭

chargen
使用tcp协议的chargen server，chargen（Character Generator Protocol）是一种网络服务，主要功能是提供类似远程打字的功能。
chargen-udp
使用UDP协议的chargen server。
chargen-dgram
chargen-stream
conman
cpuspeed
该服务可以在运行时动态调节 CPU 的频率来节约能源（省电）。许多笔记本的 CPU 支持该特性，现在，越来越多的台式机也支持这个特性了。如果你的 CPU 是：Petium-M，Centrino，AMD PowerNow， Transmetta，Intel SpeedStep，Athlon-64，Athlon-X2，Intel Core 2 中的一款，就应该开启它。如果你想让你的 CPU 以固定频率运行的话就关闭它。

cupsd, cups-config-daemon, cups-lpd
以打印机相关的服务，有打印机可以打开
cvs
cvs 是一个版本控制系统。
daytime
使用TCP 协议的Daytime守护进程，该协议为客户机实现从远程服务器获取日期 和时间的功能。预设端口：13。
daytime-udp
使用UDP 协议的Daytime守护进程。
daytime-dgram
daytime-stream
dc_client, dc_server
磁盘缓存（Distcache）用于分布式的会话缓存。主要用在 SSL/TLS 服务器。它可以被 Apache 使用。大多数的台式机应该关闭它。

dhcdbd
这是一个让 DBUS 系统控制 DHCP 的接口。可以保留默认的关闭状态。DHCP相关服务，使用DHCP的人打开，用固定IP的关闭就行了
diskdump, netdump
磁盘转储（Diskdump）用来帮助调试内核崩溃。内核崩溃后它将保存一个 “dump“ 文件以供分析之用。网络转储（Netdump）的功能跟 Diskdump 差不多，只不过它可以通过网络来存储。除非你在诊断内核相关的问题，它们应该被关闭。
discard-dgram
discard-stream
dnsmasq
DNSmasq是一个轻巧的，容易使用的DNS服务工具，它可以应用在内部网和Internet连接的时候的IP地址NAT转换，也可以用做小型网络的 DNS服务。
echo
服务器回显客户数据服务守护进程。
echo-udp
使用UDP协议的服务器回显客户数据服务守护进程。
echo-dgram
echo-stream
eklogin
接受rlogin会话鉴证和用kerberos5加密的一种服务的守护进程。
ekrb5-telnet
firstboot
该服务是 Fedora 安装过程特有的。它执行在安装之后的第一次启动时仅仅需要执行一次的特定任务。它可以被关闭。用于第一启动相关的设置，关闭
functions
gated
网关路由守护进程。它支持各种路由协议，包括RIP版本1和2、DCN HELLO协议、 OSPF版本2以及EGP版本2到4。
gpm
终端鼠标指针支持（无图形界面）。如果你不使用文本终端（CTRL-ALT-F1, F2..），那就关闭它。不过，我在运行级别 3 开启它，在运行级别 5 关闭它。对鼠标的支持，如果你用 console 要以打开，常用 x-server 就关闭
gssftp
使用kerberos 5认证的ftp守护进程。
haldaemon
HAL (Hardware Abstraction Layer) 这个必须打开
halt
hplip, hpiod, hpssd
HPLIP 服务在 Linux 系统上实现 HP 打印机支持，包括 Inkjet，DeskJet，OfficeJet，Photosmart，Business InkJet 和一部分 LaserJet 打印机。这是 HP 赞助的惠普 Linux 打印项目（HP Linux Printing Project）的产物。如果你有相兼容的打印机，那就启用它。HP打印机支持程序，不使就HP打印机的就关闭吧
hsqldb
一个java的关系型数据库守护进程，得名于Hypersonic SQL，但这个项目已经没有再继续了。
httpd
Web服务器Apache守护进程，可用来提供HTML文件以 及CGI动态内容服务。
innd
Usenet新闻服务器守护进程。
iiim
中文输入法服务器守护进程。
inetd
因特网操作守护程序。监控网络对各种它管理的服务的需求，并在必要的时候启动相应的服务程序。在Redhat 和Mandrake linux中被xinetd代替。Debian, Slackware, SuSE仍然使用。
ip6tables
如果你不知道你是否在使用 IPv6，大部分情况下说明你没有使用。该服务是用于 IPv6 的软件防火墙。大多数用户都应该关闭它。
ipmi
iptables
它是 Linux 标准的防火墙（软件防火墙）。如果你直接连接到互联网（如，cable，DSL，T1），建议开启它。如果你使用硬件防火墙（比如：D- Link，Netgear，Linksys 等等），可以关闭它。强烈建议开启它。Linux 下的防火墙，好东东啊
irda, irattach
IrDA 支持服务，大部分用户都不会用上,IrDA 提供红外线设备（笔记本，PDA’s，手机，计算器等等）间的通讯支持。大多数用户应该关闭它。
irqbalance
在多处理器系统中，启用该服务可以提高系统性能。大多数人不使用多处理器系统，所以关闭它。但是我不知道它作用于多核 CPU’s 或 超线程 CPU’s 系统的效果。在单 CPU 系统中关闭它应该不会出现问题。对多核多CPU的用户的服务，用VMware的没必要打开了
isdn
这是一种互联网的接入方式。除非你使用 ISDN 猫来上网，否则你应该关闭它。
lirc
红外遥控支持，没什么用处
lisa
和网上邻居的功能很像，如果用Samba 或 NFS 可以打开
lm_sensors
主板测试PC健康用的服务，如CPU，硬盘温度之些的，不用可以关掉
keytable
该进程的功能是转载在/etc/sysconfig/keyboards里定义的键盘映射表，该表可以通过kbdconfig工具进行选择。您应该使该程序处于激活状态。
kdump
klogin
远程登陆守护进程。
krb5-telnet
使用kerberos 5认证的telnet守护进程。
kshell
kshell守护进程。
killall
krb524
kudzu
该服务进行硬件探测，并进行配置。如果更换硬件或需要探测硬件更动，开启它。但是绝大部分的台式机和服务器都可以关闭它，仅仅在需要时启动。如果你不是经常的更换硬件就关闭它
ldap
ldap（Lightweight Directory Access Protocol）目录访问协议服务器守护进程。
libvirtd
lm_sensors
该服务可以探测主板感应器件的值或者特定硬件的状态（一般用于笔记本电脑）。你可以通过它来查看电脑的实时状态，了解电脑的健康状况。它在 GKrellM 用户中比较流行。如果没有特殊理由，建议关闭它。
lvm2-monitor
mcstrans
SELinux转换服务，如果你使用 SELinux 就开启它，但你也可以关闭。用于查看 context 的，用 SELinux 的可打开
mdmonitor
该服务用来监测 Software RAID 或 LVM 的信息。它不是一个关键性的服务，可以关闭它。用于监视软 RAID 和 LVM 信息，你也可以关掉
mdmpd
该服务用来监测 Multi-Path 设备（该类型的存储设备能被一种以上的控制器或方法访问）。它应该被关闭。
messagebus
这是 Linux 的 IPC（Interprocess Communication，进程间通讯）服务。确切地说，它与 DBUS 交互，是重要的系统服务。强烈建议开启它。
IPC (Interprocess Communication) 进程间通信服务，一个重要的服务，必须打开
multipathd, microcode_ctl
可编码以及发送新的微代码到内核以更新Intel IA32系列处理器守护进程。
mysqld
一个快速高效可靠的轻型SQL数据库引擎守护进程。
named
DNS（BIND）服务器守护进程。
netconsole
初始化网络控制台登陆，关闭
nasd
声音支持，用于X Windows，不用的就半掉
netfs
该服务用于在系统启动时自动挂载网络中的共享文件空间，比如：NFS，Samba 等等。如果你连接到局域网中的其它服务器并进行文件共享，就开启它。大多数台式机和笔记本用户应该关闭它。
netplugd, ifplugd
Netplugd 用于监测网络接口并在接口状态改变时执行指定命令。建议保留它的默认关闭状态。监测网络接口用的，普通用户关掉
network
激活/关闭启动时的各个网络接口守护进程。
nfs, nfslock
这是用于 Unix/Linux/BSD 系列操作系统的标准文件共享方式。除非你需要以这种方式共享数据，否则关闭它。
nscd
服务名缓存进程，它为NIS和LDAP等服务提供更快的验证，如果你运行这些服务，那你应该开启它。用于缓存密码的，没什么用
nmbd
Samba的一个服务，用于NETBeui名称解析用的
ntpd
该服务通过互联网自动更新系统时间。如果你能永久保持互联网连接，建议开启它，但不是必须的。
pcscd
该服务提供智能卡（和嵌入在信用卡，识别卡里的小芯片一样大小）和智能卡读卡器支持。如果你没有读卡器设备，就关闭它。
pcmcia
主要用于支持笔记本电脑接口守护进程。
portmap
该服务是 NFS（文件共享）和 NIS（验证）的补充。除非你使用 NFS 或 NIS 服务，否则关闭它。
postgresql
PostgreSQL 关系数据库引擎。
pppoe
ADSL连接守护进程。
proftpd
proftpd 是Unix下的一个配置灵活的ftp服务器的守护程序。
psacct
该守护进程包括几个工具用来监控进程活动的工具，包括ac,lastcomm, accton和sa。
random
保存和恢复系统的高质量随机数生成器，这些随机数是系统一些随机行为提供的。
rawdevices
在使用集群文件系统时用于加载raw设备的守护进程。
rdisc
readahead_early, readahead_later
该服务通过预先加载特定的应用程序到内存中以提供性能。如果你想程序启动更快，就开启它。
restorecond
用于给 SELinux 监测和重新加载正确的文件上下文（file contexts）。它不是必须的，但如果你使用 SELinux 的话强烈建议开启它。
rhnsd
Red Hat 网络服务守护进程。通知官方的安全信息以及为系统打补丁。
routed
该守护程序支持RIP协议的自动IP路由表维护。RIP主要 使用在小型网络上，大一点的网络就需要复杂一点的协议。
rpcgssd, rpcidmapd, rpcsvcgssd
用于 NFS v4。除非你需要或使用 NFS v4，否则关闭它。
rsync
remote sync远程数据备份守护进程。
rsh
远程主机上启动一个shell，并执行用户命令。
rwhod
允许远程用户获得运行rwho守护程序的机器上所有已登录用户的列表。
rstatd
一个为LAN上的其它机器收集和提供系统信息的守候进程。
ruserd
远程用户定位服务，这是一个基于RPC的服务，它提供关于当前记录到LAN上一个机器日志中的用户信息。
rwalld
激活rpc.rwall服务进程，这是一项基于RPC的服务，允许用户给每个注册到LAN机器上的其他终端写消息。
rwhod：激活rwhod服务进程，它支持LAN的rwho和ruptime服务。
saslauthd
使用SASL的认证守护进程。
sendmail
除非你管理一个邮件服务器或你想 在局域网内传递或支持一个共享的 IMAP 或 POP3 服务。大多数人不需要一个邮件传输代理。如果你通过网页（hotmail/yahoo/gmail）或使用邮件收发程序（比如：Thunderbird， Kmail，Evolution 等等）收发邮件。你应该关闭它。
setroubleshoot
查看selinux日志的程序,这个程序提供信息给 setroubleshoot Browser，如果你用 SELinux 可以打开它
squid
代理服务器squid守护进程。
smartd
SMART Disk Monitoring 服务用于监测并预测磁盘失败或磁盘问题（前提：磁盘必须支持 SMART）。大多数的桌面用户不需要该服务，但建议开启它，特别是服务器。SMART，用于监测硬盘的，VMware用户关掉
smb
SAMBA 服务是在 Linux 和 Windows 之间共享文件必须的服务。如果有 Windows 用户需要访问 Linux 上的文件，就启用它。
snmpd
本地简单网络管理守护进程。
sshd
SSH 允许其他用户登录到你的系统并执行程序，该用户可以和你同一网络，也可以是远程用户。开启它存在潜在的安全隐患。如果你不需要从其它机器或不需要从远程登录，就应该关闭它。
syslog
tcpmux-server
tftp
time
该守护进程从远程主机获取时间和日期，采用TCP协议。
time-udp
该守护进程从远程主机获取时间和日期，采用UDP协议。
time-dgram
time-stream
tux
在Linux内核中运行apache服务器的守护进程。
vsftpd
vsftpd服务器的守护进程
vmware-tools
vmware-tools，虚拟机中装了vmware-tools包之后才会有的。
vncserver
VNC （Virtual Network Computing，虚拟网络计算），它提供了一种在本地系统上显示远程计算机整个”桌面”的轻量型协议。
winbind
Winbind 是一款 Samba 组件，在 CentOS 系统下，他被包含在了 samba-common 包中。 Winbind 在Linux上实现了微软的RPC调用、可插式验证模块和名字服务切换，通过 samba 接口与 Windows 域控获得联系，可以使NT域用户能在Linux主机上以Linux用户身份进行操作。通过设定 Linux 服务器的 nss 配置，我们可以让系统通过 Winbind 程序来解析用户信息。
wpa_supplicant
无线网卡上网服务
xend, xendomains
XEN虚拟服务相关
xfs
X Window字型服务器守护进程，为本地和远程X服务器提供字型集。
xinetd
（该服务默认可能不被安装）它是一个特殊的服务。它可以根据特定端口收到的请求启动多个服务。比如：典型的 telnet 程序连接到 23 号端口。如果有 telent 请求在 23 号端口被 xinetd 探测到，那 xinetd 将启动 telnetd 服务来响应该请求。为了使用方便，可以开启它。运行 chkconfig -list， 通过检查 xinetd 相关的输出可以知道有哪些服务被 xinetd 管理。
ypbind
为NIS（网络信息系统）客户机激活ypbind服务进程 。
yppasswdd
NIS口令服务器守护进程。
ypserv
NIS主服务器守护进程。
yum, yum-updatesd
RPM操作系统自动升级和软件包管理守护进程。
ConsoleKit
这个主要是 Gnome 使用的用于 Fedora - Fast User Switching ，主要用于自动加载 device 和 Power Management. 建议 Disable





