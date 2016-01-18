#Node.js
-----
#安装
##cygwin
1.安装win版
2.路径加入cygwin path
3.dos2unix 'xxxxx/nodejs/npm'
 
###设置DNS
cygwin内部是使用windows的DNS查询，而nodejs另外使用的是c-ares库来解析DNS，这个库会读取/etc/resolv.conf里的nameserver配置，而默认是没有这个文件的，需要自己建立并配置好DNS服务器的IP地址，这里使用Google Public DNS服务器的IP地址：8.8.8.8和8.8.4.4。
vi /ect/resolv.conf


#学习
写给 Node.js 学徒的 7 个建议(http://blog.jobbole.com/48769/)
[我为什么向后端工程师推荐Node.js](http://blog.jobbole.com/9378/)


-----
#优化
[为重负网络优化 Nginx 和 Node.js](http://blog.jobbole.com/32670/)






















