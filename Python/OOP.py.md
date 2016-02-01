#classOOP
---
#docs

---
#概念
类同样也是一种对象
这个对象（类）自身拥有创建对象（类实例）的能力，而这就是为什么它是一个类的原因
于是乎你可以对它做如下的操作：
1)   你可以将它赋值给一个变量
2)   你可以拷贝它
3)   你可以为它增加属性
4)   你可以将它作为函数参数进行传递
动态地创建类
因为类也是对象，你可以在运行时动态的创建它们，就像其他任何对象一样
type()

---
#类函数
在类中定义的函数只有一点不同，就是第一个参数永远是实例变量self，并且，调用时，不用传递该参数


---
#类变量
    紧接在类名后面定义，相当于java和c++的static变量
    实例的变量名如果以__开头，就变成了一个私有变量（private）


---
#实例变量
    __init__里定义，相当于java和c++的普通变量


---
#继承
class Dog(Animal):

判断一个变量是否是某个类型可以用isinstance()


---
#Mixin


---
#type
type就是创建类对象的类
创建一个class对象，type()函数依次传入3个参数：
class的名称；
继承的父类集合，注意Python支持多重继承，如果只有一个父类，别忘了tuple的单元素写法；
class的方法名称与函数绑定，这里我们把函数fn绑定到方法名hello上。
```python
MyShinyClass = type('MyShinyClass', (), {'bar':True})  
```

----
#metaclass
[深刻理解Python中的元类(metaclass)](http://blog.jobbole.com/21351/)
__metaclass__属性
你可以在写一个类的时候为其添加__metaclass__属性。
```python
class Foo(object):
    __metaclass__ = something…
[…]
```
如果你这么做了，Python就会用元类来创建类Foo
    小心点，这里面有些技巧
    你首先写下class Foo(object)，但是类对象Foo还没有在内存中创建
Python会在类的定义中寻找__metaclass__属性
    如果找到了，Python就会用它来创建类Foo
    如果没有找到，就会用内建的type来创建这个类

当你写如下代码时 :
```python
class Foo(Bar):
    pass
```
Python做了如下的操作：
Foo中有__metaclass__这个属性吗？
    如果是，Python会在内存中通过__metaclass__创建一个名字为Foo的类对象（我说的是类对象，请紧跟我的思路）。
    如果Python没有找到__metaclass__，它会继续在Bar（父类）中寻找__metaclass__属性，并尝试做和前面同样的操作
    如果Python在任何父类中都找不到__metaclass__，它就会在模块层次中去寻找__metaclass__，并尝试做同样的操作
    如果还是找不到__metaclass__,Python就会用内置的type来创建这个类对象。

现在的问题就是，你可以在__metaclass__中放置些什么代码呢？
答案就是：可以创建一个类的东西。
那么什么可以用来创建一个类呢？type，或者任何使用到type或者子类化type的东东都可以。

metaclass是创建类，所以必须从`type`类型派生：
```python
class ListMetaclass(type):
    def __new__(cls, name, bases, attrs):
        attrs['add'] = lambda self, value: self.append(value)
        return type.__new__(cls, name, bases, attrs)

class MyList(list):
    __metaclass__ = ListMetaclass # 指示使用ListMetaclass来定制类

```



---
#常用属性
##`__new__`
    __new__ 是在__init__之前被调用的特殊方法
    __new__是用来创建对象并返回之的方法
    __init__只是用来将传入的参数初始化给对象

__new__()方法接收到的参数依次是：
* 当前准备创建的类的对象；
* 类的名字；
* 类继承的父类集合；
* 类的方法集合

```
class UpperAttrMetaclass(type):
    def __new__(cls, name, bases, dct):
        attrs = ((name, value) for name, value in dct.items() if not name.startswith('__')
        uppercase_attr  = dict((name.upper(), value) for name, value in attrs)
        return type.__new__(cls, name, bases, uppercase_attr)

```

## `__slots__`
```python
def set_age(self, age): # 定义一个函数作为实例方法
    self.age = age
```

给一个实例绑定的方法，对另一个实例是不起作用的
为了给所有实例都绑定方法，可以给class绑定方法：
```python
def set_score(self, score):
    self.score = score
Student.set_score = MethodType(set_score, None, Student)
```
定义一个特殊的__slots__变量，来限制该class能添加的属性，对继承的子类是不起作用的

##@property
装饰器就是负责把一个方法变成属性调用的
```python
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


##`__str__`
直接显示变量调用的不是__str__()，而是__repr__()，两者的区别是__str__()返回用户看到的字符串，而__repr__()返回程序开发者看到的字符串，也就是说，__repr__()是为调试服务的。
解决办法是再定义一个__repr__()。
```python
class Student(object):
    def __init__(self, name):
        self.name = name
    def __str__(self):
        return 'Student object (name=%s)' % self.name
    __repr__ = __str__
```

##`__iter__`
如果一个类想被用于for ... in循环，类似list或tuple那样，就必须实现一个__iter__()方法，该方法返回一个迭代对象
```python
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

##`__getitem__`
要表现得像list那样按照下标取出元素
```python
class Fib(object):
    def __getitem__(self, n):
        a, b = 1, 1
        for x in range(n):
            a, b = b, a + b
        return a
```

##`__getattr__`
```python
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

##`__call__`
__call__()方法，就可以直接对实例进行调用
```python
class Student(object):
    def __init__(self, name):
        self.name = name

    def __call__(self):
        print('My name is %s.' % self.name)
调用方式如下：

s = Student('Michael')
s()
```



---
#ORM
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
