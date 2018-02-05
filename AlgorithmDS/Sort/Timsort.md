

[Timsort原理介绍](http://blog.csdn.net/yangzhongblog/article/details/8184707)

# 定义
Timsort是结合了合并排序（merge sort）和插入排序（insertion sort）而得出的排序算法，它在现实中有很好的效率。Tim Peters在2002年设计了该算法并在Python中使用（TimSort 是 Python 中 list.sort 的默认实现）。该算法找到数据中已经排好序的块-分区，每一个分区叫一个run，然后按规则合并这些run。Pyhton自从2.3版以来一直采用Timsort算法排序，现在Java SE7和Android也采用Timsort算法对数组排序。


（0）如果数组长度小于某个值，直接用二分插入排序算法
（1）找到各个run，并入栈
（2）按规则合并run



简单的合并算法是用简单插入算法，依次从左到右或从右到左比较，然后合并2个run。为了提高效率，Timsort用二分插入算法（binary merge sort）。先用二分查找算法/折半查找算法（binary search）找到插入的位置，然后在插入。




