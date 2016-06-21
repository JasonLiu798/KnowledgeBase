#Common tools
---
#docs
[知乎软件神器推荐](https://weavi.com/92079)

---
#mac
```bash
brew install
brew list           列出已安装的软件
brew update     更新brew
brew home       用浏览器打开brew的官方网站
brew info         显示软件信息
brew deps        显示包依赖
brew edit xxx  编辑url
brew link xxx
```
改键
https://pqrs.org/osx/karabiner/
##openssl
./Configure darwin64-x86_64-cc --prefix=/usr/local/openssl

---
#sys系统
##linux
[nmon](http://nmon.sourceforge.net/pmwiki.php)
##mac
⌘——Command ()
⌃ ——Control
⌥——Option (alt)
⇧——Shift
⇪——Caps Lock
fn——功能键就是fn

##mac字典
/Library/Dictionaries

##disk磁盘
CCleaner：全球下载超过1000万次的磁盘清理工具；
Defraggler：磁盘整理；
Recuva：数据恢复
Speccy：电脑硬件信息。



---
#net网络
##下载
[youtube-dl](http://bbs.feng.com/read-htm-tid-8856281-page-1.html)


---
#editor编辑器
## sublime text
## git gui tool
p4merge http://www.perforce.com/downloads/helix
##markdown
[flowchart](https://github.com/knsv/mermaid)
[win-mdp](https://tylingsoft.com/mdp)
[mac-Mou]()


---
#前端
[全新理念的Web前端开发方式——AlloyDesigner](http://www.alloyteam.com/2014/03/alloydesigner-lai-zi-xing-xing-di-web-qian-duan-kai-fa-fang-shi/)
[AlloyDesigner](http://alloyteam.github.io/AlloyDesigner/)


---
#加解密
##GPG
https://www.gnupg.org/



---
#字体 font
微软雅黑    Microsoft YaHei


----
#其他
##时间管理
WorkRave
[](http://www.mifengtd.cn/articles/body-mechanics-and-workrave.html)
##省市区sql,mysql
http://blog.csdn.net/whzhaochao/article/details/37969145


---
#PM项目管理
[甘特图](https://www.zhihu.com/question/21493972)

#python ide
[ALL](http://www.jetbrains.com/pycharm)

##project 
[Microsoft Project 2010](http://download.microsoft.com/download/4/3/6/43668FB2-E9F4-456B-AF81-F33FC58C63CB/ProjectProfessional.exe)
```
推荐：8XWTK-7DBPM-B32R2-V86MX-BTP8P
8XWTK-7DBPM-B32R2-V86MX-BTP8P
MVR3D-9XVBT-TBWY8-W3793-FR7C3
26K3G-RGBT2-7W74V-4JQ42-KHXQW
D4HF2-HMRGR-RQPYJ-WGD4G-79YXM
XB62K-YMC83-MMDWB-HK264-M68MK
V239V-F39D3-3VPPM-JMHJJ-QJGCF
CMWV4-2D83Y-PHYMG-DFX73-QPGQC
7TCB4-6DVYG-P4KVX-TV97T-G9H74
C44YG-8BM4M-9RTJM-VJCTD-WKVYT
YG64T-FDD7J-P6R3Q-4X4YV-7QGJP
```


-----
#DEV
[mac 程序员必备](http://www.zhihu.com/question/20036899)
##win 终端
[Developers can run Bash Shell and user-mode Ubuntu Linux binaries on Windows 10](http://www.hanselman.com/blog/DevelopersCanRunBashShellAndUsermodeUbuntuLinuxBinariesOnWindows10.aspx)

##iterm2
###zsh
```
zsh 设置 chsh -s /bin/zsh
zsh 高级 https://linuxtoy.org/archives/zsh.html
zsh 主题展示 https://github.com/robbyrussell/oh-my-zsh/wiki/themes
zsh 颜色 http://www.tuicool.com/articles/mu26Jb
zsh 介绍 http://zhuanlan.zhihu.com/mactalk/19556676
zsh 提示符配置 https://linuxtoy.org/archives/zsh-prompt.html http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
ls 颜色 http://blog.csdn.net/meegomeego/article/details/13092157
相关问题 http://www.cnblogs.com/bamanzi/p/zsh-simple-guide.html
go2shell配置 open -a go2shell --args config
```

配置备份~/Library/Preferences/com.googlecode.iterm2.plist
PANE
切换pane有默认设置 Cmd+[ 和 Cmd+] .但是新建tab是没有默认快捷键的，这个用户可以自己设置，在Preferences->Keys。
⌘ + d 横着分屏 / ⌘ + shift + d 竖着分屏
TAB
1⌘ + 数字在各 tab 标签直接来回切换
选择即复制 + 鼠标中键粘贴，这个很实用
⌘ + f 所查找的内容会被自动复制
终端通用
C+a / C+e 这个几乎在哪都可以使用
C+p / !! 上一条命令

⌘ + r = clear，而且只是换到新一屏，不会想 clear 一样创建一个空屏
ctrl + u 清空当前行，无论光标在什么位置
输入开头命令后 按 ⌘ + ; 会自动列出输入过的命令
⌘ + shift + h 会列出剪切板历史
9可以在 Preferences > keys 设置全局快捷键调出 iterm，这个也可以用过 Alfred 实现
我常用的一些快捷键
1⌘ + 1 / 2 左右 tab 之间来回切换，这个在 前面 已经介绍过了
2⌘← / ⌘→ 到一行命令最左边/最右边 ，这个功能同 C+a / C+e
3⌥← / ⌥→ 按单词前移/后移，相当与 C+f / C+b，其实这个功能在Iterm中已经预定义好了，⌥f / ⌥b，看个人习惯了
4好像就这几个。。囧
设置方法如下
C+k 从光标处删至命令行尾 (本来 C+u 是删至命令行首，但iterm中是删掉整行)
C+w A+d 从光标处删至字首/尾
C+h C+d 删掉光标前后的自负
C+y 粘贴至光标后
C+r 搜索命令历史，这个较常用

#java相关
## 性能
性能监控
Java Mission Control JMC
## 开发
[findbugs](http://findbugs.sourceforge.net)

##图像图形img
[markman 图像测量](http://www.getmarkman.com/)
freetype
    mac 
    ln -sfv /usr/local/Cellar/freetype/2.5.5/include/freetype2 /usr/local/include/freetype
    ln -sfv /usr/local/Cellar/freetype/2.5.5/lib/* /usr/local/lib
X11
    ln -sfv /opt/X11/include/X11 X11
zlib
    /usr/local/Cellar/zlib/1.2.8
    ln -sfv /usr/local/Cellar/zlib/1.2.8/include/* /usr/local/include
    ln -sfv /usr/local/Cellar/zlib/1.2.8/lib/* /usr/local/lib
LITTLECMS
```
brew install littlecms
ln -sfv /usr/local/Cellar/little-cms/1.19/include/* /usr/local/include
```
tesseract
```
brew install tesseract

```

##文档管理 
[mac-dash]()
[win-velocity](http://velocity.silverlakesoftware.com)
[win-zeal](https://zealdocs.org/download.html)

[mac-Valgrind-内存调试、内存泄漏检测以及性能分析](http://valgrind.org/)

-----
#SoftwareEngineer
##UML
[jude](http://jude.change-vision.com/jude-web/product/community.html)
[多平台](http://staruml.io/)
StarUML.app/Contents/www/license/node
[crack](http://www.360doc.com/content/15/1115/01/9437165_513270982.shtml)
```javascript
function validate(PK, name, product, licenseKey) {
        var pk, decrypted;
        // edit by 0xcb
        return {
            name: "0xcb",
            product: "StarUML",
            licenseType: "vip",
            quantity: "bbs.chinapyg.com",
            licenseKey: "later equals never!"
        };
//....
}
```



----
#shell终端
[shell json 处理](https://stedolan.github.io/jq/)
## mosh 异步ssh 
https://mosh.mit.edu/#getting
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
[iTerm 2]()

-----
#包管理
[ubuntu]
```
/etc/apt/sources.list
apt-get update #更新源

中科大的）：
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-updates main restricted
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-updates main restricted
deb http://mirrors.ustc.edu.cn/ubuntu/ precise universe
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise universe
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-updates universe
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-updates universe
deb http://mirrors.ustc.edu.cn/ubuntu/ precise multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-updates multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-updates multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse

比较快的源：
搜狐源：
deb http://mirrors.sohu.com/ubuntu/ precise-updates main restricted
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates main restricted
deb http://mirrors.sohu.com/ubuntu/ precise universe
deb-src http://mirrors.sohu.com/ubuntu/ precise universe
deb http://mirrors.sohu.com/ubuntu/ precise-updates universe
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates universe
deb http://mirrors.sohu.com/ubuntu/ precise multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-updates multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-backports main restricted universe multiverse
网易源：
deb http://mirrors.163.com/ubuntu/ precise-updates main restricted
deb-src http://mirrors.163.com/ubuntu/ precise-updates main restricted
deb http://mirrors.163.com/ubuntu/ precise universe
deb-src http://mirrors.163.com/ubuntu/ precise universe
deb http://mirrors.163.com/ubuntu/ precise-updates universe
deb-src http://mirrors.163.com/ubuntu/ precise-updates universe
deb http://mirrors.163.com/ubuntu/ precise multiverse
deb-src http://mirrors.163.com/ubuntu/ precise multiverse
deb http://mirrors.163.com/ubuntu/ precise-updates multiverse
deb-src http://mirrors.163.com/ubuntu/ precise-updates multiverse
deb http://mirrors.163.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ precise-backports main restricted universe multiverse
```


[mac-Homebrew]
homebrew常用
```bash
curl -LsSf http://github.com/mxcl/homebrew/tarball/master | sudo tar xvz -C/usr/local --strip 1

安装 ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
brew update
brew search xxx
brew doctor
brew update                        #更新brew可安装包，建议每次执行一下
brew search php55                  #搜索php5.5
brew tap josegonzalez/php          #安装扩展<gihhub_user/repo>
brew tap                           #查看安装的扩展列表
brew install php55                 #安装php5.5
brew remove  php55                 #卸载php5.5
brew upgrade php55                 #升级php5.5
brew options php55                 #查看php5.5安装选项
brew info    php55                 #查看php5.5相关信息
brew home    php55                 #访问php5.5官方网站

brew cask search        #列出所有可以被安装的软件
brew cask search php    #查找所有和php相关的应用
brew cask list          #列出所有通过cask安装的软件
brew cask info phpstorm #查看 phpstorm 的信息
brew cask uninstall qq  #卸载 QQ
brew options xxx     查看安装选项

brew uninstall xxx
```



## Guard livereload
automatically reload your browser when 'view' files are modified.
https://github.com/guard/guard-livereload

## Divvy

## Doo
文档管理工具
http://www.macupdate.com/app/mac/45860/doo

## Less.app
## MAMP


#app store
强制刷新
点击底部按钮10次以上



---
#效率工具
[all-pomodairo]()#efficient #番茄工作法
[mac-alfred-附加](http://www.alfredworkflow.com)

---
#game游戏
[win-改fov](http://www.flawlesswidescreen.org/#Download)
[资源修改器](http://www.portablesoft.org/restorator/)
[mac-winskin]()
[mac-winskin-辅助-THE PORTINGKIT](http://paulthetall.com/portingkit-2/)


----
#浏览器
##safari
[windows 同步 safari标签  iCloud（Windows 版)](http://support.apple.com/kb/DL1455?viewlocale=zh_CN&locale=zh_CN)
[safari-改造指南一-safari扩展-safari优化](http://bbs.waerfa.com/discussion/13/safari-改造指南一-safari扩展-safari优化)
###配置
字体修改
设置-

* {
    font-family: "Hiragino Sans GB" !important
}

###插件
[插件 official](https://safari-extensions.apple.com)
[Stylish for Safari](http://sobolev.us/stylish/)
    不同网站不同css
```css
body {
    zoom: 150%;
}
/*domain zhihu.com*/
```


###快捷键
cmd+D 添加到收藏夹 
切换到下一个标签页 – Control+Tab
切换到上一个标签页 – Control+Shift+Tab
向下滚动一屏 – 空格
向上滚动一屏 – Shift+空格
焦点移到地址栏 – Command+L
新增标签页 – Command+T
在新标签页打开链接 – Command+点按链接
将链接添加到阅读列表 – Shift+点按链接

阅读和查看网页的快捷键 7 个
去除格式，在阅读器中阅读 – Command+Shift+R
增大文字大小 – Command+加号
减小文字大小 – Command+减号
默认文字大小 – Command+0
进入或退出全屏 – Command+Escape
打开主页 – Command+Shift+H
邮寄当前页面的链接 – Command+Shift+I

缓存、载入页面、源代码和弹出窗口的快捷键 5 个
清空浏览器缓存 – Command+Option+E
重新载入页面 – Command+R
停止载入页面 – Command+.
查看页面源代码 – Command+Option+U
禁止弹出窗口 – Command+Shift+K

查找并在找到的项目中导航的快捷键 3 个
在页面上查找文字 – Command+F
向下浏览找到的项目 – 回车
向上浏览找到的项目 – Shift+回车

工具栏、历史记录和阅读列表的快捷键 8 个
隐藏或显示工具栏 – Command+i
隐藏或显示书签栏 – Command+Shift+B
隐藏或显示状态栏 – Command+/
隐藏或显示标签页栏 – Command+Shift+T
显示 Top Sites – Command+Option+1
显示历史记录 – Command+Option+2
显示阅读列表 – Command+Shift+L
显示下载内容 – Command+Option+L

附加多点触摸手势 4 个
后退 – 两指向左滑动
前进 – 两指向右滑动
缩小 / 减小文字大小 – 两指捏合
放大 / 增大文字大小 – 两指外张


----
#小工具
[罗马数字](http://www.novaroma.org/via_romana/numbers.html)




----
#效率
Find And Run Robot
Launchy



Guard livereload


Balasmiq mockups 最好的画ue工具
Minipicker 免费取色器
Free ruler 免费屏幕尺
Firefox/firebug

##Enterprise   architect8的注册码
Name:whitehouse.net.cn
Company:eric
注册码:{67SC0O95-SZPS-LIG2-YQ8Q-8D2N-KWTD-0W6R-TWDD-KT6RB-1J}



acrobat
1118-0497-5921-8734-9742-0242
1118-0732-7889-3385-4819-5335
1118-0833-3524-0475-2122-4564
1118-0413-0660-6186-6863-8213


---
#foxmail
##gmail
接收邮件 (IMAP) 服务器：    imap.gmail.com
要求 SSL：是
端口：993
发送邮件 (SMTP) 服务器：    smtp.gmail.com
使用身份验证：是
SSL 端口：465 或 587
设置与接收邮件服务器的设置相同




---
#linux
#[web压测](http://www.oschina.net/question/12_6110)
siege
    siege http://localhost:8000/?q=pants -c10 -t10s
    10秒内执行大约10个并发请求

    [download](http://soft.vpser.net/test/siege/siege-2.67.tar.gz)
    ./configure
    configure: error: cannot guess build type; you must specify one

ab

