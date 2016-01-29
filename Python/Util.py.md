---
#注释
```
#单行
'''
    多行
'''
"""
    多行
"""

```

---
#ssh
[pexpect](http://blog.csdn.net/lwnylslwnyls/article/details/8239791)
pip install pexpect

---
#字符串处理
##代码高亮
Pygments
##makedown
markdown

[rux markdonw-html](https://github.com/hit9/rux)


---
#随机数
```
import random

#random.uniform(a, b),返回[a,b]之间的浮点数
print random.uniform(10, 20)     
#random.randint(a, b),返回[a,b]之间的整数
print random.randint(12, 20)

#random.randrange([start], stop[, step])，从指定范围内，按指定基数递增的集合中 获取一个随机数
random.randrange(10, 100, 2)
    结果相当于从[10, 12, 14, 16, ... 96, 98]序列中获取一个随机数。
random.randrange(10, 100, 2)
    在结果上与 random.choice(range(10, 100, 2) 等效。
random.choice(sequence)
    参数sequence表示一个有序类型。这里要说明 一下：sequence在python不是一种特定的类型，而是泛指一系列的类型。list, tuple, 字符串都属于sequence。
random.shuffle(x[, random])
    用于将一个列表中的元素打乱
    p = ["Python", "is", "powerful", "simple", "and so on..."]     
    random.shuffle(p)     
    print p     

random.sample(sequence, k)
    从指定序列中随机获取指定长度的片断。sample函数不会修改原有序列。
    list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]     
    slice = random.sample(list, 5) #从list中随机获取5个元素，作为一个片断返回     
    print slice     
    print list #原有序列并没有改变
```
