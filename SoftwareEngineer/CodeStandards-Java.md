#编码规范 Code Standards
---
#描述 
永远遵循同一套编码规范 -- 可以是这里列出的，也可以是你自己总结的。如果你发现本规范中有任何错误，敬请指正。
不管有多少人共同参与同一项目，一定要确保每一行代码都像是同一个人编写的。
代码正确性、稳定性、可读性！

#Java编码规范 
##2.1	格式与命名规范
* 换行
参考值：普通屏，每行80字符；宽屏，每行120字符
实际测量：根据显示器分辨率，以一屏内显示一行所有内容为准，或使用IDE的软换行

* 括号
if,for,while等语句块全部使用括号包围

2.1.4  命名规则
不允许使用汉语拼音命名
避免使用下划线(静态变量除外)
接口尽量采用"able", "ible", or "er"，如Runnable命名，尽量不采用首字母为I或加上IF后缀的命名方式，如IBookDao,BookDaoIF。

2.2	注释规范(Document Convertions)
2.2.1	注释类型
Java doc注释:/*** .... **/
失效代码注释:由/**... **/界定，标准的C-Style的注释。专用于注释已失效的代码
代码细节注释：由//界定，专用于注释代码细节。注意：即使有多行注释也仍然使用//，以便与用/**/注释的失效代码分开。
2.2.2	注释的内容
可精简的注释内容：
注释中的每一个单词都要有其不可缺少的意义，注释里不写"@param name -名字"这样的废话。如果该注释是废话，连同标签删掉它，而不是自动生成一堆空的标签，如空的@param name，空的@return
推荐的注释内容：
对于调用复杂的API尽量提供代码示例。(II)对于已知的Bug需要声明，//TODO 或 //FIXME 声明:未做/有Bug的代码。(II)Null规约:  如果方法允许Null作为参数，或者允许返回值为Null，必须在JavaDoc中说明。否则方法的调用者不允许使用Null作为参数，并认为返回值是Null Safe(不会返回NULL)。
2.3	编程规范
2.3.1	基本规范 
1、	当API会面对不可知的调用者时，方法需要对输入参数进行校验，如不符合则抛出IllegalArgumentException，建议使用Spring的Assert系列函数。
2、	因为System.out.println()，e.printStackTrace()仅把信息显示在控制台，因此不允许使用，必须使用logger打印并记录信息。
3、	在数组中的元素(如String [1])，如果不再使用需要设为NULL，否则会内存泄漏。因此直接用Collections类而不要使用数组。
4、	在不需要封闭修改的时候，尽量使用protected 而不是 private，方便子类重载。
5、	变量，参数和返回值定义尽量基于接口而不是具体实现类，如Map map = new HashMap();
6、	用double 而不是Float，因为float会容易出现小数点后N位的误差

2.3.2	异常处理 

1、	重新抛出的异常必须保留原来的异常，即throw new NewException("message", e); 而不能写成throw new NewException("message")。
2、	在所有异常被捕获且没有重新抛出的地方必须写日志。
3、	如果属于正常异常的空异常处理块必须注释说明原因，否则不允许空的catch块。

2.3.3	JDK5.0规范
1、	重载方法必须使用@Override，可避免父类方法改变时导致重载函数失效。
2、	不需要关心的warning信息用@SuppressWarnings("unused"), @SuppressWarnings("unchecked"), @SuppressWarnings("serial") 注释。

 
3.	Myeclipse代码格式与规范
总述：
导入cleanup-profile.xml 和formatter.xml 到eclipse中；
习惯经常性的执行cleaup命令进行清理(对源码目录右键->source->cleanup)、有点耗时间，视情况而定；手工进行warnning规则的设置。
3.1	基本设置

1.	导入formatter模板(见formatter-profile.xml)：
	对默认Formatter修改如下。
	  .每行增至120字符 (Line wrapping)
	  .取消三个 Comment Format (Comments) --因为Eclipse的Formatter不能自由换行，老把		  注释搞成一行的缘故
