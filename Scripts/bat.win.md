#bat
---
#setting
##font
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont
每加一种字体要多加一个0
如
00为Consolas
增加000为Source Code Pro
增加0000为Anoymous Pro
cmd输入
chcp 850
Active code page: 850
因为cmd默认使用936 gb编码
[所有编码](https://msdn.microsoft.com/en-us/library/dd317756(VS.85).aspx)


##乱码
cmd命令行窗口显示中文乱码，多是因为cmd命令行窗口字符编码不匹配导致。
修改cmd窗口字符编码为UTF-8，命令行中执行：chcp 65001
切换回中文：chcp 936
这两条命令只在当前窗口生效，重启后恢复之前的编码。
切换cmd窗口字符编码有风险，例如切换过以后中文显示乱码，并且不能永久切换回原来模式，只能每次chcp 936。
cmd中文显示乱码永久解决方案，以切换回中文936为例：
打开不正常的 CMD命令提示符窗口后,单击窗口左上角的图标，选择弹出的菜单中的“默认值”，切换到第一个“选项”tab,将默认的代码页改为 936 后重启 CMD。重启cmd后还不能正常显示请继续往下看。
如果重启 CMD以后无法生效：窗口的“默认值”和“属性”没变，则进入注册表，在 HKEY_CURRENT_USER\Console下找到%SystemRoot%_system32_cmd.exe（如果没有codepage就不考虑了），codepage值改为 936（十进制）或 3a8（十六进制）。
936(十进制)是简体中文的，如是其它语言，则改为对应的代码。
部分字符编码对应代码：
65001——UTF-8
936——简体中文
950——繁体中文
437——美国/加拿大英语
932——日文
949——韩文
866——俄文
最后一个乱码原因：CMD 的“默认值”或“属性”窗口的“字体”选项卡中设定为可以显示中文字符的字体，并且确定字体文件没有被破坏，字体最好设置为默认的点阵字体。


---
#语法
##注释
1、:: 注释内容（第一个冒号后也可以跟任何一个非字母数字的字符）
2、rem 注释内容（不能出现重定向符号和管道符号）
3、echo 注释内容（不能出现重定向符号和管道符号）〉nul
4、if not exist nul 注释内容（不能出现重定向符号和管道符号）
5、:注释内容（注释文本不能与已有标签重名）
6、%注释内容%（可以用作行间注释，不能出现重定向符号和管道符号）
7、goto 标签 注释内容（可以用作说明goto的条件和执行内容）
8、:标签 注释内容（可以用作标签下方段的执行内容）

##alias
@doskey ls=dir /b $*
@doskey l=dir /od/p/q/tw $*
@doskey ping=ping -t $*
解释：doskey就相当于Linux中的alias，等于号左边是其右边的别名，$*表示这个命令还可能有其他参数，@表示执行这条命令时不显示这条命令本身

##cmdrc
reg add "HKLM\Software\Microsoft\Command Processor" /v "AutoRun" /t REG_SZ /d "D:\yp\documents\Scripts\bashrc\cmdrc.bat" /f

---
#变量
查看
set 变量名
set 变量名=变量内容
追加
set 变量名=%变量名%;变量内容

##环境变量
%ALLUSERSPROFILE%   | 局部 | 返回所有“用户配置文件”的位置。
%APPDATA%           | 局部 | 返回默认情况下应用程序存储数据的位置。
%CD%                | 局部 | 返回当前目录字符串。
%CMDCMDLINE%        | 局部 | 返回用来启动当前的 Cmd.exe 的准确命令行。
%CMDEXTVERSION%     | 系统 | 返回当前的“命令处理程序扩展”的版本号。
%COMPUTERNAME%      | 系统 | 返回计算机的名称。
%COMSPEC%           | 系统 | 返回命令行解释器可执行程序的准确路径。
%DATE%              | 系统 | 返回当前日期。使用与 date /t 命令相同的式。由 Cmd.exe 生成。有关 date 命令的详细信息，请参阅 Date。
%ERRORLEVEL%        | 系统 | 返回最近使用过的命令的错误代码。通常用非零表示错误。
%HOMEDRIVE%         | 系统 | 返回连接到用户主目录的本地工作站驱动器号。基于主目录的设置。用户主目录是在“本地用户和组”中指定的。
%HOMEPATH%          | 系统 | 返回用户主目录的完整路径。基于主目录的设置。用户主目录是在“本地用户和组”中指定的


---
#print
echo ''
echo on/off
#file
del
copy
powershell set-executionpolicy remotesigned -force
powershell xx.ps1

#other
@pause

#network
主机名
hostname




---
#powershell
Get-WmiObject -Class Win32_Product
Select-Object -Property Name
重定向 >>



