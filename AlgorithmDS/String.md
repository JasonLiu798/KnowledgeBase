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

