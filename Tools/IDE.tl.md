#IDE
------
#idea
##配置
### keymap
http://www.juvenxu.com/2013/07/18/my-most-used-intellij-idea-shortcuts/
vim
http://linux.chinaunix.net/techdoc/desktop/2009/07/06/1122020.shtml
###乱码
File->setting->encoding改
intellij安装目录下bin\idea.exe.vmoptions文件，加上 
-Dfile.encoding=UTF-8
-Dfile.encoding=UTF8
[关于Idea testng单元测试乱码的解决](http://www.iteye.com/topic/1131087)


###代码检查配置
####泛型提示
raw use of 
####不开的
feature envy

###自动换行
1)搜 soft wrap
2)在File->settings->Code Style->Java中，选中“Wrapping and Braces”选项卡，在“Keep when reformatting”中有一个“Ensure rigth margin is not exceeded


## plugins 插件
[intellij idea 13&14 插件](http://blog.csdn.net/sunny243788557/article/details/26556967)
###手动安装插件目录
C:\Users\Administrator\.IntelliJIdea14\config\plugins
$SETUP_DIR/plugins
###junit
http://my.oschina.net/laugh2last/blog/169352
http://kidneyball.iteye.com/blog/1814028
###JunitGenerator
default:
${SOURCEPATH}/test/${PACKAGE}/${FILENAME}
maven:
${SOURCEPATH}/../../test/java/${PACKAGE}/${FILENAME}
###Identifier Highlighter 
高亮显示选中变量插件（idea14报错无法使用）
不安装插件的时的快捷键是选中这个变量然后按Ctrl+F7
idea默认的选中变量以后，是不会像eclipse一样提示这个变量用到的地方的。安装这个插件以后既可以和eclipse一样啦
###Key Promoter   
快捷键提示插件，当你点击鼠标一个功能的时候，可以提示 你这个功能快捷键是什么 ，和这个按钮你的使用频率
###Jrebel 热部署插件
  MyEclipse10和2014都是默认debugger模式支持热部署的。而idea需要你安装这个插件才会支持热部署，所以也算个遗憾吧
###FindBugs for IntelliJ IDEA，
  通过FindBugs帮你找到隐藏的bug及不好的做法。
###TabSwitch
  通过ctrl + tab在文件，各个面板tab间切换。
###Mybatis
  收费，改用mini版 
###UpperLowerCapitalize
大小写转换插件 
安装后快捷键alt+P全部大写     alt+L全部小写      alt+C开头字母大写
###generate serialversionuid 
生成uuid 的插件，安装后快捷键 alt+insert，有冲突
###idea vim
[IdeaVim插件使用技巧](http://kidneyball.iteye.com/blog/1828427)
模拟linux下 vi编辑器的插件支持vi的命令
###generateO2O    自动对象转换插件。
  方法体内可以生成对应的get set方法把一个对象对等拷贝到另一个对象里  快捷键 alt+insert
###EncodingPlugin 
  可按项目指定其默认编码，非常有用
###Equals and hashCode 
重写equals和hashcode方法的自定义模板
###unitTest 
在指定的方法上按下shift + cmd + t 即可为这个方法生成单元测试代码模板。
###GenerateToString 
自动生成toString方法, toString方法是可定制的
###angularjs


不好用，不可用的
###FileBrowser 在IDEA中查看项目外的文件 [不可用]（目前13.1.2以上好像不支持不知道其他人怎么样）
###sql query plugin    
数据库插件（这个13版本已经自带了database插件，比这个好用。可以不安装了）默认快捷键是ctrl+alt+v  ，但是和其他的快捷键冲突了， 建议修改为ctrl+等号
###maven repo search



## keyMap 快捷键
[所有](http://www.itjhwd.com/intellij-ideakjj)
### 常用
#### 代码生成
    Shift + F6    (Alt + Shift + R)        重构rename   
    Alt + Insert    (Alt + Shift + Z)      自动创建getter/setter   
    Alt + Enter     解决错误     
    Ctrl + Alt + L     (Ctrl + Shift + F)  自动格式化代码     
    Ctrl + Alt + O (Ctrl + Shift + O)   自动去除无用的import语句 
    Shift+F6  重构-重命名
#### 查找/查看
    Ctrl+Alt+ left/right  返回至上次浏览的位置
    双击Shift   全局查找     
    ctrl-E      最近编辑文件 
    ctrl-F12    文档结构        
    ctrl-H      查看类继承层次
    Ctrl+Q      显示注释文档
    ctrl-alt-H  调用层次
    alt+F7      查看该方法/变量/类被调用的地方

#### 移动
    Alt+ left/right 切换代码视图
    在方法间快速移动                        Alt + 上下键 
    在定位当前文件到左边结构树的节点上      Alt + F1 

```
mac
alt+f7查找在哪里使用 相当于eclipse的ctrl+shift+G

command+alt+f7 这个是查找选中的字符在工程中出现的地方，可以不是方法变量类等，这个和上面的有区别的

command＋F7可以查询当前元素在当前文件中的引用，然后按F3可以选择 ，功能基本同上

选中文本，按command+shift+F7 ，高亮显示所有该文本，按Esc高亮消失。
选中文本，按Alt+F3 ，逐个往下查找相同文本，并高亮显示。shift+f3就是往上找

ctrl+enter 出现生成get,set方法的界面

shift+enter 换到下一行
command+N 查找类
command+shift+N 查找文件
command+R 替换
ctrl+shift+R 可以在整个工程或着某个目录下面替换变量
command+Y 删除行
command+D复制一行
ctrl+shift+J 把多行连接成一行，会去掉空格的行

command+J 可以生成一些自动代码，比如for循环
command+B 找变量的来源  同F4   查找变量来源
ctrl+shift+B 找变量所属的类
command+G定位
command+F 在当前文件里查找文本 f3向下看，shift+f3向上看
ctrl+shift+F  可以在整个工程或着某个目录下面查找变量   相当于eclipse里的ctrl+H
alt+shift+C 最近修改的文件
command+E最近打开的文件
alt+enter 导入包，自动修改
command+alt+L 格式化代码
command+alt+I 自动缩进，不用多次使用tab或着backspace键，也是比较方便的

ctrl+shift+space代码补全，这个会判断可能用到的，这个代码补全和代码提示是不一样的
command+P 方法参数提示
command+alt+T 把选中的代码放在 TRY{} IF{} ELSE{} 里
command+X剪切删除行
command+shift+V 可以复制多个文本
command+shift+U 大小写转换
alt+f1查找文件所在目录位置
command+/ 注释一行或着多行 //
ctrl+shift+/ 注释/*...*/

command+alt+左右箭头 返回上次编辑的位置

shift+f6重命名

command+shift+上下箭头 把代码上移或着下移

command+[或]  可以跳到大括号的开头结尾

command+f12可以显示当前文件的结构

command+alt+B 可以导航到一个抽象方法的实现代码

command+shift+小键盘的*  列编辑
alt+f8 debug时选中查看值
f8相当于eclipse的f6跳到下一步
shift+f8相当于eclipse的f8跳到下一个断点，也相当于eclipse的f7跳出函数
f7相当于eclipse的f5就是进入到代码
alt+shift+f7这个是强制进入代码

ctrl+shift+f9 debug运行java类

ctrl+shift+f10正常运行java类

command+f2停止运行
```
## 与vim快捷键冲突解决办法
http://www.tianweishu.com/my-ideavim/
ctrl + e：这个在idea里面是打开最近使用的文件，非常非常常用，再也不用鼠标来回切换了；在vim里面是光标不动，屏幕往上翻（ctrl+y屏幕不懂，下翻）；这里必须改成idea的！
ctrl + w：在vim里面是分屏操作相关的，在idea里面是拓展选择，如果用习惯了的话挺好用的，当然习惯了vim强大的选择这个知识小case这个功能在ideavim里面vim的快捷键没什么用，建议改成idea的。
ctrl + r：在vim里面这个是redo，撤销操作的取消；在idea里面则是替换，这个看个人喜好了，相互可以替换，如果选择用idea的，那么可以用ctrl + shift + Z取消；如果选择vim的可以选择vim自带的替换；建议改成vim的操作；然后用强大的vim进行查找正则什么的不在话下！
### ctrl + p #IDE
在idea里面这个是提示方法参数的，在vim里面跟什么补全相关？毫无疑问，必须改成idea的键
### ctrl + q #VI
idea里面是显示文档，在vim里面是块选择模式！文档其实没关系，调过去看看然后回来也行，但是去块选择多行编辑就很强大了，必须选择vim的。
### ctrl + H #IDE
idea里面是显示类的继承树，vim里面是翻页？改成idea的吧，很好用。
### ctrl + b #IDE
idea里面是跳转到定义，vim里面是翻页；既然要抛弃鼠标，自然不能用ctrl + 鼠标跳转到定义了，毫无疑问必须选择idea的。
### ctrl + c，ctrl + v，ctrl + x
这几个用习惯了，复制粘贴剪切还是用系统的吧；至于ctrl + s，习惯了idea的人一般不会强迫性地不停ctrl + s的，idea帮你做了，这么干很low。

### ctrl + o #VI
这个真的很难抉择，在idea里面是重写方法，太好用了，还支持搜索；在vim里面也非常有用：在编辑模式下执行一个普通模式的命令然后回到编辑模式。没办法，只有把ctrl + o这个键重新映射了；还好在idea里面有个类似功能被ctrl + o覆盖了的，那就是ctrl + i，算是ctrl + o的弱化版，只覆盖方法；所以我把idea的ctrl + i取消掉，原来的ctrl + o改成ctrl + i就好了。

然后说说个人常用的操作。

在编辑模式下移动光标到某个地方然后继续编辑：ctrl + o  f 要移动到的字符，ctrl + o + / + 查找的单词；这个功能太常用了，以前用别的idea很不爽没有支持这个，比如我在某个方法的内部填完了参数，要跳出来在括号后面继续编辑，木有办法，只有用鼠标点；也许你会说用esc推出编辑模式用vim移动光标到地方然后插入，这不是多此一举么。这个功能完美解决需求。

caw，ciw，diw，daw  删除单词（或者然后插入）c的意思是删除然后进入插入模式，d则是删除，iw以及aw是文本语义，aw代表一个单词，包含前后空格，iw代表一个单词；还不仅如此，w可以换成别的，比如“代表两个引号之间的内容，｝两个大括号之间的，依次类推；di}可以删除块之间的内容。


## web
### jetty 调试配置
http://www.xuebuyuan.com/1115716.html
http://my.oschina.net/zhanglubing/blog/94386
run-configuration
jetty:run

    <dependency>
        <groupId>org.mortbay.jetty</groupId>
        <artifactId>jsp-2.1</artifactId>
        <version>6.0.0</version>
    </dependency>

    <plugin>
          <groupId>org.mortbay.jetty</groupId>
          <artifactId>maven-jetty-plugin</artifactId>
          <version>6.1.26</version>
          <configuration>
              <connectors>
                  <connector implementation="org.mortbay.jetty.nio.SelectChannelConnector">
                      <port>9000</port>
                  </connector>
              </connectors>
              <!--<webAppSourceDirectory>${project.build.directory}/${pom.artifactId}-${pom.version}</webAppSourceDirectory>-->
              <!--<contextPath>/jason</contextPath>-->
              <scanIntervalSeconds>10</scanIntervalSeconds>
              <stopKey>stop</stopKey>
              <stopPort>8005</stopPort>
          </configuration>
      </plugin>

### tomcat 配置
####  1 配置tomcat应用服务器 
File->Settings... 
Build,Execution,Deployment ->Application Servers 
点击"+"号，选择"Tomcat Server" 
选中tomcat 的地址，点击OK 

#### 2 配置web应用 
Defaults->TomcatServer 
点击"+"号， 
Server tab页，修改Name ,Applicaton server 下拉框选择刚才配置的Tomcat应用服务器。 
Deployment目录选择要部署的web应用，注意此处一定要选到WebContent文件夹，即WEB-INF上的上一级目录： 
点击OK，并配置应用的上下文路径： 

#### 3 修改编译输出路径。 
工程->右键->Open Module Settings 
选择Paths tab页，将output path:配置到WEB-INF\classes中，否则会找不到类。 

### tomcat热部署
JRebel Plugin
http://wibiline.iteye.com/blog/2073399

##Q
idea jdk无法识别，重导入项目无效
http://stackoverflow.com/questions/10612813/intellij-idea-cant-setup-jdk
File | Invalidate Caches is the first thing you should try in case of such issues.




---
#eclipse

##eclipse.ini
### 指定jdk
-vm
C:/Program Files (x86)/Java/jdk1.7.0_79/bin/javaw.exe


### 日期格式
-Duser.language=zh-cn
-Duser.language=en 


### 自动补齐
key binding:
Window->preferences
General->keys
word completion
content assistant

java->edit->content assisnt->Advanced->Java Proposals

##settings
###jar包乱码
Window–>Preferences–>General–>Content types
Window–>Preferences–>General–>Workspace



##plugin
###svn
name：subclipse 1.6.x，url：http://subclipse.tigris.org/update_1.6.x
git - http://download.eclipse.org/egit/updates
###github
http://www.cnblogs.com/yc-755909659/p/3753626.html


---
#crack
http://appcode.aliapp.com/
http://hw1287789687.iteye.com/blog/2153894



