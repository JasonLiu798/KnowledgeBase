#LVS
---
---
#LVS主要组成部分
##负载调度器(load balancer/ Director)
它是整个集群对外面的前端机，负责将客户的请求发送到一组服务器上执行，而客户认为服务是来自一个IP地址(我们可称之为虚拟IP地址)上的。
##服务器池(server pool/ Realserver)
一组真正执行客户请求的服务器，执行的服务一般有WEB、MAIL、FTP和DNS等。
##共享存储(shared storage)
它为服务器池提供一个共享的存储区，这样很容易使得服务器池拥有相同的内容，提供相同的服务。





---
#DR模式：(Direct Routing)直接路由模式
##工作过程
当一个client发送一个WEB请求到VIP，LVS服务器根据VIP选择对应的real-server的Pool，根据算法，在Pool中选择一台Real-server，LVS在hash表中记录该次连接，然后将client的请求包发给选择的Real-server，最后选择的Real-server把应答包直接传给client；当client继续发包过来时，LVS根据更才记录的hash表的信息，将属于此次连接的请求直接发到刚才选择的Real-server上；当连接中止或者超时，hash表中的记录将被删除。

##细节：
* LVS和Real-server必须在相同的网段
DR模式在转发client的包时，只修改了包目的MAC地址为选定的Real-server的mac地址，所以如果LVS和Real-server在不通的广播域内，那么Real-server就没办法接收到转发的包。下面是mac地址的修改过程：

* LVS不需要开启路由转发
LVS的DR模式不需要开启路由转发功能，就可以正常的工作，出于安全考虑，如果不需要转发功能，最好关闭。

* ARP问题
通常，DR模式需要在Real-server上配置VIP，配置的方式为：
/sbin/ifconfig lo:0 inet VIP netmask 255.255.255.255
原因在于，当LVS把client的包转发给Real-server时，因为包的目的IP地址是VIP，那么如果Real-server收到这个包后，发现包的目的IP不是自己的系统IP，那么就会认为这个包不是发给自己的，就会丢弃这个包，所以需要将这个IP地址绑到网卡上；
当发送应答包给client时，Real-server就会把包的源和目的地址调换，直接回复给client

* 关于ARP广播
上面绑定VIP的掩码是”255.255.255.255″，说明广播地址是其本身，那么他就不会将ARP发送到实际的自己该属于的广播域了，这样防止与LVS上VIP冲突，而导致IP冲突。
另外在Linux的Real-server上，需要设置ARP的sysctl选项:（下面是举例说明设置项的）
假设服务器上ip地址如下所示:
```
System Interface MAC Address IP Address
HN eth0 00:0c:29:b3:a2:54 192.168.18.10
HN eth3 00:0c:29:b3:a2:68 192.168.18.11
HN eth4 00:0c:29:b3:a2:5e 192.168.18.12
client eth0 00:0c:29:d2:c7:aa 192.168.18.129
```

