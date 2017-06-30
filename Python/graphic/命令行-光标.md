
[Curses Programming with Python](https://docs.python.org/2/howto/curses.html)
[Python：Curses 编程](http://www.ibm.com/developerworks/cn/linux/sdk/python/python-6/)




获取命令行窗口或终端的宽度和高度
import os
os.system('echo $LINES') # heigth
os.system('echo $COLUMNS') # width

（1）clear
这个命令将会刷新屏幕，本质上只是让终端显示页向后翻了一页，如果向上滚动屏幕还可以看到之前的操作信息。一般都会用这个命令。
（2）reset
这个命令将完全刷新终端屏幕，之前的终端输入操作信息将都会被清空，这样虽然比较清爽，但整个命令过程速度有点慢，使用较少。
（3）另外介绍一个用别名来使用清屏命令的方法，如下：
[root@localhost ~]$ alias cls='clear'
 [root@localhost ~]$ cls




