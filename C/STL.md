C++ 标准库：

1  language support lib
语言支持（language support）部分，包含了一些标准类型的定义以及其他特性的定义，这些内容，被用于标准库的其他地方或是具体的应用程序中。

2 Diagnostics lib
诊断（diagnostics）部分，提供了用于程序诊断和报错的功能，包含了异常处理（exception handling），断言（assertions），错误代码（error number codes）三种方式。
其中主体部分主要是异常库（包含在头文件<exception>中）
1) <exception>头文件中定义了异常类exception；
2) <stdexcept>：exception的派生类,报告程序运行时错误,这些错误仅在程序运行时可以被检测到，如一些能被C++库函数或运行时系统抛出的标准的异常。runtime_error类也是exception的派生类,报告程序的逻辑错误,这些错误在程序执行前可以被检测到.
logic_error类，是所有标准异常类的基类.可以调用它的成员函数what()获取其特征的显示说明.
3) <new>头文件中定义了bad-alloc异常类。当new无法分配内存时将抛出该异常类对象。派生类<memory>中定义了auto_ptr异常类，auto_ptr是一个指针，当内存没有被安全释放时就引发这个异常。
4) <type_info>头文件中定义了bad_cast异常类。当dynamic_cast失败时将抛出该异常类对象。


3 General lib 通用工具库（包含在头文件<Utilities>),主要包括：
  对组（Pairs）：class pair 对组可将两个值视为一个单元。
  Class auto_ptr：一种智能指针，帮助程序员防止“抛出异常时发生资源泄露”
  数值极值（Numeric Limits）：提供多个数值类型在计算机中所能表达的最大和最小值。
  辅助函数（包含在头文件<algorithm>中）：例如求两个值中的较大值和较小值函数min()和max()，交换两个变量的值swap()函数等。
  头文件<cstddef>和<cstdlib>主要定义了一些常用的常数，类型和函数等。如NULL代表0地址或变量值，offset()函数返回在一个数组，结构体或是枚举类型中的偏移量，exit()与abort()函数用于退出当前的运行程序等等。

4 String lib
    包含在头文件<string>中,主要有以下内容：
   4.1 构造函数
a）    string s;     //生成一个空字符串s
b)       string s(str) //拷贝构造函数 生成str的复制品
c)       string s(str,stridx) //将字符串str内“始于位置stridx”的部分当作字符串的初值
d)       string s(str,stridx,strlen) //将字符串str内“始于stridx且长度顶多strlen”的部分作为字符串的初值
e)       string s(cstr) //将C字符串作为s的初值
f)       string s(chars,chars_len) //将C字符串前chars_len个字符作为字符串s的初值。
g)       string s(num,c) //生成一个字符串，包含num个c字符
h)       string s(beg,end) //以区间beg;end(不包含end)内的字符作为字符串s的初值
i)       s.~string() //销毁所有字符，释放内存
   4.2．字符串操作函数
a) =,assign()      //赋以新值
b) swap()      //交换两个字符串的内容
c) +=,append(),push_back() //在尾部添加字符
d) insert() //插入字符
e) erase() //删除字符
f) clear() //删除全部字符
g) replace() //替换字符
h) + //串联字符串
i) ==,!=,<,<=,>,>=,compare()     //比较字符串
j) size(),length()     //返回字符数量
k) max_size() //返回字符的可能最大个数
l) empty()     //判断字符串是否为空
m) capacity() //返回重新分配之前的字符容量
n) reserve() //保留一定量内存以容纳一定数量的字符
o) [ ], at() //存取单一字符
p) >>,getline() //从stream读取某值
q) <<     //将谋值写入stream
r) copy() //将某值赋值为一个C_string
s) c_str() //将内容以C_string返回
t) data() //将内容以字符数组形式返回
u) substr() //返回某个子字符串
v)查找函数find()
       rfind()
       find_first_of()
       find_last_of()
       find_first_not_of()
       find_last_not_of()

5 math lib
数学函数库（包含在头文件<cmath>中），这其中包含了大量在数学计算中要用到的函数，主要包括：三角函数，如sin(),cos(),tan(),asin(),acos(),atan()等；指数与对数函数，如exp().frexp().ldexp(),log(),modf ()等；双曲线函数，如cosh(),sinh(),tanh ()等；幂函数，如pow(),sqrt()等；其它还有ceil(),fabs(),floor()函数等等。


STL（标准模板库）部分：
******************************************************************************************************************************
STL的代码从广义上讲分为三类：algorithm（算法）、container（容器）和iterator（迭代器），几乎所有的代码都采用了模板类和模版函数的方式。在C++标准中，STL被组织为下面的13个头文件：<algorithm>、<deque>、<functional>、<iterator>、<vector>、<list>、<map>、<memory>、<numeric>、<queue>、<set>、<stack>和<utility>。