当我从192.168.18.129 ping 192.168.18.10时，tcpdump抓包发现:
```
00:0c:29:d2:c7:aa > ff:ff:ff:ff:ff:ff, ARP, length 60: arp who-has 192.168.18.10 tell 192.168.18.129
00:0c:29:b3:a2:5e > 00:0c:29:d2:c7:aa, ARP, length 60: arp reply 192.168.18.10 is-at 00:0c:29:b3:a2:5e
00:0c:29:b3:a2:54 > 00:0c:29:d2:c7:aa, ARP, length 60: arp reply 192.168.18.10 is-at 00:0c:29:b3:a2:54
00:0c:29:b3:a2:68 > 00:0c:29:d2:c7:aa, ARP, length 60: arp reply 192.168.18.10 is-at 00:0c:29:b3:a2:68
00:0c:29:d2:c7:aa > 00:0c:29:b3:a2:5e, IPv4, length 98: 192.168.18.129 > 192.168.18.10: ICMP echo request, id 32313, seq 1, length 64
00:0c:29:b3:a2:54 > 00:0c:29:d2:c7:aa, IPv4, length 98: 192.168.18.10 > 192.168.18.129: ICMP echo reply, id 32313, seq 1, length 64
00:0c:29:d2:c7:aa > 00:0c:29:b3:a2:5e, IPv4, length 98: 192.168.18.129 > 192.168.18.10: ICMP echo request, id 32313, seq 2, length 64
00:0c:29:b3:a2:54 > 00:0c:29:d2:c7:aa, IPv4, length 98: 192.168.18.10 > 192.168.18.129: ICMP echo reply, id 32313, seq 2, length 64
00:0c:29:b3:a2:54 > 00:0c:29:d2:c7:aa, ARP, length 60: arp who-has 192.168.18.129 tell 192.168.18.10
00:0c:29:d2:c7:aa > 00:0c:29:b3:a2:54, ARP, length 60: arp reply 192.168.18.129 is-at 00:0c:29:d2:c7:aa
```
三个端口都发送了arp的reply包，但是192.168.18.129使用的第一个回应的eth4的mac地址作为ping请求的端口，由于192.168.18.10是icmp包中的目的地址，那么ping的应答包，会从eth0端口发出。
如果Real-server有个多个网卡，每个网卡在不同的网段，那么可以过滤掉非本网卡ARP请求的回应；但是如果多个网卡的ip在一个网段，那么就不行了。
```
sysctl -w net.ipv4.conf.all.arp_filter=1
```
对于多个接口在相同网段可以设置下面的来防止：
```
sysctl -w net.ipv4.conf.all.arp_ignore=1
sysctl -w net.ipv4.conf.all.arp_announce=2
```
还是从192.168.18.129 ping 192.168.18.10时，tcpdump抓包发现:
```
00:0c:29:d2:c7:aa > ff:ff:ff:ff:ff:ff, ARP, length 60: arp who-has 192.168.18.10 tell 192.168.18.129
00:0c:29:b3:a2:54 > 00:0c:29:d2:c7:aa, ARP, length 60: arp reply 192.168.18.10 is-at 00:0c:29:b3:a2:54
00:0c:29:d2:c7:aa > 00:0c:29:b3:a2:54, IPv4, length 98: 192.168.18.129 > 192.168.18.10: ICMP echo request, id 32066, seq 1, length 64
00:0c:29:b3:a2:54 > 00:0c:29:d2:c7:aa, IPv4, length 98: 192.168.18.10 > 192.168.18.129: ICMP echo reply, id 32066, seq 1, length 64
00:0c:29:d2:c7:aa > 00:0c:29:b3:a2:54, IPv4, length 98: 192.168.18.129 > 192.168.18.10: ICMP echo request, id 32066, seq 2, length 64
00:0c:29:b3:a2:54 > 00:0c:29:d2:c7:aa, IPv4, length 98: 192.168.18.10 > 192.168.18.129: ICMP echo reply, id 32066, seq 2, length 64
00:0c:29:b3:a2:54 > 00:0c:29:d2:c7:aa, ARP, length 60: arp who-has 192.168.18.129 tell 192.168.18.10
00:0c:29:d2:c7:aa > 00:0c:29:b3:a2:54, ARP, length 60: arp reply 192.168.18.129 is-at 00:0c:29:d2:c7:aa
```
看到了么，现在只有eth0会回应arp请求了。

arp报文格式：
请求报文：MAC地址字段是空的。 应答报文：所有字段都又内容。:
```
The arp_announce/arp_ignore reference：

arp_announce – INTEGER
Define different restriction levels for announcing the local
source IP address from IP packets in ARP requests sent on
interface:
0 – (default) Use any local address, configured on any interface
1 – Try to avoid local addresses that are not in the target’s
subnet for this interface. This mode is useful when target
hosts reachable via this interface require the source IP
address in ARP requests to be part of their logical network
configured on the receiving interface. When we generate the
request we will check all our subnets that include the
target IP and will preserve the source address if it is from
such subnet. If there is no such subnet we select source
address according to the rules for level 2.
2 – Always use the best local address for this target.
In this mode we ignore the source address in the IP packet
and try to select local address that we prefer for talks with
the target host. Such local address is selected by looking
for primary IP addresses on all our subnets on the outgoing
interface that include the target IP address. If no suitable
local address is found we select the first local address
we have on the outgoing interface or on all other interfaces,
with the hope we will receive reply for our request and
even sometimes no matter the source IP address we announce.

The max value from conf/{all,interface}/arp_announce is used.

Increasing the restriction level gives more chance for
receiving answer from the resolved target while decreasing
the level announces more valid sender’s information.
```
arp_announce 用来限制，是否使用发送的端口的ip地址来设置ARP的源地址：

