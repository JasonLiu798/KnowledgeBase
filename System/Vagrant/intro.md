Vagrant
打造跨平台开发环境
1，概述
    Vagrant 是一款用来构建虚拟开发环境的工具，非常适合 php/python/ruby/java 这类语言开发 web 应用，“代码在我机子上运行没有问题”这种说辞将成为历史。
    我们可以通过 Vagrant 封装一个 Linux 的开发环境，分发给团队成员。成员可以在自己喜欢的桌面系统（Mac/Windows/Linux）上开发程序，代码却能统一在封装好的环境里运行，非常霸气。
    另外,如果有同学的电脑上还跑着32位的系统,请提交代码到仓库之后,重装成64位系统.
2，安装步骤
1. 安装 VirtualBox
虚拟机还是得依靠 VirtualBox 来搭建，免费小巧。
下载地址：https://www.virtualbox.org/wiki/Downloads
* 虽然 Vagrant 也支持 VMware，不过 VMware 是收费的，对应的 Vagrant 版本也是收费的
文档所在目录提供了 virtualbox 的windows安装包,linux和mac版本，自己去官网下载
2. 安装 Vagrant
下载地址：http://downloads.vagrantup.com/
根据提示一步步安装。此外，还得下载官方封装好的基础镜像：
如果你要其他系统的镜像，可以来这里下载：http://www.vagrantbox.es/
文档所在目录，我提供了一个已经安装好php开发所需的环境的镜像

3. 添加镜像到 Vagrant
假设我们下载的镜像存放路径是 ~/box/precise64.box，在终端里输入：
$ vagrant box add ~/box/precise64.box --name hahaha
hahaha 是我们给这个 box 命的名字，~/box/precise64.box 是 box 所在路径
windows 下cmd中的命令是一样的，但是首先要保证系统变量中path已经包
vagrant安装后的bin目录（安装时，会自动加入，如果运行上述命令时系统提示找不到命令 
请windows下手动添加到系统的path,linux下使用 export
PATH=$path:/path/to/vagrant/bin,或者将 vagrant 软链接到/usr/bin/vagrant）
目前我会讲镜像通过问价你提供给大家，之后，将会把镜像部署在内网服务器中，提供http下载，命令中可以直接使用远程地址添加。
另外 ，请自行添加一个 VAGRANT_DEFAULT_PROVIDER环境变量，值为virtualbox，否则部分电脑上在进行下面的操作时会出错。
4. 初始化开发环境
创建一个开发目录（比如：~/dev），你也可以使用已有的目录，切换到开发目录里，用 hahaha 镜像初始化当前目录的环境：
$ cd ~/dev  # 切换目录
$ vagrant init hahaha  # 初始化
$ vagrant up  # 启动环境
你会看到终端显示了启动过程，启动完成后，我们就可以用 SSH 登录虚拟机了，剩下的步骤就是在虚拟机里配置你要运行的各种环境和参数了。
$ vagrant ssh  # SSH 登录
$ cd /vagrant  # 切换到开发目录，也就是宿主机上的 `~/dev`
~/dev 目录对应虚拟机中的目录是 /vagrant
Windows 用户注意：Windows 终端并不支持 ssh，所以需要安装第三方 SSH 客户端，比如：Putty、Cygwin 等。
5. 其他设置
Vagrant 初始化成功后，会在初始化的目录里生成一个 Vagrantfile 的配置文件，可以修改配置文件进行个性化的定制。
Vagrant 默认是使用端口映射方式将虚拟机的端口映射本地从而实现类似 http://localhost:80 这种访问方式，这种方式比较麻烦，新开和修改端口的时候都得编辑。相比较而言，host-only 模式显得方便多了。打开 Vagrantfile，将下面这行的注释去掉（移除 #）并保存：
config.vm.network :private_network, ip: "192.168.33.10"
重启虚拟机，这样我们就能用 192.168.33.10 访问这台机器了，你可以把 IP 改成其他地址，只要不产生冲突就行。
如果希望别人访问你的环境，那么需要一个public_network
配置文件中 config.vm.network :public_network, bridge: ”网卡名”
配置文件目录中也提供了,之后,配置文件将会添加到仓库中,那么可以免去初始化项目的过程,可能需要做的改动就是如果你添加镜像时起了特殊名字,就需要把这个名字覆盖掉配置文件中名字,还有就是,你希望你的环境开发给其他人,需要添加一项网络配置,做一个桥接.

3.phpstorm集成
Phpstorm 9 中集成了vagrant,其他版本我想通过plugin搜索vagrant可能也能找到,最好还是都升级到phpstorm 9
我之后会把vagrant的配置文件直接放到仓库中,就是为了使用ide集成,当项目中存在Vagrantfile这个配置文件时,Tools/vagrant 中,就可以直接使用up命令启动虚拟机了.当启动完成之后,当前目录会被挂载到虚拟机的/vagrant目录下,而虚拟机里的环境,tengine的根目录是只想/vagrant/INDEX目录,所以,如果当前j_V3项目中没有INDEX这个目录的,你们可以自己建立这个目录,然后就把入口文件丢进去.
通过vagrant ssh,可以登录到虚拟机,如果证书有问题,你可以通过密码登录 ssh vagrant@127.0.0.1 -p 2222 密码是vagrant 登录之后,删除掉 .ssh/目录,并删除掉当前项目目录下 .vagrant/machines/defaults/virtualbox/private_key 然后,执行命令 vagrant reload或者直接通过 tools/vagrant/reload 即可.
我替提供的配置文件,默认会创建一个私有ip 192.168.33.138 你可以把j_V3项目中的域名指向这个ip访问.默认给虚拟机了1024M的内存,1颗cpu,其实可以讲内存降低一些,512M其实就够了.做了一个目录的挂载,将项目根目录挂载到虚拟机的/vagrant目录.执行了一个初始环境脚本,向虚拟机中加入拓展源.
虚拟机和线上的环境一致,tengine2.1 + php 5.6.12+memcached+redis
tengine和php安装在 /usr/local/webserver/目录下,所有的服务启动脚本在 /etc/init.d/目录下.
虚拟机提供了和线上一样的运行环境,一般来说,你们现在的本地开发环境,可以直接迁移进去,不会有改动,链接内网的资源,服务器依旧可以连接,但是链接本地资源的,可能需要有些改动,比如说,你的代码中链接了本机的127.0.0.1:6379 但是环境中,会连接上一台空白的redis,如果仍然要链接你宿主机的6379端口,需要把ip改为192.168.33.1(这个的前提是使用我的配置文件)
关于不同环境中的项目配置,是另外一个问题,目前只能你们手动的往本地代码中加入test.php 这个文件处理,在后面高度的环境变量上线之后,我将会提供另外一个放来来处理.
环境中集成了xdebug,在使用我的配置文件的情况下,只需要讲ide中的pgdb 的idekey 改为phpstorm即可
