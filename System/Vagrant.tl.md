#vagrant
---
#command
## add box
vagrant box add [boxname] [boxurl/boxpath] 

## init new vm
vagrant init ubuntu/trusty64
## open & close
vagrant up
vagrant halt
vagrant status  
## ssh to
vagrant ssh
## after change 
vagrant reload
## pause & resume
vagrant suspend
vagrant resume
###shutdown
vagrant halt 
###delete
vagrant destroy

## list all
vagrant box list
vagrant global-status

vagrant provision

---
#setup
vagrant box add ct65_00 Downloads/centos65.box 
vagrant init ubuntu/trusty64

---
#config
http://xuclv.blog.51cto.com/5503169/1239250
[doc](http://docs.vagrantup.com/v2/)

## defautl user
vagrant vagrant
root vagrant

## share foler
config.vm.synced_folder "python", "/opt/pythonprj"
config.vm.synced_folder "/opt/vm/share", "/opt/share"
local,vm
##memory
config.vm.provider "virtualbox" do |v|
  v.memory = 2048
end


##network
###1brige 
v2
Vagrant.configure("2") do |config|
  config.vm.network :public_network,ip:"192.168.1.200"
end
v1
Vagrant::Config.run do |config|
  config.vm.network :bridged
end

VBoxManage list bridgedifs | grep ^Name  
    Name:            eth0
###set eth
Vagrant::Config.run do |config|
  config.vm.network :bridged, :bridge => "eth0" ,
end

###2port
v2
Vagrant.configure("2") do |config|
  config.vm.network :forwarded_port, guest: 80, host: 8080
end
v1
Vagrant::Config.run do |config|
  # Forward guest port 80 to host port 8080
  config.vm.forward_port 80, 8080
end

###3 hostonly
v2
Vagrant.configure("2") do |config|
  config.vm.network :private_network, ip: "192.168.50.4"
end
v1
Vagrant::Config.run do |config|
  config.vm.network :hostonly, "192.168.50.4"
end



---
#Q&A
##Q Connection Timeout
##A
http://junnan.org/blog/2014-06-27-fix-vagrant-error-connection-timeout.html

ssh_exchange_identification: Connection closed by remote host


[default] Clearing any previously set forwarded ports... 
[default] Clearing any previously set network interfaces... 
There was an error while executing `VBoxManage`, a CLI used by Vagrant 
for controlling VirtualBox. The command and stderr is shown below. 
Command: ["hostonlyif", "create"]  
Stderr: 0%...


被召者 RC: E_NOINTERFACE (0x80004002)



1、进入到C:\Users\Administrator\VirtualBox VMs\ 将相应guest的文件夹删除，再重新打开此guest就可以了。
2、打开bios（具体方法要看你是什么电脑）BIOS Setup Utility --》Config ==> CPU ==> Intel(R) Virtualization Technology（如果你用的不是intel的处理器，那就是别的带有virtualization technology的选项） ==> 设置为 Enabled 
3、在虚拟机设置里将CPU个数调整为1个。

---
#docker
##setup
[setup](http://yansu.org/2014/04/10/install-docker-in-mac.html)
[csdn win](http://blog.csdn.net/zistxym/article/details/42918339)

##使用
使用docker安装需要先启动boot2docker虚拟机
```bash
# Initiate the VM
boot2docker init
# Run the VM (the docker daemon)
boot2docker up
# To see all available commands:
boot2docker

boot2docker up ~/Downloads

#To connect the Docker client to the Docker daemon, please set:
export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/xxx/.boot2docker/certs/boot2docker-vm
```

自启动
ln -sfv /usr/local/opt/boot2docker/*.plist ~/Library/LaunchAgents
Then to load boot2docker now:
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.boot2docker.plist





---
#init
##ubuntu
sed 's/PermitRootLogin*/PermitRootLogin yes/g' /etc/ssh/sshd_config
apt-get update
apt-get install rabbitmq-server
apt-get install node
apt-get install phantomjs
apt-get install casperjs
apt-get install golang


Realtek PCIe GBE Family Controller



---
#ESX
vmkfstools被比做虚拟磁盘中的瑞士军刀，可用于复制、转换、重命名、输入、输出和调整虚拟磁盘文件的大小。 
• Esxtop故障排除。它提供实时的CPU、内存、硬盘和网络使用的历史表现的统计数字。 
• Esxcfg-nics观察和配置物理网络接口卡（NIC）。它显示网卡状态和配置的速度和全双工网卡。 
• Esxcfg-vswitch显示和配置虚拟交换机。它是在vSphere不能使用网络中有用的配置客户端。该命令用于配置端口组和连接物理网卡（称为上行）配置虚拟局域网ID，思科协议（CDP）和vswitch中的MTU。 
• Esxcfg-vswif和esxcfg-vmknic允许您查看和配置vSwitches特殊的端口组。 Esxcfg - vswif配置的ESX服务控制台网络接口，它也被称为vswif港口。 Esxcfg - vmknic配置VMkernel网络接口，这是VMotion和连接到iSCSI和网络文件系统的网络存储设备所必要的。 
• Vmware-cmd是一个复合管理命令，负责管理和检索虚拟机信息。它可以改变虚拟机电源状态、管理快照、注册和注销的用户，并检索和设置各种虚拟机的信息。 
• Vimsh和vmware-vim-cmd是复杂的命令，只有完全了解才能使用。 Vimsh是一个强大的交互式框架，有很多允许执行的命令，以及具备显示和配置能力。 VMware的vim - cmd是一种逻辑的vimsh，能够简化vimsh，无需知道很多前端交换命令。 
• Vihostupdate和esxupdate更新ESX和ESXi主机和打补丁。 Esxupdate用于ESX服务控制台和vihostupdate，通过RCLI / vSphere CLI使用。此外，vihostupdate35是用来修补ESX和ESXi 3.5版主机。 
• Svmotion是RCLI/vSphere CLI命令，用于发起Storage VMotion的迁移虚拟机虚拟磁盘到另一个数据存储空间。此命令的ESX 3.5版本是唯一启动SVMotion的方法，加上vSphere客户端的GUI，vSphere能做到这一点。 
• Esxcfg-mpath显示和设置一台主机从所有路径到达它的存储设备。 
• Esxcfg-rescan让主机产生一个特定的存储适配器，用来发现新的存储设备。这是非常有用的工具，存储设备已被添加，删除或从存储网络改变。 
• Esxcfg-scsidevs和esxcfg-vmhbadevs显示连接到主机的存储设备的资料。 Esxcfg - vmhbadevs用于ESX 3.5，在vSphere中被 esxcfg-scsidevs取代。 
• Esxcfg-firewall显示信息和配置内置的防火墙保护ESX服务控制台。它允许和阻止特定的TCP /IP服务之间的控制台和其他网络设备端口。 
• Esxcfg-info命令提供了有关运行中的主机信息。它可以重新定向到一个文本文件记录主机配置。 
• Esxcfg-auth在ESX主机上配置服务控制台验证。它可以配置第三方LDAP或Active Directory服务器的身份验证并设置多个本地安全选项。 
• Vm-support是一个强大的信息收集工具，常用于故障排除。该命令收集大量信息、日志文件，并把很多命令以单一的tgz存档文件方式输出。它也可以用来显示VM的信息以及停止没有响应的虚拟机。






















