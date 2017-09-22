172.16.5.1 E0 			172.16.5.3 E0
1）Down State
->
2）Init State （瞬时状态）
<- 
3）Two-Way State（暂时稳定）

4）Exstart state 
	Hello->I will start exchange because i have router id 172.16.5.1
	<-Hello No, I will start exchange because  i have a higher route ID
	选择Router ID 较大的为DR

5）Exchange state 
	DBD->
<- LSAck（Thanks for the information!） ->
	互相确认
	
6）Loading state
	LSR-> I need the complete entry for network 172.16.6.0/24
<- LSU Here is the entry for network 172.16.6.0/24
	LSAck-> Thanks for the information!

状态发生变化 LSU->DR
DR泛洪

――――――――――――――――――――――――――――――――
单区域OSPF配置
启用
router ospf process-id
网段指派到指定区域
network address wild card bits area(反掩码，控制网段范围) area-id

show ip ospf interface 查看区域号和与此相关的信息
show ip ospf neighbor 查看每一个接口上的邻居

――――――――――――――――――――――――――――――――
以太网
n<16次
802.2 规定 LLC子层
隐藏802.2上层差异，提供统一的接口

――――――――――――――――――――――――――――――――
交换机
Cisco lan switching

生成树协议
每个网络只有一个根桥，根桥有最低桥ID，所有端口为指派端口（DP）
非根桥只有一个根端口，到根桥代价最低，根端口处于转发
每段只能有一个指派端口，指派端口到根桥花费最低

路径代价
BPDU Bridge protocol data unit
缺省每2秒
根桥=最低识别码的桥（桥ID）
桥识别码=桥优先级+桥MAC地址

bocking->listening->learning->forwarding

――――――――――――――――――――――――――――――――
VLAN
交换机对帧进行VLAN标记的协议：ISL和802.1Q
ISL 
通过ASIC实现
ISL标示不会出现在工作站，客户端不知道ISL封装信息

ISL封装
ISL头		以太网帧数据		CRC
26bytes							4bytes
DA|Type|User|SA|LEN|AAAA03|HSA|VLAN|BPDU|INDEX|RES
VLAN：最多1024个VLAN
BPDU控制位

config-vlan
vlan database

VLAN配置
(config)vlan {vlan-id}
(config-vlan)name {vlan-name}
(config)interface {interface}
(config-if)switchport mode access
(config-if)switchport access vlan {vlan-id} 
(config-if)switchport trunk encapsulation {isl|dot1q|negotiate} 定义中继模式
(config-if)switchport mode {dynamic auto|dynamic desirable|trunk} 层2中继端口


vtp(vlan trunking protocol)
宣告vlan配置信息的系统
一个共有的管理域





