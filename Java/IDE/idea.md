#IDEA
---
#启动参数
```
-server
-Xms512m
-Xmx1500m
-XX:+UseConcMarkSweepGC
-XX:ReservedCodeCacheSize=240m
-XX:SoftRefLRUPolicyMSPerMB=50
-ea
-Dsun.io.useCanonCaches=false
-Djava.net.preferIPv4Stack=true
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-Dfile.encoding=UTF8
-Xverify:none
-XX:+DisableExplicitGC
```
-Xverify：none 不验证字节码


#启动jdk替换
64位：
IDEA_JDK_64
32位：IDEA_JKD

---
# 需要修改的菜单
## 代码格式化
editor->code style->java->java doc
preserve line feeds


---
#配置
## 乱码
File->setting->encoding改
intellij安装目录下bin\idea.exe.vmoptions文件，加上
-Dfile.encoding=UTF-8 (无法识别)
-Dfile.encoding=UTF8
[关于Idea testng单元测试乱码的解决](http://www.iteye.com/topic/1131087)

Build,Execution,Deployment > Compiler > Java Compiler， 设置 Additional command line parameters选项为
-encoding utf-8

## compile的VM参数
如果是compile期出了问题，则需要为javac设置"-encoding UTF-8 "参数，在idea中，是通过ctrl+alt+s-compiler>java compiler->additional command line parameters设置）； 

##配色
动态相关：
接口，紫色，D072F3
实例field,粉红，E868CD
局部变量，浅红，FF939A

静态相关：
constant(final)，浅绿，8DF66A
key word，橘黄色，FFA21C
line comment，灰绿，97C47C
java doc comment，灰绿，7AC668
静态变量，浅绿蓝，36C596
静态方法，浅蓝绿，2EEBFF
分号，6DC89F
注解名，深绿，169F5B
普通方法调用，蓝色，A19FFF

## external tool
javap
Program:    $JDKPath$\bin\javap.exe
Arguments:  -c $FileClass$
//Parameter:  -classpath /opt/.../calsses -v -s -l -c $FileClass$
Work dir: $OutputPath$
//directory:  /opt/.../projectdir

## 显示右侧边栏
View->Tool buttons

## 代码检查配置
### 泛型提示
raw use of
#### 不开的
feature envy

### 自动换行
1)搜 soft wrap
2)在File->settings->Code Style->Java中，选中“Wrapping and Braces”选项卡，在“Keep when reformatting”中有一个“Ensure rigth margin is not exceeded


