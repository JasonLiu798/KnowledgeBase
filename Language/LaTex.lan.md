#LaTex
---
[LaTeX 各种命令，符号](http://blog.csdn.net/garfielder007/article/details/51646604)
#setup
方法A-自助
MikTeX的官网下载免费的MikTeX编译包并安装
下载WinEdt（收费）或TexMaker（免费）等编辑界面软件并安装。
方法B-打包
在ctex.org下载ctex套装（含MikTeX及WinEdt）
---
$$
\documentclass{article}
\begin{document}
hello, world
\end{document}
$$

##中文支持
MikTeX+WinEdt
把开头的\documentclass{atricle}换成\documentclass{ctexart}


---
#语法
##基本结构
$$
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
$$

##换行
$$
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
$$

##插入图片
$ \includegraphics[width=4.00in,height=3.00in]{figure1.eps} $

##表格
$$
\begin{table}
\caption{设置表格总长}
\begin{tabular*}{12cm}{|||}
\hline
Start & End & Character block name \\
\hline
3400  & 4DB5 & CJK Unified Ideographs Extension A \\  
4E00  & 9FFF & CJK Unified Ideographs \\  
\hline  
\end{tabular*}
\end{table}
$$

$$
\begin{tabular}{|c|c|}
\hline
a & b \\
\hline
c & d\\
\hline
\end{tabular}
$$

$$
\begin{tabular}{|c|c|}
\hline
a & b \\ \hline
c & d\\
\hline
\end{tabular}
$$

---
#数学公式
[公示表](http://www.mohu.org/info/symbols/symbols.htm)
[数学公式基本命令](http://hubl82.blog.163.com/blog/static/12676948520134510173383/)

## 放大缩小
\huge

##运算符
乘号，叉乘 \times
点乘 \cdot
异或 \oplus	\bigoplus
叉乘+圈 \otimes \bigotimes
除号 \div
小空圈 \circ
大黑点 \bullet
圈+点 \bigodot
正方形+叉 \boxtimes
正方形+加号 \boxplus

###基本形式
$$ F=ma $$
\[F=ma\]

###希腊字母 
$ \alpha \beta \gamma $
$ \delta \epsilon \zeta \eta \theta $
$ \iota \kappa\varkappa \lambda \mu \nu \xi \omicron\pi $
$ \rho \sigma \tau \upsilon \phi \chi \psi\omega $
$ \Epsilon \epsilon \varepsilon	 $
$ \Theta\theta\vartheta $
$ \Kappa \kappa \varkappa $

###分数 
\frac{...}{...} 排版
$$ 	\frac{2}{4}=0.5 $$
一般来说，1/2这种形式更受欢迎，因为对于少量的分式，它看起来更好些
$ 1 \frac{1}{2} $ ~hours
$ \frac{ x^{2} }{ k+1 } \qquad $
$ x^{ \frac{2}{k+1} } \qquad $
小型分数
$ \tfrac{2}{4} = 0.5 $
大型分数（嵌套）
$ \cfrac{2}{c + \cfrac{2}{d + \cfrac{2}{4}}} =a $
大型分数（不嵌套）
$ \dfrac{2}{c + \dfrac{2}{d +\dfrac{2}{4}}} = a $

###幂^  上标
$a^b$
###下标_ 

###不等号\neq
\neq e^{-\alpha t}_{ij}$ \qquad
$a_b$

\hat{x}

###平方根
平方根（square root）的输入命令为：\sqrt，n 次方根相应地为: \sqrt[n]
方根符号的大小由LATEX自动加以调整。也可用\surd 仅给出符号
$\sqrt{x}$ \qquad
$\sqrt{ x^{2}+\sqrt{y} }$ \qquad
$\sqrt[3]{2}$ \\[3pt] $\surd[x^2+y^2]$
###上下水平线
\overline 和 \underline 在表达式的上、下方画出水平线
$\overline{m+n}$ \qquad
$\underline{m+n}$
###上下大括号
\overbrace 和\underbrace 在表达式的上、下方给出一水平的大括号
$\underbrace{ a+b+\cdots+z}_{26}$


###向量 
上方有小箭头（arrow symbols）的变量
\vec{x}
从A 到B 的向量时 \overrightarrow 和\overleftarrow
\overrightarrow{a b}  
\overleftarrow{b a}
\widehat{e f g}

### 求和
独立公式
p = \sum_{n=1}^Na_n
行间公式
p = \sum_{n=1}^Na_n

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

### 导数


### 偏导数
$\frac{\partial y}{\partial t} $
∂


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

无括号矩阵
```latex
\begin{matrix}
x & y \\
z & v
\end{matrix}
```
单竖线边矩阵
```latex
\begin{vmatrix}
x & y \\
z & v
\end{vmatrix}
```
双竖线边矩阵
```latex
\begin{Vmatrix}
x & y \\
z & v
\end{Vmatrix}
```

方括号矩阵（常用）
```latex
\begin{bmatrix}
1 & 2 \\
3 & 4
\end{bmatrix}
```

圆括号矩阵
```latex
\begin{pmatrix}
1 & 2 \\
3 & 4
\end{pmatrix}
```‘

小圆括号矩阵
```latex
\bigl( \begin{smallmatrix}
a&b\\ c&d
\end{smallmatrix} \bigr)
```



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

##排列组合
```latex
$\binom{n}{k}$
```

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

---
#宏包
\package{}就是在调用宏包
每一个宏包里都定义了一些专门的命令，通过这些命令可以实现对于一类对象（如数学公式等）的统一排版（如字号字形），或用来实现一些功能（如插入图片或制作复杂表格）。
通常在\documentclass之后，在\begin{document}之前，将文章所需要涉及的宏包都罗列上

##常用的宏包
编辑数学公式的宏包：\usepackage{amsmath}和 \usepackage{amssymb}
编辑数学定理和证明过程的宏包：\usepackage{amsthm}
插入图片的宏包：\usepackage{graphicx}
复杂表格的宏包：\usepackage{multirow}

---
#模板
在\documentclass{}后面的大括号里的内容
LaTeX默认自带的模板article，以及中文模板ctexart
一个模板可以规定，section这个层级都用什么字体什么字号怎么对齐，subsection这个层级用什么字体什么字号怎么对齐，paragraph又用什么字体什么字号怎么对齐。

---
#参考文献和制作幻灯片
参考文献搜bibtex
制作幻灯片搜beamer


---
#各种符号
http://www.mohu.org/info/symbols/symbols.htm
无限  \infty

##希腊字母
\alpha  	Α	α
\beta 		Β	β
\gamma		Γ 	γ 	\Gamma
\delta		Δ 	δ 	\Delta	
\epsilon 	Ε 	ε 	\varepsilon
\zeta 		Ζ 	ζ
\eta 		Η	η
\theta 		Θ	θ 	 \vartheta \Theta
\iota		Ι	ι
\kappa 		Κ	κ
\lambda		Λ	λ
\mu 		Μ	μ
\nu 	 	Ν 	ν
\xi 		Ξ 	ξ 	\Xi
\omicron	Ο 	ο
\pi 		Π	π
\rho 		P   ρ ϱ 	\varrho 
\sigma		Σ 	σ ς
\tau 		Τ 	τ
\upsilon 	Υ 	υ 	\Upsilon
\phi 		Φ 	φ 	\varphi \Phi
\chi 		Χ 	χ
\psi 		Ψ 	ψ
\omega 		Ω 	ω














