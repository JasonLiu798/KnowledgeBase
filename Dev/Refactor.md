#Refactor
---
#C2重构的原则
##定义
名词版定义：对软件内部结构的一种调整，目的是在不改变软件可观察行为的前提下，提高可理解性，降低其修改成本
动词版定义：使用一系列重构手法，在不改变可观察行为的前提下，调整其结构

两顶帽子：添加新功能，重构

三次法则，三则重构

程序两面价值：
今天可以为你做什么，明天可以为你做什么

中间层的价值：
允许逻辑共享
分开解释意图和实现
隔离变化，如增加子类，而不必修改其他出现的这个对象的地方
封装条件逻辑


#2.5 重构的难题 
##数据库
对象模型
分割层
数据库模型

##修改接口
如何面对已发布得接口：让旧接口调用新接口，旧的标记为deprecated
不要过早发布接口，请修改你的代码所有权政策，使重构更顺畅
###Java的异常类
增加后，会导致用户代码要做修改
解决办法：将新增受控异常会变成非受控异常，但会市区校验能力
将整个包定义一个异常基类，throws子句声明此异常，异常子类可随便定义，不影响调用方

##重构不能做到的设计改动
既有代码太混乱
现有代码不能正常工作
项目时间、成本

分解成小块重构

#2.6 重构与设计
预先设计
思考可以很快，但充满了小漏洞
重构可以在设计时不必一下找到 正确/最优 的解决方案，随着对问题理解加深，不断重构

#2.7 重构与性能
编写快速软件的方法
时间预算法：高度追求性能
持续关注法：
提升90%的统计数据：发现热点，去除热点

#2.8 重构起源何处
极限编程

---
#C3 代码得坏味道
#3.1重复代码
extract method
pull up method 
from template method
#3.2过长函数
extract method
replace temp with query
introduce parameter object
Preserve whole object
replace method with method object
寻找注释，即提醒你可将这段代码替换为函数
#3.3 large class
extract class
extract subclass
先确定客户端如何调用他们，运用extract interface为每种使用方式提炼接口
#3.4 long parameter list
#3.5 divergent change 发散式变化
一处受多处变化影响
#3.6 shotgun surgery 散弹式修改 
一种变化引发多处修改
move method
move field 
inline class
#3.7 feature envy 依恋情结
将总是一起变化的东西放一块
#3.8 data clumps 数据泥团
#3.9 primitive obsession 基本类型偏执
#3.10 switch statements 
多态
replace type code with state/strategy
replace type code with subclass
replace conditional with polymorphism
replace parameter with explicit methods 
#3.11 parallel inheritance hierachies
为一个类添加子类，必须为另一个同时添加
#3.12 lazy class
#3.13 speculative generality 
#3.14 temporary field 暂时字段
#3.15 message chains 过度耦合得消息链
hide delegate
#3.16 middle man 中间人
减少不必要得委托
inline method
replace delegation with inheritance
#3.17 inappropriate intimacy 
move method
move field
change bidirectional association to unidirectional
extract class
hide delegate 
replace inheritance with delegation
#3.18 alternative classes with different interfaces 异曲同工的类
#3.19 incomplete library class
introduce foreigh method
introduce local extension
#3.20 data class 纯粹的数据类
#3.21 refused bequest 被拒绝的遗赠
#3.22 comments 过多得注释

----
#C4 构筑测试体系
#4.1 自测试代码的价值
尽快发现问题
#4.2 junit
#4.3 添加更多测试
风险驱动
测试最担心出错的部分
考虑可能出错边界条件，把测试火力集中在那
---
#C5 重构列表
#5.1 重构的记录格式
name
summary
motivation
mechanics
examples
#5.2 寻找引用点
ide无法做到的：
继承体系；速度如果过慢；反射机制得到得引用点
#5.3 这些重构手法有多成熟

----
#C6 重新组织函数
#6.1 extract method 提炼函数
关键在于函数名称与本体之间的语义距离

命名：做什么，而不是怎样做
检查局部变量
检查移动过去代码变量作用域
多个返回值：挑选另一块代码来提炼；replace method with method object

