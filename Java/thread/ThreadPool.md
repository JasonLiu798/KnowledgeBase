
# ThreadPoolExecutor
## 参数
* int corePoolSize 
核心线程数，创建后，即使空闲，也不销毁，除非设置了allowCoreThreadTimeOut参数
* int maximumPoolSize 
最大线程数
* long keepAliveTime
线程数>corePoolSize，多余的线程最多等待多久被销毁
* TimeUnit unit
* BlockingQueue<Runnable> workQueue
等待队列

## 默认拒绝策略
RejectedExecutionHandler defaultHandler = new AbortPolicy();
抛出异常

## 默认线程工厂
```java
static class DefaultThreadFactory implements ThreadFactory {
    private static final AtomicInteger poolNumber = new AtomicInteger(1);
    private final ThreadGroup group;
    private final AtomicInteger threadNumber = new AtomicInteger(1);
    private final String namePrefix;

    DefaultThreadFactory() {
        SecurityManager s = System.getSecurityManager();
        group = (s != null) ? s.getThreadGroup() :
                              Thread.currentThread().getThreadGroup();
        namePrefix = "pool-" +
                      poolNumber.getAndIncrement() +
                     "-thread-";
    }

    public Thread newThread(Runnable r) {
        Thread t = new Thread(group, r,
                              namePrefix + threadNumber.getAndIncrement(),
                              0);
        if (t.isDaemon())
            t.setDaemon(false);
        if (t.getPriority() != Thread.NORM_PRIORITY)
            t.setPriority(Thread.NORM_PRIORITY);
        return t;
    }
}
```

## execute
* 当前线程数 < corePoolSize
启动新进程

* 当前线程数 > corePoolSize
放入队列，放完后再次检查，以防止进入方法时，线程池shut down，或者有线程刚好执行完
如果成功则，从队列取出，或者启动新线程

* 不能加入队列
尝试添加新线程，如果失败，则为正在关闭，或者饱和，则拒绝线程

## addWorker
判断状态

cas递增 当前线程数


---
# 扩展
[支持生产阻塞的线程池](http://blog.hesey.net/2013/04/blocking-threadpool-executor.html)



























