#bytecode
---
[Java字节码浅析1](http://ifeve.com/javacode2bytecode/)
[Java字节码浅析2](http://blog.csdn.net/afei198409/article/details/22930875)
[Java字节码浅析3](http://ifeve.com/java-code-to-byte-code-3/)
[java字节码指令列表 速查](http://blog.csdn.net/ygc87/article/details/12953421)
[jvm字节码指令理解](http://kingj.iteye.com/blog/1451008)
[字节码执行引擎](http://www.cnblogs.com/royi123/p/3569511.html)
#变量

局部变量
JVM是一个基于栈的架构。方法执行的时候（包括main方法），在栈上会分配一个新的帧，这个栈帧包含一组局部变量。这组局部变量包含了方法运行过程中用到的所有变量，包括this引用，所有的方法参数，以及其它局部定义的变量。对于类方法（也就是static方法）来说，方法参数是从第0个位置开始的，而对于实例方法来说，第0个位置上的变量是this指针。
局部变量可以是以下这些类型：
* char
* long
* short
* int
* float
* double
* 引用
* 返回地址
操作数栈（operand stack）会用来存储这个新变量的值。
然后这个变量会存储到局部变量区中对应的位置上。如果这个变量不是基础类型的话，本地变量槽上存的就只是一个引用。
这个引用指向堆的里一个对象。
比如：
int i = 5;
编译后就成了
0: bipush      5
2: istore_0

```
bipush      5:
    operand stack: 5
    LocalVariableTable:
istore_0
    operand stack: 
    LocalVariableTable: 5






```


##常量池

JVM会为每个类型维护一个常量池，运行时的数据结构有点类似一个符号表，尽管它包含的信息更多。Java中的字节码操作需要对应的数据，但通常这些数据都太大了，存储在字节码里不适合，它们会被存储在常量池里面，而字节码包含一个常量池里的引用 。


##switch
字符串
首先，将每个case语句里的值的hashCode和操作数栈顶的值（译注：也就是switch里面的那个值，这个值会先压入栈顶）进行比较。这个可以通过lookupswitch或者是tableswitch指令来完成。结果会路由到某个分支上，然后调用String.equlals来判断是否确实匹配。最后根据equals返回的结果，再用一个tableswitch指令来路由到具体的case分支上去执行。



##循环
for循环和while循环这些语句也类似，只不过它们通常都包含一个goto指令，使得字节码能够循环执行。do-while循环则不需要goto指令，因为它们的条件判断指令是放在循环体的最后来执行。














