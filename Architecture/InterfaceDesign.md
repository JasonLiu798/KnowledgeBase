#接口设计
[API设计原则](https://coolshell.cn/articles/18024.html)

#好API的6个特质
API之于程序员就如同图形界面之于普通用户（end-user）。API中的『P』实际上指的是『程序员』（Programmer），而不是『程序』（Program），强调的是API是给程序员使用的这一事实。

在第13期Qt季刊，Matthias 的关于API设计的文章中提出了观点：API应该极简（minimal）且完备（complete）、语义清晰简单（have clear and simple semantics）、符合直觉（be intuitive）、易于记忆（be easy to memorize）和引导API使用者写出可读代码（lead to readable code）。

##1.1 极简
极简的API是指每个class的public成员尽可能少，public的class也尽可能少。这样的API更易理解、记忆、调试和变更。

##1.2 完备
完备的API是指期望有的功能都包含了。这点会和保持API极简有些冲突。如果一个成员函数放在错误的类中，那么这个函数的潜在用户就会找不到，这也是违反完备性的。

##1.3 语义清晰简单
就像其他的设计一样，我们应该遵守最少意外原则（the principle of least surprise）。好的API应该可以让常见的事完成的更简单，并有可以完成不常见的事的可能性，但是却不会关注于那些不常见的事。解决的是具体问题；当没有需求时不要过度通用化解决方案。（举个例子，在Qt 3中，QMimeSourceFactory不应命名成QImageLoader并有不一样的API。）

##1.4 符合直觉
就像计算机里的其他事物一样，API应该符合直觉。对于什么是符合直觉的什么不符合，不同经验和背景的人会有不同的看法。API符合直觉的测试方法：经验不很丰富的用户不用阅读API文档就能搞懂API，而且程序员不用了解API就能看明白使用API的代码。

##1.5 易于记忆
为使API易于记忆，API的命名约定应该具有一致性和精确性。使用易于识别的模式和概念，并且避免用缩写。

##1.6 引导API使用者写出可读代码
代码只写一次，却要多次的阅读（还有调试和修改）。写出可读性好的代码有时候要花费更多的时间，但对于产品的整个生命周期来说是节省了时间的。



#静态多态

#基于属性的API
正交性

#传参
按常量引用传参 vs. 按值传参
这是传引用和传值的差别了，因为传值会有对像拷贝，传引用则不会。所以，如果对像的构造比较重的话（换句话说，就是对像里的成员变量需要的内存比较大），这就会影响很多性能。所以，为了提高性能，最好是传引用。但是如果传入引用的话，会导致这个对象可能会被改变。所以传入const reference。

#API的语义和文档
API需要的是质量保证。API第一个版本一定是不对的；必须对其进行测试。 以阅读使用API的代码的方式编写用例，且验证这样代码是可读的。

#命名的艺术
##通用的命名规则
有几个规则对于所有类型的命名都等同适用。
###第一个，之前已经提到过，不要使用缩写。
即使是明显的缩写，比如把previous缩写成prev，从长远来看是回报是负的，因为用户必须要记住缩写词的含义。

如果API本身没有一致性，之后事情自然就会越来越糟；
例如，Qt 3 中同时存在activatePreviousWindow()与fetchPrev()。恪守『不缩写』规则更容易地创建一致性的API。

###另一个重要但更微妙的准则是在设计类时应该保持子类名称空间的干净。
在Qt 3中，此项准则并没有一直遵循。以QToolButton为例对此进行说明。如果调用QToolButton的 name()、caption()、text()或者textLabel()，你觉得会返回什么？用Qt设计器在QToolButton上自己先试试吧：

name属性是继承自QObject，返回内部的对象名称，用于调试和测试。
caption属性继承自QWidget，返回窗口标题，对QToolButton来说毫无意义，因为它在创建的时候parent就存在了。
text函数继承自QButton，一般用于按钮。当useTextLabel不为true，才用这个属性。
textLabel属性在QToolButton内声明，当useTextLabel为true时显示在按钮上。
为了可读性，在Qt 4中QToolButton的name属性改成了objectName，caption改成了windowTitle，删除了textLabel属性因为和text属性相同。

当你找不到好的命名时，写文档也是个很好方法：要做的就是尝试为各个条目（item）（如类、方法、枚举值等等）写文档，并用写下的第一句话作为启发。如果找不到一个确切的命名，往往说明这个条目是不该有的。如果所有尝试都失败了，并且你坚信这个概念是合理的，那么就发明一个新名字。像widget、event、focus和buddy这些命名就是在这一步诞生的。

##类的命名
识别出类所在的分组，而不是为每个类都去找个完美的命名。例如，所有Qt 4的能感知模型（model-aware）的item view，类后缀都是View（QListView、QTableView、QTreeView），而相应的基于item（item-based）的类后缀是Widget（QListWidget、QTableWidget、QTreeWidget）。


##函数和参数的命名
函数命名的第一准则是可以从函数名看出来此函数是否有副作用。在Qt 3中，const函数QString::simplifyWhiteSpace()违反了此准则，因为它返回了一个QString而不是按名称暗示的那样，改变调用它的QString对象。在Qt 4中，此函数重命名为QString::simplified()。

虽然参数名不会出现在使用API的代码中，但是它们给程序员提供了重要信息。因为现代的IDE都会在写代码时显示参数名称，所以值得在头文件中给参数起一个恰当的名字并在文档中使用相同的名字。

##布尔类型的getter与setter方法的命名
为bool属性的getter和setter方法命名总是很痛苦。getter应该叫做checked()还是isChecked()？scrollBarsEnabled()还是areScrollBarEnabled()？

Qt 4中，我们套用以下准则为getter命名：

形容词以is为前缀，例子：
isChecked()
isDown()
isEmpty()
isMovingEnabled()
然而，修饰名词的形容词没有前缀：
scrollBarsEnabled()，而不是areScrollBarsEnabled()
动词没有前缀，也不使用第三人称(-s)：
acceptDrops()，而不是acceptsDrops()
allColumnsShowFocus()
名词一般没有前缀：
autoCompletion()，而不是isAutoCompletion()
boundaryChecking()
有的时候，没有前缀容易产生误导，这种情况下会加上is前缀：
isOpenGLAvailable()，而不是openGL()
isDialog()，而不是dialog()
（一个叫做dialog()的函数，一般会被认为是返回QDialog。）
setter的名字由getter衍生，去掉了前缀后在前面加上了set；例如，setDown()与setScrollBarsEnabled()。


#避免常见陷阱
##简化的陷阱
一个常见的误解是：实现需要写的代码越少，API就设计得越好。
应该记住：代码只会写上几次，却要被反复阅读并理解。

##布尔参数的陷阱
布尔类型的参数总是带来无法阅读的代码。给现有的函数增加一个bool型的参数几乎永远是一种错误的行为。

解决方案
* 拆分为两个接口
* bool类型改成枚举类型

















