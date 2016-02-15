#函数式编程
---

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
```
f1 = lazy_sum(1, 3, 5, 7, 9)
f2 = lazy_sum(1, 3, 5, 7, 9)
f1==f2
```
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
