#scala
---
#grammar
#变量
##数据类型
全部相同于Java
数据类型	描述
Byte	8位有符号值。范围从-128到127
Short	16位有符号值。范围从-32768至32767
Int		32 位有符号值。范围从 -2147483648 to 2147483647
Long	64位有符号值。 从-9223372036854775808到9223372036854775807
Float	32位IEEE754单精度浮点数
Double	64位IEEE754双精度浮点数
Char	16位无符号Unicode字符。范围由U+0000至U+FFFF
String	字符序列
Boolean	无论是字面true或false字面
Unit	对应于没有值
Null	空或空引用
Nothing	每一个其他类型的子类型; 包括无值
Any	Any类型的超类型;任何对象是任何类型
AnyRef	任何引用类型的超类型

##Scala基本字面值
Scala中使用的文字规则是简单和直观的。这部分解释了所有Scala中的基本文字。

多行字符串
多行字符串是包含在三重引号“”字符序列“...”“”。字符序列是任意的，不同之处在于它可以包含三个或更多个连续引号字符仅在未尾。

NULL值
null是scala.Null类型一个值，因此这个引用类型兼容。它表示参考值是指一种特殊的“空”的对象。

* 转义序列
转义序列	Unicode	描述
		u0008	退格BS
		u0009	水平制表符HT
		u000c	换页FF
f		u000c	换页FF
		u000d	回车CR
"		u0022	双引用 "
'		u0027	单引用 .
		u005c	反斜线 

##变量声明
Scala的变量声明有不同的语法，它们可以被定义为值，即，常量或变量。
var-定义变量
var myVar : String = "Foo"

val-定义常量
val myVal : String = "Foo"

##变量数据类型
变量类型在变量名后面指定
val or val VariableName : DataType [=  Initial Value]

##变量类型推断
当分配一个初始值给一个变量，Scala编译器可以计算出根据分配给它的值的变量类型。这就是所谓的变量类型推断。
var myVar = 10;
val myVal = "Hello, Scala!";
默认情况下，myVar是int类型，将设为myVal为字符串类型变量。

##多重任务
Scala支持多任务。如果一个代码块或方法返回一个元组，该元组可被分配给一个val变量。 [注：元组在以后的章节中学习。]
val (myVar1: Int, myVar2: String) = Pair(40, "Foo")
类型推断得到正确类型：
val (myVar1, myVar2) = Pair(40, "Foo")

---
#字符串
```scala
object Test {
   val greeting: String = "Hello, world!"

   def main(args: Array[String]) {
      println( greeting )
   }
}
```
上面的值类型是从Java的java.lang.String借来的，因为Scala的字符串也是Java字符串
长度 s1.length();
连接 string1.concat(string2);
格式化字符串 printf()和format()

---
#数组
##声明数组变量
```scala
var z:Array[String] = new Array[String](3)
//or
var z = new Array[String](3)

var z = Array("Zara", "Nuha", "Ayan")

z(0) = "Zara"; z(1) = "Nuha"; z(4/2) = "Ayan"
```
##多维数组
Scala不直接支持多维数组，并提供各种方法来处理任何尺寸数组。以下是定义的二维数组的实例：
var myMatrix = ofDim[Int](3,3)
##联接数组
以下是使用concat()方法来连接两个数组的例子。可以通过多个阵列作为参数传递给concat()方法。
```scala
import Array._

object Test {
   def main(args: Array[String]) {
      var myList1 = Array(1.9, 2.9, 3.4, 3.5)
      var myList2 = Array(8.9, 7.9, 0.4, 1.5)
      var myList3 =  concat( myList1, myList2)
      
      // Print all the array elements
      for ( x <- myList3 ) {
         println( x )
      }
   }
}
/*
C:/>scala Test
1.9
2.9
3.4
3.5
8.9
7.9
0.4
1.5
*/
```
##创建具有范围数组
range() 方法来产生包含在给定的范围内增加整数序列的数组
```
import Array._
object Test {
   def main(args: Array[String]) {
      var myList1 = range(10, 20, 2)
      var myList2 = range(10,20)

      // Print all the array elements
      for ( x <- myList1 ) {
         print( " " + x )
      }
      println()
      for ( x <- myList2 ) {
         print( " " + x )
      }
   }
}
```

