# sublime text 3 settings
---
#Key binding
### line 
#### mouse
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
#### keyboard
OS X
Ctrl + Shift + Up
Ctrl + Shift + Down
Windows
Ctrl + Alt + Up
Ctrl + Alt + Down
Linux
Ctrl + Alt + Up
Ctrl + Alt + Down

### General
	* ↑↓←→ ：上下左右移动光标，注意不是不是 KJHL ！
	* Alt ：调出菜单
	* Ctrl + Shift + P ：调出命令板（Command Palette）
	* `Ctrl + “：调出控制台

### Editing
	* Ctrl + Enter ：在当前行下面新增一行然后跳至该行
	* Ctrl + Shift + Enter ：在当前行上面增加一行并跳至该行
	* Ctrl + ←/→ ：进行逐词移动
	* Ctrl + Shift + ←/→ 进行逐词选择
	* Ctrl + ↑/↓ 移动当前显示区域
	* Ctrl + Shift + ↑/↓ 移动当前行
### Selecting
	* Ctrl + D ：选择当前光标所在的词并高亮该词所有出现的位置，再次Ctrl + D 选择该词出现的下一个位置，在多重选词的过程中，使用Ctrl + K 进行跳过，使用 Ctrl + U 进行回退，使用 Esc 退出多重编辑
	* Ctrl + Shift + L ：将当前选中区域打散
	* Ctrl + J ：把当前选中区域合并为一行
	* Ctrl + M ：在起始括号和结尾括号间切换
	* Ctrl + Shift + M ：快速选择括号间的内容
	* Ctrl + Shift + J ：快速选择同缩进的内容
	* Ctrl + Shift + Space ：快速选择当前作用域（Scope）的内容
### Finding&Replacing
	* F3 ：跳至当前关键字下一个位置
	* Shift + F3 ：跳到当前关键字上一个位置
	* Alt + F3 ：选中当前关键字出现的所有位置
	* Ctrl + F/H ：进行标准查找/替换，之后：
	* Alt + C ：切换大小写敏感（Case-sensitive）模式
	* Alt + W ：切换整字匹配（Whole matching）模式
	* Alt + R ：切换正则匹配（Regex matching）模式
	* Ctrl + Shift + H ：替换当前关键字
	* Ctrl + Alt + H ：替换所有关键字匹配
	* Ctrl + Shift + F ：多文件搜索&替换

### Jumping
	* Ctrl + P ：跳转到指定文件，输入文件名后可以：
	* @ 符号跳转：输入 @symbol 跳转到 symbol 符号所在的位置
	* # 关键字跳转：输入 #keyword 跳转到 keyword 所在的位置
	* : 行号跳转：输入 :12 跳转到文件的第12行。
	* Ctrl + R ：跳转到指定符号
	* Ctrl + G ：跳转到指定行号

### Window
	* Ctrl + Shift + N ：创建一个新窗口
	* Ctrl + N ：在当前窗口创建一个新标签
	* Ctrl + W ：关闭当前标签，当窗口内没有标签时会关闭该窗口
	* Ctrl + Shift + T ：恢复刚刚关闭的标签
	* 屏幕（Screen）
	* F11 ：切换普通全屏
	* Shift + F11 ：切换无干扰全屏
	* Alt + Shift + 2 ：进行左右分屏
	* Alt + Shift + 8 ：进行上下分屏
	* Alt + Shift + 5 ：进行上下左右分屏
	* 分屏之后，使用 Ctrl + 数字键 跳转到指定屏，使用Ctrl + Shift + 数字键 将当前屏移动到指定屏


---
#peference备份
###settings
"font_face": "Courier New",
```
{
    "auto_complete": false,
    "caret_style": "solid",
    "color_scheme": "Packages/User/SublimeLinter/Monokai (SL).tmTheme",
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
    "font_size": 12,
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
```
[
    { "keys": ["alt+m"], "command": "markdown_preview", "args": { "target": "browser"} },
    { "keys": ["ctrl+right"], "command": "next_view" },
    { "keys": ["ctrl+left"], "command": "prev_view" },
    { "keys": ["ctrl+shift+enter"], "command": "open_in_browser" }
]

```

###markdown
markdown editing
```
{
	"line_numbers": true,
	"highlight_line": true
}
```

## package control安装
* 简单的安装方法

使用```Ctrl+` ```快捷键或者通过View->Show Console菜单打开命令行，粘贴如下代码：
`
import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())
`
 
如果顺利的话，此时就可以在Preferences菜单下看到Package Settings和Package Control两个菜单了。
顺便贴下Sublime Text2 的代码：
`
import urllib2,os; pf='Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler( ))); open( os.path.join( ipp, pf), 'wb' ).write( urllib2.urlopen( 'http://sublime.wbond.net/' +pf.replace( ' ','%20' )).read()); print( 'Please restart Sublime Text to finish installation')
`

* 手动安装

可能由于各种原因，无法使用代码安装，那可以通过以下步骤手动安装Package Control：
1.点击Preferences > Browse Packages菜单
2.进入打开的目录的上层目录，然后再进入Installed Packages/目录
3.下载Package Control.sublime-package并复制到Installed Packages/目录
4.重启Sublime Text。

### 全程指南
http://www.tuicool.com/articles/AJR7Rn3

---
#plugins packages 插件
##view in browser
快捷键配置：
```
{ "keys": ["ctrl+shift+enter"], "command": "open_in_browser" }
```

## vi扩展
Vintageous
配置
http://feliving.github.io/Sublime-Text-3-Documentation/vintage.html
启用
"ignored_packages": [""]
默认命令模式
 "vintage_start_in_command_mode": true

##转码
* ConvertToUTF8 
* GBK Encoding Support

##窗口布局
SublimeREPL

##语法补全
SublimeCodeIntel

##SublimeLinter
语法检查

##Emmet
- "Emmet (ex-Zen Coding) for Sublime Text."
语法速查 http://docs.emmet.io/cheat-sheet/

##Doc​Blockr
"Simplifies writing DocBlock comments in Javascript, PHP, CoffeeScript, Actionscript, C & C++."

##Emmet Css Snippets
- "Emmet CSS completions for Sublime Text."

##Bootstrap 3 Snippets
Twitter Bootstrap 3 Snippets Plugin for Sublime Text

##Better Completion
- "Better auto-completion for Sublime Text."

##All Autocomplete
- "Extend Sublime text autocompletion to find matches in all open files of the current window."

##Auto​File​Name
- "Sublime Text plugin that autocompletes filenames."

##j​Query
- "Sublime Text package bundle for jQuery."

##Markdown Preview
快捷键配置
[
	{ "keys": ["alt+m"], "command": "markdown_preview", "args": { "target": "browser"} }
]


##Js​Format
自动格式调整 
- "Javascript formatting for Sublime Text."

##HTMLBeautify
- "A plugin for Sublime Text that formats (indents) HTML source code. It makes code easier for humans to read."
Mac OS X: Command-Option-Shift-F
Windows: ctrl-Alt-Shift-F
Linux: ctrl-Alt-Shift-F

##ctag
brew install ctags
配置：
command配置项，为ctags的可执行文件路径/usr/local/bin/ctags
win _CTags binary: http://prdownloads.sourceforge.net/ctags/ctags58.zip
```
{
	"command": "C:\\opt\\ctags58\\ctags.exe"
	"command": "D:\\yp\\ubin\\ctags58\\ctags.exe"
}
D:\\yp\\ubin\\ctags58\\ctags.exe
```
mouse binding: 去掉shift,可以左键+点击


##SideBarEnhancements
- "Enhancements to Sublime Text sidebar, Files and folders."

##View In Browser
- "Open the contents of your current view/tab in a web browser."

##AutoBackups
- "Backup file every time you save or open (if backup file not exists) it."

##Plain​Tasks
- "An opinionated todo-list plugin for Sublime Text."


##Soda[Theme]
- "Dark and light custom UI themes for Sublime Text."
##Monokai Extended[Theme]
如果你喜欢 Soda Dark 和 Monokai，我建议你使用 Monokai Extended (GitHub)。这个 color scheme 是 Monokai Soda 的增强，如果再配合 Markdown Extended (GitHub)，将大大改善 Markdown 的语法高亮。


## license

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
