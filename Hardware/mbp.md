#mac book
---
[Mac OS X使用技巧汇总页面](http://www.elias.cn/Mac/OSXTips#monitor)

---
#外接第三方显示器字体模糊、偏色问题
MacBook Air 外接第三方显示器，其效果几乎可以用支离破碎来形容，文字扭曲得看不清楚，颜色也不正。同样一个应用程序窗口，从笔记本自带显示器拖到外接的，立即觉得模糊到没法儿看了（啊，我可怜的眼睛。。）。其实这是 OSX 10.6 开始的一个 Bug ，OSX 有时候会把外接显示器识别成电视机，然后用 YCbCr 色域来输出，而不是用液晶显示器标准的 RGB 。并且 OSX 会在外接显示器上自动关闭字体平滑，从而导致图片显示清晰、文字模模糊糊。（常见于 HDMI 接口，DisplayPort 则几乎没有这个问题。）
可以这样来绕过这个问题（原文参考 [Force RGB mode in Mac OS X to fix the picture quality of an external monitor](http://www.ireckon.net/2013/03/force-rgb-mode-in-mac-os-x-to-fix-the-picture-quality-of-an-external-monitor/comment-page-6#comment-10104) ）：
下载这个文件：Attach:patch-edid.zip
解压，得到 patch-edid.rb
只启用外接显示器（也就是说 MacBook 的屏幕得合上，变成外接显示器单个屏幕显示的模式），因为这个脚本会生成所有当前正在使用的显示器的配置文件。
在命令行终端下键入如下命令：
ruby patch-edid.rb
[Get Code]
终端当前目录下会生成长得像 “DisplayVendorID-1e6d” 这样的文件夹
把生成的文件夹统统拷贝到 /System/Library/Displays/Overrides 目录下，如果对应目录下已经存在同名文件夹，建议先备份。以及拷贝的过程中应该会用到 sudo 权限。
拔掉外接显示器，再重新插上，新的配置应该就生效了，显示应该已经正常多了。这时在“系统偏好设定”的“显示器”面板中，外接显示器的名字应该会带有“(EDID override)”字样。
如果上一步不成，那么可能需要重启系统，然后再重新插拔显示器。
检查一下显示器硬件自身的配置选项，确保显示器工作在 PC 模式，并且使用 RGB 颜色体系（有些显示器是能把自己当电视用的，所以我们检查一下设置，确保它知道自己连的是 PC ）
好吧，大功告成了，现在外接显示器的显示效果应该跟 MacBook 自带屏幕差不多了。
另外，以前还传说过另外一个在外接显示器强制开启字体平滑的方法，我觉得不彻底解决问题，不过还是列在这里参考（原文参考 MacBook 外接第三方显示器字体发虚 以及 Change Font Smoothing Settings in Mac OS X ）：
在命令行终端下输入
defaults -currentHost write -globalDomain AppleFontSmoothing -int 2
[Get Code]
其中的数字 2 表示中度平滑，还可以写 1 表示轻度、写 3 表示重度
然后重启系统、拔掉外接显示器再重新插上（好吧，我不清楚到底应该怎么弄，各种文档说法不一致，总之就这几种可能）
这时候外接显示器的字体应该稍微舒服点儿了

---