“0″代表是用ip包的源地址来设置ARP请求的源地址。
“1″代表不使用ip包的源地址来设置ARP请求的源地址，如果ip包的源地址是和该端口的IP地址相同的子网，那么用ip包的源地址，来设置ARP请求的源地址，否则使用”2″的设置。
“2″代表不使用ip包的源地址来设置ARP请求的源地址，而由系统来选择最好的接口来发送。
当内网的机器要发送一个到外部的ip包，那么它就会请求路由器的Mac地址，发送一个arp请求，这个arp请求里面包括了自己的ip地址和Mac地址，而linux默认是使用ip的源ip地址作为arp里面的源ip地址，而不是使用发送设备上面的 ，这样在lvs这样的架构下，所有发送包都是同一个VIP地址，那么arp请求就会包括VIP地址和设备 Mac，而路由器收到这个arp请求就会更新自己的arp缓存，这样就会造成ip欺骗了，VIP被抢夺，所以就会有问题。

现在假设一个场景来解释 arp_announce ：
```
Real-server的ip地址：202.106.1.100(public local address)，
172.16.1.100(private local address)，
202.106.1.254(VIP)
```
如果发送到client的ip包产生的arp请求的源地址是202.106.1.254(VIP),那么LVS上的VIP就会被冲掉，因为交换机上现在的arp对应关系是Real-server上的VIP对应自己的一个MAC，那么LVS上的VIP就失效了。:
```
arp_ignore – INTEGER
Define different modes for sending replies in response to
received ARP requests that resolve local target IP addresses:
0 – (default): reply for any local target IP address, configured
on any interface
1 – reply only if the target IP address is local address
configured on the incoming interface
2 – reply only if the target IP address is local address
configured on the incoming interface and both with the
sender’s IP address are part from same subnet on this interface
3 – do not reply for local addresses configured with scope host,
only resolutions for global and link addresses are replied
4-7 – reserved
8 – do not reply for all local addresses

The max value from conf/{all,interface}/arp_ignore is used
when ARP request is received on the {interface}
```

“0″,代表对于arp请求，任何配置在本地的目的ip地址都会回应，不管该arp请求的目的地址是不是接口的ip；如果有多个网卡，并且网卡的ip都是一个子网，那么从一个端口进来的arp请求，别的端口也会发送回应。 “1″,代表如果arp请求的目的地址，不是该arp请求包进入的接口的ip地址，那么不回应。 “2″,要求的更苛刻，除了”1″的条件外，还必须要求arp发送者的ip地址和arp请求进入的接口的ip地址是一个网段的。 (后面略)

---
#IP Tunneling模式
##IP Tunneling的工作过程
1> client 发送request包到LVS服务器的VIP上。
2> VIP按照算法选择后端的一个Real-server，并将记录一条消息到hash表中，然后将client的request包封装到一个 *新的IP包* 里，新IP包的目的IP是Real-server的IP，然后转发给Real-server。
3> Real-server收到包后，解封装，取出client的request包，发现他的目的地址是VIP，而Real-server发现在自己的lo:0口上有这个IP地址，于是处理client的请求，然后将relpy这个request包直接发给client。
4> 该client的后面的request包，LVS直接按照hash表中的记录直接转发给Real-server，当传输完毕或者连接超时，那么将删除hash表中的记录。

##细节问题
* LVS和Real-server不需要在一个网段 	
由于通过IP Tunneling 封装后，封装后的IP包的目的地址为Real-server的IP地址，那么只要Real-server的地址能路由可达，Real-server在什么网络里都可以，这样可以减少对于公网IP地址的消耗，但是因为要处理IP Tunneling封装和解封装的开销，那么效率不如DR模式。

* Real-server的系统设置
由于需要Real-server支持IP Tunneling，所以设置与DR模式不太一样，LVS不需要设置tunl设备，LVS本身可以进行封装 i) 需要配置VIP在tunl设备上：(VIP：172.16.1.254)
```
shell> ifconfig tunl0 172.16.1.254 netmask 255.255.255.255
shell> ifconfig tunl0
tunl0 Link encap:IPIP Tunnel HWaddr
inet addr:172.16.1.254 Mask:255.255.255.255
UP RUNNING NOARP MTU:1480 Metric:1
RX packets:0 errors:0 dropped:0 overruns:0 frame:0
TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:0
RX bytes:0 (0.0 b) TX bytes:0 (0.0 b)
```
当添加tunl0设备时，自动载入需要的模块：
```
shell> lsmod |grep ipip
ipip 7516 0
tunnel4 2700 1 ipip
```
其中，ipip依赖于tunnel4，假如现在删除tunnel4的话：
```
shell> rmmod tunnel4
ERROR: Module tunnel4 is in use by ipip
```
如果添加tunl0失败，那么可能是内核没有开启tunneling功能，默认是以模块形式，加载到内核里的

