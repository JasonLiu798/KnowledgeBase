#函数式编程
---
[函数式思维和函数式编程](http://www.oschina.net/news/54999/programming-thinking-functional-way)
[函数式编程很难，这正是你要学习它的原因](http://kb.cnblogs.com/page/118598/)

#基本特点
* 支持闭包和高阶函数。
* 支持懒惰计算（lazy evaluation）     
* 使用递归作为控制流程的机制     
    使用参数保存状态，最好的例子就是递归
* 加强了引用透明性        
    指的是函数的运行不依赖于外部变量或"状态"，只依赖于输入的参数，任何时候只要参数相同，引用函数所得到的返回值总是相同的。
    有了前面的第三点和第四点，这点是很显然的。其他类型的语言，函数的返回值往往与系统状态有关，不同的状态之下，返回值是不一样的。这就叫"引用不透明"，很不利于观察和理解程序的行为。
* 没有副作用     
    不修改状态，函数式编程只是返回新的值，不修改系统变量。因此，不修改变量，也是它的一个重要特点。
* 只用"表达式"，不用"语句"        
    函数式编程的开发动机，一开始就是为了处理运算（computation），不考虑系统的读写（I/O）。"语句"属于对系统的读写操作，所以就被排斥在外。
    当然，实际应用中，不做I/O是不可能的。因此，编程过程中，函数式编程只要求把I/O限制到最小，不要有不必要的读写行为，保持计算过程的单纯性。

在函数式编程语言中，当你写了一个函数，接受一些参数，那么当你调用这个函数时，影响函数调用的只可能是你传进去的参数，而你得到的也只能够是计算结果。因此，一个void的方法，是没有任何意义的。如果传入了引用类型的参数，也是不合要求的。

```java
private int i = 0;
public lambda int Function( int p, Random random )//编译错误，不允许引用类型参数 
{ 
  int j = p + i;//编译错误，不允许使用i。 
  p++;//编译错误，不允许更改变量 
  int r = random.Next( j );//编译错误，不允许使用非lambda修饰的函数。 
  return r; 
}
```


---
#theory
允许把函数本身作为参数传入另一个函数，还允许返回一个函数
高阶函数：
变量可以指向函数，函数名其实就是指向函数的变量
函数的参数能接收变量，那么一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数

[Y不动点组合子](https://www.zhihu.com/question/21099081)


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



---
#Monad
[图解 Monad](http://www.ruanyifeng.com/blog/2015/07/monad.html)
简单说，Monad就是一种设计模式，表示将一个运算过程，通过函数拆解成互相连接的多个步骤。你只要提供下一步运算所需的函数，整个运算就会自动进行下去。