---
#集合

严格或懒惰
懒集合有可能不消耗内存，直到他们被访问，就像范围元素

集合可以是可变的(引用的内容可以更改)或不变(一个引用的东西指从未改变)

SN	集合使用说明
1	Scala Lists
Scala的List[T]是T类型的链表
2	Scala Sets
集是相同类型的配对的不同元素的集合。
3	Scala Maps
映射是键/值对的集合。任何值可以根据它的键进行检索。
4	Scala Tuples
不像数组或列表，元组可以容纳不同类型的对象。
5	Scala Options
Option[T] 提供了一种容器，用于给定类型的零个或一个元素。
6	Scala Iterators
迭代不是集合，而是一种由一个访问的集合之一的元素。

```scala
// Define List of integers.
val x = List(1,2,3,4)

// Define a set.
var x = Set(1,3,5,7)

// Define a map.
val x = Map("one" -> 1, "two" -> 2, "three" -> 3)

// Create a tuple of two elements.
val x = (10, "Scala")

// Define an option
val x:Option[Int] = Some(5)
```

---
#List
首先，列表是不可变的，这意味着一个列表的元素可以不被分配来改变。
第二，列表表示一个链表，而数组平坦的。
具有T类型的元素的列表的类型被写为List[T]
```scala
// List of Strings
val fruit: List[String] = List("apples", "oranges", "pears")

// List of Integers
val nums: List[Int] = List(1, 2, 3, 4)

// Empty List.
val empty: List[Nothing] = List()

// Two dimensional list
val dim: List[List[Int]] =
   List(
      List(1, 0, 0),
      List(0, 1, 0),
      List(0, 0, 1)
   )
```
所有的列表可以使用两种基本的构建模块来定义，一个无尾Nil和::，这有明显的缺点。Nil也代表了空列表。所有上述列表可以定义如下：
```scala
// List of Strings
val fruit = "apples" :: ("oranges" :: ("pears" :: Nil))

// List of Integers
val nums = 1 :: (2 :: (3 :: (4 :: Nil)))

// Empty List.
val empty = Nil

// Two dimensional list
val dim = (1 :: (0 :: (0 :: Nil))) ::
          (0 :: (1 :: (0 :: Nil))) ::
          (0 :: (0 :: (1 :: Nil))) :: Nil
```
列表的基本操作：
上列出了所有的操作都可以体现在以下三个方法来讲
方法	描述
head	此方法返回的列表中的第一个元素。
tail	此方法返回一个由除了第一个元素外的所有元素的列表。
isEmpty	如果列表为空，此方法返回true，否则为false。
以下是上述方法中的例子显示用法：
```scala
object Test {
   def main(args: Array[String]) {
      val fruit = "apples" :: ("oranges" :: ("pears" :: Nil))
      val nums = Nil

      println( "Head of fruit : " + fruit.head )
      println( "Tail of fruit : " + fruit.tail )
      println( "Check if fruit is empty : " + fruit.isEmpty )
      println( "Check if nums is empty : " + nums.isEmpty )
   }
}
```
##串联列表
可以使用:::运算符或列表List.:::()方法或List.concat()方法来添加两个或多个列表。下面是一个例子：
```scala
object Test {
   def main(args: Array[String]) {
      val fruit1 = "apples" :: ("oranges" :: ("pears" :: Nil))
      val fruit2 = "mangoes" :: ("banana" :: Nil)
      // use two or more lists with ::: operator
      var fruit = fruit1 ::: fruit2
      println( "fruit1 ::: fruit2 : " + fruit )
      // use two lists with Set.:::() method
      fruit = fruit1.:::(fruit2)
      println( "fruit1.:::(fruit2) : " + fruit )
      // pass two or more lists as arguments
      fruit = List.concat(fruit1, fruit2)
      println( "List.concat(fruit1, fruit2) : " + fruit  )
   }
}
```
##创建统一列表：
可以使用List.fill()方法创建，包括相同的元素如下的零个或更多个拷贝的列表：
```scala
object Test {
   def main(args: Array[String]) {
      val fruit = List.fill(3)("apples") // Repeats apples three times.
      println( "fruit : " + fruit  )

      val num = List.fill(10)(2)         // Repeats 2, 10 times.
      println( "num : " + num  )
   }
}
```
##制成表格一个功能：
可以使用一个函数连同List.tabulate()方法制表列表之前的列表中的所有元素以应用。它的参数是一样List.fill：第一个参数列表给出的列表的尺寸大小，而第二描述列表的元素。唯一的区别在于，代替的元素被固定，它们是从一个函数计算：
```scala
object Test {
   def main(args: Array[String]) {
      // Creates 5 elements using the given function.
      val squares = List.tabulate(6)(n => n * n)
      println( "squares : " + squares  )

      // 
      val mul = List.tabulate( 4,5 )( _ * _ )      
      println( "mul : " + mul  )
   }
}
```
##反向列表顺序：
可以使用List.reverse方法来扭转列表中的所有元素。以下为例子来说明的用法：
```scala
object Test {
   def main(args: Array[String]) {
      val fruit = "apples" :: ("oranges" :: ("pears" :: Nil))
      println( "Before reverse fruit : " + fruit )

      println( "After reverse fruit : " + fruit.reverse )
   }
}
```

