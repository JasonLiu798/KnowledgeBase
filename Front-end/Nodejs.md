#Node.js
-----
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
npm root -g     #查看在你的系统中全局的路径。
npm config set prefix "D:\tools\nodejs"

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
npm view moudleName dependencies  查看包的依赖关系
npm view moduleNames              查看node模块的package.json文件夹
npm view moduleName labelName     查看package.json文件夹下某个标签的内容
npm view moduleName repository.url  查看包的源文件地址
npm view moduleName engines       查看包所依赖的Node的版本
npm help folders                  查看npm使用的所有文件夹
npm rebuild moduleName            用于更改包内容后进行重建
npm outdated                      检查包是否已经过时，列出所有已经过时的包
npm update moduleName             更新node模块


###设置DNS
cygwin内部是使用windows的DNS查询，而nodejs另外使用的是c-ares库来解析DNS，这个库会读取/etc/resolv.conf里的nameserver配置，而默认是没有这个文件的，需要自己建立并配置好DNS服务器的IP地址，这里使用Google Public DNS服务器的IP地址：8.8.8.8和8.8.4.4。
vi /ect/resolv.conf


#学习
写给 Node.js 学徒的 7 个建议(http://blog.jobbole.com/48769/)
[我为什么向后端工程师推荐Node.js](http://blog.jobbole.com/9378/)


-----
#优化
[为重负网络优化 Nginx 和 Node.js](http://blog.jobbole.com/32670/)






