6 Container lib ：容器
STL的一个重要组成部分，涵盖了许多数据结构。
容器(container)类：可以容纳其他对象的类。STL包含 vector, list, deque, set, multiset, map, multimap, hash_set, hash_multiset, hash_map 和 hash_multimap 类。这些类每个都是模板(template)，能被实例化来包含各种类型的对象。例如，你可以用 vector ，就象常规的C语言中的数组，额外地，vector 能消除手工管理动态内存分配的杂事。string也可以看作是一个容器，适用于容器的方法同样也适用于string。主要容器介绍：
数据结构                                                     描述                                                                                  实现头文件
向量(vector)                                      连续存储的元素                                                                            <vector>
列表(list)                                 由节点组成的双向链表，每个结点包含着一个元素                                  <list>
双队列(deque)                 连续存储的指向不同元素的指针所组成的数组                                                <deque>
集合(set)             由节点组成的红黑树，每个节点都包含着一个元素，节点之间以某种作用于
                           元素对的谓词排列，没有两个不同的元素能够拥有相同的次序                                     <set>
多重集合(multiset)                 允许存在两个次序相等的元素的集合                                                        <set>
栈(stack)                                 后进先出的值的排列                                                                                <stack>
队列(queue)                          先进先出的执的排列                                                                                  <queue>
优先队列(priority_queue)     元素的次序是由作用于所存储的值对上的某种谓词决定的的一种队列         <queue>
映射(map)                            由{键，值}对组成的集合，以某种作用于键对上的谓词排列                          <map>
多重映射(multimap)            允许键对有相等的次序的映射                                                                       <map>

7 Iterators lib：迭代器
      如果没有迭代器的撮合，容器和算法便无法结合的如此完美。事实上，每个容器都有自己的迭代器，只有容器自己才知道如何访问自己的元素。它有点像指针，算法通过迭代器来定位和操控容器中的元素。概括来说，迭代器在STL中用来将算法和容器联系起来，起着一种黏和剂的作用。几乎STL提供的所有算法都是通过迭代器存取元素序列进行工作的，每一个容器都定义了其本身所专有的迭代器，用以存取容器中的元素。
       迭代器部分主要由头文件<utility>,<iterator>和<memory>组成。<utility>是一个很小的头文件，它包括了贯穿使用在STL中的几个模板的声明，<iterator>中提供了迭代器使用的许多方法，而对于<memory>的描述则十分的困难，它以不同寻常的方式为容器中的元素分配存储空间，同时也为某些算法执行期间产生的临时对象提供机制,<memory>中的主要部分是模板类allocator，它负责产生所有容器中的默认分配器。

8 Algorithms lib：算法
STL提供了大约100个实现算法的模版函数，用于操控各种容器，同时也可以操控内建数组。比如：find用于在容器中查找等于某个特定值的元素，for_each用于将某个函数应用到容器中的各个元素上，sort用于对容器中的元素排序。所有这些操作都是在保证执行效率的前提下进行的。
算法部分主要由头文件<algorithm>，<numeric>和<functional>组成。<algorithm>是所有STL头文件中最大的一个，它是由一大堆模版函数组成的，可以认为每个函数在很大程度上都是独立的，其中常用到的功能范围涉及到比较、交换、查找、遍历操作、复制、修改、移除、反转、排序、合并等等。<numeric>体积很小，只包括几个在序列上面进行简单数学运算的模板函数，包括加法和乘法在序列上的一些操作。<functional>中则定义了一些模板类，用以声明函数对象。


******************************************************************************************************************************


9 Numerics lib
包含了一些数学运算功能，提供了复数运算的支持。
头文件<complex>用于支持对复数的操作。
头文件<valarrays>中的valarrays是一个一维数组，元素从0开始计数，可以针对一个或多个数值数组的全体或部分进行数值处理。

10 I/O lib
C++语言提供了就是输入/输出流(I/O Stream的概念),在I/O流结构中,ios是基类,它包含如下两个派生类:
(1)istream类
istream类主要供处理数据输入之用,其底下包含一些成员函数,可以处理格式化或非格式化的输入动作,例如get()可以从输入流获取一个字符,并把它放置到指定变量中,getline(),peek(),putback(),read()及">>"等.
(2)ostream类
ostream类主要供处理数据输出之用,其底下包含一些成员函数,可以处理格式化或非格式化的输出动作,例如put() 提供了一种将字符送进输出流的方法,write()也可以提供一种将字符串送到输出流的方法及"<<"等.
iostream类派生于istream和ostream类,因此,它将继承istream和ostream类的特性,ifstream和ofstream这两个类则分别派生于istream和ostream类,因此它们也将分别继承其基类的特性.
ifstream:对文件进行提取操作
ostream:对文件进行插入操作
四个主要的流类对象，包含在头文件<iostream>中
cin: istream类的对象,用来处理标准键盘输入
cout: ostream类的对象,用来处理标准屏幕输出
cerr: ostream类的对象,用来处理标准出错信息,它提供不带缓冲区的输出
clog: ostream类的对象,也用来处理标准出错信息,但它提供带缓冲区的输出

