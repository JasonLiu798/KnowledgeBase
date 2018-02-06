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


---
# 执行模型
do {    
	自动计算PC寄存器的值加1;    
	根据PC寄存器的指示位置，从字节码流中取出操作码;
	if (字节码存在操作数)
		从字节码流中取出操作数;
	执行操作码所定义的操作;
} while (字节码流长度 > 0);

---
# 字节码与数据类型
i代表对int类型的数据操作
l代表long
s代表short,
b代表byte
c代表char
f代表float
d代表double
a代表reference

---
# 加载和存储指令
## 将一个局部变量加载到操作栈
iload、iload_<n>、lload、lload_<n>、fload、fload_<n>、dload、dload_<n>、aload、aload_<n>

## 将一个数值从操作数栈存储到局部变量表：
istore、istore_<n>、lstore、lstore_<n>、fstore、fstore_<n>、dstore、dstore_<n>、astore、astore_<n>。   

## 将一个常量加载到操作数栈
bipush、sipush、ldc、ldc_w、ldc2_w、aconst_null、iconst_m1、iconst_<i>、lconst_<l>、fconst_<f>、dconst_<d>。   

## 扩充局部变量表的访问索引的指令
wide。

# 运算指令
运算或算术指令用于对两个操作数栈上的值进行某种特定运算，并把结果重新存入到操作栈顶。

大体上算术指令可以分为两种：
对整型数据进行运算的指令
对浮点型数据进行运算的指令

无论是哪种算术指令，都使用Java虚拟机的数据类型，由于没有直接支持byte、short、char和boolean类型的算术指令，对于这类数据的运算，应使用操作int类型的指令代替。整数与浮点数的算术指令在溢出和被零除的时候也有各自不同的行为表现，所有的算术指令如下。

加法指令：iadd、ladd、fadd、dadd。   
减法指令：isub、lsub、fsub、dsub。   
乘法指令：imul、lmul、fmul、dmul。   
除法指令：idiv、ldiv、fdiv、ddiv。   
求余指令：irem、lrem、frem、drem。   
取反指令：ineg、lneg、fneg、dneg。   
位移指令：ishl、ishr、iushr、lshl、lshr、lushr。   
按位或指令：ior、lor。   
按位与指令：iand、land。   
按位异或指令：ixor、lxor。   
局部变量自增指令：iinc。   
比较指令：dcmpg、dcmpl、fcmpg、fcmpl、lcmp

## 类型转换指令
可以将两种不同的数值类型进行相互转换，这些转换操作一般用于实现用户代码中的显式类型转换操作，或者用来处理本节开篇所提到的字节码指令集中数据类型相关指令无法与数据类型一一对应的问题。
Java虚拟机直接支持（即转换时无需显式的转换指令）以下数值类型的宽化类型转换（Widening Numeric Conversions，即小范围类型向大范围类型的安全转换）：
* int类型到long、float或者double类型
* long类型到float、double类型。   
* float类型到double类型
 
相对的，处理窄化类型转换（Narrowing Numeric Conver-sions）时，必须显式地使用转换指令来完成，这些转换指令包括：i2b、i2c、i2s、l2i、f2i、f2l、d2i、d2l和d2f。
窄化类型转换可能会导致转换结果产生不同的正负号、不同的数量级的情况，转换过程很可能会导致数值的精度丢失。在将int或long类型窄化转换为整数类型T的时候，转换过程仅仅是简单地丢弃除最低位N个字节以外的内容，N是类型T的数据类型长度，这将可能导致转换结果与输入值有不同的正负号。这点很容易理解，因为原来符号位处于数值的最高位，高位被丢弃之后，转换结果的符号就取决于低N个字节的首位了。

在将一个浮点值窄化转换为整数类型T（T限于int或long类型之一）的时候，将遵循以下转换规则：  
* 如果浮点值是NaN，那转换结果就是int或long类型的0。   
* 如果浮点值不是无穷大的话，浮点值使用IEEE 754的向零舍入模式取整，获得整数值v，如果v在目标类型T（int或long）的表示范围之内，那转换结果就是v。   
* 否则，将根据v的符号，转换为T所能表示的最大或者最小正数。

