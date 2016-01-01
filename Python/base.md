#python基础
-----
![语法速查](../img/python-grammer.jpg)
[Python 2.7教程](http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000)
----
#语法-变量
#数字
struct
解决str和其他二进制数据类型的转换。
struct的pack函数把任意数据类型变成字符串

---
#字符串string
''或""括起来的任意文本
转义字符\
ord()和chr()函数，可以把字母和对应的数字相互转换：
>>> ord('A')
>>> chr(65)

Unicode表示的字符串用u'...'
u'ABC'.encode('utf-8')
'\xe4\xb8\xad\xe6\x96\x87'.decode('utf-8')
len()

格式化
%d  整数
%f  浮点数
%s  字符串
%x  十六进制整数

##布尔值
True、False
and,or,not

##空值
None

##类型判断
type()
##正则
import re
>>> re.match(r'^\d{3}\-\d{3,8}$', '010-12345')

match()方法判断是否匹配，如果匹配成功，返回一个Match对象，否则返回None
re.split(r'\s+', 'a b   c')

###分组
除了简单地判断是否匹配之外，正则表达式还有提取子串的强大功能。用()表示的就是要提取的分组（Group）

##Base64
是一种用64个字符来表示任意二进制数据的方法。
>>> import base64
>>> base64.b64encode('binary\x00string')
'YmluYXJ5AHN0cmluZw=='
>>> base64.b64decode('YmluYXJ5AHN0cmluZw==')
'binary\x00string'

##hashlib
import hashlib
md5 = hashlib.md5()
md5.update('how to use md5 in python hashlib?')
print md5.hexdigest()

itertools提供了非常有用的用于操作迭代对象的函数



----
#集合
---
#list
classmates = ['Michael', 'Bob', 'Tracy']
index范围 -len ~ len-1
classmates.insert(1, 'Jack')
classmates.pop()

## 元素删除
python的列表list可以用for循环进行遍历，实际开发中发现一个问题，就是遍历的时候删除会出错，例如
```
l = [1,2,3,4]
for i in l:
    if i != 4:
    l.remove(i)
print l 
```
这几句话本来意图是想清空列表l，只留元素4，但是实际跑起来并不是那个结果。再看下面，利用index来遍历删除列表l

    l = [1, 2, 3, 4]
    for i in range(len(l)):
        if l[i] == 4:
            del l[i]
    print l

这样没问题，可以遍历删除，但是列表l如果变为 l = [1,2,3,4,5]
如果还是按照上面的方法，设想一下，range开始的范围是0-4，中间遍历的时候删除了一个元素4，这个时候列表变成了= [1,2,3,5],这时候就会报错了，提示下标超出了数组的表示，原因就是上面说的遍历的时候删除了元素
删除可以使用filter过滤返回新的list
```
l = [1,2,3,4]
l = filter(lambda x:x !=4,l)
print l
```
这样可以安全删除l中值为4的元素了，filter要求两个参数，第一个是规则函数，第二个参数要求输入序列，而lambda这个函数的作用就是产生一个函数，是一种紧凑小函数的写法，一般简单的函数可以这么些
或者可以这样
l = [1,2,3,4]
l = [ i for i in l if i !=4]//同样产生一个新序列，复值给l
print l
或者干脆建立新的list存放要删除的元素
l = [1,2,3,4]
dellist = []
for i in l:
    if i == 4:
        dellist.append(i)
for i in dellist:
    l.remove(i)
这样也能安全删除元素
所以要遍历的时候删除元素一定要小心，特别是有些操作并不报错，但却没有达到预期的效果
上面说到产生新序列，赋值等等，用python的id()这个内置函数来看对象的id,可以理解为内存中的地址，所以有个简要说明
如果
l = [1,2,3,4]
ll = l
l.remove(1)
print l//肯定是[2,3,4]
print ll//这里会是什么？
如果用id函数查看的话就发现
print id(l),id(ll)
打印出相同的号码，说明他们其实是一个值，也就是说上面的print ll将和l打印的一样，所以python有这种性质，用的时候注意一下就行了

---
#deque
使用list存储数据时，按索引访问元素很快，但是插入和删除元素就很慢了，因为list是线性存储，数据量大的时候，插入和删除效率很低。
deque是为了高效实现插入和删除操作的双向列表，适合用于队列和栈
>>> from collections import deque
>>> q = deque(['a', 'b', 'c'])
>>> q.append('x')
>>> q.appendleft('y')
>>> q
deque(['y', 'a', 'b', 'c', 'x'])


---
#tuple
一旦初始化就不能修改
classmates = ('Michael', 'Bob', 'Tracy')
tuple不可变，所以代码更安全
当你定义一个tuple时，在定义的时候，tuple的元素就必须被确定下来