11 Boost  
Boost 库是一个经过千锤百炼、可移植、提供源代码的C++库， Boost库是由C++标准委员会库工作组成员发起制定的。
主要包括以下一些库：
    Regex ——正则表达式库   
   Spirit LL parser framework——用C++代码直接表达EBNF 
   Graph ——图组件和算法
   Lambda ——在调用的地方定义短小匿名的函数对象，很实用的functional功能   
   concept check ——检查泛型编程中的concept
   Mpl ——用模板实现的元编程框架
   Thread ——可移植的C++多线程库
   Python ——把C++类和函数映射到Python之中
   Pool ——内存池管理
   Boost 总体来说是实用价值很高，质量很高的库。并且由于其对跨平台的强调，对标准C++的强调，是编写平台无关，现代C++的开发者必备的工具。

12  GUI
在众多C++的库中，GUI部分的库算是比较繁荣，也比较引人注目的。在实际开发中，GUI库的选择也是非常重要的一件事情。主要包括：
1  MFC ——微软基础类库（Microsoft Foundation Class）。它构建于Windows API 之上，能够使程序员的工作更容易,编程效率高，减少了大量在建立 Windows 程序时必须编写的代码，同时它还提供了所有一般 C++ 编程的优点，例如继承和封装。MFC 编写的程序在各个版本的Windows操作系统上是可移植的。
2 QT ——Qt 是Trolltech公司的一个多平台的C++图形用户界面应用程序框架。它提供给应用程序开发者建立艺术级的图形用户界面所需的所用功能。Qt是完全面向对象的很容易扩展，并且允许真正地组件编程。
3  WxWindows ——跨平台的GUI库。通过多年的开发也是一个日趋完善的 GUI库，支持同样不弱于前面两个库。并且是完全开放源代码的。
4 Fox ——开放源代码的GUI库。
5 WTL  ——基于ATL的一个库。因为使用了大量ATL的轻量级手法，模板等技术，在代码尺寸，以及速度优化方面做得非常到位。主要面向的使用群体是开发COM轻量级供网络下载的可视化控件的开发者。
6  GTK——GTK是一个大名鼎鼎的C的开源GUI库。在Linux世界中有Gnome这样的应用，而GTK就是这个库的C++封装版本。
7  网络通信库ACE ——C+ +库的代表，超重量级的网络通信开发框架。ACE自适配通信环境（Adaptive Communication Environment）是可以自由使用、开放源代码的面向对象框架，在其中实现了许多用于并发通信软件的核心模式。ACE提供了一组丰富的可复用C++ 包装外观（Wrapper Facade）和框架组件，可跨越多种平台完成通用的通信软件任务，其中包括：事件多路分离和事件处理器分派、信号处理、服务初始化、进程间通信、共享内存管理、消息路由、分布式服务动态（重）配置、并发执行和同步，等等。
8  StreamModule ——设计用于简化编写分布式程序的库。尝试着使得编写处理异步行为的程序更容易，而不是用同步的外壳包起异步的本质。
9  SimpleSocket ——这个类库让编写基于socket的客户/服务器程序更加容易。
10  A Stream Socket API for C++ ——又一个对Socket的封装库。
11  XML ——Xerces-C++ 是一个非常健壮的XML解析器，它提供了验证，以及SAX和DOM API。XML验证在文档类型定义(Document Type Definition，DTD)方面有很好的支持，并且在2001年12月增加了支持W3C XML Schema 的基本完整的开放标准。
12  XMLBooster ——这个库通过产生特制的parser的办法极大的提高了XML解析的速度，并且能够产生相应的GUI程序来修改这个parser。在DOM和SAX两大主流XML解析办法之外提供了另外一个可行的解决方案。
13  Pull Parser——这个库采用pull方法的parser。在每个SAX的parser底层都有一个pull的parser，这个xpp把这层暴露出来直接给大家使用。在要充分考虑速度的时候值得尝试。
14 Xalan ——Xalan是一个用于把XML文档转换为HTML，纯文本或者其他XML类型文档的XSLT处理器。
15 CMarkup ——这是一种使用EDOM的XML解析器。在很多思路上面非常灵活实用。值得大家在DOM和SAX之外寻求一点灵感。
16 libxml++——libxml++是对著名的libxml XML解析器的C++封装版本


