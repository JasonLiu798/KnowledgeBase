# idea 快捷键
---
# 配置
http://www.juvenxu.com/2013/07/18/my-most-used-intellij-idea-shortcuts/
vim
http://linux.chinaunix.net/techdoc/desktop/2009/07/06/1122020.shtml


# mac
```
cmd+[ 前进
cmd+] 后退
cmd+alt+Lclick 查看实现
shift double 全局查找
cmd+f12 查看文件结构

cmd+E 最近打开
alt+f7 查看被调用
alt+enter 错误代码提示

shift+f6 -> shift+cmd+2 重构-重命名


```








----
# win
[所有](http://www.itjhwd.com/intellij-ideakjj)
[十大Intellij IDEA快捷键](http://blog.csdn.net/dc_726/article/details/42784275)
###常用
    ctrl + F12 -> ctrl + \    file structure  ，outline，查看文件所有函数，快速查找

####代码生成
    Shift + F6    (Alt + Shift + R)        重构rename
    Alt + Insert    (Alt + Shift + Z)      自动创建getter/setter
    Alt + Enter     解决错误
    Ctrl + Alt + L     (Ctrl + Shift + L)  reformat 自动格式化代码
    Ctrl + Alt + O (Ctrl + Shift + O)   自动去除无用的import语句
    Shift+F6  重构-重命名

####查找/查看
```
implementation  跳到 定义
ctrl+b      Declaration 跳转到定义
ctrl+alt+v  Type Declaration 跳转到接口实现定义
Ctrl+Alt+ left/right   返回至上次浏览的位置
双击Shift   全局查找
ctrl-E      最近编辑文件
ctrl-H      查看类继承层次
Ctrl+Q      显示注释文档
ctrl-alt-H  调用层次
alt+F7       Find Usage(ctrl+shift+3) 查看该方法/变量/类被调用的地方
```

####移动
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




