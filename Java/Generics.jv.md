#Generics
---
泛型是JDK 1.5的一项新特性，它的本质是参数化类型（Parameterized Type）的应用，也就是说所操作的数据类型被指定为一个参数，在用到的时候在指定具体的类型。这种参数类型可以用在类、接口和方法的创建中，分别称为泛型类、泛型接口和泛型方法。

##类型膨胀 真实泛型 
C#里面泛型无论在程序源码中、编译后的IL中（Intermediate Language，中间语言，这时候泛型是一个占位符）或是运行期的CLR中都是切实存在的，List<int>与List<String>就是两个不同的类型，它们在系统运行期生成，有自己的虚方法表和类型数据，这种实现称为类型膨胀，基于这种方法实现的泛型被称为真实泛型。

##类型擦除 伪泛型
Java语言中的泛型则不一样，它只在程序源码中存在，在编译后的字节码文件中，就已经被替换为原来的原始类型（Raw Type，也称为裸类型）了，并且在相应的地方插入了强制转型代码
因此对于运行期的Java语言来说，ArrayList<int>与ArrayList<String>就是同一个类
所以说泛型技术实际上是Java语言的一颗语法糖，Java语言中的泛型实现方法称为类型擦除，基于这种方法实现的泛型被称为伪泛型。（类型擦除在后面在学习）


整个成为ArrayList<E>泛型类型
ArrayList<E>中的 E称为类型变量或者类型参数
整个ArrayList<Integer> 称为参数化的类型
ArrayList<Integer>中的integer称为类型参数的实例或者实际类型参数
·ArrayList<Integer>中的<Integer>念为typeof   Integer
ArrayList称为原始类型


#使用
##泛型类
一个泛型类（generic class）就是具有一个或多个类型变量的类。定义一个泛型类十分简单，只需要在类名后面加上<>，再在里面加上类型参数
```java
class Pair<T> {  
    private T value;  
        public Pair(T value) {  
                this.value=value;  
        }  
        public T getValue() {  
        return value;  
    }  
    public void setValue(T value) {  
        this.value = value;  
    }  
}
```
现在我们就可以使用这个泛型类了：
```java
public static void main(String[] args) throws ClassNotFoundException {  
    Pair<String> pair=new Pair<String>("Hello");  
    String str=pair.getValue();  
    System.out.println(str);  
    pair.setValue("World");  
    str=pair.getValue();  
    System.out.println(str);  
}
```
##泛型接口
```java
interface Show<T,U>{  
    void show(T t,U u);  
}  
  
class ShowTest implements Show<String,Date>{  
    @Override  
    public void show(String str,Date date) {  
        System.out.println(str);  
        System.out.println(date);  
    }  
}  

```

##泛型方法
```java
public static void main(String[] args) throws ClassNotFoundException {  
    String str=get("Hello", "World");  
    System.out.println(str);  
}  
  
public static <T, U> T get(T t, U u) {  
    if (u != null)  
        return t;  
    else  
        return null;  
}  
```

##泛型变量的类型限定
```
public static <T extends Comparable> T get(T t1,T t2) { //添加类型限定  
        if(t1.compareTo(t2)>=0);  
        return t1;  
    }  
```

类型限定在泛型类、泛型接口和泛型方法中都可以使用，不过要注意下面几点：
1、不管该限定是类还是接口，统一都使用关键字 extends
2、可以使用&符号给出多个限定，比如
```java
public static <T extends Comparable&Serializable> T get(T t1,T t2)  
```
3、如果限定既有接口也有类，那么类必须只有一个，并且放在首位置
```java
public static <T extends Object&Comparable&Serializable> T get(T t1,T t2)  
```

---
#类型擦出（type erasure）
Java中的泛型基本上都是在编译器这个层次来实现的。在生成的Java字节码中是不包含泛型中的类型信息的。使用泛型的时候加上的类型参数，会在编译器在编译的时候去掉。这个过程就称为类型擦除。

类型变量被擦除（crased），并使用其限定类型（无限定的变量用Object）替换

```java
public class Test4 {  
    public static void main(String[] args) throws IllegalArgumentException, SecurityException, IllegalAccessException, InvocationTargetException, NoSuchMethodException {  
        ArrayList<Integer> arrayList3=new ArrayList<Integer>();  
        arrayList3.add(1);//这样调用add方法只能存储整形，因为泛型类型的实例为Integer  
        arrayList3.getClass().getMethod("add", Object.class).invoke(arrayList3, "asd");//通过反射可以添加string类型
        for (int i=0;i<arrayList3.size();i++) {  
            System.out.println(arrayList3.get(i));  
        }  
    }  
}
```


