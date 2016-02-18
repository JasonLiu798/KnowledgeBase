---
#blog
https://github.com/dengmin/logpress-tornado.git

---
#网络相关
##ssh
[pexpect](http://blog.csdn.net/lwnylslwnyls/article/details/8239791)
pip install pexpect


---
#editor
##代码高亮
Pygments
##makedown
markdown
[rux markdonw-html](https://github.com/hit9/rux)


---
#序列化
##json
[Json概述以及python对json的相关操作](http://www.cnblogs.com/coser/archive/2011/12/14/2287739.html)
```python
import json
encodedjson = json.dumps(obj,sort_keys=True,indent=4)
decodejson = json.loads(encodedjson)
```
##pickle
[python 的对象序列化/反序列化](http://san-yun.iteye.com/blog/1562883)
```python
import marshal,pickle  
  
list = [1]  
list.append(list)  
print marshal.dumps(list) #出错, 无限制的递归序列化  
print pickle.dumps(list) #no problem  

```




---
#算法相关
##排列组合
[itertools](https://docs.python.org/2/library/itertools.html?highlight=itertools.permutations#itertools.permutations)
```python
import itertools
list1 = 'abc'
list2 = []
for i in range(1,len(list1)+1):
    iter = itertools.combinations(list1,i) #组合
    iter = itertools.permutations(list1,i) #排列
    list2.append(list(iter))
print(list2)
```
[[('a',), ('b',), ('c',)], [('a', 'b'), ('a', 'c'), ('b', 'c')], [('a', 'b', 'c')]]
[[('a',), ('b',), ('c',)], [('a', 'b'), ('a', 'c'), ('b', 'a'), ('b', 'c'), ('c', 'a'), ('c', 'b')], [('a', 'b', 'c'), ('a', 'c', 'b'), ('b', 'a', 'c'), ('b', 'c', 'a'), ('c', 'a', 'b'), ('c', 'b', 'a')]]

##随机数
```python
import random
#random.uniform(a, b),返回[a,b]之间的浮点数
print random.uniform(10, 20)  
#random.randint(a, b),返回[a,b]之间的整数
print random.randint(12, 20)
#random.randrange([start], stop[, step])，从指定范围内，按指定基数递增的集合中 获取一个随机数
random.randrange(10, 100, 2)
    #结果相当于从[10, 12, 14, 16, ... 96, 98]序列中获取一个随机数。
random.randrange(10, 100, 2)
    #在结果上与 random.choice(range(10, 100, 2) 等效。
random.choice(sequence)
    #参数sequence表示一个有序类型。这里要说明 一下：sequence在python不是一种特定的类型，而是泛指一系列的类型。list, tuple, 字符串都属于sequence。
random.shuffle(x[, random])
    #用于将一个列表中的元素打乱
random.sample(sequence, k)
    #从指定序列sequence中随机获取指定长度k的片断。sample函数不会修改原有序列。
```

##加解密
###rsa
pip install rsa
[rsa](http://www.360doc.com/content/14/1205/21/14009801_430694237.shtml)
[rsa raw](https://github.com/Jackeriss/RSA)

###base64
[base64 自定义](http://book.51cto.com/art/201405/440070.htm)

###DES
[pyDes](http://www.cnblogs.com/txw1958/archive/2012/07/20/python-des-3des.html)
[同上](http://my.oschina.net/liupengs/blog/124230)
[pydes github](https://github.com/toddw-as/pyDes)




