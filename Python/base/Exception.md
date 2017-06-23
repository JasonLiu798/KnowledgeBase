
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
AttributeError 属性错误，特性引用和赋值失败时会引发属性错误
NameError：试图访问的变量名不存在
SyntaxError：语法错误，代码形式错误
Exception：所有异常的基类，因为所有python异常类都是基类Exception的其中一员，异常都是从基类Exception继承的，并且都在exceptions模块中定义。
IOError：一般常见于打开不存在文件时会引发IOError错误，也可以解理为输出输入错误
KeyError：使用了映射中不存在的关键字（键）时引发的关键字错误
IndexError：索引错误，使用的索引不存在，常索引超出序列范围，什么是索引
TypeError：类型错误，内建操作或是函数应于在了错误类型的对象时会引发类型错误
ZeroDivisonError：除数为0，在用除法操作时，第二个参数为0时引发了该错误
ValueError：值错误，传给对象的参数类型不正确，像是给int()函数传入了字符串数据类型的参数。








