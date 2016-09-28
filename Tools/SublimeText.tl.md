# sublime text 3 settings
---
#Key binding
OS X
鼠标左键 + Option
或: 鼠标中键
添加到选区: Command
从选区移除: Command+Shift
Windows
鼠标右键 + Shift
或: 鼠标中键
添加到选区: Ctrl
从选区移除: Alt
Linux
鼠标右键 + Shift
添加到选区: Ctrl
从选区移除: Alt

## keyboard
OS X
Ctrl + Shift + Up
Ctrl + Shift + Down
Windows
Ctrl + Alt + Up
Ctrl + Alt + Down
Linux
Ctrl + Alt + Up
Ctrl + Alt + Down

## General
- ↑↓←→ ：上下左右移动光标，注意不是不是 KJHL ！
- Alt ：调出菜单
- Ctrl + Shift + P ：调出命令板（Command Palette）
- `Ctrl + “：调出控制台

## Editing
- Ctrl + Enter ：在当前行下面新增一行然后跳至该行
- Ctrl + Shift + Enter ：在当前行上面增加一行并跳至该行
- Ctrl + ←/→ ：进行逐词移动
- Ctrl + Shift + ←/→ 进行逐词选择
- Ctrl + ↑/↓ 移动当前显示区域
- Ctrl + Shift + ↑/↓ 移动当前行

## Selecting
- Ctrl + D ：选择当前光标所在的词并高亮该词所有出现的位置，再次Ctrl + D 选择该词出现的下一个位置，在多重选词的过程中，使用Ctrl + K 进行跳过，使用 Ctrl + U 进行回退，使用 Esc 退出多重编辑
- Ctrl + Shift + L ：将当前选中区域打散
- Ctrl + J ：把当前选中区域合并为一行
- Ctrl + M ：在起始括号和结尾括号间切换
- Ctrl + Shift + M ：快速选择括号间的内容
- Ctrl + Shift + J ：快速选择同缩进的内容
- Ctrl + Shift + Space ：快速选择当前作用域（Scope）的内容

## Finding&Replacing
- F3 ：跳至当前关键字下一个位置
- Shift + F3 ：跳到当前关键字上一个位置
- Alt + F3 ：选中当前关键字出现的所有位置
- Ctrl + F/H ：进行标准查找/替换，之后：
- Alt + C ：切换大小写敏感（Case-sensitive）模式
- Alt + W ：切换整字匹配（Whole matching）模式
- Alt + R ：切换正则匹配（Regex matching）模式
- Ctrl + Shift + H ：替换当前关键字
- Ctrl + Alt + H ：替换所有关键字匹配
- Ctrl + Shift + F ：多文件搜索&替换

## Jumping
- Ctrl + P ：跳转到指定文件，输入文件名后可以：
- @ 符号跳转：输入 @symbol 跳转到 symbol 符号所在的位置
- # 关键字跳转：输入 #keyword 跳转到 keyword 所在的位置
- : 行号跳转：输入 :12 跳转到文件的第12行。
- Ctrl + R ：跳转到指定符号
- Ctrl + G ：跳转到指定行号

## Window
- Ctrl + Shift + N ：创建一个新窗口
- Ctrl + N ：在当前窗口创建一个新标签
- Ctrl + W ：关闭当前标签，当窗口内没有标签时会关闭该窗口
- Ctrl + Shift + T ：恢复刚刚关闭的标签
- 屏幕（Screen）
- F11 ：切换普通全屏
- Shift + F11 ：切换无干扰全屏
- Alt + Shift + 2 ：进行左右分屏
- Alt + Shift + 8 ：进行上下分屏
- Alt + Shift + 5 ：进行上下左右分屏
- 分屏之后，使用 Ctrl + 数字键 跳转到指定屏，使用Ctrl + Shift + 数字键 将当前屏移动到指定屏


---
#peference备份
##settings
"font_face": "Courier New",

//tab中文出现方块
"dpi_scale": 1.0,

```javascript
{
    "auto_complete": false,
    "caret_style": "solid",
    #win用
    #"color_scheme": "Packages/User/SublimeLinter/Monokai (SL).tmTheme",
    #mac用
    "color_scheme": "Packages/Monokai Extended/Monokai Extended.tmTheme",
    "ensure_newline_at_eof_on_save": true,
    "file_exclude_patterns":
    [
        ".DS_Store",
        "*.pid",
        "*.pyc",
        ".tags*"
    ],
    "find_selected_text": true,
    "fold_buttons": false,
    "folder_exclude_patterns":
    [
        ".git",
        "__pycache__",
        "env",
        "env3",
        "target",
        ".idea"
    ],
    "font_face": "Consolas",
    "font_options":
    [
        "subpixel_antialias"
    ],
    "font_size": 13,
    "highlight_line": true,
    "highlight_modified_tabs": true,
    "ignored_packages":
    [
        "Markdown",
        "Vintage"
    ],
    "line_numbers": true,
    "line_padding_bottom": 0,
    "line_padding_top": 0,
    "rulers":
    [
        72,
        79
    ],
    "scroll_past_end": false,
    "show_minimap": false,
    "tab_size": 4,
    "translate_tabs_to_spaces": true,
    "trim_trailing_white_space_on_save": true,
    "wide_caret": true,
    "word_wrap": true,
    "wrap_width": 80
}
```

###keybind
```javascript
[
    { "keys": ["alt+m"], "command": "markdown_preview", "args": { "target": "browser"} },
    { "keys": ["ctrl+right"], "command": "next_view" },
    { "keys": ["ctrl+left"], "command": "prev_view" },
    { "keys": ["ctrl+shift+enter"], "command": "open_in_browser" }
]
```

---
#plugins packages 插件
## package control安装
### 简单的安装方法
使用```Ctrl+` ```快捷键或者通过View->Show Console菜单打开命令行，粘贴如下代码：
```python
import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())
```

