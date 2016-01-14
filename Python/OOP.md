---
#classOOP
在类中定义的函数只有一点不同，就是第一个参数永远是实例变量self，并且，调用时，不用传递该参数

实例的变量名如果以__开头，就变成了一个私有变量（private）
##类变量
    紧接在类名后面定义，相当于java和c++的static变量
##实例变量
    __init__里定义，相当于java和c++的普通变量

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