* ARP问题
如果LVS和Real-server不在一个网络内，不需要处理ARP问题，如果在相同网络，那么处理方法和DR模式一样，但是如果一样，我就不知道选择tun模式有什么好理由了，DR似乎效率更高些吧。

* 内核的包转发
IP Tunneling模式不需要开启ip_forward功能。







lvs、haproxy、nginx 负载均衡的比较分析

从性能和稳定上还是LVS最牛，基本达到了F5硬件设备的60%性能，其他几个10%都有点困难。
     不过就因为LVS忒牛了，配置也最麻烦了，而且健康检测需要另外配置Ldirector，其他HAPROXY和NGINX自己就用，而且配置超级简单。
 
     所以小D建议，如果网站访问量不是门户级别的用HAPROXY或者NGINX就OK了，到了门户级别在用LVS+Idirector吧 哈哈
    lvs和nginx都可以用作多机负载的方案，它们各有优缺，在生产环境中需要好好分析实际情况并加以利用。

首先提醒，做技术切不可人云亦云，我云即你云；同时也不可太趋向保守，过于相信旧有方式而等别人来帮你做垫被测试。把所有即时听说到的好东西加以钻研，从而提高自己对技术的认知和水平，乃是一个好习惯。

#LVS工作模式
DR
NAT
TUNNEL
Full-NAT


下面来分析一下两者：

LVS优势：
1、抗负载能力强，因为lvs工作方式的逻辑是非常之简单，而且工作在网络4层仅做请求分发之用，没有流量，所以在效率上基本不需要太过考虑。在我手里的 lvs，仅仅出过一次问题：在并发最高的一小段时间内均衡器出现丢包现象，据分析为网络问题，即网卡或linux2.4内核的承载能力已到上限，内存和 cpu方面基本无消耗。

2、配置性低，这通常是一大劣势，但同时也是一大优势，因为没有太多可配置的选项，所以除了增减服务器，并不需要经常去触碰它，大大减少了人为出错的几率。

3、工作稳定
因为其本身抗负载能力很强，所以稳定性高也是顺理成章，另外各种lvs都有完整的双机热备方案，所以一点不用担心均衡器本身会出什么问题，节点出现故障的话，lvs会自动判别，所以系统整体是非常稳定的。

4、无流量
上面已经有所提及了。lvs仅仅分发请求，而流量并不从它本身出去，所以可以利用它这点来做一些线路分流之用。没有流量同时也保住了均衡器的IO性能不会受到大流量的影响。

5、基本上能支持所有应用，因为lvs工作在4层，所以它可以对几乎所有应用做负载均衡，包括http、数据库、聊天室等等。

另：lvs也不是完全能判别节点故障的，譬如在wlc分配方式下，集群里有一个节点没有配置VIP，会使整个集群不能使用，这时使用wrr分配方式则会丢掉一台机。目前这个问题还在进一步测试中。所以，用lvs也得多多当心为妙。


二、nginx和lvs作对比的结果

1、nginx工作在网络的7层，所以它可以针对http应用本身来做分流策略，比如针对域名、目录结构等，相比之下lvs并不具备这样的功能，所以 nginx单凭这点可利用的场合就远多于lvs了；但nginx有用的这些功能使其可调整度要高于lvs，所以经常要去触碰触碰，由lvs的第2条优点 看，触碰多了，人为出问题的几率也就会大。

2、nginx对网络的依赖较小，理论上只要ping得通，网页访问正常，nginx就能连得通，nginx同时还能区分内外网，如果是同时拥有内外网的 节点，就相当于单机拥有了备份线路；lvs就比较依赖于网络环境，目前来看服务器在同一网段内并且lvs使用direct方式分流，效果较能得到保证。另 外注意，lvs需要向托管商至少申请多一个ip来做Visual IP，貌似是不能用本身的IP来做VIP的。要做好LVS管理员，确实得跟进学习很多有关网络通信方面的知识，就不再是一个HTTP那么简单了。