只有1个元素的tuple定义时必须加一个逗号,，来消除歧
t = (1,)


##namedtuple
namedtuple是一个函数，它用来创建一个自定义的tuple对象，并且规定了tuple元素的个数，并可以用属性而不是索引来引用tuple的某个元素
>>> from collections import namedtuple
>>> Point = namedtuple('Point', ['x', 'y'])
>>> p = Point(1, 2)
>>> p.x
1
>>> p.y
2



---
#dict
##新建
http://developer.51cto.com/art/201003/188837.htm
dict1 = {}  
dict2 = {'name': 'earth', 'port': 80}  
方法②:从Python 2.2 版本起
fdict = dict((['x', 1], ['y', 2]))  
方法③:从Python 2.3 版本起, 可以用一个很方便的内建方法fromkeys() 来创建一个"默认"字典, 字典中元素具有相同的值 (如果没有给出， 默认为None):
ddict = {}.fromkeys(('x', 'y'), -1)  

PS：dict的key必须是不可变对象

##遍历
http://www.cnblogs.com/skyhacker/archive/2012/01/27/2330177.html

##合并
dict1={1:[1,11,111],2:[2,22,222]}
dict2={3:[3,33,333],4:[4,44,444]}
合并两个字典得到类似
{1:[1,11,111],2:[2,22,222],3:[3,33,333],4:[4,44,444]}
方法1：
dictMerged1=dict(dict1.items()+dict2.items())
方法2：
dictMerged2=dict(dict1, **dict2)
方法2等同于：
dictMerged=dict1.copy()
dictMerged.update(dict2)
或者
dictMerged=dict(dict1)
dictMerged.update(dict2)

#defaultdict
使用dict时，如果引用的Key不存在，就会抛出KeyError。如果希望key不存在时，返回一个默认值，就可以用defaultdict

#OrderedDict
使用dict时，Key是无序的。在对dict做迭代时，我们无法确定Key的顺序。
如果要保持Key的顺序，可以用OrderedDict

---
#set
和dict类似，也是一组key的集合，但不存储value。由于key不能重复，所以，在set中，没有重复的key。
s = set([1, 2, 3])

s1 & s2
set([2, 3])
s1 | s2
set([1, 2, 3, 4])


----
#if
if <条件判断1>:
    <执行1>
elif <条件判断2>:
    <执行2>
elif <条件判断3>:
    <执行3>
else:
    <执行4>

if x:
    print 'True'
只要x是非零数值、非空字符串、非空list等，就判断为True，否则为False。

---
#循环
for...in循环，依次把list或tuple中的每个元素迭代出来
names = ['Michael', 'Bob', 'Tracy']
for name in names:
    print name

序列 range(5)

while循环
只要条件满足，就不断循环，条件不满足时退出循环
sum = 0
n = 99
while n > 0:
    sum = sum + n
    n = n - 2
print sum

---




#*，**
两个数字之间：乘方
字符串、列表、元组与一个整数N相乘：返回一个其所有元素重复N次的同类型对象，比如"str"*3将返回字符串"strstrstr"





if __name__ == '__main__':
    statements


## json
http://www.cnblogs.com/coser/archive/2011/12/14/2287739.html
http://www.tuicool.com/articles/F3aU7j
json_input = '{ "one": 1, "two": { "list": [ {"item":"A"},{"item":"B"} ] } }'
 
try:
    decoded = json.loads(json_input)
except (ValueError, KeyError, TypeError):
    print "JSON format error"



## 反射
http://www.cnblogs.com/huxi/archive/2011/01/02/1924317.html
globals
http://blog.chinaunix.net/uid-9687384-id-1998500.html

---
#函数

def nop():
    pass
pass语句什么都不做，那有什么用？实际上pass可以用来作为占位符，比如现在还没想好怎么写函数的代码，就可以先放一个pass，让代码能运行起来。

##参数检查
调用函数时，如果参数个数不对，Python解释器会自动检查出来，并抛出TypeError：
但是如果参数类型不对，Python解释器就无法帮我们检查

##返回多个值
x, y = move(100, 100, 60, math.pi / 6)
>>>r = move(100, 100, 60, math.pi / 6)
>>>print r
(151.96152422706632, 70.0)

##默认参数

Python函数在定义的时候，默认参数L的值就被计算出来了，即[]，因为默认参数L也是一个变量，它指向对象[]，每次调用该函数，如果改变了L的内容，则下次调用时，默认参数的内容就变了，不再是函数定义时的[]了。

