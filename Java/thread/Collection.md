

# 无锁队列的实现
[无锁队列的实现](https://coolshell.cn/articles/8239.html)

CAS的原子操作
Compare And Swap
看一看内存*reg里的值是不是oldval，如果是的话，则对其赋值newval





# ConcurrentHahsMap
## 使用
[ConcurrentHashMap的使用 水太深了](http://blog.csdn.net/gjt19910817/article/details/47353909)

```java
private final ConcurrentMap<String, Long> wordCounts = newConcurrentHashMap<>();  
//使用 putIfAbsent
public long increase(String word) {  
    Long oldValue, newValue;  
    while(true) {  
        oldValue = wordCounts.get(word);  
        if(oldValue == null) {  
            // Add the word firstly, initial the value as 1  
            newValue = 1L;  
            if(wordCounts.putIfAbsent(word, newValue) == null) {  
                break;  
            }  
        }else{  
            newValue = oldValue + 1;  
            if(wordCounts.replace(word, oldValue, newValue)) {  
                break;  
            }  
        }  
    }  
    return newValue;  
}

private final ConcurrentMap<String, AtomicLong> wordCounts = newConcurrentHashMap<>();  
//使用 atomicLong  
public long increase(String word) {  
    AtomicLong number = wordCounts.get(word);  
    if(number == null) {  
        AtomicLong newNumber = newAtomicLong(0);  
        number = wordCounts.putIfAbsent(word, newNumber);  
        if(number == null) {  
            number = newNumber;  
        }  
    }  
    return number.incrementAndGet();  
}
```
这个实现仍然有一处需要说明的地方，如果多个线程同时增加一个目前还不存在的词，那么很可能会产生多个newNumber对象，但最终只有一个newNumber有用，其他的都会被扔掉

缓存中的对象获取成本一般都比较高，而且通常缓存都会经常失效，那么避免重复创建对象就有价值了
```java
private final ConcurrentMap<String, Future<ExpensiveObj>> cache = newConcurrentHashMap<>();  
   
publicExpensiveObj get(finalString key) {  
    Future<ExpensiveObj> future = cache.get(key);  
    if(future == null) {  
        Callable<ExpensiveObj> callable = newCallable<ExpensiveObj>() {  
            @Override  
            publicExpensiveObj call() throwsException {  
                return newExpensiveObj(key);  
            }  
        };  
        FutureTask<ExpensiveObj> task = newFutureTask<>(callable);  
   
        future = cache.putIfAbsent(key, task);  
        if(future == null) {  
            future = task;  
            task.run();  
        }  
    }  
   
    try{  
        returnfuture.get();  
    }catch(Exception e) {  
        cache.remove(key);  
        throw new RuntimeException(e);  
    }  
}
```
解决方法其实就是用一个Proxy对象来包装真正的对象，跟常见的lazy load原理类似；使用FutureTask主要是为了保证同步，避免一个Proxy创建多个对象。注意，上面代码里的异常处理是不准确的。

最后再补充一下，如果真要实现前面说的统计单词次数功能，最合适的方法是Guava包中AtomicLongMap；一般使用ConcurrentHashMap，也尽量使用Guava中的MapMaker或cache实现。


## 原理
[ConcurrentHashMap源码分析（JDK8版本）](http://blog.csdn.net/u010723709/article/details/48007881)

### 计算table容量大小
```java
/**
     * Returns a power of two table size for the given desired capacity.
     * See Hackers Delight, sec 3.2
     */
    private static final int tableSizeFor(int c) {
        int n = c - 1;
        n |= n >>> 1;
        n |= n >>> 2;
        n |= n >>> 4;
        n |= n >>> 8;
        n |= n >>> 16;
        return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
    }
```
100
1100100
 110010 >>>1
1110110 |
  11101 >>>2
1111111 |
    111 >>>4
1111111 |
...

### 初始化
```java
    /**
     * Initializes table, using the size recorded in sizeCtl.
     */
    private final Node<K,V>[] initTable() {
        Node<K,V>[] tab; int sc;
        while ((tab = table) == null || tab.length == 0) {
            if ((sc = sizeCtl) < 0)
                Thread.yield(); // lost initialization race; just spin
            else if (U.compareAndSwapInt(this, SIZECTL, sc, -1)) {
                try {
                    if ((tab = table) == null || tab.length == 0) {
                        int n = (sc > 0) ? sc : DEFAULT_CAPACITY;
                        @SuppressWarnings("unchecked")
                        Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n];
                        table = tab = nt;
                        sc = n - (n >>> 2);
                    }
                } finally {
                    sizeCtl = sc;
                }
                break;
            }
        }
        return tab;
    }
```


## put
```java
    /** Implementation for put and putIfAbsent */
    final V putVal(K key, V value, boolean onlyIfAbsent) {
        if (key == null || value == null) 
            throw new NullPointerException();
        int hash = spread(key.hashCode());
        int binCount = 0;
        for (Node<K,V>[] tab = table;;) {
            Node<K,V> f; int n, i, fh;
            //br1
            if (tab == null || (n = tab.length) == 0)
                tab = initTable();//为空，初始化

            //br2
            else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
                //节点为空，直接设值，设值失败，下次循环处理
                if (casTabAt(tab, i, null,
                             new Node<K,V>(hash, key, value, null)))
                    break;
                    // no lock when adding to empty bin
            }

            //br3
            else if ((fh = f.hash) == MOVED)
                tab = helpTransfer(tab, f);//协助扩容，扩容完后，下次循环进入其他分支
            
            //br4
            else {
                V oldVal = null;
                synchronized (f) {
                    if (tabAt(tab, i) == f) {//被修改，直接进入下次循环
                        if (fh >= 0) {
                        //TREEBIN=-2,MOVED=-1，大于0为链表头结点（不为链表的会进入了br2
                            binCount = 1;
                            for (Node<K,V> e = f;; ++binCount) {
                                K ek;
                                if (e.hash == hash &&
                                    ((ek = e.key) == key ||
                                     (ek != null && key.equals(ek)))) {
                                    oldVal = e.val;
                                    if (!onlyIfAbsent)
                                        e.val = value;
                                    break;
                                }
                                Node<K,V> pred = e;
                                if ((e = e.next) == null) {
                                    pred.next = new Node<K,V>(hash, key,
                                        value, null);
                                    break;
                                }
                            }
                        }
                        else if (f instanceof TreeBin) {
                            Node<K,V> p;
                            binCount = 2;
                            if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key,
                                value)) != null) {
                                oldVal = p.val;
                                if (!onlyIfAbsent)
                                    p.val = value;
                            }
                        }
                    }
                }
                if (binCount != 0) {
                    if (binCount >= TREEIFY_THRESHOLD)
                        treeifyBin(tab, i);//大于阈值，扩展成树
                    if (oldVal != null)
                        return oldVal;
                    break;
                }
            }
        }
        addCount(1L, binCount);
        return null;
    }
```



---
# 红黑树

[深入理解红黑树](http://blog.csdn.net/u011240877/article/details/53329023)

```java
/**
         * Creates bin with initial set of nodes headed by b.
         */
        TreeBin(TreeNode<K,V> b) {
            super(TREEBIN, null, null, null);
            this.first = b;
            TreeNode<K,V> r = null;
            for (TreeNode<K,V> x = b, next; x != null; x = next) {
                next = (TreeNode<K,V>)x.next;
                x.left = x.right = null;
                if (r == null) {
                    //构建父节点
                    x.parent = null;
                    x.red = false;
                    r = x;
                }
                else {
                    K k = x.key;
                    int h = x.hash;
                    Class<?> kc = null;
                    for (TreeNode<K,V> p = r;;) {
                        int dir, ph;
                        K pk = p.key;
                        if ((ph = p.hash) > h)
                            dir = -1;
                        else if (ph < h)
                            dir = 1;
                        else if ((kc == null &&
                                  (kc = comparableClassFor(k)) == null) ||
                                 (dir = compareComparables(kc, k, pk)) == 0)
                            dir = tieBreakOrder(k, pk);
                            TreeNode<K,V> xp = p;
                        if ((p = (dir <= 0) ? p.left : p.right) == null) {
                            x.parent = xp;
                            if (dir <= 0)
                                xp.left = x;
                            else
                                xp.right = x;
                            r = balanceInsertion(r, x);
                            break;
                        }
                    }
                }
            }
            this.root = r;
            assert checkInvariants(root);
        }
```


# 扩容
[](https://www.jianshu.com/p/f6730d5784ad)


























