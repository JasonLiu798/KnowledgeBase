#shell脚本编程
---
#shell是什么
OS:驱动 内核 接口库 外围

* GUI(graphic user interface) shell
* CLI(command line interface) shell
    - window
        + power shell
    - [unix/linux](http://www.cnblogs.com/cocowool/archive/2012/04/23/2466370.html)
        + sh,Thompson Shell
        + sh,Bourne shell,70's,System V7
        + csh,C shell,70's
        + ksh,Korn shell,80's,[unix war](http://www.ruanyifeng.com/blog/2010/03/unix_copyright_history.html)
        + *bash,Bourne-Again shell*,1989,GNU

---
#cli shell 能干什么
重复性的、易错的、过程复杂的、执行中不需要人为介入的

* 后台执行/批量执行，节省时间
* 自动化
* 减少人为操作
* 减少出错概率

演示：

* 自动部署并验证
    - 编译，打包
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
* 数据/变量
    - 数字
    - 字符串
    - 数组
* 指令
    - 顺序
    - 选择
    - 循环

##骨架
基本编程技能

##血和肉
Linux系统基础概念，常用命令

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

* [Bash变量是不分类型的](http://tldp.org/LDP/abs/html/untyped.html)

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
#支持整型
a=1
res=`expr $a + 1`
echo $res
```
bc
```
#支持浮点
echo "4*6.4" | bc
echo "scale=2;1/3" | bc
```
awk
```
#支持浮点
n1=1.5
n2=2.3
res=`echo "$n1 $n2"|awk '{printf("%g",$1*$2)}'`
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

#--------字符串替换----------
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
time for i in $(seq 100);do a=${#test};done;
time for i in $(seq 100);do a=$(expr length $test);done;

判断字符串为空:
```
if [ -z "$string1" ];then # -n 为非空
    echo "null"
fi

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
* continue命令也可以象break命令一样带一个参数. 一个不带参数的continue命令只会去掉本次循环的剩余代码. 而continue N将会把N层循环的剩余代码都去掉, 但是循环的次数不变

---
#函数
格式：
function functionname()
{
$1 #入口参数
echo ... #返回值
return   #返回值 1~255
}
或
function function_name {
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

---
#常用命令
##ssh
非对称加密
主机-客户端
公钥-加密
私钥-解密
ssh work@192.168.143.118
###无密码登录
```
#客户端生成公钥私钥
ssh-keygen -t rsa
.ssh/id_rsa.pub
#拷贝公钥到服务器
ssh-copy-id user@host
ssh user@host
```
###执行命令
ssh work@192.168.143.118 "ls -l"

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


##wget/curl
wget -q -O - http://ip.ws.126.net/ipquery?ip="10.10.10.1" |iconv -f GBK -t "utf-8"

curl -H "Content-type: application/json" -X POST -d '{"ip":"10.10.10.1"}'  http://ip.ws.126.net/ipquery

wget --post-data="os_username=service_guest&os_password=111111" --save-cookies=cookie.txt --keep-session-cookies http://url

wget -r -k -c -nc -p -np --load-cookies=cookie.txt http://url -U "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; GTB5)" 

##nc
nc -z -w 10 $IP $PORT
netstat -anop |grep 9999
tcpdump -i eth0 -A tcp port 22 and host 127.0.0.1

##~/.bashrc ~/.bash_profile /etc/profile

##ln
ln -sfv /target aa

##tar
tar -zpcvf xxx.tar.gz --exclude=/root/etc* --exclude=/root/system.tar.bz2 /etc /root

##网络
ifconfig
hostname
nslookup
/etc/resolve.conf
nc -z -w 10 $IP $PORT
netstat -anop |grep 9999
tcpdump -i eth0 -A tcp port 1414 and host 10.185.234.14



----
#附加
#各种括号
##单小括号 ()
1.命令组。括号中的命令将会新开一个子shell顺序执行，所以括号中的变量不能够被脚本余下的部分使用。括号中多个命令之间用分号隔开，最后一个命令可以没有分号，各命令和括号之间不必有空格。
2.命令替换。等同于`cmd`，shell扫描一遍命令行，发现了$(cmd)结构，便将$(cmd)中的cmd执行一次，得到其标准输出，再将此输出放到原来命令。有些shell不支持，如tcsh。
3.用于初始化数组。如：array=(a b c d)

##双小括号 (( ))
1.整数扩展。这种扩展计算是整数型的计算，不支持浮点型。((exp))结构扩展并计算一个算术表达式的值，如果表达式的结果为0，那么返回的退出状态码为1，或者 是"假"，而一个非零值的表达式所返回的退出状态码将为0，或者是"true"。若是逻辑判断，表达式exp为真则为1,假则为0。
2.只要括号中的运算符、表达式符合C语言运算规则，都可用在$((exp))中，甚至是三目运算符。作不同进位(如二进制、八进制、十六进制)运算时，输出结果全都自动转化成了十进制。如：echo $((16#5f)) 结果为95 (16进位转十进制)
3.单纯用 (( )) 也可重定义变量值，比如 a=5; ((a++)) 可将 $a 重定义为6
4.常用于算术运算比较，双括号中的变量可以不使用$符号前缀。括号内支持多个表达式用逗号分开。 只要括号中的表达式符合C语言运算规则,比如可以直接使用for((i=0;i<5;i++)), 如果不使用双括号, 则为for i in `seq 0 4`或者for i in {0..4}。再如可以直接使用if (($i<5)), 如果不使用双括号, 则为if [ $i -lt 5 ]。

1、在双括号结构中，所有表达式可以像c语言一样，如：a++,b--等。
2、在双括号结构中，所有变量可以不加入：“$”符号前缀。
3、双括号可以进行逻辑运算，四则运算
4、双括号结构 扩展了for，while,if条件测试运算
5、支持多个表达式运算，各个表达式之间用“，”分开

##单中括号 []
1.bash 的内部命令，[和test是等同的。如果我们不用绝对路径指明，通常我们用的都是bash自带的命令。if/test结构中的左中括号是调用test的命令标识，右中括号是关闭条件判断的。这个命令把它的参数作为比较表达式或者作为文件测试，并且根据比较的结果来返回一个退出状态码。if/test结构中并不是必须右中括号，但是新版的Bash中要求必须这样。
2.Test和[]中可用的比较运算符只有==和!=，两者都是用于字符串比较的，不可用于整数比较，整数比较只能使用-eq，-gt这种形式。无论是字符串比较还是整数比较都不支持大于号小于号。如果实在想用，对于字符串比较可以使用转义形式，如果比较"ab"和"bc"：[ ab \< bc ]，结果为真，也就是返回状态为0。[ ]中的逻辑与和逻辑或使用-a 和-o 表示。
3.字符范围。用作正则表达式的一部分，描述一个匹配的字符范围。作为test用途的中括号内不能使用正则。
4.在一个array 结构的上下文中，中括号用来引用数组中每个元素的编号。

##双中括号[[ ]]
1.[[是 bash 程序语言的关键字。并不是一个命令，[[ ]] 结构比[ ]结构更加通用。在[[和]]之间所有的字符都不会发生文件名扩展或者单词分割，但是会发生参数扩展和命令替换。
2.支持字符串的模式匹配，使用=~操作符时甚至支持shell的正则表达式。字符串比较时可以把右边的作为一个模式，而不仅仅是一个字符串，比如[[ hello == hell? ]]，结果为真。[[ ]] 中匹配字符串或通配符，不需要引号。
3.使用[[ ... ]]条件判断结构，而不是[ ... ]，能够防止脚本中的许多逻辑错误。比如，&&、||、<和> 操作符能够正常存在于[[ ]]条件判断结构中，但是如果出现在[ ]结构中的话，会报错。比如可以直接使用if [[ $a != 1 && $a != 2 ]], 如果不适用双括号, 则为if [ $a -ne 1] && [ $a != 2 ]或者if [ $a -ne 1 -a $a != 2 ]。
4.bash把双中括号中的表达式看作一个单独的元素，并返回一个退出状态码。

##{}
###常规用法
1.大括号拓展。(通配(globbing))将对大括号中的文件名做扩展。在大括号中，不允许有空白，除非这个空白被引用或转义。
第一种：对大括号中的以逗号分割的文件列表进行拓展。如 touch {a,b}.txt 结果为a.txt b.txt。
第二种：对大括号中以点点（..）分割的顺序文件列表起拓展作用，如：touch {a..d}.txt 结果为a.txt b.txt c.txt d.txt[cpp] view plaincopy
2.代码块，又被称为内部组，这个结构事实上创建了一个匿名函数 。与小括号中的命令不同，大括号内的命令不会新开一个子shell运行，即脚本余下部分仍可使用括号内变量。括号内的命令间用分号隔开，最后一个也必须有分号。{}的第一个命令和左括号之间必须要有一个空格。
###几种特殊的替换结构${var:-string},${var:+string},${var:=string},${var:?string}
1.${var:-string}和${var:=string}:若变量var为空，则用在命令行中用string来替换${var:-string}，否则变量var不为空时，则用变量var的值来替换${var:-string}；对于${var:=string}的替换规则和${var:-string}是一样的，所不同之处是${var:=string}若var为空时，用string替换${var:=string}的同时，把string赋给变量var： ${var:=string}很常用的一种用法是，判断某个变量是否赋值，没有的话则给它赋上一个默认值。
2.${var:+string}的替换规则和上面的相反，即只有当var不是空的时候才替换成string，若var为空时则不替换或者说是替换成变量 var的值，即空值。(因为变量var此时为空，所以这两种说法是等价的)
3.${var:?string}替换规则为：若变量var不为空，则用变量var的值来替换${var:?string}；若变量var为空，则把string输出到标准错误中，并从脚本中退出。我们可利用此特性来检查是否设置了变量的值。 补充扩展：在上面这五种替换结构中string不一定是常值的，可用另外一个变量的值或是一种命令的输出。
###四种模式匹配替换结构${var%pattern},${var%%pattern},${var#pattern},${var##pattern}
    第一种模式：${variable%pattern}，这种模式时，shell在variable中查找，看它是否一给的模式pattern结尾，如果是，就从命令行把variable中的内容去掉右边最短的匹配模式
    第二种模式： ${variable%%pattern}，这种模式时，shell在variable中查找，看它是否一给的模式pattern结尾，如果是，就从命令行把variable中的内容去掉右边最长的匹配模式
    第三种模式：${variable#pattern} 这种模式时，shell在variable中查找，看它是否一给的模式pattern开始，如果是，就从命令行把variable中的内容去掉左边最短的匹配模式
    第四种模式： ${variable##pattern} 这种模式时，shell在variable中查找，看它是否一给的模式pattern结尾，如果是，就从命令行把variable中的内容去掉右边最长的匹配模式 这四种模式中都不会改变variable的值，其中，只有在pattern中使用了*匹配符号时，%和%%，#和##才有区别。结构中的pattern支持通配符，*表示零个或多个任意字符，?表示仅与一个任意字符匹配，[...]表示匹配中括号里面的字符，[!...]表示不匹配中括号里面的字符。

echo ${var-DEFAULT}   #var没被声明, 那么就以$DEFAULT作为其值
echo ${var:-DEFAULT}  #var没被声明 或 其值为空, 那么就以$DEFAULT作为其值
echo ${var=DEFAULT}   #var没被声明, 那么就以$DEFAULT作为其值
echo ${var:=DEFAULT}  #var没被声明 或 其值为空, 那么就以$DEFAULT作为其值
echo ${var?ERR_MSG}   #var没被声明, 那么就打印$ERR_MSG
echo ${var:?ERR_MSG}  #var没被设置, 那么就打印$ERR_MSG

echo ${var+OTHER}     #var被声明, 那么其值就是$OTHER, 否则就为null字符串
echo ${var:+OTHER}    #var被设置, 那么其值就是$OTHER, 否则就为null字符串

echo ${!varprefix*}   #匹配之前所有以varprefix开头进行声明的变量
echo ${!varprefix@}   #同上

##符号$后的括号
1 ${a} 变量a的值, 在不引起歧义的情况下可以省略大括号。
2 $(cmd) 命令替换，和`cmd`效果相同，结果为shell命令cmd的输，过某些Shell版本不支持$()形式的命令替换, 如tcsh。
3 $((expression)) 和`exprexpression`效果相同, 计算数学表达式exp的数值, 其中exp只要符合C语言的运算规则即可, 甚至三目运算符和逻辑表达式都可以计算。



---
#参考资料
[鸟哥Linux私房菜](http://book.douban.com/subject/2208530/) 
[Advance Bash-Scripting Guide](http://book.douban.com/subject/3010746/)

