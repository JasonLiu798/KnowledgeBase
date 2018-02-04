

# doc
[MySQL中锁详解（行锁、表锁）](http://blog.csdn.net/lishenglong666/article/details/53913126)

[MySQL的并发控制与加锁分析](https://www.cnblogs.com/yelbosh/p/5813865.html)

[理解innodb的锁(record,gap,Next-Key lock)](http://blog.csdn.net/cug_jiang126com/article/details/50596729)

innodb_locks_unsafe_for_binlog

# Record lock
单条索引记录上加锁，record lock锁住的永远是索引，而非记录本身，即使该表上没有任何索引，那么innodb会在后台创建一个隐藏的聚集主键索引，那么锁住的就是这个隐藏的聚集主键索引。所以说当一条sql没有走任何索引时，那么将会在每一条聚集索引后面加X锁，这个类似于表锁，但原理上和表锁应该是完全不同的。



## 什么时候使用表锁
对于InnoDB表，在绝大部分情况下都应该使用行级锁，因为事务和行锁往往是我们之所以选择InnoDB表的理由。但在个别特殊事务中，也可以考虑使用表级锁。
第一种情况是：事务需要更新大部分或全部数据，表又比较大，如果使用默认的行锁，不仅这个事务执行效率低，而且可能造成其他事务长时间锁等待和锁冲突，这种情况下可以考虑使用表锁来提高该事务的执行速度。
第二种情况是：事务涉及多个表，比较复杂，很可能引起死锁，造成大量事务回滚。这种情况也可以考虑一次性锁定事务涉及的表，从而避免死锁、减少数据库因事务回滚带来的开销。




innodb_lock_wait_timeout




# 间隙锁 Gap Lock
锁加在不存在的空闲空间，可以是两个索引记录之间，也可能是第一个索引记录之前或最后一个索引之后的空间。

间隙锁的主要作用是为了防止出现幻读

间隙锁的出现主要集中在同一个事务中先delete后
 insert的情况下， 当我们通过一个参数去删除一条记录的时候， 
如果参数在数据库中存在，那么这个时候产生的是普通行锁，锁住这个记录， 然后删除， 然后释放锁。如果这条记录不存在，
问题就来了， 数据库会扫描索引，发现这个记录不存在， 这个时候的delete语句获取到的就是一个间隙锁，
然后数据库会向左扫描扫到第一个比给定参数小的值，向右扫描扫描到第一个比给定参数大的值， 然后以此为界，
构建一个区间， 锁住整个区间内的数据， 一个特别容易出现死锁的间隙锁诞生了。

存在才删除，尽量不去删除不存在的记录


---
# Next-Key Locks
在默认情况下，mysql的事务隔离级别是可重复读，并且innodb_locks_unsafe_for_binlog参数为0，这时默认采用next-key locks。所谓Next-Key Locks，就是Record lock和gap lock的结合，即除了锁住记录本身，还要再锁住索引之间的间隙。

select .. from  
不加任何类型的锁
select .. from lock in share mode
在扫描到的任何索引记录上加共享的（shared）next-key lock，还有主键聚集索引加排它锁 
select .. from for update
在扫描到的任何索引记录上加排它的next-key lock，还有主键聚集索引加排它锁 
update .. where 
delete from .. where
在扫描到的任何索引记录上加next-key lock，还有主键聚集索引加排它锁 
insert into .. 
简单的insert会在insert的行对应的索引记录上加一个排它锁，这是一个record lock，并没有gap，所以并不会阻塞其他session在gap间隙里插入记录。不过在insert操作之前，还会加一种锁，官方文档称它为
intention gap lock，也就是意向的gap锁。这个意向gap锁的作用就是预示着当多事务并发插入相同的gap空隙时，只要插入的记录不是gap间隙中的相同位置，则无需等待其他session就可完成，这样就使得insert操作无须加真正的gap lock。想象一下，如果一个表有一个索引idx_test，表中有记录1和8，那么每个事务都可以在2和7之间插入任何记录，只会对当前插入的记录加record lock，并不会阻塞其他session插入与自己不同的记录，因为他们并没有任何冲突。
假设发生了一个唯一键冲突错误，那么将会在重复的索引记录上加读锁。当有多个session同时插入相同的行记录时，如果另外一个session已经获得改行的排它锁，那么将会导致死锁。

























