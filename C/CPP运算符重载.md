http://school.cnd8.com/c/jiaocheng/9350.htm
C++运算符重载探讨
前言 
　　多态性是面向对象程序设计的重要特征之一。它与前面讲过的封装性和继续性构成了面向对象程序设计的三大特征。这三大特征是相互关联的。封装性是基础，继续性是要害，多态性是补充，而多态又必须存在于继续的环境之中。 
　　所谓多态性是指发出同样的消息被不同类型的对象接收时导致完全不同的行为。这里所说的消息主要是指对类的成员函数的调用，而不同的行为是指不同的实现。利用多态性，用户只需发送一般形式的消息，而将所有的实现留给接收消息的对象。对象根据所接收到的消息而做出相应的动作(即操作)。 
　　函数重载和运算符重载是简单一类多态性。函数重载的概念及用法在《函数重载》一讲中已讨论过了，这里只作简单的补充，我们重点讨论的是运算符的重载。 
　　所谓函数重载简单地说就是赋给同一个函数名多个含义。具体地讲，C++中答应在相同的作用域内以相同的名字定义几个不同实现的函数，可以是成员函数，也可以是非成员函数。但是，定义这种重载函数时要求函数的参数或者至少有一个类型不同，或者个数不同。而对于返回值的类型没有要求，可以相同，也可以不同。那种参数个数和类型都相同，仅仅返回值不同的重载函数是非法的。因为编译程序在选择相同名字的重载函数时仅考虑函数表，这就是说要靠函数的参数表中，参数个数或参数类型的差异进行选择。 由此可以看出，重载函数的意义在于它可以用相同的名字访问一组相互关联的函数，由编译程序来进行选择，因而这将有助于解决程序复杂性问题。如：在定义类时，构造函数重载给初始化带来了多种方式，为用户提供更大的灵活性。 
　　下面我们重点讨论运算符重载。 
　　
　　运算符重载就是赋予已有的运算符多重含义。C++中通过重新定义运算符，使它能够用于特定类的对象执行特定的功能，这便增强了C++语言的扩充能力。 
　　
　　运算符重载的几个问题 
　　
　　1. 运算符重载的作用是什么？ 
　　
　　它答应你为类的用户提供一个直觉的接口。 
　　
　　运算符重载答应C/C++的运算符在用户定义类型(类)上拥有一个用户定义的意义。重载的运算符是函数调用的语法修饰： 
　　
　　 class Fred
　　{
　　public:
　　// ...
　　};
　　
　　#if 0
　　// 没有算符重载：
　　Fred add(Fred, Fred);
　　Fred mul(Fred, Fred);
　　
　　Fred f(Fred a, Fred b, Fred c)
　　{
　　return add(add(mul(a,b), mul(b,c)), mul(c,a)); // 哈哈，多可笑...
　　}
　　#else
　　// 有算符重载：
　　Fred operator+ (Fred, Fred);
　　Fred operator* (Fred, Fred); 
　　
　　Fred f(Fred a, Fred b, Fred c)
　　{
　　return a*b + b*c + c*a;
　　}
　　#endif 
　　2. 算符重载的好处是什么？ 
　　
　　通过重载类上的标准算符，你可以发掘类的用户的直觉。使得用户程序所用的语言是面向问题的，而不是面向机器的。 
　　
　　最终目标是降低学习曲线并减少错误率。 
　　
　　3. 哪些运算符可以用作重载？ 
　　
　　几乎所有的运算符都可用作重载。具体包含： 
　　
　　算术运算符：+,-,*,/,%,++,--;
　　位操作运算符：&,,~,^,＜＜,＞＞
　　逻辑运算符：!,&&,;
　　比较运算符：＜,＞,＞=,＜=,==,!=;
　　赋值运算符：=,+=,-=,*=,/=,%=,&=,=,^=,＜＜=,＞＞=;
　　其他运算符：[],(),-＞,,(逗号运算符),new,delete,new[],delete[],-＞*。 
　　
　　下列运算符不答应重载： 
　　
　　.,.*,::,?: 
　　
　　4. 运算符重载后，优先级和结合性怎么办？ 
　　
　　用户重载新定义运算符，不改变原运算符的优先级和结合性。这就是说，对运算符重载不改变运算符的优先级和结合性，并且运算符重载后，也不改变运算符的语法结构，即单目运算符只能重载为单目运算符，双目运算符只能重载双目运算符。 
　　
　　5. 编译程序如何选用哪一个运算符函数？ 
　　
　　运算符重载实际是一个函数，所以运算符的重载实际上是函数的重载。编译程序对运算符重载的选择，遵循着函数重载的选择原则。当碰到不很明显的运算时，编译程序将去寻找参数相匹配的运算符函数。 
　　
　　6. 重载运算符有哪些限制？ 
　　
　　(1) 不可臆造新的运算符。必须把重载运算符限制在C++语言中已有的运算符范围内的答应重载的运算符之中。 
　　
　　(2) 重载运算符坚持4个“不能改变”。 
　　
　　・不能改变运算符操作数的个数；
　　・不能改变运算符原有的优先级；
　　・不能改变运算符原有的结合性；
　　・不能改变运算符原有的语法结构。 
　　
　　7. 运算符重载时必须遵循哪些原则？ 
　　
　　运算符重载可以使程序更加简洁，使表达式更加直观，增加可读性。但是，运算符重载使用不宜过多，否则会带来一定的麻烦。 
　　
　　使用重载运算符时应遵循如下原则： 
　　
　　(1) 重载运算符含义必须清楚。 
　　
　　(2) 重载运算符不能有二义性。 运算符重载函数的两种形式 
　　
　　运算符重载的函数一般地采用如下两种形式：成员函数形式和友元函数形式。这两种形式都可访问类中的私有成员。 
　　
　　1. 重载为类的成员函数 
　　
　　这里先举一个关于给复数运算重载复数的四则运算符的例子。复数由实部和虚部构造，可以定义一个复数类，然后再在类中重载复数四则运算的运算符。先看以下源代码： 
　　
　　 #include ＜iostream.h＞ 
　　
　　class complex
　　{
　　public:
　　complex() { real=imag=0; }
　　complex(double r, double i)
　　{
　　real = r, imag = i;
　　}
　　complex operator +(const complex &c);
　　complex operator -(const complex &c);
　　complex operator *(const complex &c);
　　complex operator /(const complex &c);
　　friend void print(const complex &c);
　　private:
　　double real, imag;
　　}; 
　　
　　inline complex complex::operator +(const complex &c)
　　{
　　return complex(real + c.real, imag + c.imag);
　　} 
　　
　　inline complex complex::operator -(const complex &c)
　　{
　　return complex(real - c.real, imag - c.imag);
　　} 
　　
　　inline complex complex::operator *(const complex &c)
　　{
　　return complex(real * c.real - imag * c.imag, real * c.imag + imag * c.real);
　　} 
　　
　　inline complex complex::operator /(const complex &c)
　　{
　　return complex((real * c.real + imag + c.imag) / (c.real * c.real + c.imag * c.imag),
　　(imag * c.real - real * c.imag) / (c.real * c.real + c.imag * c.imag));
　　} 
　　
　　void print(const complex &c)
　　{
　　if(c.imag＜0)
　　cout＜＜c.real＜＜c.imag＜＜'i';
　　else
　　cout＜＜c.real＜＜'+'＜＜c.imag＜＜'i';
　　} 
　　
　　void main()
　　{
　　complex c1(2.0, 3.0), c2(4.0, -2.0), c3;
　　c3 = c1 + c2;
　　cout＜＜" c1+c2=";
　　print(c3);
　　c3 = c1 - c2;
　　cout＜＜" c1-c2=";
　　print(c3);
　　c3 = c1 * c2;
　　cout＜＜" c1*c2=";
　　print(c3);
　　c3 = c1 / c2;
　　cout＜＜" c1/c2=";
　　print(c3);
　　c3 = (c1+c2) * (c1-c2) * c2/c1;
　　cout＜＜" (c1+c2)*(c1-c2)*c2/c1=";
　　print(c3);
　　cout＜＜endl;
　　} 
　　该程序的运行结果为： 
　　
　　 
　　 c1+c2=6+1i
　　c1-c2=-2+5i
　　c1*c2=14+8i
　　c1/c2=0.45+0.8i
　　(c1+c2)*(c1-c2)*c2/c1=9.61538+25.2308i 
　　在程序中，类complex定义了4个成员函数作为运算符重载函数。将运算符重载函数说明为类的成员函数格式如下： 
　　
　　＜类名＞ operator ＜运算符＞(＜参数表＞) 
　　
　　其中，operator是定义运算符重载函数的要害字。 
　　
　　程序中出现的表达式： 
　　
　　c1+c2 
　　
　　编译程序将给解释为： 
　　
　　c1.operator+(c2) 
　　
　　其中，c1和c2是complex类的对象。operator+()是运算+的重载函数。 
　　
　　该运算符重载函数仅有一个参数c2。可见，当重载为成员函数时，双目运算符仅有一个参数。对单目运算符，重载为成员函数时，不能再显式说明参数。重载为成员函数时，总时隐含了一个参数，该参数是this指针。this指针是指向调用该成员函数对象的指针。 
　　
　　2. 重载为友元函数 
　　
　　运算符重载函数还可以为友元函数。当重载友元函数时，将没有隐含的参数this指针。这样，对双目运算符，友元函数有2个参数，对单目运算符，友元函数有一个参数。但是，有些运行符不能重载为友元函数，它们是：=,(),[]和-＞。 
　　
　　重载为友元函数的运算符重载函数的定义格式如下： 
　　
　　friend ＜类型说明符＞ operator ＜运算符＞(＜参数表＞)
　　{……} 
　　
　　下面用友元函数代码成员函数，重载编写上述的例子，程序如下： 
　　
　　 #include ＜iostream.h＞ 
　　
　　class complex
　　{
　　public:
　　complex() { real=imag=0; }
　　complex(double r, double i)
　　{
　　real = r, imag = i;
　　}
　　friend complex operator +(const complex &c1, const complex &c2);
　　friend complex operator -(const complex &c1, const complex &c2);
　　friend complex operator *(const complex &c1, const complex &c2);
　　friend complex operator /(const complex &c1, const complex &c2);
　　friend 
　　void print(const complex &c);
　　private:
　　double real, imag;
　　}; 
　　
　　complex operator +(const complex &c1, const complex &c2)
　　{
　　return complex(c1.real + c2.real, c1.imag + c2.imag);
　　} 
　　
　　complex operator -(const complex &c1, const complex &c2)
　　{
　　return complex(c1.real - c2.real, c1.imag - c2.imag);
　　} 
　　
　　complex operator *(const complex &c1, const complex &c2)
　　{
　　return complex(c1.real * c2.real - c1.imag * c2.imag, c1.real * c2.imag + c1.imag * c2.real);
　　} 
　　
　　complex operator /(const complex &c1, const complex &c2)
　　{
　　return complex((c1.real * c2.real + c1.imag + c2.imag) / (c2.real * c2.real + c2.imag * c2.imag),
　　(c1.imag * c2.real - c1.real * c2.imag) / (c2.real * c2.real + c2.imag * c2.imag));
　　} 
　　
　　void print(const complex &c)
　　{
　　if(c.imag＜0)
　　cout＜＜c.real＜＜c.imag＜＜'i';
　　else
　　cout＜＜c.real＜＜'+'＜＜c.imag＜＜'i';
　　} 
　　
　　void main()
　　{
　　complex c1(2.0, 3.0), c2(4.0, -2.0), c3;
　　c3 = c1 + c2;
　　cout＜＜" c1+c2=";
　　print(c3);
　　c3 = c1 - c2;
　　cout＜＜" c1-c2=";
　　print(c3);
　　c3 = c1 * c2;
　　cout＜＜" c1*c2=";
　　print(c3);
　　c3 = c1 / c2;
　　cout＜＜" c1/c2=";
　　print(c3);
　　c3 = (c1+c2) * (c1-c2) * c2/c1;
　　cout＜＜" (c1+c2)*(c1-c2)*c2/c1=";
　　print(c3);
　　cout＜＜endl;
　　} 
　　该程序的运行结果与上例相同。前面已讲过，对又目运算符，重载为成员函数时，仅一个参数，另一个被隐含；重载为友元函数时，有两个参数，没有隐含参数。因此，程序中出现的 c1+c2 
　　
　　编译程序解释为： 
　　
　　operator+(c1, c2) 
　　
　　调用如下函数，进行求值， 
　　
　　complex operator +(const coplex &c1, const complex &c2) 
　　 3. 两种重载形式的比较 
　　
　　一般说来，单目运算符最好被重载为成员；对双目运算符最好被重载为友元函数，双目运算符重载为友元函数比重载为成员函数更方便此，但是，有的双目运算符还是重载为成员函数为好，例如，赋值运算符。因为，它假如被重载为友元函数，将会出现与赋值语义不一致的地方。 其他运算符的重载举例 
　　
　　1).下标运算符重载 
　　
　　由于C语言的数组中并没有保存其大小，因此，不能对数组元素进行存取范围的检查，无法保证给数组动态赋值不会越界。利用C++的类可以定义一种更安全、功能强的数组类型。为此，为该类定义重载运算符[]。 
　　
　　下面先看看一个例子： 
　　
　　 #include ＜iostream.h＞ 
　　
　　class CharArray
　　{
　　public:
　　CharArray(int l)
　　{
　　Length = l;
　　Buff = new char[Length];
　　}
　　~CharArray() { delete Buff; }
　　int GetLength() { return Length; }
　　char & operator [](int i);
　　private:
　　int Length;
　　char * Buff;
　　}; 
　　
　　char & CharArray::operator [](int i)
　　{
　　static char ch = 0;
　　if(i＜Length&&i＞=0)
　　return Buff[i];
　　else
　　{
　　cout＜＜" Index out of range.";
　　return ch;
　　}
　　} 
　　
　　void main()
　　{
　　int cnt;
　　CharArray string1(6);
　　char * string2 = "string";
　　for(cnt=0; cnt＜8; cnt++)
　　string1[cnt] = string2[cnt];
　　cout＜＜" ";
　　for(cnt=0; cnt＜8; cnt++)
　　cout＜＜string1[cnt];
　　cout＜＜" ";
　　cout＜＜string1.GetLength()＜＜endl;
　　} 
　　该数组类的优点如下： 
　　
　　(1) 其大小不心是一个常量。
　　(2) 运行时动态指定大小可以不用运算符new和delete。
　　(3) 当使用该类数组作函数参数时，不心分别传递数组变量本身及其大小，因为该对象中已经保存大小。 
　　
　　在重载下标运算符函数时应该注重： 
　　
　　(1) 该函数只能带一个参数，不可带多个参数。
　　(2) 不得重载为友元函数，必须是非static类的成员函数。 2). 重载增1减1运算符 
　　
　　增1减1运算符是单目运算符。它们又有前缀和后缀运算两种。为了区分这两种运算，将后缀运算视为又目运算符。表达式 
　　
　　obj++或obj-- 
　　
　　被看作为： 
　　
　　obj++0或obj--0 
　　
　　下面举一例子说明重载增1减1运算符的应用。 
　　
　　 #include ＜iostream.h＞ 
　　
　　class counter
　　{
　　public:
　　counter() { v=0; }
　　counter operator ++();
　　counter operator ++(int );
　　void print() { cout＜＜v＜＜endl; }
　　private:
　　unsigned v;
　　}; 
　　
　　counter counter::operator ++()
　　{
　　v++;
　　return *this;
　　} 
　　
　　counter counter::operator ++(int)
　　{
　　counter t;
　　t.v = v++;
　　return t;
　　} 
　　
　　void main()
　　{
　　counter c;
　　for(int i=0; i＜8; i++)
　　c++;
　　c.print();
　　for(i=0; i＜8; i++)
　　++c;
　　c.print();
　　} 
　　3). 重载函数调用运算符 
　　
　　可以将函数调用运算符()看成是下标运算[]的扩展。函数调用运算符可以带0个至多个参数。下面通过一个实例来熟悉函数调用运算符的重载。 
　　
　　 #include ＜iostream.h＞ 
　　
　　class F
　　{
　　public:
　　double operator ()(double x, double y) const;
　　}; 
　　
　　double F::operator ()(double x, double y) const
　　{
　　return (x+5)*y;
　　} 
　　
　　void main()
　　{
　　F f;
　　cout＜＜f(1.5, 2.2)＜＜endl;
　　}