## 对象创建与访问指令
虽然类实例和数组都是对象，但Java虚拟机对类实例和数组的创建与操作使用了不同的字节码指令

* 创建类实例的指令：new。   
* 创建数组的指令：newarray、anewarray、multianewar-ray。  
* 访问类字段（static字段，或者称为类变量）和实例字段（非static字段，或者称为实例变量）的指令：getfield、put-field、getstatic、putstatic。   
* 把一个数组元素加载到操作数栈的指令：baload、caload、saload、iaload、laload、faload、daload、aaload。   
* 将一个操作数栈的值存储到数组元素中的指令：bastore、castore、sastore、iastore、fastore、dastore、aastore。   
* 取数组长度的指令：arraylength。   
* 检查类实例类型的指令：instanceof、checkcast。

## 操作数栈管理指令
* 将操作数栈的栈顶一个或两个元素出栈：pop、pop2。  
* 复制栈顶一个或两个数值并将复制值或双份的复制值重新压入栈顶：dup、dup2、dup_x1、dup2_x1、dup_x2、dup2_x2。   
* 将栈最顶端的两个数值互换：swap

## 控制转移指令
可以让Java虚拟机有条件或无条件地从指定的位置指令而不是控制转移指令的下一条指令继续执行程序，从概念模型上理解，可以认为控制转移指令就是在有条件或无条件地修改PC寄存器的值。

* 条件分支：ifeq、iflt、ifle、ifne、ifgt、ifge、ifnull、ifnonnull、if_icmpeq、if_icmpne、if_icmplt、if_icmpgt、if_icmple、if_icmpge、if_acmpeq和if_acmpne
* 复合条件分支：tableswitch、lookupswitch。   
* 无条件分支：goto、goto_w、jsr、jsr_w、ret。

## 方法调用和返回指令
* invokevirtual指令用于调用对象的实例方法，根据对象的实际类型进行分派（虚方法分派），这也是Java语言中最常见的方法分派方式。   
* invokeinterface指令用于调用接口方法，它会在运行时搜索一个实现了这个接口方法的对象，找出适合的方法进行调用。   
* invokespecial指令用于调用一些需要特殊处理的实例方法，包括实例初始化方法、私有方法和父类方法。   
* invokestatic指令用于调用类方法（static方法）。  
* invokedynamic指令用于在运行时动态解析出调用点限定符所引用的方法，并执行该方法，前面4条调用指令的分派逻辑都固化在Java虚拟机内部，而invokedynamic指令的分派逻辑是由用户所设定的引导方法决定的。

ireturn（当返回值是boolean、byte、char、short和int类型时使用）、lreturn、freturn、dreturn和areturn，另外还有一条return指令供声明为void的方法、实例初始化方法以及类和接口的类初始化方法使用。

## 　异常处理指令
显式抛出异常的操作（throw语句）都由athrow指令来实现，除了用throw语句显式抛出异常情况之外，Java虚拟机规范还规定了许多运行时异常会在其他Java虚拟机指令检测到异常状况时自动抛出。

而在Java虚拟机中，处理异常（catch语句）不是由字节码指令来实现的（很久之前曾经使用jsr和ret指令来实现，现在已经不用了），而是采用异常表来完成的。

## 同步指令
方法级的同步是隐式的，即无须通过字节码指令来控制，它实现在方法调用和返回操作之中。虚拟机可以从方法常量池的方法表结构中的ACC_SYNCHRONIZED访问标志得知一个方法是否声明为同步方法。当方法调用时，调用指令将会检查方法的ACC_SYNCHRONIZED访问标志是否被设置，如果设置了，执行线程就要求先成功持有管程，然后才能执行方法，最后当方法完成（无论是正常完成还是非正常完成）时释放管程。在方法执行期间，执行线程持有了管程，其他任何线程都无法再获取到同一个管程。如果一个同步方法执行期间抛出了异常，并且在方法内部无法处理此异常，那么这个同步方法所持有的管程将在异常抛到同步方法之外时自动释放。

同步一段指令集序列通常是由Java语言中的synchronized语句块来表示的，Java虚拟机的指令集中有monitorenter和monitorexit两条指令来支持synchronized关键字的语义，正确实现synchronized关键字需要Javac编译器与Java虚拟机两者共同协作支持

---
# 公有设计和私有实现


























