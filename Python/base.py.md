#python基础
-----
![语法速查](../img/python-grammer.jpg)
[Python 2.7教程](http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000)
[你见过哪些令你瞠目结舌的 Python 代码技巧？](https://www.zhihu.com/question/37904398)
----
#语法-变量
#变量判断
##是否存在
内置函数locals()：
    'testvar'   in   locals().keys()
内置函数dir()：
    'testvar'   in   dir()
内置函数vars()：
    vars().has_key('testvar')
try...except...

#数字
struct
解决str和其他二进制数据类型的转换。
struct的pack函数把任意数据类型变成字符串

---
#string字符串
''或""括起来的任意文本
转义字符\
ord()和chr()函数，可以把字母和对应的数字相互转换：
```
ord('A')
chr(65)
```
##字符串拼接
```
'Jim' + 'Green' = 'JimGreen'
'Jim', 'Green' = 'Jim Green'  #中间会有空格
'Jim''Green' = 'JimGreen'
'%s, %s' % ('Jim', 'Green') = 'Jim, Green'
str.join(some_list)
#字符串乘法
a = 'abc'  a * 3 = 'abcabcabc'
```
##Unicode
u'...'
u'ABC'.encode('utf-8')
'\xe4\xb8\xad\xe6\x96\x87'.decode('utf-8')
len()
```
UnicodeEncodeError: 'ascii' codec can't encode characters in position 0-3 
在文件前加两句话： 
reload(sys)
sys.setdefaultencoding( "utf-8" )
```


格式化
%d  整数
%f  浮点数
%s  字符串
%x  十六进制整数

##布尔值 bool
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
#collection集合
---
#list
classmates = ['Michael', 'Bob', 'Tracy']
index范围 -len ~ len-1
classmates.insert(1, 'Jack')
classmates.pop()
##删除元素
python的列表list可以用for循环进行遍历，实际开发中发现一个问题，就是遍历的时候删除会出错，例如
```
l = [1,2,3,4]  #默认初始都为此
for i in l:
    if i != 4:
    l.remove(i) #本来意图是想清空列表l，只留元素4
print l         #实际结果[2, 4] 
```
再看下面，
```
for i in range(len(l)):
    if l[i] == 4:
        del l[i]        #利用index来遍历删除列表l
print l                 #结果 [1, 2, 3]
```
这样没问题，可以遍历删除，但是列表l如果变为 l = [1,2,3,4,5]
如果还是按照上面的方法，设想一下，range开始的范围是0-4，中间遍历的时候删除了一个元素4，这个时候列表变成了= [1,2,3,5],这时候就会报错了，提示下标超出了数组的表示，原因就是上面说的遍历的时候删除了元素
删除可以使用filter过滤返回新的list
```
l = filter(lambda x:x!=4,l)
#或者
l = [ i for i in l if i !=4]//同样产生一个新序列，复值给l
```
filter要求两个参数，第一个是规则函数，第二个参数要求输入序列
##排序
sorted(iterable[, cmp[, key[, reverse]]])
    cmp为函数，指定排序时进行比较的函数，可以指定一个函数或者lambda函数
    key为函数，指定取待排序元素的哪一项进行排序
```python
res=sorted(list)  
list.sort()
dict
sorted(d.items(), key=lambda d:d[0]) #按key
sorted(d.items(), key=lambda d:d[1]) #按值
```
###指定cmp
L = [('b',6),('a',1),('c',3),('d',4)]
L.sort(lambda x,y:cmp(x[1],y[1])) 
###指定key
L.sort(key=lambda x:x[1]) 
###指定key operator.itemgetter
import operator
L.sort(key=operator.itemgetter(1)) 
###DSU方法:Decorate-Sort-Undercorate
L = [('b',2),('a',1),('c',3),('d',4)]
A = [(x[1],i,x) for i,x in enumerate(L)] #i can confirm the stable sort
A.sort()
L = [s[2] for s in A]
###效率比较
cmp < DSU < key


##拷贝
```
5种拷贝方式：
1.listb = lista[:]
2.listb = list(lista)
3.listb = [i for i in lista]
4.import copy; listb = copy.copy(lista)
5.import copy; listb = copy.deepcopy(lista)
拷贝后续操作：
listb[1].append(9)
print lista, listb
五种拷贝方式后续操作的结果：
1. [2, [4, 5, 9]] [2, [4, 5, 9]]
2. [2, [4, 5, 9]] [2, [4, 5, 9]]
3. [2, [4, 5, 9]] [2, [4, 5, 9]]
4. [2, [4, 5, 9]] [2, [4, 5, 9]]
5. [2, [4, 5]] [2, [4, 5, 9]]
```

---
#deque
使用list存储数据时，按索引访问元素很快，但是插入和删除元素就很慢了，因为list是线性存储，数据量大的时候，插入和删除效率很低。
deque是为了高效实现插入和删除操作的双向列表，适合用于队列和栈
```
from collections import deque
q = deque(['a', 'b', 'c'])
q.append('x')
q.appendleft('y')
q
deque(['y', 'a', 'b', 'c', 'x'])
```

---
#tuple
一旦初始化就不能修改
classmates = ('Michael', 'Bob', 'Tracy')
tuple不可变，所以代码更安全
tuple可hash，可以放入set
当你定义一个tuple时，在定义的时候，tuple的元素就必须被确定下来
只有1个元素的tuple定义时必须加一个逗号,，来消除歧
t = (1,)
您不能向 tuple 增加元素。Tuple 没有 append 或 extend 方法。
您不能从 tuple 删除元素。Tuple 没有 remove 或 pop 方法。
您不能在 tuple 中查找元素。Tuple 没有 index 方法。
然而, 您可以使用 in 来查看一个元素是否存在于 tuple 中。
#namedtuple
namedtuple是一个函数，它用来创建一个自定义的tuple对象，并且规定了tuple元素的个数，并可以用属性而不是索引来引用tuple的某个元素
```
from collections import namedtuple
Point = namedtuple('Point', ['x', 'y'])
p = Point(1, 2)
print p.x #1
print p.y #2
```

##zip([seql, ...])
接受一系列可迭代对象作为参数，将对象中对应的元素打包成一个个tuple（元组），然后返回由这些tuples组成的list（列表）。若传入参数的长度不等，则返回list的长度和参数中长度最短的对象相同。

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


---
#itertools
[itertools 的使用](http://blog.csdn.net/xiaocaiju/article/details/6968123)


----
#控制语句
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
#三元表达式
variable = a if exper else b
variable = (exper and [b] or [c])[0]
variable = bool(exper) and b or c

---
#switch
```
#python中是没用switch语句的，一般多用字典来代替switch来实现
def jia(x,y):  
    print x+y  
def jian(x,y):  
    print x-y  
def cheng(x,y):  
    print x*y  
def chu(x,y):  
    print x/y  
operator = {'+':jia,'-':jian,'*':cheng,'/':chu}  
def f(x,o,y):  
    operator.get(o)(x,y)
f(3,'+',2)
```


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
```
r = move(100, 100, 60, math.pi / 6)
print r
(151.96152422706632, 70.0)
```

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
#module模块
[python中的import，reload，以及__import__](http://blog.csdn.net/turkeyzhou/article/details/8846527)
##引入模块
import
作用：导入/引入一个python标准模块，其中包括.py文件、带有__init__.py文件的目录。
`__import__`
作用：同import语句同样的功能，但__import__是一个函数，并且只接收字符串作为参数，所以它的作用就可想而知了。其实import语句就是调用这个函数进行导入工作的，import sys <==>sys = __import__('sys')
```python
__import__(module_name[, globals[, locals[, fromlist]]]) #可选参数默认为globals(),locals(),[]
__import__('os')    
__import__('os',globals(),locals(),['path','pip'])  #等价于from os import path, pip
```
说明：通常在动态加载时可以使用到这个函数，比如你希望加载某个文件夹下的所用模块，但是其下的模块名称又会经常变化时，就可以使用这个函数动态加载所有模块了，最常见的场景就是插件功能的支持。



reload
作用：对已经加载的模块进行重新加载，一般用于原模块有变化等特殊情况，reload前该模块必须已经import过。
但原来已经使用的实例还是会使用旧的模块，而新生产的实例会使用新的模块；reload后还是用原来的内存地址；不能支持from。。import。。格式的模块进行重新加载。

使用场景
```python
import sys   #引用sys模块进来，并不是进行sys的第一次加载  
reload(sys)  #重新加载sys  
sys.setdefaultencoding('utf8')  ##调用setdefaultencoding函数  


import sys     
sys.setdefaultencoding('utf8')   #失败
```
为什么要在调用setdefaultencoding时必须要先reload一次sys模块？
因为这里的import语句其实并不是sys的第一次导入语句，也就是说这里其实可能是第二、三次进行sys模块的import
这里只是一个对sys的引用，只能reload才能进行重新加载；
那么为什么要重新加载，而直接引用过来则不能调用该函数呢？因为setdefaultencoding函数在被系统调用后被删除了，所以通过import引用进来时其实已经没有了，所以必须reload一次sys模块，这样setdefaultencoding才会为可用，才能在代码里修改解释器当前的字符编码。


##引入自定义模块
模块搜索路径 
print sys.path
###同目录
直接import
###子目录
子目录中增加一个空白的__init__.py文件，该文件使得python解释器将子目录整个也当成一个模块，然后直接通过“import 子目录.模块”导入
###父目录/不同目录
M1:
在sys.path列表中添加新的路径 import sys，sys.path.append('父目录、其他目录的路径')
M2:
添加路径到环境变量   PYTHONPATH
M3:将库文件复制到sys.path列表中的目录里（如site-packages目录）
###模块所在路径
print modulename.__file__

##模块别名
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
之所以我们说，private函数和变量“不应该”被直接引用，而不是“不能”被直接引用，是因为Python并没有一种方法可以完全限制访问private函数或变量，但是，从编程习惯上不应该引用private函数或变量

##直接引入函数/类
from sound.effects.echo import echofilter
from sound.effects.echo import *

##`__future__`未来将要加入特性
from __future__ import unicode_literals


----
#exception异常处理
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
##抛出异常
raise [SomeException [, args [,traceback]]  
第一个参数，SomeException必须是一个异常类，或异常类的实例
第二个参数是传递给SomeException的参数，必须是一个元组。这个参数用来传递关于这个异常的有用信息。
第三个参数traceback很少用，主要是用来提供一个跟中记录对象（traceback）
raise NameError,("There is a name error","in test.py")  

另一种获取异常信息的途径是通过sys模块中的exc_info()函数。该函数回返回一个三元组:(异常类，异常类的实例，跟中记录对象)
tuple = sys.exc_info()  
##常用异常类
Error
AttributeError：属性错误，特性引用和赋值失败时会引发属性错误
NameError：试图访问的变量名不存在
SyntaxError：语法错误，代码形式错误
Exception：所有异常的基类，因为所有python异常类都是基类Exception的其中一员，异常都是从基类Exception继承的，并且都在exceptions模块中定义。
IOError：一般常见于打开不存在文件时会引发IOError错误，也可以解理为输出输入错误
KeyError：使用了映射中不存在的关键字（键）时引发的关键字错误
IndexError：索引错误，使用的索引不存在，常索引超出序列范围，什么是索引
TypeError：类型错误，内建操作或是函数应于在了错误类型的对象时会引发类型错误
ZeroDivisonError：除数为0，在用除法操作时，第二个参数为0时引发了该错误
ValueError：值错误，传给对象的参数类型不正确，像是给int()函数传入了字符串数据类型的参数。

---
#调试
##assert 
assert n != 0, 'n is zero!'
Python解释器时可以用-O参数来关闭assert

try:  
    assert 1 == 2 , "1 is not equal 2!"  
except AssertionError,reason:  
    print "%s:%s"%(reason.__class__.__name__,reason)  


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


---
#单元测试
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






