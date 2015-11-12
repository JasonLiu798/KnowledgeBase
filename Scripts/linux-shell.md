#linux常用
----
[Shell中字符串分割的三种方法](http://blog.csdn.net/chen_jp/article/details/8922582)

var='1,2,3,4,5'
var=${var//,/ }    #这里是将var中的,替换为空格  
for element in $var   
do  
    echo $element  
done


##cut
user='mark:x:0:0:this is a test user:/var/mark:nologin'
echo $user|cut -d ":" -f$i

----
#数组
[](http://blog.csdn.net/ysdaniel/article/details/7909824)
[shell脚本中数组array常用技巧学习实践 字符串切割](http://blog.csdn.net/zhuying_linux/article/details/6778877)
---
#循环
[循环](http://www.linuxidc.com/Linux/2012-02/53030.htm)
