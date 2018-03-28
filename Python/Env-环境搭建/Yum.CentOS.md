

1.查看一下当前Python的版本

$ python -V
注意这里“V”是大写的，记得当前python的版本，之后会用得到。我的当前版本是2.6.6。

 

2.安装过程中需要拥有root权限，所以在一开始就获取root

$ su root   
注意这里执行命令后提示输入密码，但是输入过程中，密码是不显示的，所以只需要键盘敲完密码回车就可以了

 

3.安装过程中还有可能会提示安装编译器，所以也提前下载安装好，以免后面报错

$ yum install gcc gcc-c++ autoconf automake
 

4.安装相关库文件

$ yum install -y zlib-devel bzip2-devel xz-libs wget     
这里的库文件，不同的教程写的有差异，我在这里安装了zlib-devel、bzip2-devel、xz-libs这三个，目前为止没有出现其他问题

 

5.下载目标版本Python安装包

$ wget http://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz 
我更新的是2.7.12版本，这里可以先到官网上看自己想用哪个版本，替换一下链接中的版本号就可以了

 

6.解压Python安装包

$ tar -xvf Python-2.7.12.tar.xz   #解压安装包
这里注意文件名不要打错，执行命令后等待解压就可以了

 

7.进入解压后的目录

$ cd Python-2.7.12    #进入解压目录
文件夹的名字和压缩包的名字是一样的

 

8.指定安装路径

$ ./configure --prefix=/usr/local   #将安装目录指定为/usr/local
 

9.编译并安装

$ make && make altinstall
这里有些教程是分开两步的，对比参考网上找到的教程，最后选择这个一行命令解决

 

10.移动旧版本Python（备份）

$ mv /usr/bin/python /usr/bin/python2.6.6    
这里有两个路径: /usr/bin/python 是原位置，/usr/bin/python2.6.6是目标位置，2.6.6版本后面还会用得到，所以备份一下

 

11.建立软链接

$ ln -s /usr/local/bin/python2.7 /usr/bin/python
这里是把我们安装在local目录中的python2.7放到/usr/bin/python路径下，这种方式并没有直接复制文件到目标目录下，而是类似于创建文件的快捷方式

 

12.安装结束 查看版本

$ python -V
这里可以看到版本已经是2.7.12了，不过还没有结束，之前我们用到的yum，现在已经不能用了，因为更新了python版本，而yum与新版本python是不匹配的，所以接下来我们要再把yum改成对应到原来的版本，我这里自带的版本是2.6.6，下面完成修改

 

13.打开yum文件

$ vi /usr/bin/yum
这里我们在终端里打开yum文件，但是现在的状态只能浏览，下面继续编辑

 

14.修改yum文件

将光标移至首行末尾，按“a”键，可以看到终端左下角出现--insert--字样，此时就可以插入内容了，将首行原来的#!usr/bin/python改为：

#!/usr/bin/python2.6.6 
 然后按ESC退出编辑模式，注意这时候还没有保存。这里由于我将原来的2.6.6版本从/usr/bin/python移动到了/usr/bin/python2.6.6所以这样修改，如果移动到了其他位置，就要写对应的路径。

15.保存并退出

:wq
按ESC退出编辑模式后，无视光标当前的位置，直接输入":wq"，就完成保存并退出了，此时yum就可以继续正常使用了。
