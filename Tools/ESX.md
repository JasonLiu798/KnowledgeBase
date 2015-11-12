•	vmkfstools被比做虚拟磁盘中的瑞士军刀，可用于复制、转换、重命名、输入、输出和调整虚拟磁盘文件的大小。 
•	Esxtop故障排除。它提供实时的CPU、内存、硬盘和网络使用的历史表现的统计数字。 
•	Esxcfg-nics观察和配置物理网络接口卡（NIC）。它显示网卡状态和配置的速度和全双工网卡。 
•	Esxcfg-vswitch显示和配置虚拟交换机。它是在vSphere不能使用网络中有用的配置客户端。该命令用于配置端口组和连接物理网卡（称为上行）配置虚拟局域网ID，思科协议（CDP）和vswitch中的MTU。 
•	Esxcfg-vswif和esxcfg-vmknic允许您查看和配置vSwitches特殊的端口组。 Esxcfg - vswif配置的ESX服务控制台网络接口，它也被称为vswif港口。 Esxcfg - vmknic配置VMkernel网络接口，这是VMotion和连接到iSCSI和网络文件系统的网络存储设备所必要的。 
•	Vmware-cmd是一个复合管理命令，负责管理和检索虚拟机信息。它可以改变虚拟机电源状态、管理快照、注册和注销的用户，并检索和设置各种虚拟机的信息。 
•	Vimsh和vmware-vim-cmd是复杂的命令，只有完全了解才能使用。 Vimsh是一个强大的交互式框架，有很多允许执行的命令，以及具备显示和配置能力。 VMware的vim - cmd是一种逻辑的vimsh，能够简化vimsh，无需知道很多前端交换命令。 
•	Vihostupdate和esxupdate更新ESX和ESXi主机和打补丁。 Esxupdate用于ESX服务控制台和vihostupdate，通过RCLI / vSphere CLI使用。此外，vihostupdate35是用来修补ESX和ESXi 3.5版主机。 
•	Svmotion是RCLI/vSphere CLI命令，用于发起Storage VMotion的迁移虚拟机虚拟磁盘到另一个数据存储空间。此命令的ESX 3.5版本是唯一启动SVMotion的方法，加上vSphere客户端的GUI，vSphere能做到这一点。 
•	Esxcfg-mpath显示和设置一台主机从所有路径到达它的存储设备。 
•	Esxcfg-rescan让主机产生一个特定的存储适配器，用来发现新的存储设备。这是非常有用的工具，存储设备已被添加，删除或从存储网络改变。 
•	Esxcfg-scsidevs和esxcfg-vmhbadevs显示连接到主机的存储设备的资料。 Esxcfg - vmhbadevs用于ESX 3.5，在vSphere中被 esxcfg-scsidevs取代。 
•	Esxcfg-firewall显示信息和配置内置的防火墙保护ESX服务控制台。它允许和阻止特定的TCP /IP服务之间的控制台和其他网络设备端口。 
•	Esxcfg-info命令提供了有关运行中的主机信息。它可以重新定向到一个文本文件记录主机配置。 
•	Esxcfg-auth在ESX主机上配置服务控制台验证。它可以配置第三方LDAP或Active Directory服务器的身份验证并设置多个本地安全选项。 
•	Vm-support是一个强大的信息收集工具，常用于故障排除。该命令收集大量信息、日志文件，并把很多命令以单一的tgz存档文件方式输出。它也可以用来显示VM的信息以及停止没有响应的虚拟机。
