

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













