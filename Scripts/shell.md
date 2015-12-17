#shell脚本编程
---
#shell是什么
OS:驱动 内核 接口库 外围

* GUI(graphic user interface) shell
* CLI(command line interface) shell
    - window
        + power shell
    - linux/unix
        + sh,Bourne shell
        + csh,C shell
        + ksh,Korn shell
        + *bash,Bourne-Again shell*
        + zsh

---
#cli shell 能干什么
重复性的、易错的、过程复杂的、执行中不需要人为介入的

* 后台执行/批量执行，节省时间
* 自动化
* 减少人为操作
* 减少出错概率

演示：

* 自动部署并验证
    - 打包
    - 上传
    - 停服务
    - 解包
    - 启服务
    - 查进程，查日志
    - php调用
* 线上查日志
    - 登录
    - 进目录，查询
    - 重复N次

---
#如何开始
##骨-shell语法

* 数据：变量
    - 数字
    - 字符串
    - 数组
* 指令
    - 顺序
    - 选择
    - 循环

##骨架-基本编程技能

##血和肉
Linux系统基础概念；常用命令；长期的学习积累；

---
#[什么时候不用](http://tldp.org/LDP/abs/html/why-shell.html)
* 涉及数学计算，尤其是浮点运算、精确运算或者复杂的算术运算-内建不支持
* 资源密集型的任务-效率低
* 跨平台移植需求-系统特性，不同shell语法支持不同
* 复杂的应用(需要变量的类型检查,函数原型,等等)
* 需要多维数组的支持-语法不支持
* 需要数据结构的支持,比如链表或数等数据结构-部分支持引用
* 需要直接操作系统硬件-驱动程序
* 需要I/O或socket接口
* 私人的,闭源的应用(shell 脚本把代码就放在文本文件中，全世界都能看到)

---
#start
##环境