#Sets
默认情况下，Scala中使用不可变的集。如果想使用可变集，必须明确地导入scala.collection.mutable.Set类
```scala
// Empty set of integer type
var s : Set[Int] = Set()
// Set of integer type
var s : Set[Int] = Set(1,3,5,7)
or 
var s = Set(1,3,5,7)
```






---
#访问修饰符
包，类或对象的成员可以标记访问修饰符private和protected，如果我们不使用这两种关键字，那么访问将被默认设置为public

私有成员：
私有成员只能看到里面包含的成员定义的类或对象。下面是一个例子：
```scala
class Outer {
   class Inner {
      private def f() { println("f") }
      class InnerMost {
         f() // OK
      }
   }
   (new Inner).f() // Error: f is not accessible
}
```
在Scala中，访问 (new Inner).f() 是非法的，因为f被声明为private内部类并且访问不是在内部类内。与此相反，到f第一接入类最内层是确定的，因为该访问包含在类内的主体。 Java将允许这两种访问，因为它可以让其内部类的外部类访问私有成员。

保护成员：
受保护的成员是从该成员定义的类的子类才能访问

公共成员：
未标示私有或受保护的每一个成员是公开的。不需要明确使用修饰符public。这样的成员可以从任何地方访问

##保护范围
Scala中的访问修饰符可以增加使用修饰符。
形式：private[X]或protected[X]的修饰符意味着访问私有或受保护“达到”X，其中X代表了一些封闭的包，类或单个对象。考虑下面的例子：
```scala
package society {
   package professional {
      class Executive {
         private[professional] var workDetails = null
         private[society] var friends = null
         private[this] var secrets = null

         def help(another : Executive) {
            println(another.workDetails)
            println(another.secrets) //ERROR
         }
      }
   }
}
```
注意，上面的例子中以下几点：
变量workDetails将可对任何一类封闭包professional范围内。
变量friends 将可对任何一类封闭包society中。
变量secrets 将可只在实例方法隐含的对象（this）。

---
#运算符
##算术运算符
运算符	描述	示例
+	两个操作数相加	A + B = 30
-	从第一操作减去第二操作数	A - B = -10
*	两个操作数相乘	A * B = 200
/	通过分子除以分子	B / A = 2
%	模运算，整数除法后的余数	B % A = 0