---
# plugins 插件
[intellij idea 13&14 插件](http://blog.csdn.net/sunny243788557/article/details/26556967)
## 手动安装插件目录
C:\Users\Administrator\.IntelliJIdea14\config\plugins
$SETUP_DIR/plugins
## idea vim
[IdeaVim插件使用技巧](http://kidneyball.iteye.com/blog/1828427)
模拟linux下 vi编辑器的插件支持vi的命令
https://github.com/JetBrains/ideavim
### :action命令
:actionlist<回车>
， 就会看到一个长长的列表，基本上这就是能你用idea的Lookup Action功能所能调用的绝大部分idea动作。你执行
:action <命令名>
，就能执行这个动作。

比如说，你执行
:action FileStructurePopup
就能打开当前文件的成员列表。（如果你使用的是2016年6月的当前发行版，成员列表弹出窗会闪退，必须升级到eap版）

聪明如你肯定已经想到，这样一来我就可以在.ideavimrc中配热键来调用idea内部功能了啊。完全正确。

比如说，我可以配
```
nnoremap <Space>nf<Space> :action NewFile<CR>
nnoremap <Space>nc<Space> :action NewClass<CR>
nnoremap <Space>nd<Space> :action NewDir<CR>
nnoremap <Space>npi<Space> :action NewPackageInfo<CR>
nnoremap <Space>ns<Space> :action NewScratchFile<CR>
```
来新建各种文件。

也可以配
```
noremap <Space>dfj :action IntroduceVariable<CR>
noremap <Space>dfk :action ExtractMehtod<CR>
noremap <Space>dfl :action Inline<CR>
noremap <Space>dfu :action ChangeSignature<CR>
noremap <Space>dfi :action RenameElement<CR>
noremap <Space>dfo :action MembersPullUp<CR>
noremap <Space>rrr :action Refactorings.QuickListPopupAction<CR>
```
来调用各种重构功能。注意上面是格斗键位：dfj 就是 [下，前，轻拳]，模仿格斗游戏的出招键位。这个特性在Mac下可以用Karabinder来做，现在在任何系统下的Idea里都可以用了。

还可以配
```
nnoremap mM :action ToggleBookmark0<CR>
nnoremap mN :action ToggleBookmark1<CR>
nnoremap mJ :action ToggleBookmark2<CR>
nnoremap mK :action ToggleBookmark3<CR>
nnoremap mH :action ToggleBookmark4<CR>
nnoremap mL :action ToggleBookmark5<CR>
nnoremap mY :action ToggleBookmark6<CR>
nnoremap mI :action ToggleBookmark7<CR>
nnoremap mA :action ToggleBookmark8<CR>
nnoremap mB :action ToggleBookmark9<CR>

nnoremap `M :action GotoBookmark0<CR>
nnoremap `N :action GotoBookmark1<CR>
nnoremap `J :action GotoBookmark2<CR>
nnoremap `K :action GotoBookmark3<CR>
nnoremap `H :action GotoBookmark4<CR>
nnoremap `L :action GotoBookmark5<CR>
nnoremap `Y :action GotoBookmark6<CR>
nnoremap `I :action GotoBookmark7<CR>
nnoremap `A :action GotoBookmark8<CR>
nnoremap `B :action GotoBookmark9<CR>
```
来局部修正Ideavim不支持跨文件书签的问题，只能配10个，不过基本够用了。

总之可以任意发挥，把常用功能全部绑到基键上，全面解放小尾指。ctrl都不用怎么按了。

顺带一提，:actionlist的列表可以用ctrl+A全选复制（但没有鼠标右键菜单），可以一次性复制出来慢慢挑选。



## junit
http://my.oschina.net/laugh2last/blog/169352
http://kidneyball.iteye.com/blog/1814028
## JunitGenerator 单元测试
default:
${SOURCEPATH}/test/${PACKAGE}/${FILENAME}
maven:
${SOURCEPATH}/../../test/java/${PACKAGE}/${FILENAME}
## serialversion
GenerateSerialVersionUID
## emmet
###FindBugs for IntelliJ IDEA
  通过FindBugs帮你找到隐藏的bug及不好的做法。

###Key Promoter
快捷键提示插件，当你点击鼠标一个功能的时候，可以提示 你这个功能快捷键是什么 ，和这个按钮你的使用频率
###Jrebel 热部署插件
  MyEclipse10和2014都是默认debugger模式支持热部署的。而idea需要你安装这个插件才会支持热部署，所以也算个遗憾吧

###TabSwitch
  通过ctrl + tab在文件，各个面板tab间切换。
###Mybatis
  收费，改用mini版
###UpperLowerCapitalize
大小写转换插件
安装后快捷键alt+P全部大写     alt+L全部小写      alt+C开头字母大写
###generate serialversionuid
生成uuid 的插件，安装后快捷键 alt+insert，有冲突

###generateO2O    自动对象转换插件。
  方法体内可以生成对应的get set方法把一个对象对等拷贝到另一个对象里  快捷键 alt+insert
###EncodingPlugin
  可按项目指定其默认编码，非常有用
###Equals and hashCode
重写equals和hashcode方法的自定义模板
###unitTest
在指定的方法上按下shift + cmd + t 即可为这个方法生成单元测试代码模板。

###angularjs

###js语法支持，社区版
TextMate Bundles Support plug-in.
[配置](http://plugins.jetbrains.com/plugin/7221?pr=idea_ce)
https://github.com/textmate
https://github.com/textmate/latex.tmbundle
https://github.com/textmate/javascript.tmbundle
https://github.com/textmate/sql.tmbundle
https://github.com/textmate/scala.tmbundle
https://github.com/textmate/antlr.tmbundle


###不好用，不可用的
###FileBrowser 在IDEA中查看项目外的文件 [不可用]（目前13.1.2以上好像不支持不知道其他人怎么样）
###sql query plugin
数据库插件（这个13版本已经自带了database插件，比这个好用。可以不安装了）默认快捷键是ctrl+alt+v  ，但是和其他的快捷键冲突了， 建议修改为ctrl+等号
###maven repo search
###GenerateToString (idea2016报错)
自动生成toString方法, toString方法是可定制的
###Identifier Highlighter
idea2016报错：Unable to save settings: Failed to save settings. Please restart IntelliJ IDEA
高亮显示选中变量插件
不安装插件的时的快捷键是选中这个变量然后按Ctrl+F7
idea默认的选中变量以后，是不会像eclipse一样提示这个变量用到的地方的。安装这个插件以后既可以和eclipse一样啦


---
# web
## jetty 调试配置
端口
-Djetty.port=8090

## 热部署
http://blog.csdn.net/xiejx618/article/details/49936541
前提
a.必须在调试模式下运行jetty;
b.On 'Update' action选Update classes and resources,On frame deactivation选Update classes and resource.



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

## tomcat 配置
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


[JRebel vs IntelliJ - hot swap](http://stackoverflow.com/questions/21674683/jrebel-vs-intellij-hot-swap)
[HotSwap和JRebel原理](http://www.hollischuang.com/archives/598)

##Q
idea jdk无法识别，重导入项目无效
http://stackoverflow.com/questions/10612813/intellij-idea-cant-setup-jdk
File | Invalidate Caches is the first thing you should try in case of such issues.

##key
http://idea.qinxi1992.cn/



[Get True Hot Swap in Java with DCEVM and IntelliJ IDEA](https://blog.jetbrains.com/idea/2013/07/get-true-hot-swap-in-java-with-dcevm-and-intellij-idea/)
