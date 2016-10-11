#powershell
---
#doc
[powershell](https://technet.microsoft.com/zh-cn/library/bb978526.aspx)
#版本
$PSVersionTable.PSVersion

---
#变量
##定义
不需要定义或声明数据类型
在变量前加"$"
定义变量的规则
  -变量可以是数字 $123
  -变量可以是字符串 $abc
  -变量可以是特殊字符 ${@1b}
##内置的变量
   -$pshome
   -$home
   -$profile
##变量赋值
$var=123  $var="aaaaaa"
##取变量值
$var
变量赋值方法:Set-Variable var 100
取值方法:    Get-Variable var
清空值:      Clear-Variable var
删除变量     Remove-Variable var
取多个变量如var1 var2 var3地值:   Get-Variable var*

另一种赋值方法 $var1="bbb"    $var2="$var $var1"  结果$var2="aaaaaa bbb"
               $var2='$var $var1' 结果$var2="$var $var1"
$date=Get-Date  获取当前时间
$date.AddDays(3) 当前时间加3天

---
#powershell rc
$ps_script_dir = "c:\path\to\scripts"

##profile
不存在则 new-item -path $profile -itemtype file -force命令来创建

然后再使用notepad $profile来快捷的打开它来编辑。
在里面输入function pro { notepad $profile }
```
function pro { notepad $profile }
$PRL="D:\project"
$DOC="$PRL\document"
Set-Alias -Name vi -Value sublime_text.exe
```

```
function Get-ShortPath($Path)
{
    $code = @'
    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError=true)]
    public static extern uint GetShortPathName(string longPath,
    StringBuilder shortPath,uint bufferSize);
'@
    $API = Add-Type -MemberDefinition $code -Name Path -UsingNamespace System.Text -PassThru
    $shortBuffer = New-Object Text.StringBuilder ($Path.Length * 2)
    $rv = $API::GetShortPathName( $Path, $shortBuffer, $shortBuffer.Capacity )
    if ($rv -ne 0)
    {
        $shortBuffer.ToString()
    }
    else
    {
        Write-Warning "Path '$path' not found."
    }
}

Function Prompt()
{
    switch ($PSPromptMode)
    {
        'C'
        {
          "$($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
        }

        'A'
        {
          '> '
        }

        'N'
        {
          ' '
        }
        'S'
        {
         'PS> '
        }
        Default
        {
         "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
        }
    }
}

Function Set-Prompt
{
    param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('N','C','A','S','M', IgnoreCase = $true)]
    $Mode
    )
    $varPSPromptMode = (Get-Variable 'PSPromptMode'  -ea SilentlyContinue)
    #配置变量不存在则新建
    if ( $varPSPromptMode -eq $null)
    {
        New-Variable -Name 'PSPromptMode' -Value $Mode -Scope 'Global'
        $varPSPromptMode = Get-Variable -Name 'PSPromptMode'
        $varPSPromptMode.Description = '提示函数配置变量'

        #限制配置变量的取值集合
        $varPSPromptModeAtt = New-Object System.Management.Automation.ValidateSetAttribute('N','C','A','S','M')
        $varPSPromptMode.Attributes.Add($varPSPromptModeAtt)

        #限制配置变量为只读并且可以贯穿所有作用域ls
        $varPSPromptMode.Options = 'ReadOnly, AllScope'

    }
    #更新配置
    #只读变量可以通过-force选项更新值
    Set-Variable -Name PSPromptMode -Value $Mode -Force
}
```
提示符
http://www.codeweblog.com/%E8%87%AA%E5%AE%9A%E4%B9%89powershell%E6%8E%A7%E5%88%B6%E5%8F%B0%E6%8F%90%E7%A4%BA%E7%AC%A6%E9%A3%8E%E6%A0%BC%E7%9A%84%E6%96%B9%E6%B3%95/


#环境变量
$env:Path


----
#排序用法
Get-Process | Sort-Object ws   根据WS值由小到大排序
Get-Process | Sort-Object | fl    Get-Process | Sort-Object | Format-List  以列表形式显示数据

#导入导出文件
Get-Process > c:/aa.txt
Get-Process | Export-Clixml c:/ddd.xml  将命令执行结果导出到xml文件中
Import-Clixml c:/ddd.xml  将xml文件导出到控件台

#注释使用
Get-Proccess | #这里写注释信息
sort ws

#比较运算符
$var="abc"
$var -like "&b&"  返回true
$var -clike "&b&"   返回true

#函数使用
案例:在一个脚本文件中有如下代码:

$var1=10
function one{"The Variable is $var1"}
function two{$var1=20;one}
one 
two
one
执行结果: The Variable is 10
     The Variable is 20
          The Variable is 10
此示例表明,在函数中改变变量值并不影响实际值
若需改变其值请看如下代码:
$var1=10
function one{"The Variable is $var1"}
function two{$Script:var1=20;one}
one 
two
one
执行结果: The Variable is 10
     The Variable is 20
          The Variable is 20

 
---
#语法
##freach使用
$var=1..6  #定义数组
foreach($i in $var)
{
   $n++
   Write-Host "$i"
}
Write-Host "there were $n record"

##if
Get-Service | foreach{
  if($_.status -eq "running"){
     Write-Host $_.displayname  "("$_status")" -foregroundcolor "green"
  }
  else
  {
     Write-Host $_.displayname  "("$_status")" -foregroundcolor "red"
  }
}

##error使用
```shell
function one
{
   Get-Process -ea stop
   Get-ChildItem ada -ErrorAction stop  #此句有误
   Get-Process -ErrorAction stop
}
one
```
-ea 定义当错误发生以后该如何继续执行
$?可以测试命令执行成功还是失败,成功则结果为true 反之为false

##单步调试
先设置Set-PSDebug -step
for($i=1;$i -le 10;$i++)
{
  Write-Host "loop number $i"
}


---
#alias
##查看
Get-Alias -name ls
Get-Alias
Set-Alias -Name Edit -Value notepad
Set-Alias -Name vi -Value sublime_text.exe
del alias:Edit







