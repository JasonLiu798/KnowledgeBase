#Number Theory 数论
---
#欧几里德算法
[人脑走一遍欧几里得算法](http://www.nowamagic.net/academy/detail/40110110)
设a=10, b=15，那么我们现在求的是 gcd(10,15)
设d=5 是 a 和 b 的一个公约数
a % d == 0 （就是 10 % 5 == 0 了），同时 b 对 d 取模也是 0，就是 
b % d == 0 （15 % 5 == 0），

我们建立一下 a 和 b 之间的联系，比如模运算关系为：
a = kb + r （10 = 0 * 15 + 10），那么 
r = a % b （10 = 10 % 15）
这个r就是这个算法的关键，欧几里德算法为何又叫辗转相除法呢？

r = a - kb （10 = 10 - 0 × 15）
    既然 a % d == 0，b % d == 0，就是说，a 能整除 d，b 也能整除 d，那么 a - kb 是不是可以理解成 
x*d - k*y*d         （x,y是随意整数），那么很明显了 
r = (x - ky)d       就是说，r 也能整除 d，就是 r % d == 0。

问题得以转化，求gcd(a,b)，可以转化为求
gcd(b,a mod b)。就是求gcd(10,15)，可以用求gcd(15,10)来替代。

那么gcd(15,10)又可以用什么来代替呢？我们来看下 r，这个时候 
r = a % b = 15 % 10 = 1*10 + 5 = 5，所以根据 
gcd(b,a mod b)，
gcd(15,10) 可以用
gcd(10,5)来替代，再替代一下，就是
gcd(10,5)可以用
gcd(5,5)来替代，问题答案出来了，5和5公约数是多少？就是5了。这里辗转相除了3次。

[关于欧几里得算法的时间复杂度](http://www.nowamagic.net/academy/detail/40110112)
设a>b>=1
构造数列{un}: 
u0=a, u1=b, uk=uk-2 mod uk-1(k>=2)
显然，若算法需要n次模运算，则有
un=gcd(a, b), un+1=0。
菲波那契数列{Fn}，F0=1<=un，F1=1<=un-1，又因为由
uk mod uk+1=uk+2，可得
uk>=uk+1+uk+2




##扩展欧几里德算法
[扩展欧几里德算法的推导](http://www.nowamagic.net/academy/detail/40110119)
[再设计几个扩展欧几里德算法C语言描述](http://www.nowamagic.net/academy/detail/40110125)
扩展欧几里德算法：对于不全为 0 的非负整数 a、b，gcd（a，b）表示 a，b 的最大公约数，必然存在整数对 x，y ，使得 gcd（a，b）=ax+by。

假如 a > b， 且 b = 0，那么很明显， ax + by = ax + 0 = gcd(0, a mod 0) = a，也就是 x = 1。扩展欧几里德算法是成立的。

a 和 b 都不为 0 的情况下呢？
假设
gcd(a,b) = a * x1 + b * y1;
// 将 gcd(b, a mod b) 套入上面公式，得
gcd(b, a mod b) = b * x2 + (a mod b) * y2;
因为 gcd(a,b) 是和 gcd(b, a mod b) 相等的，所以就有：
a * x1 + b * y1 = b * x2 + (a mod b) * y2;

a mod b 即 a % b = a - (int)(a/b) * b 替换得
a * x1 + b * y1 = b * x2 + (a - (int)(a/b) * b) * y2
// 也就是
a * x1 + b * y1 = b * x2 + a * y2 - (int)(a/b) * b * y2
// 继续合并同类项
a * x1 + b * y1 = a * y2 + b ( x2 - (int)(a/b) * y2 )

x1 = y2
y1 = x2 - (int)(a/b) * y2

#Stein算法
[Stein算法：求最大公约数的另一种算法](http://www.nowamagic.net/academy/detail/40110168)
为了说明Stein算法的正确性，首先必须注意到以下结论：
gcd(a, a) = a， 也就是一个数和他自己的公约数是其自身。
gcd(ka, kb) = k * gcd(a, b)，也就是最大公约数运算和倍乘运算可以交换，特殊的，当k=2时，说明两个偶数的最大公约数比如能被2整除。

Stein算法如下：
如果A=0，B是最大公约数，算法结束 
如果B=0，A是最大公约数，算法结束 
设置A1 = A、B1=B和C1 = 1 
如果An和Bn都是偶数，则An+1 =An /2，Bn+1 =Bn /2，Cn+1 =Cn *2(注意，乘2只要把整数左移一位即可，除2只要把整数右移一位即可) 
如果An是偶数，Bn不是偶数，则An+1 =An /2，Bn+1 =Bn ，Cn+1 =Cn (很显然啦，2不是奇数的约数) 
如果Bn是偶数，An不是偶数，则Bn+1 =Bn /2，An+1 =An ，Cn+1 =Cn (很显然啦，2不是奇数的约数) 
如果An和Bn都不是偶数，则An+1 =|An -Bn|，Bn+1 =min(An,Bn)，Cn+1 =Cn 
n++，转4 






---
#线性同余
[关于线性同余的数论知识](http://www.nowamagic.net/academy/detail/40110140)
定义：a和b为整数且m是正整数，如果有m|(a-b),
即m是a-b的因子，则称a、b模m同余，记a≡b(mod m)

定理1：令m为正整数。若a≡b(mod m),c≡d(mod m)，那么a+c≡b+d(mod m),ac≡bd(mod m)。

在a和m互质且m>1时，比存在a的逆λ，且λ模m唯一。
令 aλ+km = 1，k为整数，满足条件的λ即为逆

定理2：如果a和m为互素的整数，m>1，则存在a的模m的逆。而且这个逆模m是唯一的。（即有小于m的唯一正整数a¯，如果这样的a¯存在的话。这样的a¯称为a模m逆，且a的任何别的模m逆均和a¯模m同余。）

##线性同余方程
对于方程：ax≡b(mod m)，a、b、m都是整数，求解x的值
ax≡b(mod m)表示：(ax - b) mod m = 0，即同余。
求解ax≡b(mod n)的原理：对于方程ax≡b(mod n)，存在ax + by = gcd(a,b)，x，y是整数。而ax≡b(mod n)的解可以由x，y来堆砌。


[线性同余方程一例：POJ 青蛙的约会](http://www.nowamagic.net/academy/detail/40110135)
( x+ m*s  ) - ( n*s + y ) = k*L;
s 代表他们跳的步数，k 代表他们在第几圈相遇。
我们把这个方程变形一下：
x + m*s - n*s - y = k*L;
x - y = k*L - m*s + n*s;
s * ( n - m )  + k*L = x - y;
线性同余方程，对于这种方程，如果有解必须满足 
(x - y) % gcd ( n-m, L )==0 不然就无解， 输出Imposible。










---
#卡特兰数
[卡特兰(Catalan)数概念的简要介绍](http://www.nowamagic.net/academy/detail/40140308)
[卡特兰数通项公式在TAOCP里的推导](http://www.nowamagic.net/academy/detail/40140311)

[阿里的两道和卡特兰数相关的面试题](http://www.nowamagic.net/academy/detail/40140317)
c(2n, n)/(n+1) = c(2n, n) - c(2n, n-1)


















