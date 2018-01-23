#Node.js
-----

[web框架](http://www.csdn.net/article/2014-03-25/2818964-web-application-frameworks-for-node-js)

browserify

---
#安装
##cygwin
1.安装win版
2.路径加入cygwin path
3.dos2unix 'xxxxx/nodejs/npm'

#npm
[NODE_PATH](http://segmentfault.com/a/1190000002478924)
默认
NODE_PATH=C:\Users\Administrator\Application Data\npm\node_modules 
NODE_PATH=D:\tools\nodejs\module\node_modules
NODE_PATH=D:\tools\nodejs\nodejs54\node_modules
NODE_PATH=D:\tools\nodejs\win\node_modules
npm root -g     #查看在你的系统中全局的路径。
npm config set prefix "D:\tools\nodejs\win"
npm config get prefix

##查看
npm -g outdated
##升级
npm update <name>
升级自己
npm install -g npm
##配置相关
npm config ls -l
npm config set cache "D:\\log\\npmc"
npm config get cache
npm install xxx -g 将模块安装到全局环境中
npm ls 查看安装的模块及依赖
npm ls -g 查看全局安装的模块及依赖

npm install xxx         安装模块
npm install xxx@1.1.1   安装1.1.1版本的xxx
npm uninstall xxx  (-g) 卸载模块
npm cache clean         清理缓存
npm help xxx            帮助
npm info xxx 		查看可用版本	
npm view moudleName dependencies  查看包的依赖关系
npm view moduleNames              查看node模块的package.json文件夹
npm view moduleName labelName     查看package.json文件夹下某个标签的内容
npm view moduleName repository.url  查看包的源文件地址
npm view moduleName engines       查看包所依赖的Node的版本
npm help folders                  查看npm使用的所有文件夹
npm rebuild moduleName            用于更改包内容后进行重建
npm outdated                      检查包是否已经过时，列出所有已经过时的包
npm update moduleName             更新node模块

add-user, adduser, apihelp, author, bin, bugs, c, cache,
completion, config, ddp, dedupe, deprecate, docs, edit,
explore, faq, find, find-dupes, get, help, help-search,
home, i, info, init, install, isntall, issues, la, link,
list, ll, ln, login, ls, outdated, owner, pack, prefix,
prune, publish, r, rb, rebuild, remove, repo, restart, rm,
root, run-script, s, se, search, set, show, shrinkwrap,
star, stars, start, stop, submodule, t, tag, test, tst, un,
uninstall, unlink, unpublish, unstar, up, update, v,
version, view, whoami

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






#学习
写给 Node.js 学徒的 7 个建议(http://blog.jobbole.com/48769/)
[我为什么向后端工程师推荐Node.js](http://blog.jobbole.com/9378/)


-----
#优化
[为重负网络优化 Nginx 和 Node.js](http://blog.jobbole.com/32670/)






