* linux
* window
    - cygwin
        + [apt-cyg](https://github.com/transcode-open/apt-cyg)
    - mobaXterm


##hello world
```
#!/bin/bash
echo "hello,$1"
exit
```

----
#语法
#变量
[变量类型](http://blog.csdn.net/wangcj625/article/details/6423517)
[shell变量详解](http://www.cnblogs.com/barrychiao/archive/2012/10/22/2733210.html)
##定义
```
var=value
var='value'
var="value"
echo $var
echo ${var}  变量var的值, 与$var相同
```
PS:变量名和等号之间不能有空格。同时，变量名的命名须遵循如下规则：
* 首个字符必须为字母（a-z，A-Z）;
* 中间不能有空格，可以使用下划线（_）;
* 不能使用标点符号;
* 不能使用bash里的关键字（可用help命令查看保留关键字）

###变量类型
指定变量类型 declare或typeset

选 项  | 含 义
------|--------
-i    | 将变量设为整型
-a    | 将变量当作一个数组。即，分配元素
-f    | 列出函数的名称和定义
-F    | 只列出函数名
-r    | 将变量设为只读，等于readonly
-x    | 将变量名输出到子shell中，等于export

* Bash变量是不分类型的[ABS 4.3]
本质上,Bash 变量都是字符串,但是依赖于上下文，Bash允许比较操作和算术操作.决定这些的关键因素就是，变量中的值是否只有数字.

---
#数字
Bash不能够处理浮点运算，它会把包含小数点的数字看作字符串.
非要做浮点运算的话,可以在脚本中使用bc,这个命令可以进行浮点运算,或者调用数学库函数.

##基础计算
let
```
a=5
b=6
let res=a*b
echo $res
let res*=res
echo $res
```
(())
```
a=5
b=6
res=$((a+b))
```
[]
```
a=5
b=6
res=$[a+b]
echo $res
res=$[$a+$a]
echo $res
```

##高级操作
expr
```
a=1
res=`expr $a + 1`
echo $res
```
bc
```
echo "4*6.4" | bc
echo "scale=2;1/3" | bc
```
awk
```
a=1
b=2
res=`echo "$a $b"|awk '{printf("%g",$1*$2)}'`
echo $res
var=350456
res=`echo "$var"|awk '{printf("%g",log($1)/log(2))}'`
# %g 自动选择合适的表示法
echo $res
```

---
#字符串
```
#index 从零开始
a=1234561234567
echo ${#a}

#--------字符串截取----------
#从3开始截取
echo ${a:3}
#从3开始截取2个
echo ${a:3:2}
#从变量$a的开头，删除最短匹配
echo ${a#12*}
#从变量$a的开头，删除最长匹配
echo ${a##12*}
#从变量$a的结尾, 删除最短匹配
echo ${a%*67}
#从变量$a的结尾, 删除最短匹配
echo ${a%*67}
#字符串替换-第一个
echo ${a/23/twothree}
#字符串替换-所有
echo ${a//23/twothree}
#字符串替换-前缀替换
echo ${a/#12/twothree}
#字符串替换-后缀替换
echo ${a/%67/sixseven}
```
性能对比：
test=a
time for i in $(seq 10000);do a=${#test};done;
time for i in $(seq 100);do a=$(expr length $test);done;

判断字符串为空:
```
if [ -z "$string1" ];then
    echo "null"
fi
# -n 为非空
if [ "$str" = "" ]; then
    echo "null"
fi
if [ x"$str" = x ]; then
    echo "null"
fi

if [ $string1 ]; then
    echo "not null"
fi
```
注意：都要代双引号，否则有些命令会报错

---
#数组
```
arr=(1 2 3 4 5)
arr
arr[0]="a"
arr[1]="b"
arr[2]="c"
```
长度
```
${#array[@]}
${arr[i]}
```

```
arr=(1 2 3 4 5)
i=0
while [ $i -lt ${#arr[@]} ]
do
    echo ${arr[$i]}
    let i++
done
```
[关联数组](http://blog.csdn.net/ysdaniel/article/details/7909824)
gettab.sh

---
#环境变量 environmental variables
在一般的上下文中，每个进程都有自己的环境，就是一组保持进程可能引用的信息的变量
```
export ENV1=value
declare -x ENV2=value
```

---
#只读变量
```
declare -r RO_VARIABLE_NAME=value1
readonly RO_VARIABLE_NAME1=value2
```

---
#局部变量 local variable
只在函数或代码块中出现
```
local VARIABLE_NAME=value
```


----
#控制语句
##条件
if [ condition1 ]
then
     command1
     command2
elif [ condition2 ]  # 与else if一样
then
     command3
     command4
else
     default-command
fi
###condition
test, /usr/bin/test, [ ], 和/usr/bin/[都是等价命令
[[ ]]结构比[ ]结构更加通用.这是一个扩展的test命令, 是从ksh88中引进的. &&, ||, <, 和> 操作符能够正常存在于[[ ]]条件判断结构中, 但是如果出现在[ ]结构中的话, 会报错.

## if COMMAND 结构
将会返回COMMAND的退出状态码
```
if echo $PATH|grep -q jdka ; then echo yes;else echo no; fi 
```

## (( ))结构
扩展并计算一个算术表达式的值. 如果表达式的结果为0, 那么返回的退出状态码为1,或者是"假". 而一个非零值的表达式所返回的退出状态码将为0, 或者是"true".这种情况和先前所讨论的test命令和[ ]结构的行为正好相反.
==比较操作符在双中括号对和单中括号对中的行为是不同的.

##case结构
getopts
case "$variable" in
     $condition1" )
     TT CLASS="REPLACEABLE" >command...
     ;
     $condition2" )
     TT CLASS="REPLACEABLE" >command...
     ;
esac

##for循环
```
for arg in 1 2 3 4
do
    echo $arg
done

for arg in `ls`
do
    echo $arg
done

for ((a=1;a<=5;a++))
do
    echo $a
done
#for ((a=1, b=1; a <= LIMIT ; a++, b++))

```

##while循环
```
while [condition]
do
     command...
done
#while (( a <= LIMIT ))

```

##循环控制
continue/break
PS:
* break命令可以带一个参数. 一个不带参数的break命令只能退出最内层的循环, 而break N可以退出N层循环.
* continue命令也可以象break命令一样带一个参数. 一个不带参数的continue命令只会去掉本次循环的剩余代码. 而continue N将会把N层循环的剩余代码都去掉, 但是循环的次数不变.

---
#函数
格式：
function functionname()
{
$1 #入口参数
echo ... #返回值
return
}
默认：全局变量
局部变量 关键字local
局部变量屏蔽全局变量

function function_name {
command...
}
或
function_name () {
command...
}


---
#系统
##管道
IPC Inter-Process Communication
第三方通信协议

##ssh
非对称加密
ssh work@192.168.143.118
###执行命令
ssh work@192.168.143.118 "ls -l"
###无密码登录
```
#客户端生成公钥私钥
ssh-keygen -t rsa
.ssh/id_rsa.pub
#拷贝公钥到服务器
ssh-copy-id user@host
ssh user@host
```

##scp
scp file user@host:/path/filename
scp user@host:/path/filename file
[pssh](http://www.cnblogs.com/wangkangluo1/archive/2013/01/06/2847353.html)


##wget/curl
wget -q -O- --post-data="account=$RANDOM&password=123345"  http://aaaa
curl -H "Content-type: application/json" -X POST -d '{"account":"$RANDOM","password":"123345"}'  http://

wget --post-data="os_username=service_guest&os_password=111111" --save-cookies=cookie.txt --keep-session-cookies http://url

wget -r -k -c -nc -p -np --load-cookies=cookie.txt http://url -U "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; GTB5)" 
wget --mirror -p --convert-links --load-cookies=cookie.txt 


##~/.bashrc ~/.bash_profile /etc/profile

##ln
ln -sfv /target aa
iconv -f encoding -t encoding inputfile

tar -zpcvf xxx.tar.gz --exclude=/root/etc* --exclude=/root/system.tar.bz2 /etc /root


##系统状态
ps -ef|grep 
top
free -m

##
strace

##网络
ifconfig
hostname
nslookup
/etc/resolve.conf
nc -z -w 10 $IP $PORT
netstat -anop |grep 9999
tcpdump -i eth0 -A tcp port 1414 and host 10.185.234.14

---
#参考资料
[Advance Bash-Scripting Guide](http://book.douban.com/subject/3010746/)
[鸟哥Linux私房菜](http://book.douban.com/subject/2208530/) 第三部分 学习shell和shell脚本
[Linux Shell脚本教程：30分钟玩转Shell脚本编程](http://c.biancheng.net/cpp/shell/)