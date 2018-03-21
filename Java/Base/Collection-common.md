# apache-common-collections
https://www.jianshu.com/p/c3c3ab2bad8d

* 新的集合
* 新的概念
* 新版本的老集合
* 有用的工具类

## 新的集合
### Bag
Bag定义了一种集合：收集一个对象出现的次数。
例如Bag：{a,a,b,c}
调用bag.getCount(a)返回2，意味着里面有2个a。
调用bag.uniqueSet()则返回一个set，值为{a,b,c}。

这个集合可以用来计数，而如果用set则无法实现，用map可以把count作为value来勉强实现，但显然在add操作的时候并不优雅，需要：

map.put(key,map.get(key)+1);
并且还需要担心map中存的不是一个整数。
用Bag计算森林中的兔子：

HashBag bag = new HashBag();
bag.add("rabbit",1);
bag.add("fox",1);
bag.add("rabbit",2);

//rabbit count
System.out.print(bag.getCount("rabbit"));
//how many animals
System.out.print(bag.uniqueSet().size());

除了HashBag，还有SynchronizedBag,TreeBag,可以通过源码或者javadoc进一步了解使用。

### BidiMap
BidiMap定义了一种map，不仅可以通过key得到value，还可以通过value得到key。Bidi意思是bidirectional，双向使用的map。
除了传统map的操作，特殊操作如下：

BidiMap bidi = new DualHashBidiMap();
bidi.put("k1","v1");
bidi.put("k2","v2");

bidi.get("k2"); // return v2
bidi.getKey("v2"); // return k2

bidi.inverseBidiMap(); //反转bidi，原先的value作为key
作为代价，BidiMap必须要求k和v是一一对应的，在上述代码之后，无法做到bidi.put("k2","v1");，因为这样就无法实现响应操作。
现实中如学号和身份证号做对应就是这样一种关系，可以视情况使用。

除了DualHashBidiMap，还有TreeBidiMap等,可以通过源码或者javadoc进一步了解使用。

## 新的概念
### Predicate 预言
这个类主要结合CollectionUtils.find,CollectionUtils.filter来使用。
他的作用类似于『断言』，其中只有一个方法：

public boolean evaluate(Object object);
这个方法用于判断一个对象是否满足某种标准，你可以通过让age>50来寻找列表中年龄大于50的元素，或是找到id为12306的那个对象，如
```java
Predicate predicate = new Predicate{
  @override
  public boolean evaluate(Object object){
    return PropertyUtils.getSimpleProperty(object,"age") >50 ;
  }
}
Predicate predicate2 = new Predicate{
  @override
  public boolean evaluate(Object object){
    return PropertyUtils.getSimpleProperty(object,"id") == 12306 ;
  }
}
//删除不满足条件的结果
CollectionUtils.filter(list,predicate);
//返回第一个满足的元素
Object obj = CollectionUtils.find(list,predicate2);
```
同时，Predicate可以进行谓词连接，借助于：
* AndPredicate
* OrPredicate
* AnyPredicate
* NotPredicate
我们可以创造出id为12306并且年龄大于50的预言
new AndPredicate(predicate1,predicate2);
代码的复用程度被极大提升,这个类是apache-common包最精髓之处。

### Closure和Transformer 代码闭包
介绍这两个接口主要目的是扩大思路，因为随着jdk8的引入，作者认为这两个接口的作用性就有待商榷了。但是在他们引入的时候，这个思路无疑是值得参考的。
我们从一段代码来了解这两个类。
```java
//传统代码
..do something
for(obj in list){
  obj.sayHello();
}
..do otherthing

//使用closure
Closure closure = ClosureUtils.invokerClosure("sayHello");

..do something
CollectionUtils.forAllDo(list,closure);
..do otherthing
```
没错，这就是jdk8中大力引入的函数式编程思想。在其他语言（javascript, scala, python等)高度动态性的影响下，开发者们意识到函数式编程的好处。
最大好处在于减少了代码块的层次，把for，if，swith，while等等的嵌套代码结构更改为了顺序型的结构，让代码可读性大大提升。实际上作者自己的感触也是这样的，一段长代码的难懂程度跟嵌套代码的深度成正比。