#6.2 inline method 内联函数
如果函数本体与名称一样清楚易懂则插入函数本体，删除定义

#6.3 inline temp 内联临时变量
动机：一个临时变量，只被一个简单表达式赋值一次，妨碍了其他重构手法(如extract method)
做法：将引用替换为表达式自身

#6.4 replace temp with query 以查询取代临时变量
用临时变量保存某一表达式的运算结果
做法：找出只被赋值一次的临时变量；将该变量声明为final；编译；将对该变量赋值的语句右侧部分提炼到一个独立函数；编译；实施inline temp。
将表达式提炼到一个独立函数，将临时变量引用点替换为函数调用，此新函数可被复用

#6.5 introduce explaining variable 引入解释性变量
将复杂表达式结果或一部分 放进一个临时变量，以此变量来解释表达式用途
适合extract method难以使用时，因为变量作用范围有限，方法在整个生命周期都可用
做法：声明一个final临时变量，将待分解复杂表达式一部分的运算结果赋值给他；将运算结果替换为临时变量；编译；

#6.6 split temporary variable 分解临时变量
针对每次赋值，创造一个独立、对应的临时变量
动机：不同的赋值说明承担不同的责任，会令代码阅读者糊涂
做法：第一次赋值处修改名称；新的临时变量声明为final；修改之前的引用

#6.7 remove assignments to parameters 移除对参数的赋值
以一个临时变量取代该参数的位置
动机：降低了代码清晰度；区分按引用按值传递；
tips:较长函数，参数增加final可检查参数是否修改

#6.8 replace method withe method object 以函数对象取代函数
将函数放进单独对象中，局部变量变成了对象内的字段，可以在同一个对象中将大型函数分解为多个小函数
做法：
建立新类；建立final字段，保存原先大型函数所在对象，源对象；
针对原函数的每个临时变量和每个参数，在新类中建立一个对应的字段保存之；
新类中建立构造函数，接收源对象及原函数的所有参数作为参数；
新类中建立一个compute函数；
原函数代码复制到compute中，如需要调用源对象任何函数，通过源对象字段调用；
编译；
旧函数本体增加注释。

可以轻松对compute采取extract method 不必担心参数传递问题

#6.9 subsititute algorithm 替换算法
将函数本体替换为另一个算法
动机：用清晰的算法取代复杂算法

----
#C7 在对象之间搬移特性
#7.1 move method 搬移函数
在该函数最常引用的类中建立一个有着类似行为新函数，将旧函数变味单纯的委托函数，或将旧函数完全移除
做法：
检查源类中被源函数使用的一切特性，考虑是否应该搬移；
检查源类的子类和超类，是否有此函数的声明；
目标类声明此函数，拷贝代码；
编译；
决定如何从源函数引用目标对象；
修改源函数，使其成为一个纯委托函数；

#7.2 move field 搬移字段
在目标类新建一个字段，修改源字段的所有用户，令他们改用新字段

#7.3 extract class 提炼类
建立一个新类，将相关字段和函数从旧类移动到新类
动机：
单一职责原则

#7.4 inline class 将类内联化
某个类没有做太多事
将这个类所有特性搬移到另一个类中，移除原类
动机：
如重构移走了这个类的职责

#7.5 hide delegate 隐藏委托关系
在服务类上建立客户所需的所有函数，用以隐藏委托关系
动机：封装；减少依赖，减少对客户端影响

#7.6 remove middle man 移除中间人
某个类做了过多的简单委托动作，
让客户直接调用受托类
动机：中间层的代价，当客户端要新特性，中间层就得增加简单委托函数
只要把出问题的地方修补好

#7.7 introduce foreign method 引入外加函数
你需要为提供服务的类增加一个函数，但你无法修改这个类
在客户类中建立一个函数，并以第一参数形式传入服务类实例
动机：这个函数原本应该在提供服务的类中实现，如果有大量外加函数可以用introduce local extension，当然最好做法是将函数放到服务类中

#7.8 introduce local extension 引入本地扩展
建立一个新类，使他包含这些额外函数，让这个扩展品成为源类的子类或包装类

