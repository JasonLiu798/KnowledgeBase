#String 
---
#rotate
[左旋转字符串](http://blog.csdn.net/v_JULY_v/article/details/6322882)
暴力移位法
指针翻转法
递归转换法
循环移位法
三步翻转法

---
#字符串是否包含
[字符串是否包含问题](http://blog.csdn.net/v_JULY_v/article/details/6347454)
双重循环遍历
排序+单趟遍历
hash

---
#回文
最长回文字串O(n)
[Manacher csdn](http://blog.csdn.net/ggggiqnypgjg/article/details/6645824/)
[Manacher cnblog](http://www.cnblogs.com/biyeymyhjob/archive/2012/10/04/2711527.html)
(3)[http://www.tuicool.com/articles/mqUfai]
12212321 ->
S[] = "$#1#2#2#1#2#3#2#1#";
然后用一个数组 P[i] 来记录以字符S[i]为中心的最长回文子串向左/右扩张的长度（包括S[i]），比如S和P的对应关系：
S     #  1  #  2  #  2  #  1  #  2  #  3  #  2  #  1  #
P     1   2  1  2  5   2  1  4   1  2  1  6   1  2   1  2  1
(p.s. 可以看出，P[i]-1正好是原字符串中回文串的总长度）
mx则为id+P[id]，即最大回文子串的边界
如果mx > i，那么P[i] >= MIN(P[2 * id - i], mx - i)

---
#ac自动机
http://www.cnblogs.com/kuangbin/p/3164106.html

http://blog.csdn.net/niushuai666/article/details/7002823

http://acm.uestc.edu.cn/bbs/read.php?tid=4294



---
#KMP
[从头到尾彻底理解KMP（2014年8月22日版）](http://blog.csdn.net/v_july_v/article/details/7041827)


---
#Trie Tree
http://www.cnblogs.com/huangxincheng/archive/2012/11/25/2788268.html



---
#正则
[正则表达式（包含 *, ?) 的动态规划算法](http://blog.csdn.net/martin_liang/article/details/27863807)
[正则表达式匹配](http://www.cnblogs.com/davidluo/articles/1806842.html)


----
#相似度
[图解 编辑距离LCS算法详解：Levenshtein Distance算法计算两个字符串的相似度](http://www.it165.net/pro/html/201306/6105.html)
  一个字符串可以通过“增加一个字符”，“删除一个字符”，“替换一个字符”，从而得到另一个字符串，假设我们从字符串A转换为字符串B，前面3种操作所执行的最少次数就是A和B的相似度。求该最小次数。
  如 abc adc 度为 1
  ababababa babababab 度为 2
  abcd acdb 度为2
  那是相当有趣啊，哈哈，博客中介绍了这个问题最常用的解决算法--Levenshtein Distance，下面就来介绍下这个算法如何来解决这个问题（部分摘自维基百科http://en.wikipedia.org/wiki/Levenshtein_distance）
  假设我们可以使用d[ i , j ]个步骤（可以使用一个二维数组保存这个值），表示将串s[ 1…i ] 转换为 串t [ 1…j ]所需要的最少步骤个数，那么，在最基本的情况下，即在i等于0时，也就是说串s为空，那么对应的d[0,j] 就是 增加j个字符，使得s转化为t，在j等于0时，也就是说串t为空，那么对应的d[i,0] 就是 减少 i个字符，使得s转化为t。
  然后我们考虑一般情况，加一点动态规划的想法，我们要想得到将s[1..i]经过最少次数的增加，删除，或者替换操作就转变为t[1..j]，那么我们就必须在之前可以以最少次数的增加，删除，或者替换操作，使得现在串s和串t只需要再做一次操作或者不做就可以完成s[1..i]到t[1..j]的转换。所谓的“之前”分为下面三种情况：

s[1..i]
t[1..j]

1）我们可以在k个操作内将 s[1…i] 转换为 t[1…j-1]
针对第1种情况，我们只需要在最后将 t[j] 加上s[1..i] 总共就需要k+1个操作。
s[1..i] 	-> 	t[1..j-1]  	t[j]加上s[1..i]{即t[1..j-1]}

2）我们可以在k个操作里面将s[1..i-1]转换为t[1..j]
在最后将s[i]移除，然后再做这k个操作，所以总共需要k+1个操作。
s[1..i-1] 	->	t[1..j]		s[i]移除

3）我们可以在k个步骤里面将 s[1…i-1] 转换为 t [1…j-1]
只需要在最后将s[i]替换为 t[j]，使得满足s[1..i] == t[1..j]
s[1..i-1]	->	t[1..j-1]	s[i]替换为t[j]


更加具体的算法如下：
##1
Set n to be the length of s.
Set m to be the length of t.
If n = 0, return m and exit.
If m = 0, return n and exit.
	s0 s1 s2 s3 ... sm
t0
t1
t2
...
tn
Construct a matrix containing 0..m rows and 0..n columns.
构造 行数为m+1 列数为 n+1 的矩阵 , 用来保存完成某个转换需要执行的操作的次数，将串s[1..n] 转换到 串t[1…m] 所需要执行的操作次数为matrix[n][m]的值
##2
Initialize the first row to 0..n.
Initialize the first column to 0..m.
初始化matrix第一行为0到n，第一列为0到m。
Matrix[0][j]表示第1行第j-1列的值，这个值表示将串s[1…0]转换为t[1..j]所需要执行的操作的次数，很显然将一个空串转换为一个长度为j的串，只需要j次的add操作，所以matrix[0][j]的值应该是j，其他值以此类推。
##3
Examine each character of s (i from 1 to n).
##4
Examine each character of t (j from 1 to m).
##5
If s[i] equals t[j], the cost is 0.
If s[i] doesn't equal t[j], the cost is 1.
将串s和串t的每一个字符进行两两比较，如果相等，则让cost为0，如果不等，则让cost为1（这个cost后面会用到）
##6
Set cell d[i,j] of the matrix equal to the minimum of:
a. The cell immediately above plus 1: d[i-1,j] + 1.
如果我们可以在k个操作里面将s[1..i-1]转换为t[1..j]，那么我们就可以将s[i]移除，然后再做这k个操作，所以总共需要k+1个操作。
b. The cell immediately to the left plus 1: d[i,j-1] + 1.
如果我们可以在k个操作内将 s[1…i] 转换为 t[1…j-1] ，也就是说d[i,j-1]=k，那么我们就可以将 t[j] 加上s[1..i]，这样总共就需要k+1个操作。
c. The cell diagonally above and to the left plus the cost: d[i-1,j-1] + cost.
如果我们可以在k个步骤里面将 s[1…i-1] 转换为 t [1…j-1]，那么我们就可以将s[i]转换为 t[j]，使得满足s[1..i] == t[1..j]，这样总共也需要k+1个操作。（这里加上cost，是因为如果s[i]刚好等于t[j]，那么就不需要再做替换操作，即可满足，如果不等，则需要再做一次替换操作，那么就需要k+1次操作）
因为我们要取得最小操作的个数，所以我们最后还需要将这三种情况的操作个数进行比较，取最小值作为d[i,j]的值
##7
After the iteration steps (3, 4, 5, 6) are complete, the distance is found in cell d[n,m].
然后重复执行3,4,5,6，最后的结果就在d[n,m]中

