##关系运算符
```
运算符	描述	示例
==	检查两个操作数的值是否相等，如果是的话那么条件为真。	(A == B) 不为 true.
!=	检查两个操作数的值是否相等，如果值不相等，则条件变为真。	(A != B) 为 true.
>	检查左边的操作数的值是否大于右操作数的值，如果是的话那么条件为真。	(A > B) 不为 true.
<	检查左边的操作数的值是否小于右操作数的值，如果是的话那么条件为真。	(A < B) 为 true.
>=	检查左边的操作数的值是否大于或等于右操作数的值，如果是的话那么条件为真。	(A >= B) 不为 true.
<=	检查左边的操作数的值是否小于或等于右操作数的值，如果是的话那么条件为真。	(A <= B) 为 true.
```

##逻辑运算符
运算符	描述	示例
&&	所谓逻辑与操作。如果两个操作数为非零则条件为真。	(A && B) 为 false.
||	所谓的逻辑或操作。如果任何两个操作数是非零则条件变为真。	(A || B) 为 true.
!	所谓逻辑非运算符。使用反转操作数的逻辑状态。如果条件为真，那么逻辑非操作符作出结果为假。	!(A && B) 为  true.

##位运算符
```
运算符	描述	示例
&	二进制和运算符副本位的结果，如果它存在于两个操作数。	(A & B) = 12, 也就是 0000 1100
|	二进制或操作拷贝，如果它存在一个操作数。	(A | B) = 61, 也就是 0011 1101
^	二进制异或运算符的副本，如果它被设置在一个操作数而不是两个比特。	(A ^ B) = 49, 也就是 0011 0001
~	二进制的补运算符是一元的，具有“翻转”位的效应。	(~A ) = -61, 也就是 1100 0011在2补码形式，由于一个带符号二进制数。
<<	二进制左移位运算符。左边的操作数的值向左移动由右操作数指定的位数。	A << 2 = 240, 也就是 1111 0000
>>	二进制向右移位运算符。左边的操作数的值由右操作数指定的位数向右移动。	A >> 2 = 15, 也就是 1111
>>>	右移补零操作。左边的操作数的值由右操作数指定的位数向右移动，并转移值以零填充。	A >>>2 = 15 也就是 0000 1111
```

##赋值运算符
```
运算符	描述	示例
=	简单的赋值操作符，分配值从右边的操作数左侧的操作数	C = A + B 将分配 A + B 的值到 C
+=	加法和赋值运算符，它增加了右操作数左操作数和分配结果左操作数	C += A 相当于 C = C + A
-=	减和赋值运算符，它减去右操作数从左侧的操作数和分配结果左操作数	C -= A 相当于 C = C - A
*=	乘法和赋值运算符，它乘以右边的操作数与左操作数和分配结果左操作数	C *= A 相当于 C = C * A
/=	除法和赋值运算符，它把左操作数与右操作数和分配结果左操作数	C /= A 相当于 C = C / A
%=	模量和赋值运算符，它需要使用两个操作数的模量和分配结果左操作数	C %= A 相当于 C = C % A
<<=	左移位并赋值运算符	C <<= 2 等同于 C = C << 2
>>=	向右移位并赋值运算符	C >>= 2 等同于 C = C >> 2
&=	按位与赋值运算符	C &= 2 等同于C = C & 2
^=	按位异或并赋值运算符	C ^= 2 等同于 C = C ^ 2
|=	按位或并赋值运算符	C |= 2 等同于 C = C | 2
```

##运算符优先级
具有最高优先级的运算符在表的顶部，那些优先低级排在底部。在一个表达式，优先级高的运算符将首先计算。
分类 	运算符	关联
Postfix 	() []	从左到右
Unary 	! ~	从右到左
Multiplicative  	* / % 	从左到右
Additive  	+ - 	从左到右
Shift  	>> >>> <<  	从左到右
Relational  	> >= < <=  	从左到右
Equality  	== != 	从左到右
Bitwise AND 	& 	从左到右
Bitwise XOR 	^ 	从左到右
Bitwise OR 	| 	从左到右
Logical AND 	&& 	从左到右
Logical OR 	|| 	从左到右
Assignment 	= += -= *= /= %= >>= <<= &= ^= |= 	从右到左
Comma 	, 	从左到右