如果顺利的话，此时就可以在Preferences菜单下看到Package Settings和Package Control两个菜单了。
顺便贴下Sublime Text2 的代码：
```javascript
import urllib2,os; pf='Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler( ))); open( os.path.join( ipp, pf), 'wb' ).write( urllib2.urlopen( 'http://sublime.wbond.net/' +pf.replace( ' ','%20' )).read()); print( 'Please restart Sublime Text to finish installation')
```

### 手动安装
可能由于各种原因，无法使用代码安装，那可以通过以下步骤手动安装Package Control：
1.点击Preferences > Browse Packages菜单
2.进入打开的目录的上层目录，然后再进入Installed Packages/目录
3.下载Package Control.sublime-package并复制到Installed Packages/目录
4.重启Sublime Text。

### 全程指南
http://www.tuicool.com/articles/AJR7Rn3
[Sublime插件：C语言篇](http://www.jianshu.com/p/595975a2a5f3)
[Sublime插件：增强篇](http://www.jianshu.com/p/5905f927d01b)



##开发相关
* ctag
```javascript
brew install ctags
配置：
command配置项，为ctags的可执行文件路径/usr/local/bin/ctags
win _CTags binary: http://prdownloads.sourceforge.net/ctags/ctags58.zip
{
    "command": "C:\\opt\\ctags58\\ctags.exe"
    "command": "D:\\yp\\ubin\\ctags58\\ctags.exe"
}
D:\\yp\\ubin\\ctags58\\ctags.exe
mouse binding: 去掉shift,可以左键+点击
```
* DocBlockr,    自动生成大块的注释，并且可以用tab在不同内容之间切换
* SublimeLinter,    语法检查
* SublimeCodeIntel, 语法补全
* Alignment,    ctrl+alt+a就可以使其按照等号对其
* Emmet,    [语法速查](http://docs.emmet.io/cheat-sheet)
* CoolFormat,   代码格式化工具，相当于简化版的Astyle，默认ctrl+alt+shift+q格式化当前文件，ctrl+alt+shift+s格式化当前选中
* AllAutocomplete,  Sublime自带的可以对当前文件中的变量和函数名进行自动提示，但是AllAutocomplete可以对打开的所有文件的变量名进行提示，增强版的代码自动提示符
* Emmet Css Snippets,   "Emmet CSS completions for Sublime Text."
* Bootstrap 3 Snippets, Twitter Bootstrap 3 Snippets Plugin for Sublime Text
* SublimeAStyleFormatter,   国人做的Astyle Sublime版，蛮不错的。安装完成之后，下面这个配置一定要打开，即保存自动格式化，这个相比于CoolFormat要简单很多。
* SublimeREPL,  窗口布局
* Js​Format,    Javascript formatting for Sublime Text
* HTMLBeautify,
```
"A plugin for Sublime Text that formats (indents) HTML source code. It makes code easier for humans to read."
Mac OS X: Command-Option-Shift-F
Windows: ctrl-Alt-Shift-F
Linux: ctrl-Alt-Shift-F
```
* j​Query,  "Sublime Text package bundle for jQuery
* Better Completion,    "Better auto-completion for Sublime Text."
* Auto​File​Name,   "Sublime Text plugin that autocompletes filenames."


##增强型
* ConvertToUTF8,        转码
* GBK Encoding Support, 转码
* EncodingHelper,       编码增强
* Vintageous,   vi扩展
```
配置
http://feliving.github.io/Sublime-Text-3-Documentation/vintage.html
启用
"ignored_packages": [""]
默认命令模式
 "vintage_start_in_command_mode": true
```
* HexViewer,    查看二进制
* view in browser
```javascript
快捷键配置
{ "keys": ["ctrl+shift+enter"], "command": "open_in_browser" }
```
* SideBarEnhancements,  增强侧边栏
https://github.com/titoBouzout/SideBarEnhancements

* View In Browser,  在浏览器打开
* AutoBackups,  自动备份
* Plain​Tasks, todo list
* TrailingSpaces, 高亮空格
* AdvancedNewFile,  配置新建文件的附属文件，直接生成一个工程都可以
* Compare Side-By-Side, Sublime版本的Beyond Compare
* WordCount,  字数显示

##主题
* Soda[Theme],  Dark and light custom UI themes for Sublime Text
* Monokai Extended[Theme],  如果你喜欢 Soda Dark 和 Monokai，我建议你使用 Monokai Extended (GitHub)。这个 color scheme 是 Monokai Soda 的增强，如果再配合 Markdown Extended (GitHub)，将大大改善 Markdown 的语法高亮。
* 
https://github.com/SublimeText-Markdown/MarkdownEditing

## license
```
----- BEGIN LICENSE -----
Michael Barnes
Single User License
EA7E-821385
8A353C41 872A0D5C DF9B2950 AFF6F667
C458EA6D 8EA3C286 98D1D650 131A97AB
AA919AEC EF20E143 B361B1E7 4C8B7F04
B085E65E 2F5F5360 8489D422 FB8FC1AA
93F6323C FD7F7544 3F39C318 D95E6480
FCCC7561 8A4A1741 68FA4223 ADCEDE07
200C25BE DBBC4855 C4CFB774 C5EC138C
0FEC1CEF D9DCECEC D3A5DAD1 01316C36
------ END LICENSE ------

----- BEGIN LICENSE -----
Free Communities Consultoria em Informática Ltda
Single User License
EA7E-801302
C154C122 4EFA4415 F1AAEBCC 315F3A7D
2580735A 7955AA57 850ABD88 72A1DDD8
8D2CE060 CF980C29 890D74F2 53131895
281E324E 98EA1FEF 7FF69A12 17CA7784
490862AF 833E133D FD22141D D8C89B94
4C10A4D2 24693D70 AE37C18F 72EF0BE5
1ED60704 651BC71F 16CA1B77 496A0B19
463EDFF9 6BEB1861 CA5BAD96 89D0118E
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Nicolas Hennion
Single User License
EA7E-866075
8A01AA83 1D668D24 4484AEBC 3B04512C
827B0DE5 69E9B07A A39ACCC0 F95F5410
729D5639 4C37CECB B2522FB3 8D37FDC1
72899363 BBA441AC A5F47F08 6CD3B3FE
CEFB3783 B2E1BA96 71AAF7B4 AFB61B1D
0CC513E7 52FF2333 9F726D2C CDE53B4A
810C0D4F E1F419A3 CDA0832B 8440565A
35BF00F6 4CA9F869 ED10E245 469C233E
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Anthony Sansone
Single User License
EA7E-878563
28B9A648 42B99D8A F2E3E9E0 16DE076E
E218B3DC F3606379 C33C1526 E8B58964
B2CB3F63 BDF901BE D31424D2 082891B5
F7058694 55FA46D8 EFC11878 0868F093
B17CAFE7 63A78881 86B78E38 0F146238
BAE22DBB D4EC71A1 0EC2E701 C7F9C648
5CF29CA3 1CB14285 19A46991 E9A98676
14FD4777 2D8A0AB6 A444EE0D CA009B54
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Alexey Plutalov
Single User License
EA7E-860776
3DC19CC1 134CDF23 504DC871 2DE5CE55
585DC8A6 253BB0D9 637C87A2 D8D0BA85
AAE574AD BA7D6DA9 2B9773F2 324C5DEF
17830A4E FBCF9D1D 182406E9 F883EA87
E585BBA1 2538C270 E2E857C2 194283CA
7234FF9E D0392F93 1D16E021 F1914917
63909E12 203C0169 3F08FFC8 86D06EA8
73DDAEF0 AC559F30 A6A67947 B60104C6
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Peter Halliday
Single User License
EA7E-855988
3997BFF0 2856413A 7A555954 67069B78
06D8CE12 63EAF079 AD039757 79E16D13
C555AD90 465CBE53 10F6DFC4 D3A3C611
411106F8 0CFEB15F 0A7BB891 111F5ED2
C6AA8429 77913528 FA6291A9 B88D4550
F1D6AB13 BF9153BC 91B4DFFE D296CFE0
C1D8EB22 13D5F14E 75A699EC 49EDDC23
D89D0F9B D240B10A A3712467 09DE7870
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Fred Zirdung
Single User License
EA7E-844672
6089C0EC 22936E1A 1EADEBE2 B8654BBA
5C98FFA6 C0FD1599 0364779B 071C74FB
EEFE9EAB 92B3D867 CD1B32FE D190269F
6FC08F8F 8D24191D 32828465 942CE58E
AECE5307 08B62229 D788560A 6E0AAC4B
48A2D9EE 24FD8CAA 07BEBDF2 28EA86D4
CCB96084 6C34CAD2 E8A04F39 3B5A3CBC
3B668BB7 C94D0B4B 847D6D7F 4BC07375
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Wixel
Single User License
EA7E-848235
103D2969 8700C7ED 8173CF61 537000C0
EB3C7ECB 5E750F17 6B42B67C A190090B
7669164F C6F371A8 5A1D88D5 BDD0DA70
C065892B 7CC1BB2B 1C8B8C7C F08E7789
7C2A5241 35F86328 4C8F70D9 C023D7C2
11245C36 59A730DB 72BDB9A7 D5B20304
90E90E72 9F08CA25 73F49C20 179D938E
5BC8BEDA 13457A69 39E6265F 233767F9
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Daniel Russel
Single User License
EA7E-917420
9327EC62 44020C2A 45172A68 12FE13F1
1D22245B 680892EE F551F8EB C183D032
8B4EDB4B 479CB7E4 07E42EDD A780021D
56BADF42 AC05238B 023B47B1 EBA1B7DE
6DF9A383 159F32AE 04EBE100 1278B1D2
52E81B60 C68AA2E8 F84A20BE FE7990EB
5D44E4B6 16369263 1DDAACBC 280FF19E
86CF4319 0B8615A8 4FF0512E B123B8EC
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Peter Eriksson
Single User License
EA7E-890068
8E107C71 3100D6FC 2AC805BF 9E627C77
72E710D7 43392469 D06A2F5B F9304FBD
F5AB4DB2 7A95F172 FE68E300 42745819
E94AB2DF C1893094 ECABADC8 71FEE764
20224821 3EABF931 745AF882 87AD0A4B
33C6E377 0210D712 CD2B1178 82601542
C7FD8098 F45D2824 BC7DFB38 F1EBD38A
D7A3AFE0 96F938EA 2D90BD72 9E34CDF0
------ END LICENSE ------
 
----- BEGIN LICENSE -----
Ryan Clark
Single User License
EA7E-812479
2158A7DE B690A7A3 8EC04710 006A5EEB
34E77CA3 9C82C81F 0DB6371B 79704E6F
93F36655 B031503A 03257CCC 01B20F60
D304FA8D B1B4F0AF 8A76C7BA 0FA94D55
56D46BCE 5237A341 CD837F30 4D60772D
349B1179 A996F826 90CDB73C 24D41245
FD032C30 AD5E7241 4EAA66ED 167D91FB
55896B16 EA125C81 F550AF6B A6820916
------ END LICENSE ------



--no--
=======
>>>>>>> 6248ce492c51e654f7b9bd279be549212211986d
----- BEGIN LICENSE ----
Andrew Weber
Single User License
EA7E-855605
813A03DD 5E4AD9E6 6C0EEB94 BC99798F
942194A6 02396E98 E62C9979 4BB979FE
91424C9D A45400BF F6747D88 2FB88078
90F5CC94 1CDC92DC 8457107A F151657B
1D22E383 A997F016 42397640 33F41CFC
E1D0AE85 A0BBD039 0E9C8D55 E1B89D5D
5CDB7036 E56DE1C0 EFCC0840 650CD3A6
B98FC99C 8FAC73EE D2B95564 DF450523
------ END LICENSE ------

-----BEGIN LICENSE-----
XiuMu
Unlimited User License
EA7E-10380
642B276AFB7276D8B84DB9D0619754F1
11ED3EA65788A6AA120806E990257926
791E2A831C0A78647F4E3770D5D826FC
F6164FA721FF5BF369C021ED14788990
36494B4177E8716ED11B49C957D87E82
3FC228AD15751332C116946F80A28210
9BA08C8482E2B244728712B688378012
24107C9344081E4E610458AC453199E4
-----END LICENSE-----
```



