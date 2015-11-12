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