3、nginx安装和配置比较简单，测试起来也很方便，因为它基本能把错误用日志打印出来。lvs的安装和配置、测试就要花比较长的时间了，因为同上所述，lvs对网络依赖比较大，很多时候不能配置成功都是因为网络问题而不是配置问题，出了问题要解决也相应的会麻烦得多。

4、nginx也同样能承受很高负载且稳定，但负载度和稳定度差lvs还有几个等级：nginx处理所有流量所以受限于机器IO和配置；本身的bug也还是难以避免的；nginx没有现成的双机热备方案，所以跑在单机上还是风险较大，单机上的事情全都很难说。

5、nginx可以检测到服务器内部的故障，比如根据服务器处理网页返回的状态码、超时等等，并且会把返回错误的请求重新提交到另一个节点。目前lvs中 ldirectd也能支持针对服务器内部的情况来监控，但lvs的原理使其不能重发请求。重发请求这点，譬如用户正在上传一个文件，而处理该上传的节点刚 好在上传过程中出现故障，nginx会把上传切到另一台服务器重新处理，而lvs就直接断掉了，如果是上传一个很大的文件或者很重要的文件的话，用户可能 会因此而恼火。

6、nginx对请求的异步处理可以帮助节点服务器减轻负载，假如使用apache直接对外服务，那么出现很多的窄带链接时apache服务器将会占用大 量内存而不能释放，使用多一个nginx做apache代理的话，这些窄带链接会被nginx挡住，apache上就不会堆积过多的请求，这样就减少了相 当多的内存占用。这点使用squid也有相同的作用，即使squid本身配置为不缓存，对apache还是有很大帮助的。lvs没有这些功能，也就无法能 比较。

7、nginx能支持http和email（email的功能估计比较少人用），lvs所支持的应用在这点上会比nginx更多。

在使用上，一般最前端所采取的策略应是lvs，也就是DNS的指向应为lvs均衡器，lvs的优点令它非常适合做这个任务。

重要的ip地址，最好交由lvs托管，比如数据库的ip、webservice服务器的ip等等，这些ip地址随着时间推移，使用面会越来越大，如果更换ip则故障会接踵而至。所以将这些重要ip交给lvs托管是最为稳妥的，这样做的唯一缺点是需要的VIP数量会比较多。

nginx可作为lvs节点机器使用，一是可以利用nginx的功能，二是可以利用nginx的性能。当然这一层面也可以直接使用squid，squid的功能方面就比nginx弱不少了，性能上也有所逊色于nginx。

nginx也可作为中层代理使用，这一层面nginx基本上无对手，唯一可以撼动nginx的就只有lighttpd了，不过lighttpd目前还没有 能做到nginx完全的功能，配置也不那么清晰易读。另外，中层代理的IP也是重要的，所以中层代理也拥有一个VIP和lvs是最完美的方案了。

nginx也可作为网页静态服务器，不过超出了本文讨论的范畴，简单提一下。