---
#IF...ELSE语句
语法：
一个 if 语句的语法：
```scala
if(Boolean_expression)
{
   // Statements will execute if the Boolean expression is true
}

if(Boolean_expression){
   //Executes when the Boolean expression is true
}else{
   //Executes when the Boolean expression is false
}

if(Boolean_expression 1){
   //Executes when the Boolean expression 1 is true
}else if(Boolean_expression 2){
   //Executes when the Boolean expression 2 is true
}else if(Boolean_expression 3){
   //Executes when the Boolean expression 3 is true
}else {
   //Executes when the none of the above condition is true.
}
```

---
#循环类型
循环类型	描述
while循环	重复声明语句或一组，当给定的条件为真。它测试条件执行循环体前。
do...while循环	像一个while语句，不同之处在于它测试条件在循环体的结尾
for循环	执行语句多次序列并简写管理循环变量的代码。

break语句	终止循环语句并将执行立刻循环的下面语句。

---
#while循环
```scala
while(condition){
   statement(s);
}
```

---
#函数
##声明
def functionName ([list of parameters]) : [return type]
##定义
```scala
def functionName ([list of parameters]) : [return type] = {
   function body
   return [expr]
}

//有返回值
object add{
   def addInt( a:Int, b:Int ) : Int = {
      var sum:Int = 0
      sum = a + b

      return sum
   }
}

//无返回值
object Hello{
   def printMe( ) : Unit = {
      println("Hello, Scala!")
   }
}
```

##调用函数
```
functionName( list of parameters )

[instance.]functionName( list of parameters )

object Test {
   def main(args: Array[String]) {
        println( "Returned Value : " + addInt(5,7) );
   }
   def addInt( a:Int, b:Int ) : Int = {
      var sum:Int = 0
      sum = a + b
      return sum
   }
}
```

---
#闭包
闭包是函数，它的返回值取决于此函数之外声明一个或多个变量的值。考虑下面的一块使用匿名函数的代码：

	val multiplier = (i:Int) => i * 10

在这里，在函数体中使用的唯一变量， i * 0, 为i，其被定义为一个参数的函数。
现在，让我们来看另一块代码：

	val multiplier = (i:Int) => i * factor

有两个自由变量的乘数：i和factor。其中一个i是一个正式函数参数。因此，它被绑定到一个新的值在乘数每次调用。然而，factor不是一个正式的参数，那么这是什么？让我们增加一行代码：

var factor = 3
val multiplier = (i:Int) => i * factor

现在，factor具有参考变量在函数之外，但为封闭范围的变量。让我们试试下面的例子：
```scala
object Test {
   def main(args: Array[String]) {
      println( "muliplier(1) value = " +  multiplier(1) )
      println( "muliplier(2) value = " +  multiplier(2) )
   }
   var factor = 3
   val multiplier = (i:Int) => i * factor
}

/*结果
C:/>scalac Test.scala
C:/>scala Test
muliplier(1) value = 3
muliplier(2) value = 6
*/
```

上面的函数引用factor并读取每个时间的当前值。如果函数没有外部引用，那么它就是封闭了自己。无需外部环境是必需的。

---
#类和对象
```scala
class Yiibai(xc: Int, yc: Int) {
   var x: Int = xc
   var y: Int = yc

   def move(dx: Int, dy: Int) {
      x = x + dx
      y = y + dy
      println ("Yiibai x location : " + x);
      println ("Yiibai y location : " + y);
   }
}
```
这个类定义了两个变量x和y和方法：move，没有返回值。类变量被调用，类的字段和方法被称为类方法。
类名可以作为一个类的构造函数，可以采取一些参数。上面的代码定义了两个构造函数的参数：xc和yc;它们都在类的主体内可见。
关键字new创建对象

