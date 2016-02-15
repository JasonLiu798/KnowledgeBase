#vim emacs
---
#常用
##查找/替换
\/\* .* \*\/
%s/\/\* .* \*\///g
%s/MessageConnect/IQueueCache/g


---
#常用资料
http://blog.51yip.com/linux/1140.html
[技巧](http://kidneyball.iteye.com/blog/1828427)
[vim使用技巧](http://linux.chinaunix.net/techdoc/desktop/2009/07/06/1122020.shtml)

---
#配置
http://www.cnblogs.com/ma6174/archive/2011/12/10/2283393.html
## 终级配置
https://github.com/spf13/spf13-vim
curl https://j.mp/spf13-vim3 -L > spf13-vim.sh && sh spf13-vim.sh
[写一份自己的 VIM 配置文件](http://segmentfault.com/q/1010000003095282/a-1020000003095406)

---
#配色
## 目录
/usr/share/vim/vim74/colors/
## 资源
https://github.com/tomasr/molokai
http://ethanschoonover.com/solarized
https://github.com/altercation/vim-colors-solarized
https://github.com/altercation/vim-colors-solarized.git
## 单独修改
vi ~/.vimrc 加入如下内容
hi Comment ctermfg =blue
修改字符串颜色
hi String ctermfg =darkred
修改类型颜色
hi Type ctermfg =yellow
修改数字颜色
hi Number ctermfg =darkblue
修改常量颜色
hi Constant ctermfg =blue
修改声明颜色
hi Statement ctermfg =darkyellow

---
#命令模式
set fileformats=unix,dos unix文件格式作为第一选择，dos格式作为第二选择
set fileformat ==>查看文件格式
set fileformat=unix/dos ==>设置（转换）文件格式
set list/nolist ==>设置是否显示不可见字符，注意此选项受set listchars约束
set listchars=tab:>-,trail:-
set textwidth=78 ==>设置指定列宽自动换行，当使用gq命令格式化文本时就会按照设置的长度在单词的结尾换行。
TAB会被显示成 ">—" 而行尾多余的空白字符显示成 "-"。
highlight WhitespaceEOL ctermbg=red guibg=red 
match WhitespaceEOL /\s\+$/
%s/\n//g ==>删除换行符

---
#.vimrc
## 配色
syntax on
##行号
set nu
set nonu
## cywin配置
### 退格
set nocp
set backspace=start,indent,eol
### 右键不能粘贴
方法一
:set mouse-=a”（不包括引号） 
方法二
~/.vimrc
if has('mouse')
    set mouse-=a
endif 
### 注释更换颜色
hi Comment ctermfg =blue

---
#命令
## 移动光标
### 按词
w   下一个词首
e   本词尾(只有一个词)/下一个单词尾
b   上一个词首

### 行内
^     本行最开头的字符处
n|    移动到当前行的第n列
0     移动到行首
$     移动到行末

+     移动到下一行开头
-     移动到上一行开头

Enter 下移一行 
)   移至句尾 
(   移至句首 
}   移至段落开头 
{   移至段落结尾 

### 滚屏
Ctrl+f            往前滚动一整屏
Ctrl+b            往后滚动一整屏
Ctrl+d            往前滚动半屏
Ctrl+u            往后滚动半屏

Ctrl+e            往后滚动一行        
Ctrl+y            往前滚动一行

z<Enter>        将光标所在行移动到屏幕顶端
z.              将光标所在行移动到屏幕中间
z-              将光标所在行移动到屏幕低端
980z<Enter>     将第980行移动到屏幕顶端

### 在屏幕中移动
H            移动到屏幕顶端的行
M            移动到屏幕中央的行
L            移动到屏幕底端的行
nH           移动到屏幕顶端往下的第n行
nL           移动到屏幕顶端往上的第n行

### 按行号移动
Ctrl+g           显示当前行信息
nG               转至第n行
G                转至文本末尾
gg　　　　　　   移至文本开头

##插入
o - 在当前行下方插入新行并自动缩进 
O - 在当前行上方插入新行并自动缩进 （普通模式下的大写字母命令用 shift+字母键 输入，下同） 
i - 在当前字符左方开始插入字符 
a - 在当前字符右方开始插入字符 
I - 光标移动到行首并进入插入模式 
A - 光标移动到行尾并进入插入模式 
s - 删除光标所在字符并进入插入模式 
S - 删除光标所在行并进入插入模式 
c<范围> - 删除光标所在位置周围某个范围的文本并进入插入模式。关于范围请看第5点，常用的组合有：
caw - 删除一个单词包括它后面的空格并开始插入； 
ciw - 删除一个单词并开始插入； 
ci" - 删除一个字符串内部文本并开始插入； 
c$ - 从光标位置删除到行尾并开始插入； ct字符 - 从光标位置删除本行某个字符之前（保留该字符）并开始插入。等等。 
C - 删除光标位置到行尾的内容并进入插入模式 (相当于c$) 
r - 修改光标所在字符，然后返回普通模式 
R - 进入覆盖模式 

##范围
    r<范围> - 删除一定范围内的文本 
    c<范围> - 删除一定范围内的文本并进入插入模式 
    y<范围> - 将范围内的文本放入0号和"号注册栏 
    v<范围> - 选择范围内的文本 
    =<范围> - 自动缩进范围内的文本 
    gU<范围> - 将范围内的字符转换为大写 
    gu<范围> - 将范围内的字符转换为小写 
    ><范围> - 将范围中的内容缩进一格 
    <<范围> - 将范围中的内容取消缩进一格 


## 复制粘贴
y   复制
v   粘贴

##重做，撤销
重做 ctrl+r
撤销 u
U return the last line to its original state

#搜索
## 大小写敏感
\C 大小写敏感
\c 不敏感
模式          匹配    
\Cword         word
\CWord         Word
\cword         word，Word，WORD，WoRd，等。
\cWord         word，Word，WORD，WoRd，等。

:set ignorecase
大小写敏感
:set ignorecase smartcase
如果你采用的模式里至少有一个大写字母，查找就成了大小写敏感的

## 高亮搜索
:set hlsearch

##编码
:set fileencoding
set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp936

##替换replace
http://tanqisen.github.io/blog/2013/01/13/vim-search-replace-regex/
[vi替换](http://os.51cto.com/art/200907/140987.htm)
:[range]s/from/to/[flags]
range:搜索范围，如果没有指定范围，则作用于但前行。
:1,10s/from/to/ 表示在第1到第10行（包含第1，第10行）之间搜索替换；
:10s/from/to/ 表示只在第10行搜索替换；

使用 :s/正则表达式/替换文本/ 可在本行内替换
:s/from/to/ 表示在所有行中搜索第一个替换
:s/from/to/g 表示在所有行中搜索所有替换

使用 :%s/正则表达式/替换文本/g 在当前文件内替换所有出现的匹配 
:%s/from/to/ 表示在所有行中搜索第一个替换
:%s/from/to/g 表示在所有行中搜索所有替换

1,$s/from/to/ 同上。

flags 有如下四个选项：
c confirm，每次替换前询问；
e error， 不显示错误；
g globle，不询问，整行替换。如果不加g选项，则只替换每行的第一个匹配到的字符串；
i ignore，忽略大小写。


使用 :s/正则表达式/替换文本/g 在本行内替换所有出现的匹配 



#列模式
[Vim 的纵向编辑模式](http://www.ibm.com/developerworks/cn/linux/l-cn-vimcolumn/)
H    移动光标到屏幕的首行.
M    移动光标到屏幕的中间一行.
L    移动光标到屏幕的尾行.
gg   移动光标到文档首行.
G    移动光标到文档尾行.
c-f  (即 ctrl 键与 f 键一同按下) 本命令即 page down.
c-b  (即 ctrl 键与 b 键一同按下, 后同) 本命令即 page up.
''   此命令相当有用, 它移动光标到上一个标记处, 比如用 gd, * 等查
    找到某个单词后, 再输入此命令则回到上次停留的位置.
'.   此命令相当好使, 它移动光标到上一次的修改行.
`.   此命令相当强大, 它移动光标到上一次的修改点.

## 一些常用组合技 
全选： ggvG
调换两个字符位置： xp
复制一行： yyp
调换两行位置： ddp
插入模式下到行尾继续输入（相当于End键）： Ctrl+o A 或 Ctrl+[ A 
插入模式下到行首继续输入（相当于Home键）： Ctrl+o I 或 Ctrl+[ I 
到类定义位置（适用于正确缩进的public，protected类） ： ?^p回车 

---
#.vimrc
set autoindent 
set smartindent 
set tabstop=4 
set shiftwidth=4 
set softtabstop=4 
set noexpandtab 


;可以令屏幕滚动时在光标上下方保留5行预览代码
set so=5 



---
#plugin
pathogen ＃vim插件管理，结合git可以更好的管理vim插件。
Vundle: 插件管理。
Plugin 'gmarik/Vundle.vim'
##drawit
wget -O DrawIt.vba.gz http://www.vim.org/scripts/download_script.php?src_id=8798
要在vim里面画个下面这样的图，可以使用drawit插件
[1] http://www.drchip.org/astronaut/vim/index.html#DRAWIT
[2] http://www.vim.org/scripts/script.php?script_id=40
[3] http://www.drchip.org/astronaut/vim/doc/DrawIt.txt.html
参考[2]中的文档，安装过程如下：
1）下载Drawit，drawit通过vimball发布
从vim.org官网[2]下载DrawIt.vba.gz
2）在当前目录下用vim打开该文件
vim DrawIt.vba.gz
在vim中执行下面命令安装
:so %
退出vim，会发现.vim下面多了两个plugin
ls ~/.vim/plugin/
cecutil.vim  DrawItPlugin.vim
如果执行:so %安装的时候报如下错误：
(Vimball) The current file does not appear to be a Vimball!(我用的Fedora17，就碰到该问题)
从[1]下载DrawIt，重试下
wget http://www.drchip.org/astronaut/vim/vbafiles/DrawIt.vba.gz
3）使用
vim test
在命令模式下输入\di，开启drawit(或者执行:DIstart)
然后输入上下左右键就可以看到效果了
要结束drawit模式，键入\di，或者:DIstop
常用的符号和键对应关系如下：
上下左右
上箭头^
下箭头v
左箭头shift + <
右箭头shift + >


VimWiki 和 Calendar。
工作(Coding)时很多，
a.vim .h和.c之间切换
lookupfile 使用部分关键字查找文件名
taglist 大名鼎鼎，不多说了
NERD_tree 树形的文件系统浏览器（替代netrw)
EnhancedCommentify 多文本类型的快捷comment/uncomment, 据说NERD Commenter 更好一些
DoxygenToolkit 生成doxygen风格注释，以及doxygen.syntax
repeat 支持使用.来重复执行一些插件的命令（如speeddating, surround等)
surround 用来加括号，引号，前后缀等等，写XML很有用（特别是配合repeat）
manpageview 在Vim中查看Manpage，有语法高亮
VCScommand 支持多种版本管理器
vimcdoc vim帮助中文版
cctree 可以查看function的call tree



---
#other

http://dikar.iteye.com/blog/308934

i插入命令 a附加命令 o打开命令 c修改命令
　　r取代命令 s替换命令 Esc退出命令

x删除光标处的单个字符
dd 删除光标所在行
dw 删除当前字符到单词尾包括空格的所有字符

yy命令复制当前整行的内容到vi缓冲区
yw复制当前光标所在位置到单词尾字符的内容到vi缓存区，相当于复制一个单词
y$复制光标所在位置到行尾内容到缓存区
y^复制光标所在位置到行首内容到缓存区

##Netrw插件
常用快捷键
<F1>        显示帮助
<cr>        如果光标下为目录，则进入该目录；如果光标下是文件，则用vim打开该文件
-           返回上级目录
c           切换vim的当前工作目录为正在浏览的目录
d           创建目录 
D           删除文件或目录
i           切换显示方式
R           改名文件或目录
s           选择排序方式
x           定制浏览方式，使用你指定的程序打开该文件 





---
#Emacs
artist mode
http://www.cinsk.org/emacs/emacs-artist.html


