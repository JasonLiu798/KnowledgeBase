#DataStruct
---
#doc
[黑书](http://www.china-pub.com/16323)
[数据结构（C语言版）](http://www.china-pub.com/31071)
[数据结构与算法分析——C语言描述](http://www.china-pub.com/15267)
[算法导论（第二版）](http://www.china-pub.com/31701)


---
#list
##arraylist


##LinkedList
特点：逻辑上连续，空间上不连续。
一个重要应用：用邻接表来表示一个图。
如果用数组表示：需要|V|x|V|个元素的二维数组，与邻接矩阵内存消耗相当。表示多重图时，甚至需要|V| x |E|个元素的数组。
如果用链表表示：只需要开|E|个元素（无向图要2 * |E|个）

###实现
一般而言，链表的空间从堆上的空间获得（用new或者malloc函数）
缺点：速度慢，容易导致TLE（超时）可以用静态链表克服速度慢的缺点。
邻接表一般只涉及插入不涉及删除，可以简化静态链表的实现。

预先开一个数组做pool，定义一个指针alloc指向pool。每次申请空间时，就使用alloc指向的元素，然后将alloc增1。

##示例
```c
//读入一个带权有向图的边
sturct edge{
	int end, weight;
	edge *next;
} pool[MAXE], *alloc = pool, *adj[MAXV];
…
scanf( “%d %d %d”, &A, &B, &C );
alloc->end = B;
alloc->weight = C;
alloc->next = adj[A];
adj[A] = alloc++;

//遍历一个点的边
for ( edge *e = adj[u]; e; e = e->next ){
	e->end…
	e->weight…
}
```
问题1：多Case情况如何初始化pool，alloc以及adj？
问题2：当涉及删除操作时，仍可以用这种方法吗？
问题3：别的需要动态申请空间的数据结构，也可以这样用吗？

##Vector
如果图的邻接表采用数组表示，如果保存图中每个点的邻接点的数组可以动态的增长而不必提前申请好足够的空间，那么……

STL中的vector可以实现动态增长的数组。


```c
//读入一个无权有向图的边
#include <vector>
using namespace std;
vector< int > adj[MAXV];
…
scanf( “%d %d”, &A, &B );
adj[A].push_back( B );
…

//遍历一个点的边
int i;
for ( i = 0; i < adj[u].size(); ++i ){	
	adj[u][i]…
}

//初始化
adj[u].clear();

```
问题：如何用vector表示一个有权图的邻接表？

---
#栈
栈是一种LIFO（Last In First Out，后进先出）的线性数据结构。

一种简单的实现：
```c
int stack[…], *top = stack; //申请
*top++ = ….; //入栈
… = *--top; //出栈
*(top-1) //栈顶
top == stack //判空
top = stack; //清空
top – stack //栈中元素个数
```

#队列
与栈相反，是FIFO，先进先出的：

一种简单的实现：
```c
int queue[…], *front, *rear; //申请：
front = rear = queue; //初始化，清空
*rear++ = ….; //入队
… = *front++; //出对
front == rear //判空
*front //队首
*(rear-1) //队尾
rear – front //队列中元素个数
```

#vector中的栈和队列
stack容器的几个方法 <stack>
入栈 push();
出栈 pop();
栈顶 top();

queue容器的几个方法 <queue>
入队 push();
出队 pop();
队首 top();

二者都有的方法
判空 empty();
元素个数 size();

---
#优先队列
与队列相似，区别在于每个元素具有一个优先值，具有最大（最小）值的元素优先出队。例如以元素本身的值作为优先值。

STL实现：
```c
#include <queue>
using namespace std;
priority_queue< int > PQ; //大数先出队
priority_queue< int, greater<int> > PQ;//小数先出队
```
复杂度：入队O(lgN)，出队O(lgN)。
几个方法：push(); pop(); top(); size(); empty(); 
没有clear();

有时不是直接比较元素值，如何实现？
方法一：重载优先队列元素的<，右侧元素先出队。
方法二：传递比较类，重载该类的()运算符，右侧元素先出队。
//方法二示例代码：
struct Cmp {
	bool operator() ( int i, int j ) { return  d[i] < d[j]; }
};
priority_queue< int, Cmp > PQ;
这样声明的话，d值最大的元素先出队。

有时我们需要更改优先队列中一些元素的值，STL的priority_queue无法实现。

##问题：
1.如何用两个栈模拟一个队列？
2.如何用一个优先队列模拟一个队列？
3.如何用一个优先队列模拟一个栈？
POJ1361 – Rails 黑书36页
POJ1879 - Tempus et mobilius Time and motion 黑书38页

---
#堆（二叉堆）
O(lgN)的优先队列是如何实现的？
我们可以用“二叉堆”实现。（只有用堆才可以实现？NO）
原理 主要理解三点：
1.数组表示树时的下标计算
2.上浮
3.下沉
只要改进一下二叉堆即可实现。
最原始的思想：某个元素的优先值改变了，只要对他做上浮或者下沉就搞定。
关键问题在于：要做上浮和下沉就需要知道这个元素在堆中的位置。
怎么办？
用一个数组记录下元素在堆中的位置，并在上浮和下沉中维护这个数组。

```c
//小顶堆的上浮
void Up( int u ) {
	int parent = u/2, i = heap[u], temp = value(i);
	while ( parent > 0 && value(heap[parent]) > temp ) {
		heap[u] = heap[parent];
		pos[heap[u]] = u;
		u = parent;
		parent /= 2;
	}
	heap[u] = i;
	pos[i] = u;
}
```

##堆的变种
二项堆，配对堆，斐波那契堆

##STL中的堆函数
<algorithm>
make_heap( *first, *last, Cmp() ); //[first,last)建堆
//假设[first,last-1)是堆,将[first,last)调整成堆
push_heap( *first, *last, Cmp() );
//假设[first,last)是堆,将last-1的值与first交换,并调整[first,last-1)为堆
pop_heap( *first, *last, Cmp() );

1.不对称边界
即用“地址的左闭右开”来表示任意区间。
例如a[1] ~~ a[3]在STL中表示成[ &a[1], &a[4] )
推荐书籍：[C陷阱与缺陷](http://www.china-pub.com/38125)

2.比较类与比较对象
上一讲提到过比较类，即在此类中重载()。
而比较对象就是用该类声明的一个对象。
在声明一个容器时，应传递比较类，例如set，map（后面会提到）。
在STL的算法函数中，应传递比较对象。例如堆函数，排序函数。

这个比较对象可以传递一个比较类的函数对象(会用下面的方法就行)
如果Cmp是一个比较类，Cmp()就是Cmp类的函数对象，将其传递给STL算法函数即可。

##STL的排序
sort( first, last, Cmp() ); 右侧元素在右，复杂度O( nlgn )‏
例：从0到N-1这N个整数中，每个数i对应一个值f[i]，现在要求按照f的升序对这N个数排序
```c
#include <algorithm>
using namespace std;
struct Cmp {
	bool operator()( int i, int j ) { 
		return f[i] < f[j]; 
	}
};
//假设排序前A[i] = i;
//用sort进行排序，按照Cmp的升序，即左侧元素在前，右侧元素在后。
sort( A, A+N, Cmp() );
//不对称边界
//比较对象
```

仿函数greater< type >()
其实就是表示大于号的意思，STL中的算法函数或者容器都是用小于号做比较。用了greater，就可以实现降序排序了。
例：//对vector<int>容器A进行降序排序
sort( A.begin(), A.end(), greater<int>() );

##STL中的二分查找
upper_bound( first, last, item,Cmp() );
lower_bound( first, last, item, Cmp() );
equal_range( first, last, item, Cmp() );
binary_search( first, last, item, Cmp() );

在按Cmp()排序后的区间[first,last)进行搜索。
左侧元素lower，右侧元素upper

例如： ….AAAABBBBCCCCC….
红色的B：lower_bound的返回位置
蓝色的C：upper_bound的返回位置
equal_range返回一个
pair < lower_bound, upper_bound >。
binary_search返回查找元素是否存在。

四个函数的复杂度均为 O(lgN)‏


有时候对一个有序数组，我们希望能删除一个元素，还保持数组有序性和连续性以便再次二分。

##练习题
1.用一下STL的排序函数和二分查找，务必做到熟练使用。
2.自己手写堆实现优先队列，做一下POJ3159。熟练使用手写堆。
3.POJ3664。排序
4.POJ3665。堆模拟             

---