想像一下:
```java
for(condition){
  if(cond2){
    if(cond4){
      ..do trunk logic
    }else{
      ..do branch logic
    }
  }else{
    if(cond3){
      ..do fast fail logic
    }
    ..do error fixing logic
  }
}
```
讲到这里，可以正式介绍一下Closure和Transformer。他们的含义是封装一个代码结构块，前者是void函数，后者是有返回值的函数，可以理解为对一个对象的transform。
jdk8中正式引入了lambda功能，我们的解决方案可以是：

//forEach函数实现内部迭代
list.forEach(o->{System.out.println(o);});

这里想说的是，技术多种多样，思想不变

## 老集合的新面孔
这一节我会走马观花的列举一系列类，具体使用可以自行发掘。
### GrowthList
为了避免大部分IndexOutOfBoundsException而使用的list容器。对于index越界会安静的处理：超过length的set和add操作会自动增大list以适应。

### LazyList
通过传入一个factory对象来实现懒加载。同时也具有Growth的特点，比如get一个不存在的index时，会自动create一个对象并返回。

[1,2,3].get(5)会导致：[1,2,3,null,factory.create()]
SetUniqueList
内部是一个set的list，我们经常需要用到没有重复的列表，会新建一个ArrayList，并最后调用
new ArrayList(new HashSet(list))来去重。而这个类会自动帮你做好这些。

### SynchronizedList
一个线程安全的列表

### LazyMap
类似LazyList

### LRUMap
一个有限个数的Map，并根据LRU算法来决定哪些元素被丢弃，适合用来做简易缓存。

### MultiKeyMap
多个键的Map，譬如操作班级，学号时：

map.put("class1",1001,john);
但看过源码之后发现是通过合并多个key的hashcode来做到这一点，那么和我们使用普通map时直接put("class1"+1001,john)效果类似。只能理解为提升代码可读性了。

### MultiValueMap
这个类可以方便的为一个key对应多个value的情况做适应。
然而如果了解Google的Guava包，实际上里面有一个更好用的类:Multimap这里就不过多介绍了。

### CompositeCollection
包括CompositeSet,CompositeMap，用于保持其他容器的同时提供各容器混合的功能。

以CompositeSet为例，
compositeSet.add(set1,set2);
形成了一个二级的set，这一点和set1.addAll(set2)是不一样的,使用时我们可以同时存在set1,set2和compositeSet。
而对二级set的修改操作会直接影响到子容器。
如compositeSet.remove(obj);
如果set1和set2都包含了obj，会同时删去obj。

## 有用的工具类
这是collections包中最有价值的一个部分，我准备介绍ListUtils和CollectionUtils。

### ListUtils 列表工具类
ListUtils.intersection(list1,list2)
取交集
ListUtils.subtract(list1,list2)
返回list1和list2的差。这里和list1.removeAll(list2)的差别在于：
前者不改变任何一个集合
如果list1中有2个a，list2中有一个a：removeAll会将list1中所有的a都抹去，而subtract结果list1仍然会剩下一个a
ListUtils.union(list1,list2)
取并集
ListUtils.removeAll(list1,list2)
不改变list的情况下做removeAll

### CollectionUtils 通用的集合工具类

CollectionUtils.union(c1,c2)，CollectionUtils.intersection(c1,c2)
不再解释
CollectionUtils.disjunction(c1,c2)
返回两者的不相交部分的并集，没想到一个现实场景。。
CollectionUtils.containsAny(c1,c2)
只要c1包含任何一个c2的元素，返回true
前方高能：
CollectionUtils.find(c,predicate)
重要方法：借助Predicate达到神一般的效果，从此减少一半for循环。返回第一个找到的元素

CollectionUtils.filter(c,predicate)
重要方法：同上，直接改变容器c。

CollectionUtils.transform(c,transformer)
重要方法：还是神器，但是在jdk8中等同于foreach方法效果。如果jdk<8，可以用这个方法代替

CollectionUtils.countMatches(c,predicate)
根据predicate返回有多少元素满足预言，返回值int。

CollectionUtils.select(c,predicate)
根据predicate找出满足的元素，组成新的collection并返回

CollectionUtils.select(c,predicate,outputCollection)
根据predicate找出满足的元素，加入到outputCollection中。

CollectionUtils.isEmpty(c)
简单实用，是否为null或者空集合


