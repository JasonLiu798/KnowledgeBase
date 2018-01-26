

# doc
[MySQL中锁详解（行锁、表锁）](http://blog.csdn.net/lishenglong666/article/details/53913126)

[MySQL的并发控制与加锁分析](https://www.cnblogs.com/yelbosh/p/5813865.html)


innodb_locks_unsafe_for_binlog





## 什么时候使用表锁
对于InnoDB表，在绝大部分情况下都应该使用行级锁，因为事务和行锁往往是我们之所以选择InnoDB表的理由。但在个别特殊事务中，也可以考虑使用表级锁。
第一种情况是：事务需要更新大部分或全部数据，表又比较大，如果使用默认的行锁，不仅这个事务执行效率低，而且可能造成其他事务长时间锁等待和锁冲突，这种情况下可以考虑使用表锁来提高该事务的执行速度。
第二种情况是：事务涉及多个表，比较复杂，很可能引起死锁，造成大量事务回滚。这种情况也可以考虑一次性锁定事务涉及的表，从而避免死锁、减少数据库因事务回滚带来的开销。




innodb_lock_wait_timeout


