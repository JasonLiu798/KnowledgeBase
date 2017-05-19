
8,7分钟

http://www.bilibili.com/video/av6731067/index_6.html

#矩阵
$$\begin{bmatrix} 
-1 \\
2 \end{bmatrix}$$
-1可以看做x坐标，2看做y坐标

##basis vector 基向量

##Linearly dependent 线性相关
两个 向量 无法张成平面
$ \vec{u} = a\vec{v}+b\vec{w} $

##Linearly independent 线性无关
$ \vec{w}  != a\vec{v} $

##Technical definition of basis 基的定义
The basis of a vector space is a set of linearly independent vectors that span the full space

#Linear transformation 线性变换
* Lines remain lines (include diagonal lines )
* Origin remains fixed
in general,Grid lines remain parallel and evenly spaced

$$
\vec{v} = -1\hat{x} + 2\hat{j}
= -1 * \begin{bmatrix} -1 \\ 2 \end{bmatrix} + 2* \begin{bmatrix} 3 \\ 0 \end{bmatrix}
=\begin{bmatrix} 5 \\ 2 \end{bmatrix}
$$

$$
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
*
\begin{bmatrix}
x \\
y
\end{bmatrix}
= x * \begin{bmatrix} a \\ c \end{bmatrix}
+y* \begin{bmatrix} b \\ d \end{bmatrix}
=\begin{bmatrix}
ax+by \\
cx+dy
\end{bmatrix}
$$

rotation -90
$$
\begin{bmatrix}
0 & -1 \\
1 & 0
\end{bmatrix}
$$

shear
$$
\begin{bmatrix}
1 & 1 \\
0 & 1
\end{bmatrix}
$$

Linearly dependent columns

----
#矩阵乘法
Composition of a rotation and a shear
$$
\begin{bmatrix}
1 & -1 \\
1 & 0
\end{bmatrix}
$$

两次线性变换 

M2 M1

$$
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
*
\begin{bmatrix}
e & f \\
g & h
\end{bmatrix} =
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
*
\begin{bmatrix}
e \\
g
\end{bmatrix} 
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
*
\begin{bmatrix}
f \\
h
\end{bmatrix} =
\begin{bmatrix}
ae+bg & af+bh \\
ce+dg & cf+dh
\end{bmatrix}
$$

(AB)C=A(BC)


三维空间
$$
\begin{bmatrix}
1 & 1 & 1 \\
0 & 1 & 0 \\
-1 & 0 & 1
\end{bmatrix}
$$

#The determinant 行列式
面积的放大缩小
det()=0 代表变换能否将空间压缩到更小维度上

负行列式，感觉像是将空间翻转了
定向发生了改变

右手定则，食指i，中指j，大拇指k
三维的负行列式，则为左手定则

##公式
$$
det(
\begin{bmatrix}
a & b \\
c & d 
\end{bmatrix}
)
=(a+b)(c+d)-ac-bd-2bc
=ad-bc
$$

直观解释
ad-0*0
a代表i在x轴方向伸缩比例，d代表j在y轴伸缩方向


#线性方程组
2x+5y+3z=-3
4x+0y+8z=0
1x+3y+0z=2
->
$$
\begin{bmatrix}
2 & 5 & 3 \\
4 & 0 & 8 \\
1 & 3 & 0 
\end{bmatrix}
*
\begin{bmatrix}
x \\ y \\ z
\end{bmatrix}
=
\begin{bmatrix}
-3 \\ 0 \\ 2
\end{bmatrix}
$$
求解xyz则是

#矩阵的逆
即上面方程的解
A^-1
逆变换

A^-1*A = 恒等变换
$$
A* \vec{x} = \vec{v}
\begin{bmatrix}
a & b \\
c & d 
\end{bmatrix}
)
=ad-bc
$$

#秩 rank
三维变换后的向量落在某个一维线上，rank 1
三维变换后的向量落在某个二维平面上，rank 2
秩：列张成的空间，列空间的维数，变换后的空间维数

零向量

变换后落在原点的向量的集合，矩阵的 零空间 或 核

---
#非方阵
高维的投影


----
#点积
http://www.bilibili.com/video/av6731067/index_9.html#page=10

严格线性性质
$$
L(\vec{v}+\vec{w} = L(\vec{v})+L(\vec{w})
L(c\vec{v}=cL(\vec{v}))
$$
等距元素保持等距分布

$$
\begin{bmatrix}
1 & -2
\end{bmatrix} \cdot
\begin{bmatrix}
4 \\ 3
\end{bmatrix} = 4 \cdot 1 + 3 \cdot -2
$$

$$
\begin{bmatrix}
u_x & u_y
\end{bmatrix} \cdot
\begin{bmatrix}
x \\ y
\end{bmatrix} = u_x \cdot x + u_y \cdot y
$$
将其中一个向量转化为线性变换


----
#叉乘
$ \vec{v} \times \vec{w} = det() $

08第二部分 - 以线性变换的眼光看叉积
http://www.bilibili.com/video/av6731067/index_11.html#page=12





































---
#计算相关
高斯消元法，行阶梯型
























