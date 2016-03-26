#search
---
#二分查找算法
　　二分查找算法是一种在有序数组中查找某一特定元素的搜索算法。搜素过程从数组的中间元素开始，如果中间元素正好是要查找的元素，则搜 素过程结束； 如果某一特定元素大于或者小于中间元素，则在数组大于或小于中间元素的那一半中查找，而且跟开始一样从中间元素开始比较。如果在某一步骤数组 为空，则代 表找不到。这种搜索算法每一次比较都使搜索范围缩小一半。折半搜索每次把搜索区域减少一半，时间复杂度为Ο(logn) 。

---
#BFPRT(线性查找算法)
　　BFPRT算法解决的问题十分经典，即从某n个元素的序列中选出第k大（第k小）的元素，通过巧妙的分 析，BFPRT可以保证在最坏情况下仍为线 性时间复杂度。该算法的思想与快速排序思想相似，当然，为使得算法在最坏情况下，依然能达到o(n)的时间复杂 度，五位算法作者做了精妙的处理。
算法步骤：
1. 将n个元素每5个一组，分成n/5(上界)组。
2. 取出每一组的中位数，任意排序方法，比如插入排序。
3. 递归的调用selection算法查找上一步中所有中位数的中位数，设为x，偶数个中位数的情况下设定为选取中间小的一个。
4. 用x来分割数组，设小于等于x的个数为k，大于x的个数即为n-k。
5. 若i==k，返回x；若i<k，在小于x的元素中递归查找第i小的元素；若i>k，在大于x的元素中递归查找第i-k小的元素。
终止条件：n=1时，返回的即是i小元素。


---
#backtracking
顺序问题，与现场恢复
https://leetcode.com/problems/word-search/
https://leetcode.com/discuss/23011/accepted-python-backtracking-solution


---
#DFS（深度优先搜索）
　　深度优先搜索算法（Depth-First-Search），是搜索算法的一种。它沿着树的深度遍历树的节点，尽可能深的搜索树的分 支。当节点v 的所有边都己被探寻过，搜索将回溯到发现节点v的那条边的起始节点。这一过程一直进行到已发现从源节点可达的所有节点为止。如果还存在未被发 现的节点， 则选择其中一个作为源节点并重复以上过程，整个进程反复进行直到所有节点都被访问为止。DFS属于盲目搜索。
　　深度优先搜索是图论中的经典算法，利用深度优先搜索算法可以产生目标图的相应拓扑排序表，利用拓扑排序表可以方便的解决很多相关的图论问题，如最大路径问题等等。一般用堆数据结构来辅助实现DFS算法。
深度优先遍历图算法步骤：
1. 访问顶点v；
2. 依次从v的未被访问的邻接点出发，对图进行深度优先遍历；直至图中和v有路径相通的顶点都被访问；
3. 若此时图中尚有顶点未被访问，则从一个未被访问的顶点出发，重新进行深度优先遍历，直到图中所有顶点均被访问过为止。
上述描述可能比较抽象，举个实例：
DFS 在访问图中某一起始顶点 v 后，由 v 出发，访问它的任一邻接顶点 w1；再从 w1 出发，访问与 w1邻 接但还没有访问过的顶点 w2；然后再从 w2 出发，进行类似的访问，… 如此进行下去，直至到达所有的邻接顶点都被访问过的顶点 u 为止。
接着，退回一步，退到前一次刚访问过的顶点，看是否还有其它没有被访问的邻接顶点。如果有，则访问此顶点，之后再从此顶点出发，进行与前述类似的访问；如果没有，就再退回一步进行搜索。重复上述过程，直到连通图中所有顶点都被访问过为止。

---
#BFS(广度优先搜索)
　　广度优先搜索算法（Breadth-First-Search），是一种图形搜索算法。简单的说，BFS是从根节点开始，沿着树(图)的宽度遍历树(图)的节点。如果所有节点均被访问，则算法中止。BFS同样属于盲目搜索。一般用队列数据结构来辅助实现BFS算法。
算法步骤：
1. 首先将根节点放入队列中。
2. 从队列中取出第一个节点，并检验它是否为目标。
如果找到目标，则结束搜寻并回传结果。
否则将它所有尚未检验过的直接子节点加入队列中。
3. 若队列为空，表示整张图都检查过了——亦即图中没有欲搜寻的目标。结束搜寻并回传“找不到目标”。
4. 重复步骤2。