----
#C8 重新组织数据
#8.1 self encapsulate field 自封装字段
直接访问一个字段，但与字段之间耦合关系逐渐变得笨拙
为这个字段建立取值/设值函数，并且只以这些函数来访问字段，增加逻辑
动机：间接访问，支持灵活的数据管理方式，如延迟加载
直接访问，代码容易读

#8.2 replace data value with object 以对象取代数据值
你有一个数据项，需要与其他数据和行为一起使用才有意义
将数据项变为对象
动机：数据逐渐变得复杂，需要拆分

#8.3 change value to reference 将值对象改为引用对象


#8.4 change reference to value 将引用对象改为值对象
动机：引用对象-同步问题；关联复杂
值对象-不可变，如果可变则修改会自动更新其他“代表相同事物”的对象

#8.5 replace array with object 以对象取代数组
以对象取代数组，对于数组中每个元素，以一个字段来表示

#8.6 duplicate observed data 复制 被监视数据
将数据复制到一个领域对象中。简历一个observer模式，以同步领域对象和GUI对象内的重复数据
动机：隔离GUI；分离职责

#8.7 change unidirectional association to bidirectional 将单向关联改为双向关联
添加一个反向指针，并使修改函数能够同时更新两条连接
动机：方便获取被引用类
需要测试
做法：先让对方删除指向你的指针，再降你的指针指向一个新对象，最好让那个新对象把他的指针指向你

#8.8 change bidirectional association to unidirectional 将双向关联改为单向关联
动机：维护关联复杂度高；僵尸对象；紧耦合

#8.9 replace magic number with symbolic constant 以字面常量取代魔法数

#8.10 encapsulate field 封装字段
将他声明为private，并提供相应的访问函数

#8.11 encapsulate collection 封装集合
让这个函数返回该集合的一个只读副本，并在这个类中提供添加/移除集合元素的函数
动机：降低耦合度，保护集合对象；统一访问接口；


#8.12 replace record with data class 以数据类取代记录
为该记录创建一个哑数据对象

#8.13 replace type code with class 以类取代类型码
以一个新的类替换该数值类型码
动机：获得运行期检验能力

#8.14 replace type code with subclasses 以子类取代类型码


#8.15 replace type code with state/strategy 

#8.16 replace subclass with fields 以字段取代子类
动机：常量函数，减少继承带来的额外复杂性

----
#C9 简化条件表达式
#9.1 decompose conditional 分解条件表达式
从if、then、else三个段落中分别提炼出独立函数
动机：简化复杂度；增加可读性；

#9.2 consolidate conditional expression 合并条件表达式
将这些测试合并为一个条件表达式，并将这个条件表达式提炼成为一个独立函数
动机：检查条件不同，但最终行为一致


#9.3 consolidate duplicate conditional fragments 合并重复条件片段
动机：减少重复代码

#9.4 remove control flag 移除控制标记
以break语句或return语句取代控制标记
动机：

#9.5 replace nested conditional with guard clauses 以卫语句取代嵌套条件表达式
使用卫语句表现所有特殊情况
动机：如果单一出口能使这个函数更清楚易读，那就单一出口，否则不比这么做；减少没必要的else

#9.6 replace conditional with polymorphism 以多态取代条件表达式
将这个条件表达式的每个分支放进一个子类内的复写函数中，然后将原始函数声明为抽象函数
动机：降低系统依赖

#9.7 introduce null object 引入null对象
将null值替换为null对象，null对象继承自不为null的对象
动机：只有大多数客户端代码要求空对象做出相同的响应时，才有意义
做法：
为源类建立子类，使其行为像是源类的null版本
在源类和null子类加上isNull()函数，或者增加nullable接口，isNull为接口方法
返回null的地方，改为返回空对象；
==null改为isNull()判断

#9.8 introduce assertion 引入断言
以断言明确表达这种假设
动机：使用断言明确表达这种假设；导致非受控异常；方便排查bug；帮助程序员理解代码正确运行的必要条件
做法：只使用来检查"一定必须为真"的条件，滥用会导致难以维护的重复逻辑

---
#C10 简化函数调用
#10.1 rename method 函数改名