具体的应用还得具体分析，如果是比较小的网站（日PV<1000万），用nginx就完全可以了，如果机器也不少，可以用DNS轮询，lvs所耗费的机器还是比较多的；大型网站或者重要的服务，机器不发愁的时候，要多多考虑利用lvs。
****************************************************************************************************************
Nginx的优点:
性能好，可以负载超过1万的并发。
功能多，除了负载均衡，还能作Web服务器，而且可以通过Geo模块来实现流量分配。
社区活跃，第三方补丁和模块很多
支持gzip proxy
缺点:
不支持session保持。
对后端realserver的健康检查功能效果不好。而且只支持通过端口来检测，不支持通过url来检测。
nginx对big request header的支持不是很好，如果client_header_buffer_size设置的比较小，就会返回400bad request页面。
Haproxy的优点:
它的优点正好可以补充nginx的缺点。支持session保持，同时支持通过获取指定的url来检测后端服务器的状态。
支持tcp模式的负载均衡。比如可以给MySQL的从服务器集群和邮件服务器做负载均衡。
缺点：
不支持虚拟主机(这个很傻啊)
目前没有nagios和cacti的性能监控模板
LVS的优点:
性能好，接近硬件设备的网络吞吐和连接负载能力。
LVS的DR模式，支持通过广域网进行负载均衡。这个其他任何负载均衡软件目前都不具备。
缺点：
比较重型。另外社区不如nginx活跃。
*************************************************************************************
现在网络中常见的的负载均衡主要分为两种：一种是通过硬件来进行进行，常见的硬件有比较昂贵的NetScaler、F5、Radware和Array等商用的负载均衡器，也有类似于LVS、Nginx、HAproxy的基于Linux的开源的负载均衡策略,
商用负载均衡里面NetScaler从效果上比F5的效率上更高。对于负载均衡器来说，不过商用负载均衡由于可以建立在四~七层协议之上，因此适用 面更广所以有其不可替代性，他的优点就是有专业的维护团队来对这些服务进行维护、缺点就是花销太大，所以对于规模较小的网络服务来说暂时还没有需要使用。
另一种负载均衡的方式是通过软件：比较常见的有LVS、Nginx、HAproxy等，其中LVS是建立在四层协议上面的，而另外Nginx和HAproxy是建立在七层协议之上的，下面分别介绍关于
LVS：使用集群技术和Linux操作系统实现一个高性能、高可用的服务器，它具有很好的可伸缩性（Scalability）、可靠性（Reliability）和可管理性（Manageability）。
LVS的特点是：
1、抗负载能力强、是工作在网络4层之上仅作分发之用，没有流量的产生；
2、配置性比较低，这是一个缺点也是一个优点，因为没有可太多配置的东西，所以并不需要太多接触，大大减少了人为出错的几率；
3、工作稳定，自身有完整的双机热备方案；
4、无流量，保证了均衡器IO的性能不会收到大流量的影响；
5、应用范围比较广，可以对所有应用做负载均衡；
6、LVS需要向IDC多申请一个IP来做Visual IP，因此需要一定的网络知识，所以对操作人的要求比较高。
Nginx的特点是：
1、工作在网络的7层之上，可以针对http应用做一些分流的策略，比如针对域名、目录结构；
2、Nginx对网络的依赖比较小；
3、Nginx安装和配置比较简单，测试起来比较方便；
4、也可以承担高的负载压力且稳定，一般能支撑超过1万次的并发；
5、Nginx可以通过端口检测到服务器内部的故障，比如根据服务器处理网页返回的状态码、超时等等，并且会把返回错误的请求重新提交到另一个节点，不过其中缺点就是不支持url来检测；
6、Nginx对请求的异步处理可以帮助节点服务器减轻负载；
7、Nginx能支持http和Email，这样就在适用范围上面小很多；
8、不支持Session的保持、对Big request header的支持不是很好，另外默认的只有Round-robin和IP-hash两种负载均衡算法。
HAProxy的特点是：
1、HAProxy是工作在网络7层之上。
2、能够补充Nginx的一些缺点比如Session的保持，Cookie的引导等工作
3、支持url检测后端的服务器出问题的检测会有很好的帮助。
4、更多的负载均衡策略比如：动态加权轮循(Dynamic Round Robin)，加权源地址哈希(Weighted Source Hash)，加权URL哈希和加权参数哈希(Weighted Parameter Hash)已经实现
5、单纯从效率上来讲HAProxy更会比Nginx有更出色的负载均衡速度。
6、HAProxy可以对Mysql进行负载均衡，对后端的DB节点进行检测和负载均衡。
***********************************************************************************************
现在网站发展的趋势对网络负载均衡的使用是随着网站规模的提升根据不同的阶段来使用不同的技术：
第一阶段：利用Nginx或者HAProxy进行单点的负载均衡，这一阶段服务器规模刚脱离开单服务器、单数据库的模式，需要一定的负载均衡，但是 仍然规模较小没有专业的维护团队来进行维护，也没有需要进行大规模的网站部署。这样利用Nginx或者HAproxy就是第一选择，此时这些东西上手快， 配置容易，在七层之上利用HTTP协议就可以。这时是第一选择
第二阶段：随着网络服务进一步扩大，这时单点的Nginx已经不能满足，这时使用LVS或者商用F5就是首要选择，Nginx此时就作为LVS或者 F5的节点来使用，具体LVS或者F5的是选择是根据公司规模，人才以及资金能力来选择的，这里也不做详谈，但是一般来说这阶段相关人才跟不上业务的提 升，所以购买商业负载均衡已经成为了必经之路。
第三阶段：这时网络服务已经成为主流产品，此时随着公司知名度也进一步扩展，相关人才的能力以及数量也随之提升，这时无论从开发适合自身产品的定制，以及降低成本来讲开源的LVS，已经成为首选，这时LVS会成为主流。
最终形成比较理想的状态为：F5/LVS<—>Haproxy<—>Squid/Varnish<—>AppServer。