##扩展一个类
方法重载需要override关键字，只有主构造可以传递参数给基构造。
现在扩展上面的类，并增加一个类的方法：
```scala
class Location(override val xc: Int, override val yc: Int,
   val zc :Int) extends Yiibai(xc, yc){
   var z: Int = zc

   def move(dx: Int, dy: Int, dz: Int) {
      x = x + dx
      y = y + dy
      z = z + dz
      println ("Yiibai x location : " + x);
      println ("Yiibai y location : " + y);
      println ("Yiibai z location : " + z);
   }
}
```
extends子句有两种作用：它使类Location继承类Yiibai所有非私有成员，它使Location类作为Yiibai类的子类。 
因此，这里的Yiibai类称为超类，
而Location类被称为子类。
扩展一个类，继承父类的所有功能，被称为继承，但scala允许继承，只能从一个唯一的类。让我们看看完整的例子，显示继承的用法：
```scala
import java.io._

class Yiibai(val xc: Int, val yc: Int) {
   var x: Int = xc
   var y: Int = yc
   def move(dx: Int, dy: Int) {
      x = x + dx
      y = y + dy
      println ("Yiibai x location : " + x);
      println ("Yiibai y location : " + y);
   }
}

class Location(override val xc: Int, override val yc: Int,
   val zc :Int) extends Yiibai(xc, yc){
   var z: Int = zc

   def move(dx: Int, dy: Int, dz: Int) {
      x = x + dx
      y = y + dy
      z = z + dz
      println ("Yiibai x location : " + x);
      println ("Yiibai y location : " + y);
      println ("Yiibai z location : " + z);
   }
}

object Test {
   def main(args: Array[String]) {
      val loc = new Location(10, 20, 15);

      // Move to a new location
      loc.move(10, 10, 5);
   }
}
```

##单例对象：
Scala比Java更面向对象，因为在Scala中不能有静态成员。
相反，Scala有单例的对象。单例就是只能有一个实例，即，类的对象。可以使用关键字object代替class关键字，而不是创建单例。因为不能实例化一个单独的对象，不能将参数传递给主构造。前面已经看到全部采用单一对象，调用Scala的main方法的例子。以下是单例显示的相同的例子：
```scala
import java.io._

class Yiibai(val xc: Int, val yc: Int) {
   var x: Int = xc
   var y: Int = yc
   def move(dx: Int, dy: Int) {
      x = x + dx
      y = y + dy
   }
}

object Test { // 关键字object代替class关键字
   def main(args: Array[String]) {
      val yiibai = new Yiibai(10, 20)
      printYiibai

      def printYiibai{
         println ("Yiibai x location : " + yiibai.x);
         println ("Yiibai y location : " + yiibai.y);
      }
   }
}
```

---
#特征
特性封装方法和字段定义，然后可以通过将它们混合成类被重用。不同于类继承，其中每个类都必须继承只有一个父类，一类可以在任意数量特质混合。
特征用于通过指定支持的方法的签名定义的对象类型。Scala中也允许部分实现特性但可能不具有构造参数。
一个特征定义看起来就像不同的是它使用关键字trait如下类定义：
```scala
trait Equal {
  def isEqual(x: Any): Boolean
  def isNotEqual(x: Any): Boolean = !isEqual(x)
}
```
这种特质由两个方法的isEqual和isNotEqual。这里，我们没有给出任何实现的isEqual其中作为另一种方法有它的实现。扩展特性的子类可以给实施未实现的方法。因此，一个特点是非常相似Java的抽象类。下面是一个完整的例子来说明特性的概念：
```scala
trait Equal {
  def isEqual(x: Any): Boolean
  def isNotEqual(x: Any): Boolean = !isEqual(x)
}

class Yiibai(xc: Int, yc: Int) extends Equal {
  var x: Int = xc
  var y: Int = yc
  def isEqual(obj: Any) =
    obj.isInstanceOf[Yiibai] &&
    obj.asInstanceOf[Yiibai].x == x
}

object Test {
   def main(args: Array[String]) {
      val p1 = new Yiibai(2, 3)
      val p2 = new Yiibai(2, 4)
      val p3 = new Yiibai(3, 3)

      println(p1.isNotEqual(p2))
      println(p1.isNotEqual(p3))
      println(p1.isNotEqual(2))
   }
}
```
##什么时候使用
没有严格的规定，但这里有一些指导原则需要考虑：
* 如果行为不被重用，则要使它成为一个具体的类。它毕竟不是可重复使用的行为。
* 如果它可能在多个不相关的类被重用，使它成为一个性状。只有特性可混入的类层次结构的不同部分。
* 如果想它从继承Java代码，使用抽象类。
* 如果打算在已编译的形式分发，而且希望外部组织编写的类继承它，可能会倾向于使用抽象类。
* 如果效率是非常重要的，倾向于使用类。