2.	导入Cleanup规则模板(见cleanup-profile.xml):
	默认的规则
   	Change non static accesses to static members using declaring type
 	Change indirect accesses to static members to direct accesses (accesses through 	subtypes)
 	Remove unused imports
   	Add missing '@Override' annotations
    	Add missing '@Deprecated' annotations
    	Remove unnecessary casts
    	Remove unnecessary '$NON-NLS$' tags
 	增加的规则
    	Convert control statement bodies to block(Code Style)
    	Convert for loops to enhanced for loops (Code Style)
    	Organize imports (Code Organizing)
    	Format source code (Code Organizing)
    	Remove trailing whitespaces on non empty lines(Code Organizing)
3.	手工修改warning设置： 
	Code Style:
	增加全部，除Unqualified access to instance field , Undocumented empty block 和 Non-	externalized strings
	Potential programming problem
	增加全部，除Boxing and UnBoxing
	Name shadowing and confict
	增加全部
	Unecessary Code
	增加全部, 除Unnecessary 'else' statement
	Annoatation
	增加全部
4.	取消XML缺少DTD的warning 并设置XML每行长度为120字符, (Preference->XML->XML Files下的Editor和Validation)


 
4.	CheckStyle插件的安装
4.1	下载插件
插件下载地址：http://eclipse-cs.sourceforge.net/

4.2	Checkstyle插件的安装
略
4.3	Checkstyle的配置
4.3.1	配置的方法：
  在Eclipse->Windows->Preference->checkstyle中，将sferp_checks.xml 以External Configure File的形式导入，并设为Default。
    该配置文件参考SpringSide的配置文件，取消太过严格或与Eclipse严重重复的检测。
    注意对测试代码不需要进行检查
4.3.2	配置说明
 
 代码格式

    Size Volations：取消line width.
    White Space：取消所有检测.
    Blocks：取消Need Braces,Left/Right Curly Brace Placement
               取消empty block(由pmd检测)
    Import：取消Avoid Star imports ,unused import

代码注释

    JavaDoc：
    取消Method Javadoc、Variable Javadoc 、Package javadoc

编码设计

    Coding Problems：
    取消Avoid InlineConditionals，
    取消Simplify Boolean Return
    取消Magic Number

      修改Hidden Fileld 增加ignore setter 和contructor
      修改Redundant  Throws 增加Allow Unchecked

      增加Declaration Order Check
      增加Equals avoid NULL(5.0)，
      增加Modify Control Variable，
      增加Multiple Variable Declarartion，
      增加Nested If(max=3 info级别),
      增加String Literal Equality，
      增加Return Count(限制为3)，

    Class Design:
    取消Design For Extension,
    取消Final Class,
    取消Hide Utility Class Constroctor,
    取消Interface is Type
    修改Visibility Modifer 增加packageAllowed,proectedAllowed
    Misc：取消Final Parameter.
    Modifier: 取消Redundant Modifer

代码度量

    Size Violations：
    增加Executable Statement和匿名内部类（30），
    增加Outer Type Number(5.0)
    修改Method Length为50
    取消Executable Statement Count，OuterType number
    Metrics
    取消Cyclomatic Complexity

3.SpringSide的最终规则
Blocks

    Avoid Nested Blocks
    EmptyBlock(text)

Coding Problem

    Declaration Order
    Double Checked Locking
    Empty Statement
    Equals avoid Null
    Equals Hash Code
    Hidden Field(ignore setter 和contructor)
    Illegal Instantiation
    Inner Assignmen
    Modified Control Variable
    Multiple Variable Declarations
    Nested If Depth（3）
    Return Count(3)
    Simplify Boolean Expression
    String Literal Equality

Class Design

    Visibility Modifier 

Imports

    Redundant import 

JavaDoc Comments

    Type JavaDoc
    Style JavaDoc

Metrics

    Boolean Expression Complexity

Miscllenous

    Array Type Style 
    Upper Ell

Modifiers

    Modifiers Order

Name Convention

    Constant Name
    Local Final Variable Name
    Local Variable Name
    Member Name
    Method Name
    Package Name
    Parameter Name
    Static Variable Name
    Type Name

Size Violations

    Method Length(50)
    Parameter Number(7)
    Anon Inner Class Length(30)
    File Length（2000）

