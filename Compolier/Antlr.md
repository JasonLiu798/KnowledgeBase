


[antlr4权威参考 读书笔记](http://codemany.com/blog/reading-notes-the-definitive-antlr4-reference-part1/)







---
#自定义语法
[](http://blog.csdn.net/xiyue_ruoxi/article/details/38687213)
单词之间的顺序和依赖性约束是来自于自然语言的，基本上可以总结成四种抽象的计算机语言模式
l  序列：是由许多元素组成的一个序列，比如数组初始化句法中的数值。
l  选项：是指在多个可选的短语中的选择，比如编程语言中的不同语句。
l  单词约束：一个单词的出现需要对应另一个其它短语的出现，比如左括号和右括号。
l  嵌套短语：这是一种自相似的语言结构，例如编程语言中的嵌套算术表达式或嵌套语句块。


如果希望这个序列也可以是空的，也就是某个元素可以出现零次或多次，我们可以使用```"*"```操作符：INT*
下面是我们将上一节中描述的CSV伪代码用ANTLR语法编写的代码：
```
file : (row '\n')* ;       // sequence with a '\n' terminator
row : field (',' field)*; // sequence with a ',' separator
field: INT ;             // assume fields are just integers
```

"?"，这种模式通常用来表示可选项结构。例如，在Java的语法中，我们可以发现可以使用('extends' identifier)? 这样的序列来识别可选的父类继承说明

模式：选项（替换项）
field : INT | STRING ;

模式：符号约束
expr: expr '(' exprList?')'  // func call like f(), f(x), f(1,2)
   | expr '[' expr ']'      // array index like a[i], a[i][j]
   ...
   ;


模式：嵌套短语


语法 | 描述
------|--------
x		| 匹配一个符号，规则或子规则x
x y … z | 匹配一个规则序列
(…|…|…) | 带有多个选项的子规则
x? 		| 匹配零次或一次x
x* 		| 匹配零次或多次x
x+ 		| 匹配一次或多次x
r:…; 	| 定义规则r
r:…|…|…;| 定义一个带有多个选项的规则r



模式名称 | 描述
##序列
这是由符号和子短语组成的任意长的有限的序列，例如变量声明语法（类型后	面加上标识符）以及整数列表等。下面是一些实现这种模式的例子： 
```
x y ... z       // x followed by y, ..., z      
'[' INT+ ']'   // Matlab vector of integers
```

##带终结符的序列
这是由符号和子短语组成的任意长的，可能是空的序列，以一个符号结束，通常情况系这个符号是分号或换行符，例如C风格的编程语言中的语句以及以换行符终结的数据行。下面是一些实现这种模式的例子：
```
(statement ';')*   // Java statement list
(row '\n')*        // Lines of data
```

##带分隔符的序列
这是由符号的子短语组成的任意长的非空的序列，用一个特定的符号分隔开，通常这个符号是逗号，分号或句号。例如函数参数列表，函数调用列表，或者是分开却不终止的程序语句。下面是一些实现这种模式的例子：
```
expr (',' expr)*      // function call arguments
( expr (',' expr)* )?
// optional function call arguments
'/'? name ('/'name)*  // simplified directory name
stat ('.' stat)*      // SmallTalk statement list
```

##选项
这是由一系列可选择的短语组成的，例如类型说明，语句，表达式或者XML的标签。下面是一些实现这种模式的例子：
```
type : 'int' | 'float';
stat : ifstat | whilestat | 'return'expr ';' ;
expr : '(' expr ')'| INT | ID ;
tag : '<' Name attribute* '>'| '<' '/' Name '>';
```

##符号约束
一个符号的出现需要另一个或多个子序列符号的出现来对应，例如小括号，中括号，大括号，尖括号的匹配等。下面是一些实现这种模式的例子：
```
'(' expr ')'         // nested expression
ID '[' expr ']'         // array index
'{' stat* '}'  // statements grouped in curlies
'<' ID (','ID)* '>' // generic type specifier
```

##递归短语
这是一种自相似的语言结构，例如表达式结构，Java类嵌套，代码块嵌套以及Python中的函数嵌套定义等。下面是一些实现这种模式的例子：
```
expr : '(' expr ')'| ID ;
classDef : 'class' ID '{'(classDef|method|field) '}' ;
```


#左递归
```
expr : expr '*' expr // match subexpressions joined with '*' operator
    | expr '+' expr  // match subexpressions joined with '+' operator
    | INT             // matches simple integer atom
    ;
```
1+2*3
=>(1+2)*3
=>1+(2*3)
左递归产生歧义

ANTLR通过这些算符规则定义的顺序来解决这种歧义


assoc选项来手动来指定运算符的结合方向
```
expr : expr '^'<assoc=right>expr// ^ operator is right associative
   | INT
   ;
```

目前还不能处理间接左递归。这意味着如果我们想讲expr因子化为一些等价的规则会出问题。
```
expr : expo // indirectlyinvokes expr left recursively via expo
   | ...
   ;
expo : expr '^'<assoc=right>expr ;
```


---
#识别通用词法结构
语法分析器和词法分析器的唯一差别在于，语法分析器是从符号流中识别语法结构的，而词法分析器是从字符流中识别语法结构的
第一个字符是大写字母的是词法过则，第一个字符是小写的是语法规则。

ID : ('a'..'z'|'A'..'Z')+ ; // match 1-or-more upper or lowercaseletters


##正则导致的歧义
```
grammar KeywordTest;

enumDef : 'enum' '{' ... '}' ;
...

FOR : 'for' ;
...

ID : [a-zA-Z]+ ; // does NOT match 'enum' or 'for'
```
ANTLR的词法分析器是通过词法规则出现的顺序来解决这种歧义的。
ANTLR会将所有的词汇引用隐含地生成词法规则并将这些规则放在明确定义的词法规则之前，所以直接词汇引用一般都有较高的优先级。

由于ANTLR自动将所有词法规则都放在语法规则后面，像下面的例子这样重新调整顺序依然能够获得同样的解析结果：
```
grammar KeywordTestReordered;
FOR : 'for' ;
ID : [a-zA-Z]+ ; // does NOT match 'enum' or 'for'
...
enumDef : 'enum' '{' ... '}' ;
...
```
到目前为止，我们的标识符的定义中还不允许出现数字，你可以在6.3节和6.5节看到完整的关于ID的定义。

##匹配数字
要描述像10这样的整数是一件非常容易的事情，因为它仅仅是数码的序列。
```
INT : '0'..'9'+ ; // match 1 or more digits
//或
INT : [0-9]+ ; // match 1 or more digits
```
浮点数的表达方式就显得非常复杂了。但是，我们可以通过忽略指数形式来简化浮点数的表示。（在6.5节中可以看到完整的浮点数表示，甚至还能看到像3.2i这样的复数的表示。）浮点数就是一个数码的序列，后面跟上一个小数点，然后跟上一个可选择的小数部分，或者是由小数点开始，后面跟上一连串的数码序列。只有一个小数点这样的表示方法是非法的。所以，我们使用选择模式和序列模式来表示浮点数规则。
```
FLOAT: DIGIT+ '.' DIGIT*    // match 1. 39. 3.14159 etc...
   | '.' DIGIT+          // match .1 .14159
   ;
fragment
DIGIT : [0-9] ;             // match single digit
```
协助规则DIGIT，这样我们只需要写一遍[0-9] 就可以了。使用fragment前缀来定义，ANTLR就会知道这条规则仅仅用来组成其它词法规则，而不会单独使用。DIGIT本身并不是我们需要的符号，也就是说，我们在语法分析器中是看不到DIGIT这个符号的。

##匹配字符串
计算机语言中最经常出现的下一个通用结构就是字符串，比如”Hello”。大多数情况下都是使用双引号，但是也有些语言会使用单引号，甚至像Python这样的语言两种符号都使用。不管使用什么符号来分割字符串，我们使用同样的规则来表示字符串内部。在伪代码中，字符串就是在双引号之间由任意字符组成的序列。
```
STRING : '"' .*? '"' ; // match anything in "..."
```
通配符“.”匹配任意一个字符。所以，
```.*
```
就能匹配任意长的可以为空的字符串。当然，这种匹配也可以直接匹配到文件末尾，但是这么做往往是没有意义的。
非贪婪子规则
所以，ANTLR使用标准正则表达式符号（后缀：?）来表示采用非贪婪子规则的策略。非贪婪的意思是“不断匹配字符，直到匹配上词法规则中子规则的后面跟着的元素”。更精确地说，非贪婪子规则值匹配尽可能少的字符，尽管这条规则有可能匹配更多的字符。更多细节查看第15.6节
贪婪子规则
```
.*
```
就被认为是贪婪子规则，因为它会匹配掉所有循环内部的字符（这种情况下，作为通配符使用）。如果你现在对“.*?”不太理解，也没有关系，现在你只需要知道这种写法是用来表示值匹配双引号引起来的内部所有字符就可以了。我们会在后面讨论注释的时候再次讨论非贪婪循环的。

要让双引号引起来的字符串中也出现双引号，我们使用"\""。我们需要如下定义来支持转义字符：
STRING: '"' (ESC|.)*?'"' ;
fragment
ESC : '\\"' | '\\\\' ; // 2-char sequences \" and \\

##匹配注释和空白字符

当词法分析器匹配了我们定义的符号之后，就会通过符号流将识别到的符号提交给语法分析器。然后，语法分析器就会根据语法结构来检查这个符号流。但是，当词法分析器遇到注释和空白字符时，我们希望词法分析器直接忽略它们，这样的话，语法分析器就不用考虑怎么处理这些到处都可能会出现的注释和空白字符了。例如，WS代表是一个词法规则中的空白字符，像下面这么定义语法规则的话是一件非常可怕的事情：

assign : ID (WS|COMMENT)? '=' (WS|COMMENT)? expr (WS|COMMENT)? ;

定义这些需要丢弃的符号和定义非丢弃的符号是一样的，我们只需要简单地使用skip命令来指明词法分析器需要将这些符号忽略就行了。例如，下面是匹配类C语言中单行注释和多行注释的规则：

LINE_COMMENT  : '//' .*? '\r'? '\n' -> skip ; // Match"//" stuff '\n'

COMMENT       : '/*' .*? '*/' ->skip ;       // Match "/*" stuff "*/"

在LINE_COMMENT规则中，“.*?”匹配“//”后面直到第一个出现的换行符（回车符前面的那个换行符是为了匹配Windows下的换行符）之前的所有字符。在COMMENT规则中，“.*?”匹配了“/*”和“*/”之间的所有字符。

词法分析器通过“->”操作符来接收命令，skip只是诸多命令中的一种。例如，我们还可以通过channel命令将这些符号传递给语法分析器的“隐藏通道”。关于符号通道请查阅第12.1节。

下面来看看怎样处理我们这一解中的最后一个通用符号，空白字符。一些编程语言把空白字符作为符号的分隔符，而其他语言则是直接忽略空白字符。（Python是一个例外，因为Python将空白字符作为语法结构的一部分了：换行符作为命令的结束符，缩进（Tab或者空格）作为指定嵌套结构的符号。）下面是让ANTLR忽略空白字符的例子：

WS : (''|'\t'|'\r'|'\n')+ -> skip ; // match 1-or-more whitespace but discard

或者

WS : [\t\r\n]+ -> skip ; // match 1-or-more whitespace but discard

当换行符既是需要忽略的空白字符又是作为命令的结束符时，我们就会遇到一个问题。换行符是上下文相关的。在一个语法结构中，我们需要忽略换行符，但是再另外一个语法结构中，我们又需要将换行符传递给语法分析器，这样语法分析器才能知道一条命令是否结束。例如，在Python中，f()后面跟一个换行符意味着我们需要执行指令，调用f()。但是我们又可以在圆括号中插入一个额外的换行符。Python会等到遇到“)”后面的换行符才会执行函数调用。