可以用None这个不变对象来实现：
def add_end(L=None):
    if L is None:
        L = []
    L.append('END')
    return L
PS：默认参数一定要用不可变对象，如果是可变对象，运行会有逻辑错误


## 参数传递
[python进阶教程之函数参数的多种传递方法](http://www.jb51.net/article/54503.htm)
[python中函数参数传递的几种方法](http://www.douban.com/note/13413855/)

###* 和 **
函数定义中参数前：
    * 将调用时的多个参数放入元组中，可变参数
    **则表示将调用函数时的关键字参数放入一个字典中，关键字参数
如定义以下函数
def func(*args):print(args)
当用func(1,2,3)调用函数时,参数args就是元组(1,2,3)
定义以下函数
def func(**args):print(args)
当用func(a=1,b=2)调用函数时,参数args将会是字典{'a':1,'b':2}

如果是在函数调用中,*args表示将可迭代对象扩展为函数的参数列表
args=(1,2,3)
func=(*args)
等价于函数调用func(1,2,3)
函数调用的**表示将字典扩展为关键字参数
args={'a':1,'b':2}
func(**args)
等价于函数调用 func(a=1,b=2)




### 示例
    import json
    class Student(object):
        def __init__(self, name, age):
            self.name = name
            self.age = age
        def get_name(self):
            return self.name
        def get_age(self):
            return self.age
    if __name__ == '__main__':
        jstr = '''
        {
            "name": "Student" ,
            "arguments": 
                [
                    {"name": "Bob"},
                    {"age": 14}
                ]
        }'''
        try:
            obj = json.loads(jstr)
            param = {}
            # merge dict
            for v in obj['arguments']:
                param = dict(v.items()+param.items())
                
            # create object
            res = globals()[obj['name']](**param)
            print res.get_name()
            print res.get_age()
        except (ValueError, KeyError, TypeError):
            print "JSON format error"

---
#generator
如果列表元素可以按照某种算法推算出来，那我们是否可以在循环的过程中不断推算出后续的元素呢？这样就不必创建完整的list，从而节省大量的空间。在Python中，这种一边循环一边计算的机制，称为生成器（Generator）。
>>>L = [x * x for x in range(10)]
>>>L
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
>>>g = (x * x for x in range(10))
>>>for n in g:
>>>...     print n

isgeneratorfunction 

#yield
[yeild ibm](http://www.ibm.com/developerworks/cn/opensource/os-cn-python-yield/)
[yeild](http://www.cnblogs.com/tqsummer/archive/2010/12/27/1917927.html)

如果一个函数定义中包含yield关键字，那么这个函数就不再是一个普通函数，而是一个generator
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        yield b
        a, b = b, a + b
        n = n + 1

generator和函数的执行流程不一样。
    * 函数是顺序执行，遇到return语句或者最后一行函数语句就返回。
    * generator在每次调用next()的时候执行，遇到yield语句返回，再次执行时从上次返回的yield语句处继续执行



----
#函数式编程
允许把函数本身作为参数传入另一个函数，还允许返回一个函数
高阶函数：
变量可以指向函数，函数名其实就是指向函数的变量
函数的参数能接收变量，那么一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数

##map
map(str, [1, 2, 3, 4, 5, 6, 7, 8, 9])
map将传入的函数依次作用到序列的每个元素，并把结果作为新的list返回

##reduce
把一个函数作用在一个序列[x1, x2, x3...]上，这个函数必须接收两个参数，reduce把结果继续和序列的下一个元素做累积计算
reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)

##filter
filter()把传入的函数依次作用于每个元素，然后根据返回值是True还是False决定保留还是丢弃该元素

##sort
sorted([36, 5, 12, 9, 21], reversed_cmp)

#闭包
如果不需要立刻求和，而是在后面的代码中，根据需要再计算怎么办？可以不返回求和的结果，而是返回求和的函数！

def lazy_sum(*args):
    def sum():
        ax = 0
        for n in args:
            ax = ax + n
        return ax
    return sum

>>> f1 = lazy_sum(1, 3, 5, 7, 9)
>>> f2 = lazy_sum(1, 3, 5, 7, 9)
>>> f1==f2

返回的函数并没有立刻执行，而是直到调用了f()才执行
返回闭包时牢记的一点就是：返回函数不要引用任何循环变量，或者后续会发生变化的变量。
```
def count():
    fs = []
    for i in range(1, 4):
        def f(j):
            def g():
                return j*j
            return g
        fs.append(f(i))
    return fs
```
如果一定要引用循环变量怎么办？方法是再创建一个函数，用该函数的参数绑定循环变量当前的值，无论该循环变量后续如何更改，已绑定到函数参数的值不变：

##匿名函数
关键字lambda表示匿名函数，冒号前面的x表示函数参数。
map(lambda x: x * x, [1, 2, 3, 4, 5, 6, 7, 8, 9])
匿名函数有个限制，就是只能有一个表达式，不用写return，返回值就是该表达式的结果

##装饰器
函数对象有一个__name__属性，可以拿到函数的名字
decorator就是一个返回函数的高阶函数
```
def log(func):
    def wrapper(*args, **kw):
        print 'call %s():' % func.__name__
        return func(*args, **kw)
    return wrapper

@log
def now():
    print '2013-12-25'
```
把@log放到now()函数的定义处，相当于执行了语句：
now = log(now)

如果decorator本身需要传入参数，那就需要编写一个返回decorator的高阶函数，写出来会更复杂。比如，要自定义log的文本：
```
def log(text):
    def decorator(func):
        def wrapper(*args, **kw):
            print '%s %s():' % (text, func.__name__)
            return func(*args, **kw)
        return wrapper
    return decorator

@log('execute')
def now():
    print '2013-12-25'

#相当于 now = log('execute')(now)
```
经过decorator装饰之后的函数，它们的__name__已经从原来的'now'变成了'wrapper'
functools.wraps相当于wrapper.__name__ = func.__name__
```
import functools

def log(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        print 'call %s():' % func.__name__
        return func(*args, **kw)
    return wrapper

#带参数的
def log(text):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kw):
            print '%s %s():' % (text, func.__name__)
            return func(*args, **kw)
        return wrapper
    return decorator
```

##偏函数
```
import functools
int2 = functools.partial(int, base=2)
```
functools.partial的作用就是，把一个函数的某些参数给固定住（也就是设置默认值），返回一个新的函数，调用这个新函数会更简单

----
#模块
```
#!/usr/bin/env python
# -*- coding: utf-8 -*-

' a test module '

__author__ = 'Michael Liao'

import sys

def test():
    args = sys.argv
    if len(args)==1:
        print 'Hello, world!'
    elif len(args)==2:
        print 'Hello, %s!' % args[1]
    else:
        print 'Too many arguments!'

if __name__=='__main__':
    test()
```

##别名
```
try:
    import cStringIO as StringIO
except ImportError: # 导入失败会捕获到ImportError
    import StringIO

try:
    import json # python >= 2.6
except ImportError:
    import simplejson as json # python <= 2.5
```

类似__xxx__这样的变量是特殊变量，可以被直接引用，但是有特殊用途，比如上面的__author__，__name__就是特殊变量，hello模块定义的文档注释也可以用特殊变量__doc__访问，我们自己的变量一般不要用这种变量名；

类似_xxx和__xxx这样的函数或变量就是非公开的（private），不应该被直接引用，比如_abc，__abc等；

之所以我们说，private函数和变量“不应该”被直接引用，而不是“不能”被直接引用，是因为Python并没有一种方法可以完全限制访问private函数或变量，但是，从编程习惯上不应该引用private函数或变量。

##包路径
默认情况下，Python解释器会搜索当前目录、所有已安装的内置模块和第三方模块，搜索路径存放在sys模块的path变量中

##__future__
from __future__ import unicode_literals

---
#OOP
在类中定义的函数只有一点不同，就是第一个参数永远是实例变量self，并且，调用时，不用传递该参数

实例的变量名如果以__开头，就变成了一个私有变量（private）

##继承
class Dog(Animal):

判断一个变量是否是某个类型可以用isinstance()

##__slots__
```
def set_age(self, age): # 定义一个函数作为实例方法
    self.age = age
```

给一个实例绑定的方法，对另一个实例是不起作用的

为了给所有实例都绑定方法，可以给class绑定方法：
```
def set_score(self, score):
    self.score = score
Student.set_score = MethodType(set_score, None, Student)
```

定义一个特殊的__slots__变量，来限制该class能添加的属性，对继承的子类是不起作用的

##@property
装饰器就是负责把一个方法变成属性调用的
```
class Student(object):

    @property
    def score(self):
        return self._score

    @score.setter
    def score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value
```

##Mixin




##__str__
直接显示变量调用的不是__str__()，而是__repr__()，两者的区别是__str__()返回用户看到的字符串，而__repr__()返回程序开发者看到的字符串，也就是说，__repr__()是为调试服务的。
解决办法是再定义一个__repr__()。
```
class Student(object):
    def __init__(self, name):
        self.name = name
    def __str__(self):
        return 'Student object (name=%s)' % self.name
    __repr__ = __str__
```

##__iter__
如果一个类想被用于for ... in循环，类似list或tuple那样，就必须实现一个__iter__()方法，该方法返回一个迭代对象
```
class Fib(object):
    def __init__(self):
        self.a, self.b = 0, 1 # 初始化两个计数器a，b

    def __iter__(self):
        return self # 实例本身就是迭代对象，故返回自己

    def next(self):
        self.a, self.b = self.b, self.a + self.b # 计算下一个值
        if self.a > 100000: # 退出循环的条件
            raise StopIteration();
        return self.a # 返回下一个值
```

##__getitem__
要表现得像list那样按照下标取出元素
class Fib(object):
    def __getitem__(self, n):
        a, b = 1, 1
        for x in range(n):
            a, b = b, a + b
        return a

##__getattr__
```
class Student(object):

    def __getattr__(self, attr):
        if attr=='age':
            return lambda: 25
        raise AttributeError('\'Student\' object has no attribute \'%s\'' % attr)


class Chain(object):
    def __init__(self, path=''):
        self._path = path
    def __getattr__(self, path):
        return Chain('%s/%s' % (self._path, path))
    def __str__(self):
        return self._path

Chain().status.user.timeline.list
```

##__call__
__call__()方法，就可以直接对实例进行调用
```
class Student(object):
    def __init__(self, name):
        self.name = name

    def __call__(self):
        print('My name is %s.' % self.name)
调用方式如下：

>>> s = Student('Michael')
>>> s()
```


##type
创建一个class对象，type()函数依次传入3个参数：
class的名称；
继承的父类集合，注意Python支持多重继承，如果只有一个父类，别忘了tuple的单元素写法；
class的方法名称与函数绑定，这里我们把函数fn绑定到方法名hello上。

##metaclass
```
# metaclass是创建类，所以必须从`type`类型派生：
class ListMetaclass(type):
    def __new__(cls, name, bases, attrs):
        attrs['add'] = lambda self, value: self.append(value)
        return type.__new__(cls, name, bases, attrs)

class MyList(list):
    __metaclass__ = ListMetaclass # 指示使用ListMetaclass来定制类
```
__new__()方法接收到的参数依次是：
当前准备创建的类的对象；
类的名字；
类继承的父类集合；
类的方法集合。

ORM
```
class User(Model):
    # 定义类的属性到列的映射：
    id = IntegerField('id')
    name = StringField('username')
    email = StringField('email')
    password = StringField('password')

# 创建一个实例：
u = User(id=12345, name='Michael', email='test@orm.org', password='my-pwd')
# 保存到数据库：
u.save()
```
metaclass可以隐式地继承到子类，但子类自己却感觉不到

PS:千万不要把实例属性和类属性使用相同的名字

----
#异常处理
```
try:
    print 'try...'
    r = 10 / int('a')
    print 'result:', r
except ValueError, e:
    print 'ValueError:', e
except ZeroDivisionError, e:
    print 'ZeroDivisionError:', e
    raise  #向上抛出
else:
    print 'no error!'  #没有错误发生
finally:
    print 'finally...'
print 'END'
```

---
#调试
##assert 
assert n != 0, 'n is zero!'
Python解释器时可以用-O参数来关闭assert

##logging
import logging
s = '0'
n = int(s)
logging.info('n = %d' % n)

##pdb
python -m pdb err.py
l查看代码
n可以单步执行代码
p 变量名 查看变量
q结束调试

pdb.set_trace()，就可以设置一个断点

##单元测试
unittest

编写一个测试类，从unittest.TestCase继承
```
class Dict(dict):

    def __init__(self, **kw):
        super(Dict, self).__init__(**kw)

    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError:
            raise AttributeError(r"'Dict' object has no attribute '%s'" % key)

    def __setattr__(self, key, value):
        self[key] = value



#测试类
import unittest
from mydict import Dict
class TestDict(unittest.TestCase):

    def test_init(self):
        d = Dict(a=1, b='test')
        self.assertEquals(d.a, 1)
        self.assertEquals(d.b, 'test')
        self.assertTrue(isinstance(d, dict))

    def test_key(self):
        d = Dict()
        d['key'] = 'value'
        self.assertEquals(d.key, 'value')

    def test_attr(self):
        d = Dict()
        d.key = 'value'
        self.assertTrue('key' in d)
        self.assertEquals(d['key'], 'value')

    def test_keyerror(self):
        d = Dict()
        with self.assertRaises(KeyError):
            value = d['empty']

    def test_attrerror(self):
        d = Dict()
        with self.assertRaises(AttributeError):
            value = d.empty

if __name__ == '__main__':
    unittest.main()

python -m unittest mydict_test
```

##文档测试
doctest