public class Pair<T extends Comparable& Serializable> {  
原始类型就是Comparable

注意：
如果Pair这样声明public class Pair<T extends Serializable&Comparable> ，那么原始类型就用Serializable替换，而编译器在必要的时要向Comparable插入强制类型转换。为了提高效率，应该将标签（tagging）接口（即没有方法的接口）放在边界限定列表的末尾。


#类型擦除引起的问题及解决方法
##1、先检查，在编译，以及检查编译的对象和引用传递的问题
java编译器是通过先检查代码中泛型的类型，然后再进行类型擦除，在进行编译的

ArrayList<String> arrayList1=new ArrayList(); //第一种 情况  
ArrayList arrayList2=new ArrayList<String>();//第二种 情况  
这样是没有错误的，不过会有个编译时警告。
不过在第一种情况，可以实现与 完全使用泛型参数一样的效果，第二种则完全没效果。

因为new ArrayList()只是在内存中开辟一个存储空间，可以存储任何的类型对象
真正涉及类型检查的是它的引用，因为我们是使用它引用arrayList1 来调用它的方法，比如说调用add()方法。所以arrayList1引用能完成泛型类型的检查。
而引用arrayList2没有使用泛型，所以不行。

泛型中参数化类型为什么不考虑继承关系
```java
ArrayList<String> arrayList1=new ArrayList<Object>();//编译错误  
ArrayList<Object> arrayList1=new ArrayList<String>();//编译错误  

ArrayList<Object> arrayList1=new ArrayList<Object>();  
arrayList1.add(new Object());  
arrayList1.add(new Object());  
ArrayList<String> arrayList2=arrayList1;//编译错误  

ArrayList<String> arrayList1=new ArrayList<String>();  
arrayList1.add(new String());  
arrayList1.add(new String());  
ArrayList<Object> arrayList2=arrayList1;//编译错误  
```

##2、自动类型转换
checkcast
```
checkcast checks that the top item on the operand stack (a reference to an object or array) can be cast to a given type. For example, if you write in Java:

return ((String)obj);

then the Java compiler will generate something like:

aload_1 ; push -obj- onto the stack
checkcast java/lang/String ; check its a String
areturn ; return it

checkcast is actually a shortand for writing Java code like:

if (! (obj == null || obj instanceof <class>)) {
throw new ClassCastException();
}
// if this point is reached, then object is either null, or an instance of
// <class> or one of its superclasses.
```

##3、类型擦除与多态的冲突和解决方法
```java
class Pair<T> {  
    private T value;  
    public T getValue() {  
        return value;  
    }  
    public void setValue(T value) {  
        this.value = value;  
    }  
}  

class DateInter extends Pair<Date> {  
    @Override  
    public void setValue(Date value) {  
        super.setValue(value);  
    }  
    @Override  
    public Date getValue() {  
        return super.getValue();  
    }  
}  

//擦除后
class Pair {  
    private Object value;  
    public Object getValue() {  
        return value;  
    }  
    public void setValue(Object  value) {  
        this.value = value;  
    }  
}  
再看子类的两个重写的方法的类型：
@Override  
public void setValue(Date value) {  
    super.setValue(value);  
}  
@Override  
public Date getValue() {  
    return super.getValue();  
}

//setValue方法，父类的类型是Object，而子类的类型是Date，参数类型不一样，这如果实在普通的继承关系中，根本就不会是重写，而是重载。
```

桥方法

协变

4、泛型类型变量不能是基本数据类型
不能用类型参数替换基本类型。就比如，没有ArrayList<double>，只有ArrayList<Double>。因为当类型擦除后，ArrayList的原始类型变为Object，但是Object类型不能存储double值，只能引用Double的值。

5、运行时类型查询
if( arrayList instanceof ArrayList<String>)    //错误
java限定了这种类型查询的方式
if( arrayList instanceof ArrayList<?>)    

6、异常中使用泛型的问题
1、不能抛出也不能捕获泛型类的对象。
2、不能再catch子句中使用泛型变量

7、数组（这个不属于类型擦除引起的问题）
不能声明参数化类型的数组。
  数组可以记住自己的元素类型，下面的赋值会抛出一个ArrayStoreException异常。

8、泛型类型的实例化 
不能实例化泛型类型。如，
[java] view plain copy
first = new T(); //ERROR  

9、类型擦除后的冲突
1、当泛型类型被擦除后，创建条件不能产生冲突。如果在Pair类中添加下面的equals方法
[java] view plain copy
class Pair<T>   {  
    public boolean equals(T value) {  
        return null;  
    }  
}  
2、泛型规范说明提及另一个原则“要支持擦除的转换，需要强行制一个类或者类型变量不能同时成为两个接口的子类，而这两个子类是同一接品的不同参数化。”


10、泛型在静态方法和静态类中的问题
泛型类中的静态方法和静态变量不可以使用泛型类所声明的泛型类型参数

public class Test2<T> {    
    public static T one;   //编译错误    
    public static  T show(T one){ //编译错误    
        return null;    
    }    
}    


public class Test2<T> {
//这是一个泛型方法，在泛型方法中使用的T是自己在方法中定义的T，而不是泛型类中的T
    public static <T >T show(T one){//这是正确的    
        return null;    
    }    
}    

#通配符
有三种：
1、无限定通配符   形式<?>
2、上边界限定通配符 形式< ? extends Number>    //用Number举例
3、下边界限定通配符    形式< ? super Number>    //用Number举例
1、泛型中的？通配符
```java
import java.util.ArrayList;  
import java.util.Collection;  
import java.util.List;  
  
publicclass GernericTest {  
    publicstaticvoid main(String[] args) throws Exception{  
        List<Integer> listInteger =new ArrayList<Integer>();  
        List<String> listString =new ArrayList<String>();  
        printCollection(listInteger);  
        printCollection(listString);  
    }  
    publicstaticvoid printCollection(Collection<?> collection){  
               for(Object obj:collection){  
            System.out.println(obj);  
        }  
    }  
}  

```

2、泛型中的?通配符的扩展
1:界定通配符的上边界
Vector<? extends 类型1> x = new Vector<类型2>();
类型1指定一个数据类型，那么类型2就只能是类型1或者是类型1的子类
Vector<? extends Number> x = new Vector<Integer>();//这是正确的
Vector<? extends Number> x = new Vector<String>();//这是错误的
 
2:界定通配符的下边界
Vector<? super 类型1> x = new Vector<类型2>();
类型1指定一个数据类型，那么类型2就只能是类型1或者是类型1的父类
Vector<? super Integer> x = new Vector<Number>();//这是正确的
Vector<? super Integer> x = new Vector<Byte>();//这是错误的
 
提示：限定通配符总是包括自己








