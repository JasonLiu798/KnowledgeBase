

----
# foreach
* For-each语法内部，对collection是用nested iteratoration来实现的，对数组是用下标遍历来实现。
* Java 5 及以上的编译器隐藏了基于iteration和下标遍历的内部实现。（注意，这里说的是“Java编译器”或Java语言对其实现做了隐藏，而不是某段Java代码对其实现做了隐藏，也就是说，我们在任何一段JDK的Java代码中都找不到这里被隐藏的实现。这里的实现，隐藏在了Java 编译器中，我们可能只能像这篇帖子中说的那样，查看一段For-each的Java代码编译成的字节码，从中揣测它到底是怎么实现的了）

## For-each loop 
for (type var : arr) {
    body-of-loop
}

for (int i = 0; i < arr.length; i++) { 
    type var = arr[i];
    body-of-loop
}

## Equivalent for loop
for (type var : coll) {
    body-of-loop
}
for (Iterator<type> iter = coll.iterator(); iter.hasNext(); ) {
    type var = iter.next();
    body-of-loop
}


* 使用For-each时对collection或数组中的元素不能做赋值操作
Only access. Elements can not be assigned to, eg, not to increment each element in a collection. 
* 同时只能遍历一个collection或数组，不能同时遍历多余一个collection或数组
Only single structure. It's not possible to traverse two structures at once, eg, to compare two arrays.
* 遍历过程中，collection或数组中同时只有一个元素可见，即只有“当前遍历到的元素”可见，而前一个或后一个元素是不可见的。
Only single element. Use only for single element access, eg, not to compare successive elements.
* 只能正向遍历，不能反向遍历（相比之下，C++ STL中还有reverse_iterator, rbegin(), rend()之类的东西，可以反向遍历）
Only forward. It's possible to iterate only forward by single steps.
* 如果要兼容Java 5之前的Java版本，就不能使用For-each
At least Java 5. Don't use it if you need compatibility with versions before Java 5.

```java
public static void main(String[] args)
{
    List<String> list = new ArrayList<String>();
    list.add("111");
    list.add("222");
    
    for (String str : list)
    {
        System.out.println(str);
    }
}
```
```
public static void main(java.lang.String[]);
     flags: ACC_PUBLIC, ACC_STATIC
     Code:
       stack=2, locals=4, args_size=1
          0: new           #16                 // class java/util/ArrayList
          3: dup
          4: invokespecial #18                 // Method java/util/ArrayList."<in it>":()V
          7: astore_1
          8: aload_1
          9: ldc           #19                 // String 111
         11: invokeinterface #21,  2           // InterfaceMethod java/util/List.
 add:(Ljava/lang/Object;)Z
         16: pop
         17: aload_1
         18: ldc           #27                 // String 222
         20: invokeinterface #21,  2           // InterfaceMethod java/util/List.
 add:(Ljava/lang/Object;)Z
         25: pop
         26: aload_1
         27: invokeinterface #29,  1           // InterfaceMethod java/util/List.
 iterator:()Ljava/util/Iterator;
```
1、ArrayList之所以能使用foreach循环遍历，是因为ArrayList所有的List都是Collection的子接口，而Collection是Iterable的子接口，ArrayList的父类AbstractList正确地实现了Iterable接口的iterator方法。之前我自己写的ArrayList用foreach循环直接报空指针异常是因为我自己写的ArrayList并没有实现Iterable接口

2、任何一个集合，无论是JDK提供的还是自己写的，只要想使用foreach循环遍历，就必须正确地实现Iterable接口

实际上，这种做法就是23中设计模式中的迭代器模式。

## 对于数组
```java 
public static void main(String[] args) {
	int[] ints = {1,2,3,4,5};
	
	for (int i : ints)
		System.out.println(i);
}
//->
public static void main(String[] args) {
    int[] ints = new int[]{1, 2, 3, 4, 5};
    int[] var2 = ints;
    int var3 = ints.length;
    for(int var4 = 0; var4 < var3; ++var4) {
        int i = var2[var4];
        System.out.println(i);
    }

}
```
```java
  public static void main(java.lang.String[]);
    Code:
       0: iconst_5
       1: newarray       int
       3: dup
       4: iconst_0
       5: iconst_1
       6: iastore
       7: dup
       8: iconst_1
       9: iconst_2
      10: iastore
      11: dup
      12: iconst_2
      13: iconst_3
      14: iastore
      15: dup
      16: iconst_3
      17: iconst_4
      18: iastore
      19: dup
      20: iconst_4
      21: iconst_5
      22: iastore
      23: astore_1
      24: aload_1
      25: astore_2
      26: aload_2
      27: arraylength
      28: istore_3
      29: iconst_0
      30: istore        4
      32: iload         4
      34: iload_3
      35: if_icmpge     58
      38: aload_2
      39: iload         4
      41: iaload
      42: istore        5
      44: getstatic     #2                  // Field java/lang/System.out:Ljava/io/PrintStream;
      47: iload         5
      49: invokevirtual #3                  // Method java/io/PrintStream.println:(I)V
      52: iinc          4, 1
      55: goto          32
      58: return
}
```