---
#Scala模式匹配
模式匹配包括替代的序列，每个开始使用关键字case。
每个备选中包括模式和一个或多个表达式，如果模式匹配将被计算。
一个箭头符号=>分开的表达模式。
这里是一个小例子，它展示了如何匹配一个整数值：
```scala
object Test {
   def main(args: Array[String]) {
      println(matchTest(3))
   }
   def matchTest(x: Int): String = x match {
      case 1 => "one"
      case 2 => "two"
      case _ => "many"
   }
}
```

使用case语句块定义一个函数，该函数映射整数字符串。匹配关键字提供应用函数(如模式匹配函数以上)为一个对象的一个方便的方法。下面是第二个示例，它匹配针对不同类型的模式值：
```scala
object Test {
   def main(args: Array[String]) {
      println(matchTest("two"))
      println(matchTest("test"))
      println(matchTest(1))

   }
   def matchTest(x: Any): Any = x match {
      case 1 => "one"
      case "two" => 2
      case y: Int => "scala.Int"
      case _ => "many"
   }
}
```
##匹配使用case 类
case classes是用于模式匹配与case 表达式指定类。这些都是标准类具有特殊修饰：case。下面是一个简单的模式使用case class匹配示例：
```scala
object Test {
	def main(args: Array[String]) {
   		val alice = new Person("Alice", 25)
		val bob = new Person("Bob", 32)
   		val charlie = new Person("Charlie", 32)
   
    	for (person <- List(alice, bob, charlie)) {
        	person match {
            	case Person("Alice", 25) => println("Hi Alice!")
            	case Person("Bob", 32) => println("Hi Bob!")
            	case Person(name, age) => println("Age: " + age + " year, name: " + name + "?")
         	}
      	}
   	}
   	// case class, empty one.
   	case class Person(name: String, age: Int)
}
```
首先，编译器会自动转换的构造函数的参数为不可变的字段（vals）。val关键字是可选的。如果想可变字段，使用var关键字。因此，构造函数的参数列表现在更短。
其次，编译器自动实现equals, hashCode, 和toString方法的类，它使用指定为构造函数参数的字段。因此，不再需要自己的toString方法。
最后，还消失Person类的主体部分，因为没有需要定义的方法！

---
#正则表达式
```scala
import scala.util.matching.Regex

object Test {
   def main(args: Array[String]) {
      val pattern = "Scala".r
      val str = "Scala is Scalable and cool"
      
      println(pattern findFirstIn str)
   }
}


object Test {
   def main(args: Array[String]) {
      val pattern = new Regex("(S|s)cala")
      val str = "Scala is scalable and cool"
      
      println((pattern findAllIn str).mkString(","))
   }
}

//更换
object Test {
   def main(args: Array[String]) {
      val pattern = "(S|s)cala".r
      val str = "Scala is scalable and cool"
      
      println(pattern replaceFirstIn(str, "Java"))
   }
}
```

---
#异常处理
Scala的异常的工作像许多其他语言，如Java异常。而不是正常方式返回的值，方法可以通过抛出一个异常终止。然而，Scala实际上并没有检查异常。
当要处理异常，那么可使用try{...}catch{...} 块，就像在Java中除了catch块采用匹配识别和处理异常。
##抛出异常：
抛出一个异常看起来类似于Java。创建一个异常对象，然后使用throw关键字把它抛出：
throw new IllegalArgumentException
##捕获异常：
Scala中try/catch在一个单独的块捕捉任何异常，然后使用case块进行模式匹配
```scala
import java.io.FileReader
import java.io.FileNotFoundException
import java.io.IOException

object Test {
   def main(args: Array[String]) {
      try {
         val f = new FileReader("input.txt")
      } catch {
         case ex: FileNotFoundException =>{
            println("Missing file exception")
         }
         case ex: IOException => {
            println("IO Exception")
         }
      }
   }
}
```
##finally子句：
如果想知道引起一些代码是如何表达的终止执行，可以用一个finally子句包住一个表达式，finally块什么时候都会执行。

