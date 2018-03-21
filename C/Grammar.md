

#typedef用法 与#define
typedef根据名字就知道是对类的定义。但是值得注意的是，它并不定义新的类型，而是对已有的类型定义一个其他的名字。本人生就略愚，常常搞不清与#define的关系，难道仅仅是所定义得到的新类型所在的位置不同吗？首先我们仔细看看typedef。

一、typedef的用法
人说typedef的使用可以编写更加美观和可读的代码，原因是typedef可以隐藏笨拙的语法结构以及平台相关的数据类型，从而增加可移植性及未来的可维护性。对于typedef的用法，一般如下：原始类型一般紧紧临着typedef，最右边是声明的新的类型名字（其实就是原始类型的一种表示）。例如 typedef int INT；这里声明了一个与int同意的类型INT。如此以来int a；与INT a；并没什么本质的区别。
      typedef还可以掩盖复合类型，例如指针、数组、函数指针。例如，定义char value1[80], value2[80];可以优化一下：typedef char LINE[80]; LINE value1,value2;指针定义：typedef (int*) PINT;PINT szA,szB;等同与int* szA,*szB.对函数指针定义如：typedef void  (*FUNC)(int,int); FUNC pFun1,pFun2;等价于void (*pFun1)(int ,int); void (*pFun2)(int ,int).
     typedef可以定义变相机器无关性代码，例如三台机器对浮点类型的支持分别是long double，double，float。这是为了代码的统一，可以对三种机器分别如下定义：typedef long double REAL； typedef double REAL； typedef float REAL。这样，虽然代码中使用了浮点类型REAL，但并不会给不同类性的机器代理不兼容的问题。
    typedef可以增强程序的可读性，以及标识符的灵活性，但是它也有“非直观性”等缺点。

二、#define的用法
`#define`为一个宏定义语句，通常它用来定义常量（包括无参量与带参量），以及用来实现那些“表面似和善，背后一长串”的宏（很是形象）。它本身并不在编译过程中进行，而是在着之前（预处理过程）就完成了，但因此难以发现潜在的错误及其他代码维护问题。它的实例像：
```
#define   INT             int
#define   TRUE         1
#define   Add(a,b)     ((a)+(b));
#define   Loop_10    for (int i=0; i<10; i++)
```
在Scott Meyer的Effective C++一书的条款1中有关于#define语句弊端的分析，以及好的替代方法，大家可参看。

三、typedef与#define的区别
从以上的概念便也能基本清楚，typedef只是为了增加可读性而为标识符另起的新名称(仅仅只是个别名)，而#define原本在C中是为了定义常量，到了C++，const、enum、inline的出现使它也渐渐成为了起别名的工具。有时很容易搞不清楚与typedef两者到底该用哪个好，如#define INT int这样的语句，用typedef一样可以完成，用哪个好呢？我主张用typedef，因为在早期的许多C编译器中这条语句是非法的，只是现今的编译器又做了扩充。为了尽可能地兼容，一般都遵循#define定义“可读”的常量以及一些宏语句的任务，而typedef则常用来定义关键字、冗长的类型的别名。
宏定义只是简单的字符串代换(原地扩展)，而typedef则不是原地扩展，它的新名字具有一定的封装性，以致于新命名的标识符具有更易定义变量的功能。请看上面第一大点代码的第三行：
typedef    (int*)      pINT;
以及下面这行:
```
#define    pINT2    int*
```
效果相同？实则不同！实践中见差别：pINT a,b;的效果同int *a; int *b;表示定义了两个整型指针变量。而pINT2 a,b;的效果同int *a, b;
表示定义了一个整型指针变量a和整型变量b。
注意：两者还有一个行尾;号的区别！
