












#return语句
方法中没有finally语句块的情况下return语句的执行方式。现在我们先看看return语句，return语句的格式如下：
    return [expression]；
其中expression(表达式)是可选的，因为有些方法没有返回值，所以return后面也就没有表达式，或者可以看做是空的表达式。
我们知道return语句的作用可以结束方法并返回一个值，那么他返回的是哪里的值呢？返回的是return指令执行的时刻，操作数栈顶的值，不管expression是一个怎样的表达式，究竟做了些什么工作，对于return指令来说都不重要，他只负责把操作数栈顶的值返回。
而return expression是分成两部分执行的:
    执行：expression；
    执行：return指令；
例如：return x+y；
这句代码先执行x+y，再执行return；首先执行将x以及y从局部变量区复制到操作数栈顶的指令，然后执行加法指令，这个时候结果x+y的值会保存在操作数栈的栈顶，最后执行return指令，返回操作数栈顶的值。
对于return x；先执行x，x也是一个表达式，这个表达式只有一个操作数，会执行将变量x从局部变量区复制到操作数栈顶的指令，然后执行return，返回操作数栈顶的值。因此return x实际返回的是return指令执行时，x在操作数栈顶的一个快照或者叫副本，而不是x这个值。

#finally
finally语句块：
    如果方法中有finally语句块，那么return语句又是如何执行的呢？
    例如下面这段代码：
    try{
    return expression;
  }finally{
    do some work;
  }
首先我们知道，finally语句是一定会执行，但他们的执行顺序是怎么样的呢？他们的执行顺序如下：
    1、执行：expression，计算该表达式，结果保存在操作数栈顶；
    2、执行：操作数栈顶值（expression的结果）复制到局部变量区作为返回值；
    3、执行：finally语句块中的代码；
    4、执行：将第2步复制到局部变量区的返回值又复制回操作数栈顶；
    5、执行：return指令，返回操作数栈顶的值；
我们可以看到，在第一步执行完毕后，整个方法的返回值就已经确定了，由于还要执行finally代码块，因此程序会将返回值暂存在局部变量区，腾出操作数栈用来执行finally语句块中代码，等finally执行完毕，再将暂存的返回值又复制回操作数栈顶。
所以无论finally语句块中执行了什么操作，都无法影响返回值，所以试图在finally语句块中修改返回值是徒劳的。因此，finally语句块设计出来的目的只是为了让方法执行一些重要的收尾工作，而不是用来计算返回值的。

##finally中return
finally中return了, 那么catch块中的throw就失效了, 上级方法调用者是捕获不到异常的
如果在finally里的return之前执行了其它return , 那么最终的返回值是finally中的return:

如果try块和finally块都有返回语句，那么虽然try块中返回值在执行finally代码块之前被保存了，但是最终执行的是finally代码块的return语句，try块中的return语句不再执行。





















