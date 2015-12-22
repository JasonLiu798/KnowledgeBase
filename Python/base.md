#python基础
-----
#安装卸载包
python setup.py install --record files.txt
cat files.txt | xargs rm -rf 


----
#语法
#变量
##字符串
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

---
#list
classmates = ['Michael', 'Bob', 'Tracy']
index范围 -len ~ len-1
classmates.insert(1, 'Jack')
classmates.pop()

#tuple
一旦初始化就不能修改
classmates = ('Michael', 'Bob', 'Tracy')
tuple不可变，所以代码更安全
当你定义一个tuple时，在定义的时候，tuple的元素就必须被确定下来

只有1个元素的tuple定义时必须加一个逗号,，来消除歧
t = (1,)




## 字典
### 新建
http://developer.51cto.com/art/201003/188837.htm
dict1 = {}  
dict2 = {'name': 'earth', 'port': 80}  
方法②:从Python 2.2 版本起
fdict = dict((['x', 1], ['y', 2]))  
方法③:从Python 2.3 版本起, 可以用一个很方便的内建方法fromkeys() 来创建一个"默认"字典, 字典中元素具有相同的值 (如果没有给出， 默认为None):
ddict = {}.fromkeys(('x', 'y'), -1)  

PS：dict的key必须是不可变对象

### 遍历
http://www.cnblogs.com/skyhacker/archive/2012/01/27/2330177.html

### 合并
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

#assert 
assert n != 0, 'n is zero!'


----
## subprocess
这里的内容以Linux进程基础和Linux文本流为基础。subprocess包主要功能是执行外部的命令和程序。比如说，我需要使用wget下载文件。我在Python中调用wget程序。从这个意义上来说，subprocess的功能与shell类似。

1. subprocess以及常用的封装函数
当我们运行python的时候，我们都是在创建并运行一个进程。正如我们在Linux进程基础中介绍的那样，一个进程可以fork一个子进程，并让这个子进程exec另外一个程序。在Python中，我们通过标准库中的subprocess包来fork一个子进程，并运行一个外部的程序(fork，exec见Linux进程基础)。
subprocess包中定义有数个创建子进程的函数，这些函数分别以不同的方式创建子进程，所以我们可以根据需要来从中选取一个使用。另外subprocess还提供了一些管理标准流(standard stream)和管道(pipe)的工具，从而在进程间使用文本通信。
使用subprocess包中的函数创建子进程的时候，要注意:
1) 在创建子进程之后，父进程是否暂停，并等待子进程运行。
2) 函数返回什么
3) 当returncode不为0时，父进程如何处理。

subprocess.call()
父进程等待子进程完成
返回退出信息(returncode，相当于exit code，见Linux进程基础)
subprocess.check_call()
父进程等待子进程完成
返回0
检查退出信息，如果returncode不为0，则举出错误subprocess.CalledProcessError，该对象包含有returncode属性，可用try...except...来检查(见Python错误处理)。
subprocess.check_output()
父进程等待子进程完成
返回子进程向标准输出的输出结果
检查退出信息，如果returncode不为0，则举出错误subprocess.CalledProcessError，该对象包含有returncode属性和output属性，output属性为标准输出的输出结果，可用try...except...来检查。

这三个函数的使用方法相类似，我们以subprocess.call()来说明:
import subprocess 
rc = subprocess.call(["ls","-l"]) 
我们将程序名(ls)和所带的参数(-l)一起放在一个表中传递给subprocess.call()
可以通过一个shell来解释一整个字符串:
import subprocess 
out = subprocess.call("ls -l", shell=True) 
out = subprocess.call("cd ..", shell=True) 
我们使用了shell=True这个参数。这个时候，我们使用一整个字符串，而不是一个表来运行子进程。Python将先运行一个shell，再用这个shell来解释这整个字符串。
shell命令中有一些是shell的内建命令，这些命令必须通过shell运行，$cd。shell=True允许我们运行这样一些命令。
2. Popen
实际上，我们上面的三个函数都是基于Popen()的封装(wrapper)。这些封装的目的在于让我们容易使用子进程。当我们想要更个性化我们的需求的时候，就要转向Popen类，该类生成的对象用来代表子进程。
与上面的封装不同，Popen对象创建后，主程序不会自动等待子进程完成。我们必须调用对象的wait()方法，父进程才会等待 (也就是阻塞block)：
import subprocess 
child = subprocess.Popen(["ping","-c","5","www.google.com"]) 
print("parent process") 
从运行结果中看到，父进程在开启子进程之后并没有等待child的完成，而是直接运行print。
对比等待的情况:
import subprocess 
child = subprocess.Popen(["ping","-c","5","www.google.com"]) 
child.wait() 
print("parent process") 
此外，你还可以在父进程中对子进程进行其它操作，比如我们上面例子中的child对象:
child.poll()           # 检查子进程状态
child.kill()           # 终止子进程
child.send_signal()    # 向子进程发送信号
child.terminate()      # 终止子进程
子进程的PID存储在child.pid
3. 子进程的文本流控制
(沿用child子进程) 子进程的标准输入，标准输出和标准错误也可以通过如下属性表示:
child.stdin
child.stdout
child.stderr
我们可以在Popen()建立子进程的时候改变标准输入、标准输出和标准错误，并可以利用subprocess.PIPE将多个子进程的输入和输出连接在一起，构成管道(pipe):
import subprocess 
child1 = subprocess.Popen(["ls","-l"], stdout=subprocess.PIPE) 
child2 = subprocess.Popen(["wc"], stdin=child1.stdout,stdout=subprocess.PIPE) 
out = child2.communicate() 
print(out)
subprocess.PIPE实际上为文本流提供一个缓存区。child1的stdout将文本输出到缓存区，随后child2的stdin从该PIPE中将文本读取走。child2的输出文本也被存放在PIPE中，直到communicate()方法从PIPE中读取出PIPE中的文本。
要注意的是，communicate()是Popen对象的一个方法，该方法会阻塞父进程，直到子进程完成。
我们还可以利用communicate()方法来使用PIPE给子进程输入:
import subprocess 
child = subprocess.Popen(["cat"], stdin=subprocess.PIPE) 
child.communicate("vamei") 
我们启动子进程之后，cat会等待输入，直到我们用communicate()输入"vamei"。
通过使用subprocess包，我们可以运行外部程序。这极大的拓展了Python的功能。如果你已经了解了操作系统的某些应用，你可以从Python中直接调用该应用(而不是完全依赖Python)，并将应用的结果输出给Python，并让Python继续处理。shell的功能(比如利用文本流连接各个应用)，就完全可以在Python中实现。这也是Python经常被称为脚本语言，并拿来和bash以及Perl进行比较的原因之一。相对于bash和perl，Python的语法更加动态灵活，也大大提高了脚本的可读性与可维护性。当然，bash和perl也有各自的优势(比如bash更加贴近系统，而perl有更强大的正则表达式工具)，我们可以根据自身需要进行选择。
总结:
subprocess.call
subprocess.check_call()
subprocess.check_output()
subprocess.Popen(), subprocess.PIPE
Popen.wait(), Popen.communicate()



