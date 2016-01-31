#LaTex
---
#setup
方法A-自助
MikTeX的官网下载免费的MikTeX编译包并安装
下载WinEdt（收费）或TexMaker（免费）等编辑界面软件并安装。
方法B-打包
在ctex.org下载ctex套装（含MikTeX及WinEdt）
---
```latex
\documentclass{article}
\begin{document}
hello, world
\end{document}
```

---
#语法
##基本结构
\documentclass{article}     #标题
\author{My Name}            #作者
\begin{document}            #
\tableofcontents            #目录
\section{Hello China} China is in East Asia.                    #章节
\subsection{Hello Beijing} Beijing is the capital of China.
\subsubsection{Hello Dongcheng District}
\paragraph{Hello Tian'anmen Square}is in the center of Beijing  #段落
\subparagraph{Hello Chairman Mao} is in the center of Tian'anmen Square
\paragraph{Sun Yat-sen University} is the best university in Guangzhou.
\end{document}

##换行
\\ start a new paragraph.       
\\* start a new line but not a new paragraph.
\- OK to hyphenate a word here.
\cleardoublepage flush all material and start a new page, start new odd numbered page.
\clearpage plush all material and start a new page.
\hyphenation enter a sequence pf exceptional hyphenations.
\linebreak allow to break the line here.
\newline request a new line.
\newpage request a new page.
\nolinebreak no line break should happen here.
\nopagebreak no page break should happen here.
\pagebreak encourage page break.


---
#数学公式
[公示表](http://www.mohu.org/info/symbols/symbols.htm)
###基本形式
$$F=ma$$
\[F=ma\]
###希腊字母 
$\eta$ and $\mu$

###分数 
\frac{...}{...} 排版
一般来说，1/2 这种形式更受欢迎，因为对于少量的分式，它看起来更好些
$1\frac{1}{2}$~hours
$\frac{ x^{2} }{ k+1 } \qquad
x^{ \frac{2}{k+1} } \qquad
x^{ 1/2 }
$
###幂^ /下标_ /不等号\neq
$a^b \neq e^{-\alpha t}_{ij}$ \qquad
$a_b$
###平方根
平方根（square root）的输入命令为：\sqrt，n 次方根相应地为: \sqrt[n]
方根符号的大小由LATEX自动加以调整。也可用\surd 仅给出符号
$\sqrt{x}$ \qquad
$\sqrt{ x^{2}+\sqrt{y} }$ \qquad
$\sqrt[3]{2}$ \\[3pt] $\surd[x^2+y^2]$
###上下水平线
\overline 和\underline 在表达式的上、下方画出水平线
$\overline{m+n}$ \qquad
$\underline{m+n}$
###上下大括号
\overbrace 和\underbrace 在表达式的上、下方给出一水平的大括号
$\underbrace{ a+b+\cdots+z}_{26}$


###向量 
上方有小箭头（arrow symbols）的变量，由\vec 得到
另两个命令\overrightarrow 和\overleftarrow在定义从A 到B 的向量时非常有用
\begin{displaymath}
\vec a\quad\overrightarrow{AB}
\end{displaymath}
$\vec a\quad\overrightarrow{AB}$

###积分
上限和下限用^ 和_来生成，类似于上标和下标
积分运算符（integral operator）用\int 来生成       
$\int_{0}^{\frac{\pi}{2}} $         
求和运算符（sum operator）由\sum 生成     
$\sum_{i=1}^{n}$        
乘积运算符（product operator）由\prod 生成
$\prod_\epsilon$

###微分
?读作round 法国人发明的
$\frac{d^{2}y}{dx^{2}}$

###偏导数
$\frac{\partial y}{\partial t} $


###加粗 
$\mathbf{n}$
###点 
$\dot{F}$

###矩阵 
(lcr here means left, center or right for each column)
\[
\left[
\begin{array}{lcr}
a1 & b22 & c333 \\
d444 & e555555 & f6
\end{array}
\right]
\]

###方程
here \& is the symbol for aligning different rows
\begin{align}
a+b&=c\\
d&=e+f+g
\end{align}

###方程组
\[
\left\{
\begin{aligned}
&a+b=c\\
&d=e+f+g
\end{aligned}
\right.
\]




##测试
This expression $\sqrt{3x-1}+(1+x)^2$ is an example of a $\LaTeX$ inline equation. 
he Lorenz Equations:
$$
\begin{aligned}
\dot{x} & = \sigma(y-x) \\
\dot{y} & = \rho x - y - xz \\
\dot{z} & = -\beta z + xy
\end{aligned}
$$