---
#Dijkstra算法
　　戴克斯特拉算法（Dijkstra’s algorithm）是由荷兰计算机科学家艾兹赫尔·戴克斯特拉提出。迪科斯彻算法使用了广度优先搜索解决非负权有向图的单源最短路径问题，算法最终得到一个最短路径树。该算法常用于路由算法或者作为其他图算法的一个子模块。
　　该算法的输入包含了一个有权重的有向图 G，以及G中的一个来源顶点 S。我们以 V 表示 G 中所有顶点的集合。每一个图中的边，都是两个顶点 所形成的有序元素对。(u, v) 表示从顶点 u 到 v 有路径相连。我们以 E 表示G中所有边的集合，而边的权重则由权重函 数 w: E → [0, ∞] 定义。因此，w(u, v) 就是从顶点 u 到顶点 v 的非负权重（weight）。边的权重可以想像成两个顶点之 间的距离。任两点间路径的权重，就是该路径上所有边的权重总和。已知有 V 中有顶点 s 及 t，Dijkstra 算法可以找到 s 到 t的最低权 重路径(例如，最短路径)。这个算法也可以在一个图中，找到从一个顶点 s 到任何其他顶点的最短路径。对于不含负权的有向图，Dijkstra算法是目 前已知的最快的单源最短路径算法。
算法步骤：
1. 初始时令 S={V0},T={其余顶点}，T中顶点对应的距离值
若存在<v0,vi>，d(V0,Vi)为<v0,vi>弧上的权值
若不存在<v0,vi>，d(V0,Vi)为∞
2. 从T中选取一个其距离值为最小的顶点W且不在S中，加入S
3. 对其余T中顶点的距离值进行修改：若加进W作中间顶点，从V0到Vi的距离值缩短，则修改此距离值
重复上述步骤2、3，直到S中包含所有顶点，即W=Vi为止

---
#跳表
O(log n)
one sorted linked list O-n
two sorted linked list
L2 store all elements
L1 store some elements
##Search
walk right to top L1 until goting right would go to target
walk down to L2,walk right in L2,until find target(or >x)
##L1
separated them out uniformly
##cost
L1+L2/L1
minumize
L1+n/L1
L1=n/L1
L1=sqrt(n)
3*power(n,1/2)

threee sorted linked list
3*power(n,1/3)
...
k sorted lined list
k*power(n,1/k)
k=lgn
lgn*power(n,1/lgn)=2*lgn
r*lgn=n
r是各个list之间的间隔值
ideal skip list just like binary tree

##Insert
Search(x) cost lgn
Insert(x) to list
filp coin,head->promote x to next level
flip again
50% elements will promote to next level

##Theorem
search cost O(lgn)

---
#中位数、第K数(算法导论C9 G6)
输入：包含n个互异数的集合A，和一个整数i，1<=i<=n
输出：x属于A，且A中恰好有i-1个元素小于x
O(n)
##最大最小
一般算法，比较n-1次
同时找到最大最小，比较2*(n-1)次
优化后：最多比较3*floor(n/2)
元素两两比较，小的跟最小比，大的跟最大比，共需要3次，未优化的算法需要4次
初值：
    偶数，头两个元素比较初始化为max,min，，再两两对比
    计数，第一个初始化为max,min，再两两对比

##RANDOMIZED-SELECT
以快排为模型，只处理划分的一边
A:
<=A(r)   >=A(r)
 P     r   q
    k
```c
//A[p..r]找第i小的元素
RANDOMIZED-SELECT(A,p,r,i)
    if p==i then
        return A[p]
    q=RANDOMIZED-PARTITION(A,p,r) //A[p..q-1]<=A[q]<=A[q+1..r]
    k=q-p+1
    if i==k //the pivot value is the answer
        return A[q]
    else if i<k
        return RANDOMIZED-SELECT(A,p,q-1,i)
    else
        return RANDOMIZED-SELECT(A,q+1,r,i-k)
```

---
#红黑树
---
#B-tree










