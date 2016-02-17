

[彻底弄懂最短路径问题](http://www.cnblogs.com/hxsyl/p/3270401.html)

Dijkstra算法



##Floyd算法
从任意节点A到任意节点B的最短路径不外乎2种可能，1是直接从A到B，2是从A经过若干个节点到B，所以，我们假设dist(AB)为节点A到节点B的最短路径的距离，对于每一个节点K，我们检查dist(AK) + dist(KB) < dist(AB)是否成立，如果成立，证明从A到K再到B的路径比A直接到B的路径短，我们便设置 dist(AB) = dist(AK) + dist(KB)，这样一来，当我们遍历完所有节点K，dist(AB)中记录的便是A到B的最短路径的距离。

##Bellman-Ford算法

