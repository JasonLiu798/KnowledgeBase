


# 排序
[Collections.sort()和Arrays.sort()排序算法选择](http://blog.csdn.net/timheath/article/details/68930482)
Arrays.sort()

先来看看Arrays.sort();，一点进这个方法会看到是这样子的

public static void sort(int[] a) {
    DualPivotQuicksort.sort(a, 0, a.length - 1, null, 0, 0);
}

果然没这么简单，DualPivotQuicksort翻译过来就是双轴快速排序，关于双轴排序可以去这里http://www.cnblogs.com/nullzx/p/5880191.html 看看。那再次点进去，可以发现有这么一段代码

if (right - left < QUICKSORT_THRESHOLD) {
    sort(a, left, right, true);
    return;
}

可以发现如果数组的长度小于QUICKSORT_THRESHOLD的话就会使用这个双轴快速排序，而这个值是286。

那如果大于286呢，它就会坚持数组的连续升序和连续降序性好不好，如果好的话就用归并排序，不好的话就用快速排序，看下面这段注释就可以看出

 * The array is not highly structured,
 * use Quicksort instead of merge sort.

那现在再回到上面的决定用双轴快速排序的方法上，再点进去，发现又会多一条判断

// Use insertion sort on tiny arrays
if (length < INSERTION_SORT_THRESHOLD)

即如果数组长度小于INSERTION_SORT_THRESHOLD(值为47)的话，那么就会用插入排序了，不然再用双轴快速排序。

所以总结一下Arrays.sort()方法，如果数组长度大于等于286且连续性好的话，就用归并排序，如果大于等于286且连续性不好的话就用双轴快速排序。如果长度小于286且大于等于47的话就用双轴快速排序，如果长度小于47的话就用插入排序。真是有够绕的~

Collections.sort()

再来看看Collections.sort()，一路点进去，发现会进到Arrays里了，来看看又有什么选择

public static <T> void sort(T[] a, Comparator<? super T> c) {
    if (c == null) {
        sort(a);
    } else {
        if (LegacyMergeSort.userRequested)
            legacyMergeSort(a, c);
        else
            TimSort.sort(a, 0, a.length, c, null, 0, 0);
    }
}

会发现如果LegacyMergeSort.userRequested为true的话就会使用归并排序，可以通过下面代码设置为true

System.setProperty("java.util.Arrays.useLegacyMergeSort", "true"); 
1
2
不过方法legacyMergeSort的注释上有这么一句话，说明以后传统归并可能会被移除了。

/** To be removed in a future release. */

如果不为true的话就会用一个叫TimSort的排序算法，这个算法可以去这里http://blog.csdn.net/yangzhongblog/article/details/8184707 看看。








--------

[hashmap 红黑树](http://blog.csdn.net/u011240877/article/details/53358305)




----------