#10.2 add parameter 添加参数
不使用此重构的时机
能从参数获取所需信息吗？
有可能通过某个函数获取所需信息吗？
信息用于何处？
这个函数是否属于拥有该信息的那个对象所有？

#10.3 remove parameter 移除参数

#10.4 separate query from modifier 将查询函数和修改函数分离
建立两个不同函数，一个负责查询，一个负责修改
任何有返回值的函数，都不应该有看得到的副作用

#10.5 parameterize method 令函数携带参数
建立单一函数，以参数表达那些不同的值
动机：合并相似函数，减少相似代码

#10.6 replace parameter with explicit methods 以明确函数取代参数
针对该参数的每一个可能值，建立一个独立函数
动机：本身缺少相似代码，不同的值执行不同逻辑，避免出现条件表达式，编译期检查，需要判断参数合法，接口变清晰

#10.7 preserve whole object 保持对象完整
改为传递整个对象
动机：减少参数列表长度，但会增加依赖

#10.8 replace parameter with methods 以函数取代参数
让参数接受者去除该项参数，并直接调用前一个函数
动机：如果函数能通过其他途径获取参数值，那就不应该通过参数取得

#10.9 introduce parameter object 引入参数对象
以一个对象取代这些参数
动机：特定的一组参数总是一起被传递

#10.10 remove setting method 移除设置函数
类中某个字段在对象创建时被设值，然后不再改变
去掉该字段的设置函数

#10.10 hide method 隐藏函数
将没有被其他类用到的函数改为private 

#10.12 replace constructor with factory method 以工厂函数取代构造函数
构造函数只能返回单一类型

#10.13 encapsulate downcast 封装向下转型
动机：没有模板机制，1.5后少用

#10.14 replace error code with exception 以异常取代错误码

#10.15 replace exception with test 以测试取代异常
修改调用者，使他在调用函数前先做检查
动机：异常只应该用于异常的、罕见的行为


----
#C11 处理概括关系（继承关系）
#11.1 pull up field 字段上移
两个子类拥有相同字段，将该字段移至类
动机：减少重复

#11.2 pull up method 函数上移
动机：避免行为重复

#11.3 pull up constructor body 构造函数本体上移


#11.4 push down method 函数下移
超类中某个函数只与部分子类有关

#11.5 push down field 字段下移

#11.6 extract subclass 提炼子类
类中某些特性只被某些实例用到
新建一个子类，将上面所说的那一部分特性移到子类中

#11.7 extract superclass 提炼超类
两个类有相似特性
为这两个类建立一个超类，将相同特性移至超类

#11.8 extract interface 提炼接口
将相同子集提炼到一个独立接口

#11.9 collapse hierachy 折叠继承体系
动机：子类未带来价值

#11.10 form template method 塑造模板函数
有一些子类，其中响应的某些函数以相同顺序执行类似操作，但各个操作细节上有所不同
将这些操作分别放进独立函数中，并保持他们都有相同的签名，于是原函数也变得相同，然后将原函数上移至超类。
动机：子类中操作并不完全相同，无法提炼到超类

#11.11 replace inheritance with delegation 以委托取代继承
某个子类只使用超类接口中的一部分，或是根本不需要继承而来的数据
在子类中新建一个字段用以保存超类；调整子类函数，令他改而委托超类，然后去掉两者之间的继承关系。
动机：减少出错

#11.12 replace delegation with inheritance 以继承取代委托
你在两个类之间使用委托关系，并经常为整个接口编写许多极简单的委托函数
让委托类继承受托类

---
#C12 大型重构
#12.1 tease apart inheritance 梳理并分解继承体系
某个继承体系同时承担两个责任
建立两个继承体系，并通过委托关系让其中一个可以调用另一个 
做法：借助表格明确主要责任

#12.2 convert procedural design to objects 将过程化设计转化为对象设计
将数据记录变为对象，将大块行为分为小块，并将行为移入相关对象之中

#12.3 separate domain from presentation 将领域和表述/显示分离
将领域逻辑分离出来，为他们建立独立的领域类

#12.4 extract hierarchy 提炼继承体系
建立继承体系，以一个子类表示一种特殊情况

---
#C13 重构，复用与现实
---
#C14 重构工具


































































































































