科学计算库
1 Blitz++ ——Blitz++ 是一个高效率的数值计算函数库，它的设计目的是希望建立一套既具像C++ 一样方便，同时又比Fortran速度更快的数值计算环境。通常，用C++所写出的数值程序，比 Fortran慢20%左右，因此Blitz++正是要改掉这个缺点。方法是利用C++的template技术，程序执行甚至可以比Fortran更快。 Blitz++目前仍在发展中，对于常见的SVD，FFTs，QMRES等常见的线性代数方法并不提供，不过使用者可以很容易地利用Blitz++所提供的函数来构建。
2 POOMA ——POOMA是一个免费的高性能的C++库，用于处理并行式科学计算。POOMA的面向对象设计方便了快速的程序开发，对并行机器进行了优化以达到最高的效率，方便在工业和研究环境中使用。
3  MTL ——Matrix Template Library(MTL)是一个高性能的泛型组件库，提供了各种格式矩阵的大量线性代数方面的功能。在某些应用使用高性能编译器的情况下，比如Intel的编译器，从产生的汇编代码可以看出其与手写几乎没有两样的效能。
4  CGAL ——Computational Geometry Algorithms Library的目的是把在计算几何方面的大部分重要的解决方案和方法以C++库的形式提供给工业和学术界的用户。


   游戏开发支持库
1  Audio/Video 3D C++ Programming Library ——AV3D是一个跨平台，高性能的C++库。主要的特性是提供3D图形，声效支持（SB,以及S3M），控制接口（键盘，鼠标和遥感），XMS。
2  KlayGE ——国内游戏开发高手自己用C++开发的游戏引擎。KlayGE是一个开放源代码、跨平台的游戏引擎，并使用Python作脚本语言。KlayGE在LGPL协议下发行。感谢龚敏敏先生为中国游戏开发事业所做出的贡献。
3  OGRE ——OGRE （面向对象的图形渲染引擎）是用C++开发的，使用灵活的面向对象3D引擎。它的目的是让开发者能更方便和直接地开发基于3D硬件设备的应用程序或游戏。引擎中的类库对更底层的系统库（如：Direct3D和OpenGL）的全部使用细节进行了抽象，并提供了基于现实世界对象的接口和其它类。


    线程库
1  C++ Threads ——这个库的目标是给程序员提供易于使用的类，这些类被继承以提供在Linux环境中很难看到的大量的线程方面的功能。
2  ZThreads —— 一个先进的面向对象，跨平台的C++线程和同步库。



    序列化库
1  s11n ——  一个基于STL的C++库，用于序列化POD，STL容器以及用户定义的类型。
2 Simple XML Persistence Library ——这是个把对象序列化为XML的轻量级的C++库。

字符串库
1  C++ Str Library ——操作字符串和字符的库，支持Windows和支持gcc的多种平台。提供高度优化的代码，并且支持多线程环境和Unicode，同时还有正则表达式的支持。
2  Common Text Transformation Library ——这是一个解析和修改STL字符串的库。CTTL substring类可以用来比较，插入，替换以及用EBNF的语法进行解析。
3  GRETA ——这是由微软研究院的研究人员开发的处理正则表达式的库。在小型匹配的情况下有非常优秀的表现。

综合库
1 P::Classes ——  一个高度可移植的C++应用程序框架。当前关注类型和线程安全的signal/slot机制，i/o系统包括基于插件的网络协议透明的i/o架构，基于插件的应用程序消息日志框架，访问sql数据库的类等等。
2  ACDK - Artefaktur Component Development Kit ——这是一个平台无关的C++组件框架，类似于Java或者.NET中的框架（反射机制，线程，Unicode，废料收集，I/O，网络，实用工具，XML，等等），以及对Java, Perl, Python, TCL, Lisp, COM 和 CORBA的集成。
3  dlib C++ library ——各种各样的类的一个综合。大整数，Socket，线程，GUI，容器类,以及浏览目录的API等等。
4  Chilkat C++ Libraries ——这是提供zip，e-mail，编码，S/MIME，XML等方面的库。
5  C++ Portable Types Library (PTypes) ——这是STL的比较简单的替代品，以及可移植的多线程和网络库。
6  Loki ——  一个实验性质的库。作者在loki中把C++模板的功能发挥到了极致。并且尝试把类似设计模式这样思想层面的东西通过库来提供。同时还提供了智能指针这样比较实用的功能。
7  ATL ——ATL(Active Template Library)是一组小巧、高效、灵活的类，这些类为创建可互操作的COM组件提供了基本的设施。
8  FC++: The Functional C++ Library ——这个库提供了一些函数式语言中才有的要素。属于用库来扩充语言的一个代表作。如果想要在OOP之外寻找另一分的乐趣，可以去看看函数式程序设计的世界。
9  Crypto++ ——提供处理密码，消息验证，单向hash，公匙加密系统等功能的免费库。
