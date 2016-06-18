#String
----
##flex
取代lex
##bison
取代yacc

-----
#tr
[tr](http://fyan.iteye.com/blog/1172279)

[Shell中字符串分割的三种方法](http://blog.csdn.net/chen_jp/article/details/8922582)

var='1,2,3,4,5'
var=${var//,/ }    #这里是将var中的,替换为空格
for element in $var
do
    echo $element
done


---
#sed


---
#cut
user='mark:x:0:0:this is a test user:/var/mark:nologin'
echo $user|cut -d ":" -f$i

---
#grep
grep -C 5 foo file 显示file文件里匹配foo字串那行以及上下5行
grep -B 5 foo file 显示foo及前5行
grep -A 5 foo file 显示foo及后5行
-i 忽略大小写
-w 精确匹配，按单词
-l 只有文件名
-r 递归
-v 不匹配的行
-c 总行数
-n 行号
-H 文件名
-E 扩展正则， |
egrep=grep -E
egrep 'matches|Matches' file.txt
fgrep=grep -F
按照字符串字面意思进行的搜索(即不允许使用正则表达式)


---
#awk
```bash
##获取第N(示例为7)段之后所有内容
awk '{i=0;s=""; while(i<=NF){ i++; if (i>=7) s=s" "$i;}print s}'
```
[常用-语法](http://man.linuxde.net/awk)








































