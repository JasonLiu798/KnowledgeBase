


#npm
[NODE_PATH](http://segmentfault.com/a/1190000002478924)
默认
NODE_PATH=C:\Users\Administrator\Application Data\npm\node_modules 
NODE_PATH=D:\tools\nodejs\module\node_modules
NODE_PATH=D:\tools\nodejs\nodejs54\node_modules
NODE_PATH=D:\tools\nodejs\win\node_modules


##package.json
[结构解析](http://blog.csdn.net/woxueliuyun/article/details/39294375)

##更换源
镜像举例：
###1.临时使用
npm --registry https://registry.npm.taobao.org install express
npm --registry http://r.cnpmjs.org/ 

###2.持久使用
npm config set registry https://registry.npm.taobao.org
// 配置后可通过下面方式来验证是否成功
npm config get registry
// 或npm info express

###3.通过cnpm
使用
npm install -g cnpm --registry=https://registry.npm.taobao.org
// 使用cnpm install expresstall express

###国内优秀npm镜像
淘宝npm镜像
搜索地址：http://npm.taobao.org/
registry地址：http://registry.npm.taobao.org/
cnpmjs镜像
搜索地址：http://cnpmjs.org/
registry地址：http://r.cnpmjs.org/

npm ---- https://registry.npmjs.org/
eu ----- http://registry.npmjs.eu/
au ----- http://registry.npmjs.org.au/
sl ----- http://npm.strongloop.com/
nj ----- https://registry.nodejitsu.com/




###设置DNS
cygwin内部是使用windows的DNS查询，而nodejs另外使用的是c-ares库来解析DNS，这个库会读取/etc/resolv.conf里的nameserver配置，而默认是没有这个文件的，需要自己建立并配置好DNS服务器的IP地址，这里使用Google Public DNS服务器的IP地址：8.8.8.8和8.8.4.4。
vi /ect/resolv.conf

##win green edition
[Node](http://nodejs.cn/download/) node.exe
[NPM](http://nodejs.org/dist/npm/)
下载最新zip版本，不要下载tgz版本，下载后解压到H:\nodejs\
添加环境变量
NODE_HOME=H:\nodejs
NODE_PATH=%NODE_HOME%\node_modules
path增加%NODE_HOME%\
最终得到文件目录结构H:\nodejs\：
.
├── node.exe
├── npm.cmd
└── node_modules
    └── npm
测试一下，出现版本号，说明配置成功：
node --version
npm --version

npm -h
npm install -h
npm help install
默认安装仓库是 https://registry.npmjs.org ，查找包可以到这里 http://search.npmjs.org ，一切都很像maven。有两种安装模式可选，参考 npm 1.0 Global vs Local installation ： 
locally 
默认是locally模式，安装到当前命令的执行目录。在其他位置执行xxx会报 “xxx不是内部或外部命令，也不是可运行的程序” 。

npm install xxx
globally 
-g参数代表全局方式，使用全局模式会安装到 H:\nodejs\node_modules\ 中的xxx下。

npm install xxx -g
你可以重新设置prefix位置，方法有二：

重新设置prefix的位置：npm config set prefix "H:\hexo"
或直接修改 『当前用户』.npmrc 文件，添加prefix = H:\hexo