---
#提取器
提取器在Scala中是一个对象，有一个叫非应用作为其成员的一种方法。即不应用方法的目的是要匹配的值，并把它拆开。通常，提取对象还限定了双方法申请构建值，但是这不是必需的。

下面的例子显示电子邮件地址的提取器对象：
```scala
object Test {
   def main(args: Array[String]) {
      println ("Apply method : " + apply("Zara", "gmail.com"));
      println ("Unapply method : " + unapply("Zara@gmail.com"));
      println ("Unapply method : " + unapply("Zara Ali"));
   }
   // The injection method (optional)
   def apply(user: String, domain: String) = {
      user +"@"+ domain
   }
   // The extraction method (mandatory)
   def unapply(str: String): Option[(String, String)] = {
      val parts = str split "@"
      if (parts.length == 2){
         Some(parts(0), parts(1)) 
      }else{
         None
      }
   }
}

unapply("Zara@gmail.com") equals Some("Zara", "gmail.com")
unapply("Zara Ali") equals None
Apply method : Zara@gmail.com
Unapply method : Some((Zara,gmail.com))
Unapply method : None

```
这个对象定义了 apply 和unapply 方法。该apply 方法具有相同的含义：它原来的测试为可以被应用到的参数在括号中的方法所应用的相同的方式的对象。所以，可以写为Test("Zara", "gmail.com") 来构造字符串“Zara@gmail.com”。

unapply方法使测试类成为一个提取器并反转应用的构造过程。应用需要两个字符串，并形成了一个电子邮件地址以找到它们，非应用unapply需要一个电子邮件地址，并可能返回两个字符串：用户和地址的域名。

unapply还必须处理中给定的字符串不是一个电子邮件地址的情况。这就是为什么unapply返回一个选项型过对字符串。其结果要么是一些(用户域)如果字符串str使用给定电子邮件地址的用户和域的部分，或None，如果str不是一个电子邮件地址。下面是一些例子：

##模式匹配使用提取器
当一个类的实例后跟括号使用零个或多个参数的列表，所述编译器调用应用的方法在该实例上。我们可以定义同时适用对象和类。
如上述所提到的，unapply方法的目的是提取我们寻找一个特定的值。
它相反的操作和apply一样。
当比较使用匹配语句中unapply方法的提取对象将被自动执行，如下所示：
```scala
object Test {
   def main(args: Array[String]) {
      val x = Test(5)
      println(x)
      x match
      {
         case Test(num) => println(x+" is bigger two times than "+num)
         //unapply is invoked
         case _ => println("i cannot calculate")
      }
   }
   def apply(x: Int) = x*2
   def unapply(z: Int): Option[Int] = if (z%2==0) Some(z/2) else None
}
/*
C:/>scalac Test.scala
C:/>scala Test
10
10 is bigger two times than 5
*/
```

---
#文件I/O
```scala
import java.io._

object Test {
   def main(args: Array[String]) {
      val writer = new PrintWriter(new File("test.txt" ))

      writer.write("Hello Scala")
      writer.close()
   }
}

object Test {
   def main(args: Array[String]) {
      print("Please enter your input : " )
      val line = Console.readLine
      
      println("Thanks, you just typed: " + line)
   }
}
```
读取文件内容：
从文件中读取是非常简单的。可以使用Scala的Source 类和它配套对象读取文件。以下是这些显示如何从之前创建“test.txt”文件中读取内容的示例：
```scala
import scala.io.Source

object Test {
   def main(args: Array[String]) {
      println("Following is the content read:" )
      Source.fromFile("test.txt" ).foreach{ 
         print 
      }
   }
}
```













