#theory
---
#逻辑结构
```
连接/线程处理
 |         |
查询缓存<-解析器->
优化器
 |
存储引擎
```


##character set 和 collation
character set， 即字符集
collation, 即比对方法 指定数据集如何排序，以及字符串的比对规则
mysql> show collation;
collation 名字的规则可以归纳为这两类：
1. <character set>_<language/other>_<ci/cs>
2. <character set>_bin
ci 是 case insensitive 的缩写， cs 是 case sensitive 的缩写，bin 二进制排序
###utf8_general_ci和utf8_unicode_ci的区别
[utf8_general_ci和utf8_unicode_ci的区别](http://www.nowamagic.net/academy/detail/32161544)
当前，utf8_unicode_ci校对规则仅部分支持Unicode校对规则算法
utf8_unicode_ci的最主要的特色是支持扩展
utf8_general_ci是一个遗留的 校对规则，不支持扩展。意味着utf8_general_ci校对规则进行的比较速度很快，但是与使用utf8_unicode_ci的 校对规则相比，比较正确性较差


---
#存储引擎
* MyISAM 表级并发控制锁
* InnoDB 记录级并发控制锁
* BDB 页面级并发控制锁
* 内存存储引擎 HEAP表，适合查找表，周期性缓存聚合数据，保存中间数据，表级锁，并发写入差，每行长度固定，
* merge 合并存储引擎
* archive，只支持insert select，zlib压缩，针对高速插入和压缩优化的简单引擎
* cluster，
* csv，不支持索引
* blackhole，
* fedreted，访问其他mysql的代理
* custom storage engine，

##InnoDB MyISAM 引擎选择
[InnoDB还是MyISAM 再谈MySQL存储引擎的选择](http://database.51cto.com/art/200905/124370.htm)
你的数据库有外键吗？ 
◆你需要事务支持吗？ 
◆你需要全文索引吗？ 
◆你经常使用什么样的查询模式？ 
◆你的数据有多大？

特点      | myisam    |   innoDB
----------|----------|-----------
批量插入速度| 高       |       低
事务安全    |         |     支持
全文检索    | 支持，系统内建|  无
锁机制     | 表锁     |  行锁
存储限制    |   无   |   64TB
B树索引    |   支持  |   支持
哈希索引    |       |   支持
集群索引    |       |   支持
数据缓存    |       |   支持
索引缓存    | 支持   |   支持
数据可压缩   | 支持    |   
空间使用    | 低     | 高
内存使用    | 低     | 高
外键        |        | 支持

MyISAM 
1.MyISAM的索引和数据是分开的，并且索引是有压缩的；Innodb是索引和数据是紧密捆绑的
2.MyISAM恢复，移植方便
3.Innodb达不到MyISAM的写性能，如果是针对基于索引的update操作，虽然MyISAM可能会逊色Innodb，如并发高，myISM可通过分库分表解决
4.myISAM merge引擎
5.系统内建全文索引

索引的指针和锁的策略有关的，数据是顺序存储的（innodb数据存储方式是聚簇索引）索引btree上的节点是一个指向数据物理位置的指针，所以查找起来很快

Innodb
1.InnoDB可以利用事务日志进行数据恢复，这会比较快。而MyISAM可能会需要几个小时甚至几天来干这些事，InnoDB只需要几分钟。
2.select count(*) 和order by一类的，Innodb其实也是会锁表

LRU midpoint insertion strategy
innodb_old_blocks_time


---
#外键约束
[MySql 外键约束 之CASCADE、SET NULL、RESTRICT、NO ACTION分析和作用](http://www.cnblogs.com/yzuzhang/p/5174720.html)
CASCADE
在父表上update/delete记录时，同步update/delete掉子表的匹配记录 

SET NULL
在父表上update/delete记录时，将子表上匹配记录的列设为null (要注意子表的外键列不能为not null)  

NO ACTION
如果子表中有匹配的记录,则不允许对父表对应候选键进行update/delete操作  

RESTRICT
同no action, 都是立即检查外键约束

SET NULL
父表有变更时,子表将外键列设置成一个默认的值 但Innodb不能识别

NULL、RESTRICT、NO ACTION
删除：从表记录不存在时，主表才可以删除。删除从表，主表不变
更新：从表记录不存在时，主表才可以更新。更新从表，主表不变
 
CASCADE
删除：删除主表时自动删除从表。删除从表，主表不变
更新：更新主表时自动更新从表。更新从表，主表不变
 
SET NULL
删除：删除主表时自动更新从表值为NULL。删除从表，主表不变
更新：更新主表时自动更新从表值为NULL。更新从表，主表不变

外键约束属性： RESTRICT | CASCADE | SET NULL | NO ACTION  外键的使用需要满足下列的条件：
1. 两张表必须都是InnoDB表，并且它们没有临时表。
2. 建立外键关系的对应列必须具有相似的InnoDB内部数据类型。
3. 建立外键关系的对应列必须建立了索引。
4. 假如显式的给出了CONSTRAINT symbol，那symbol在数据库中必须是唯一的。假如没有显式的给出，InnoDB会自动的创建。


---
#索引
##优点
* 减少服务器扫描的数据量
* 帮助服务器避免排序和临时表
* 将随机IO变为顺序IO

##I.b-tree索引
```sql
create table people(
    last_name varhcar(50) not null,
    first_name varhcar(50) not null,
    dob     data not null,
    gender  enum('m','f') not null,
    key(last_name,first_name,dob)
    );
```
索引有效情况
* 全值匹配
* 匹配最左前缀，如给出last_name值
* 匹配列前缀，如 last name以J开头
* 匹配范围值，
* 精确匹配某一列并范围匹配另外一列，如last name=allen,first name开头为K
* 只访问索引的查询
索引还可满足排序需求

###二级索引
使用额外的间接层，二级索引记录指向主索引记录，而主索引本身包含在磁盘上的排的位置

* 缺点
查找需要两次。行上的（first, last）索引查找，我们实际上需要做两查找。第一次查找表，找到记录的主键。一旦找到主键，则根据主键找到记录在磁盘上的位置。

* 优点
更新如果一个行偏移的变化，只有主索引需要更新。

###限制
* 不是从最左列开始查找，或某个字母结尾的
* 不能跳过索引中的列，如给出了last_name，dob，但没有给出first_name
* 查询中有某个列的范围查询，则右边的所有列都无法使用索引优化查找，如last_name='Smith' AND first_name LIKE 'J%' AND dob='1976-12-23'，只能使用到last_name,first_name
PS:以上限制，在未来版本可能变更

##II.哈希索引
###限制
* 只包含哈希值和行指针，不存储字段值，不能避免行读取
* 不是按照所有值顺序存储，无法排序
* 不支持部分索引列匹配查找，如索引(A,B)，查询值只有A,则无法使用索引
* 只支持等值比较查询，包括=、IN()、<=>，不支持任何范围
* 速度很快，除非有很多哈希冲突
* 冲突很多情况下，维护索引操作代价较高

innoDB自适应哈希索引

自定义哈希索引，如：较长的字符串+crc(字符串)
    手动维护、触发器维护

##III.空间树索引
地理数据存储
##IV.全文索引
##V.分形树索引

##高性能索引策略
* 独立的列 where actor_id+1=5
* 前缀索引和索引选择性（不重复的索引值）
    select count(distinct left(xxx,3))/count(*) from ttt;
* 多列索引
    - 多列建立独立索引并不能提高性能
* 选择合适的索引列顺序（只适用与btree）
    - 选择性更高的索引在前
    - 特殊值，某些值特别多，如：默认值，
* 聚簇索引
    - 相关数据保存在一起
    - 数据访问更快
    - 覆盖索引扫描的查询可以直接使用叶节点中的主键值
    缺点：
    - 最大限度提高了IO密集型应用的性能
    - 插入速度严重依赖插入顺序，如果不是按照主键顺序加载数据，加载完后最好OPTIMIZE TABLE重新组织表
    - 更新聚簇索引列代价很高
    - 基于聚簇索引的表插入新行或者主键被更新导致需要移动行的时候，可能面临 页分裂 问题，导致表占用更多磁盘空间
    - 聚簇索引导致全表扫描变慢，尤其是行比较稀疏，或者 页分裂
    - 二级索引 比想象的更大
    - 二级索引 两次索引查找，索引存的是主键值（好处是移动行，不需要更新），而不是物理地址，自适应哈希可以减少重复工作

    索引值最好为顺序，随机值会导致页分裂，缓存失效，如UUID，可以通过OPTIMIZE TABLE重建优化表

    延迟关联 deferred join
    
* 索引排序
    - 索引顺序与Orderby子句顺序一致，所有列排序方向（倒序或正序）一样，才能用索引来对结果排序
    - 满足索引最左前缀，前面列如果为常量 也可满足
* 压缩索引
    - 前缀压缩，空间更少，某些操作更慢
* 冗余重复索引
    - A,ID，ID为主键列，已经包含在二级索引中了
    - 索引越多插入速度越慢
* 未使用的索引
* 索引和锁
    - 只有当innoDB在存储引擎层能够过滤掉所有不需要的行时，才有效
    - 范围查询
    - 二级索引-共享锁，主键索引-排它锁


---
#排序 #sort
http://geek.csdn.net/news/detail/105891
##MySQL的sort_mode有三种
<sort_key, rowid>对应的是MySQL 4.1之前的“原始排序模式”
<sort_key, additional_fields>对应的是MySQL 4.1以后引入的“修改后排序模式”
<sort_key, packed_additional_fields>是MySQL 5.7.3以后引入的进一步优化的”打包数据排序模式”

##回表排序模式
扫描->sort buffer/临时文件
* 根据索引或者全表扫描，按照过滤条件获得需要查询的排序字段值和row ID；
* 将要排序字段值和row ID组成键值对，存入sort buffer中；
* 如果sort buffer内存大于这些键值对的内存，就不需要创建临时文件了。否则，每次sort buffer填满以后，需要直接用qsort(快速排序算法)在内存中排好序，并写到临时文件中；
* 重复上述步骤，直到所有的行数据都正常读取了完成；
* 用到了临时文件的，需要利用磁盘外部排序，将row id写入到结果文件中；
* 根据结果文件中的rowID按序读取用户需要返回的数据。由于row ID不是顺序的，导致回表时是随机IO，为了进一步优化性能（变成顺序IO），MySQL会读一批rowID，并将读到的数据按排序字段顺序插入缓存区中(内存大小read_rnd_buffer_size)。

##2 不回表排序模式
扫描->sort buffer/临时文件->结果文件
* 根据索引或者全表扫描，按照过滤条件获得需要查询的数据；
* 将要排序的列值和用户需要返回的字段组成键值对，存入sort buffer中；
* 如果sort buffer内存大于这些键值对的内存，就不需要创建临时文件了。否则，每次sort buffer填满以后，需要直接用qsort(快速排序算法)在内存中排好序，并写到临时文件中；
* 重复上述步骤，直到所有的行数据都正常读取了完成；
* 用到了临时文件的，需要利用磁盘外部排序，将排序后的数据写入到结果文件中；
* 直接从结果文件中返回用户需要的字段数据，而不是根据row ID再次回表查询。

##打包数据排序模式
第三种排序模式的改进仅仅在于将char和varchar字段存到sort buffer中时，更加紧缩。
在之前的两种模式中，存储了“yes”3个字符的定义为VARCHAR(255)的列会在内存中申请255个字符内存空间，但是5.7.3改进后，只需要存储2个字节的字段长度和3个字符内存空间（用于保存”yes”这三个字符）就够了，内存空间整整压缩了50多倍,可以让更多的键值对保存在sort buffer中。

##三种模式比较
第二种模式是第一种模式的改进，避免了二次回表，采用的是用空间换时间的方法。
但是由于sort buffer就那么大，如果用户要查询的数据非常大的话，很多时间浪费在多次磁盘外部排序，导致更多的IO操作，效率可能还不如第一种方式。
###回表/不回表
所以，MySQL给用户提供了一个max_length_for_sort_data的参数。当“排序的键值对大小” > max_length_for_sort_data时，MySQL认为磁盘外部排序的IO效率不如回表的效率，会选择第一种排序模式；反之，会选择第二种不回表的模式。

第三种模式主要是解决变长字符数据存储空间浪费的问题，对于实际数据不多，字段定义较长的改进效果会更加明显。
很多文章写到这里可能就差不多了，但是大家忘记关注一个问题了：“如果排序的数据不能完全放在sort buffer内存里面，是怎么通过外部排序完成整个排序过程的呢？”
要解决这个问题，我们首先需要简单查看一下外部排序到底是怎么做的。


##MySQL外部排序算法
那MySQL使用的外部排序是怎么样的列，我们以回表排序模式为例：
* 根据索引或者全表扫描，按照过滤条件获得需要查询的数据；
* 将要排序的列值和row ID组成键值对，存入sort buffer中；
* 如果sort buffer内存大于这些键值对的内存，就不需要创建临时文件了。否则，每次sort buffer填满以后，需要直接用qsort(快速排序模式)在内存中排好序，作为一个block写到临时文件中。跟正常的外部排序写到多个文件中不一样，MySQL只会写到一个临时文件中，并通过保存文件偏移量的方式来模拟多个文件归并排序；
* 重复上述步骤，直到所有的行数据都正常读取了完成；
* 每MERGEBUFF (7) 个block抽取一批数据进行排序，归并排序到另外一个临时文件中，直到所有的数据都排序好到新的临时文件中；
重复以上归并排序过程，直到剩下不到MERGEBUFF2 (15)个block。

通俗一点解释： 
第一次循环中，一个block对应一个sort buffer（大小为sort_buffer_size）排序好的数据；每7个做一个归并。 
第二次循环中，一个block对应MERGEBUFF (7) 个sort buffer的数据，每7个做一个归并。 
… 
直到所有的block数量小于MERGEBUFF2 (15)。
最后一轮循环，仅将row ID写入到结果文件中；
根据结果文件中的row ID按序读取用户需要返回的数据。为了进一步优化性能，MySQL会读一批row ID，并将读到的数据按排序字段要求插入缓存区中(内存大小read_rnd_buffer_size)。

这里我们需要注意的是：
* MySQL把外部排序好的分片写入同一个文件中，通过保存文件偏移量的方式来区别各个分片位置；
* MySQL每MERGEBUFF (7)个分片做一个归并，最终分片数达到MERGEBUFF2 (15)时，做最后一次归并。这两个值都写死在代码中了……


###sort_merge_passes
MySQL手册中对Sort_merge_passes的描述只有一句话
```
Sort_merge_passes
The number of merge passes that the sort algorithm has had to do. If this value is large, you should consider increasing the value of the sort_buffer_size system variable.
```
这段话并没有把sort_merge_passes到底是什么，该值比较大时说明了什么，通过什么方式可以缓解这个问题。
我们把上面MySQL的外部排序算法搞清楚了，这个问题就清楚了。
其实sort_merge_passes对应的就是MySQL做归并排序的次数，也就是说，如果sort_merge_passes值比较大，说明sort_buffer和要排序的数据差距越大，我们可以通过增大sort_buffer_size或者让填入sort_buffer_size的键值对更小来缓解sort_merge_passes归并排序的次数。
对应的，我们可以在源码中看到证据。
上述MySQL外部排序的算法中第5到第7步，是通过sql/filesort.cc文件中merge_many_buff()函数来实现，第5步单次归并使用merge_buffers()实现，源码摘录如下：
```c
int merge_many_buff(Sort_param *param, Sort_buffer sort_buffer,
                    Merge_chunk_array chunk_array,
                    size_t *p_num_chunks, IO_CACHE *t_file)
{
...

    for (i=0 ; i < num_chunks - MERGEBUFF * 3 / 2 ; i+= MERGEBUFF)
    {
      if (merge_buffers(param,                  // param
                        from_file,              // from_file
                        to_file,                // to_file
                        sort_buffer,            // sort_buffer
                        last_chunk++,           // last_chunk [out]
                        Merge_chunk_array(&chunk_array[i], MERGEBUFF),
                        0))                     // flag
      goto cleanup;
    }
    if (merge_buffers(param,
                      from_file,
                      to_file,
                      sort_buffer,
                      last_chunk++,
                      Merge_chunk_array(&chunk_array[i], num_chunks - i),
                      0))
      break;                                    /* purecov: inspected */
...
}
```
截取部分merge_buffers()的代码如下，
```c
int merge_buffers(Sort_param *param, IO_CACHE *from_file,
                  IO_CACHE *to_file, Sort_buffer sort_buffer,
                  Merge_chunk *last_chunk,
                  Merge_chunk_array chunk_array,
                  int flag)
{
...
  current_thd->inc_status_sort_merge_passes();
...
}
```
可以看到：每个merge_buffers()都会增加sort_merge_passes，也就是说每一次对MERGEBUFF (7)个block归并排序都会让sort_merge_passes加一，sort_merge_passes越多表示排序的数据太多，需要多次merge pass。解决的方案无非就是缩减要排序数据的大小或者增加sort_buffer_size。
打个小广告，在我们的qmonitor中就有sort_merge_pass的性能指标和参数值过大的报警设置。

##trace结果解释
说明白了三种排序模式和外部排序的方法，我们回过头来看一下trace的结果。
###6.1 是否存在磁盘外部排序
"number_of_tmp_files": 0,
number_of_tmp_files表示有多少个分片，如果number_of_tmp_files不等于0，表示一个sort_buffer_size大小的内存无法保存所有的键值对，也就是说，MySQL在排序中使用到了磁盘来排序。
###6.2 是否存在优先队列优化排序
由于我们的这个SQL里面没有对数据进行分页限制，所以filesort_priority_queue_optimization并没有启用
```
"filesort_priority_queue_optimization": {
              "usable": false,
              "cause": "not applicable (no LIMIT)"
            },
```
而正常情况下，使用了Limit会启用优先队列的优化。优先队列类似于FIFO先进先出队列。
算法稍微有点改变，以回表排序模式为例。
####sort_buffer_size足够大
如果Limit限制返回N条数据，并且N条数据比sort_buffer_size小，那么MySQL会把sort buffer作为priority queue，在第二步插入priority queue时会按序插入队列；在第三步，队列满了以后，并不会写入外部磁盘文件，而是直接淘汰最尾端的一条数据，直到所有的数据都正常读取完成。
算法如下：
* 根据索引或者全表扫描，按照过滤条件获得需要查询的数据
* 将要排序的列值和row ID组成键值对，按序存入中priority queue中
* 如果priority queue满了，直接淘汰最尾端记录。
* 重复上述步骤，直到所有的行数据都正常读取了完成
* 最后一轮循环，仅将row ID写入到结果文件中
* 根据结果文件中的row ID按序读取用户需要返回的数据。为了进一步优化性能，MySQL会读一批row ID，并将读到的数据按排序字段要求插入缓存区中(内存大小read_rnd_buffer_size)。
####sort_buffer_size不够大
否则，N条数据比sort_buffer_size大的情况下，MySQL无法直接利用sort buffer作为priority queue，正常的文件外部排序还是一样的，只是在最后返回结果时，只根据N个row ID将数据返回出来。具体的算法我们就不列举了。
这里MySQL到底是否选择priority queue是在sql/filesort.cc的check_if_pq_applicable()函数中确定的，具体的代码细节这里就不展开了。
另外，我们也没有讨论Limit m,n的情况，如果是Limit m,n， 上面对应的“N个row ID”就是“M+N个row ID”了，MySQL的Limit m,n 其实是取m+n行数据，最后把M条数据丢掉。
从上面我们也可以看到sort_buffer_size足够大对Limit数据比较小的情况，优化效果是很明显的。


##MySQL其他相关排序参数
###max_sort_length
这里需要区别max_sort_length和max_length_for_sort_data。
max_length_for_sort_data是为了让MySQL选择<sort_key, rowid>还是<sort_key, additional_fields>的模式。
而max_sort_length是键值对的大小无法确定时（比如用户要查询的数据包含了SUBSTRING_INDEX(col1, ‘.’,2)）MySQL会对每个键值对分配max_sort_length个字节的内存，这样导致内存空间浪费，磁盘外部排序次数过多。
###innodb_disable_sort_file_cache
innodb_disable_sort_file_cache设置为ON的话，表示在排序中生成的临时文件不会用到文件系统的缓存，类似于O_DIRECT打开文件
###innodb_sort_buffer_size
这个参数其实跟我们这里讨论的SQL排序没有什么关系。innodb_sort_buffer_size设置的是在创建InnoDB索引时，使用到的sort buffer的大小。
以前写死为1M，现在开放出来，允许用户自定义设置这个参数了。

##MySQL排序优化总结
最后整理一下优化MySQL排序的手段
* 排序和查询的字段尽量少。只查询你用到的字段，不要使用select*
* 使用Limit查询必要的行数据；
* 要排序或者查询的字段，尽量不要用不确定字符函数，避免MySQL直接分配max_sort_length，导致sort buffer空间不足；
* 使用索引来优化或者避免排序；
* 增加sort_buffer_size大小，避免磁盘排序；
* 不得不使用original排序算法时，增加read_rnd_buffer_size；
字段长度定义合适就好（避免过长）；
* tmpdir建议独立存放，放在高速存储设备上。
##参考文献
[ORDER BY Optimization](https://dev.mysql.com/doc/refman/5.7/en/order-by-optimization.html)
[How does a relational database work](http://coding-geek.com/how-databases-work/)




---
#事务
##隔离级别
     隔离级别    | 脏读 | 不可重复读| 幻读   | 加锁读
-----------------|------|-----------|--------|--------
read uncommitted |  Y   |   Y       |   Y    |  N
read committed   |  N   |   Y       |   Y    |  N
repeatable read  |  N   |   N       |   Y    |  N
serializable     |  N   |   N       |   N    |  N

间隙锁 next-key locking，防止幻读

InnoDB 通常在相同的行更新数据，如果旧事务因为 MVCC 的 MySQL 从库而需要引用一行，老数据将进入一个特殊的区域，称为回滚段。



---
#主从
##主从复制:
MySQL的主从复制解决了数据库的读写分离，并很好的提升了读的性能

###支持多个不同的复制模式
* 语句级别的复制
复制 SQL语句（例如，它会从字面上直译复制的语句，如：更新用户 SET birth_year = 770 WHERE ID = 4 ）
基于语句的复制通常最为紧凑，但可能需要从库来支持昂贵的语句来更新少量数据。
* 行级别的复制
复制所有变化的行记录
在另一方面，基于行的复制，如同 Postgres 的 WAL 复制，是更详细，但会导致对从库数据更可控，并且更新从库数据更高效。
* 混合复制
混合这两种模式




##性能瓶颈问题
1. 写入无法扩展
2. 写入无法缓存
3. 复制延时
4. 锁表率上升
5. 表变大，缓存率下降

##优化方案
按业务垂直分区，业务间独立，无法直接join
水平分区

---
#分表
[mysql分表的3种方法](http://www.blogjava.net/kelly859/archive/2012/06/08/380369.html)
执行一个sql的过程:
1,接收到sql;
2,把sql放到排队队列中;
3,执行sql;
4,返回执行结果
在这个执行过程中最花时间在什么地方呢？
第一，是排队等待的时间，
第二，sql的执行时间。
其实这二个是一回事，等待的同时，肯定有sql在执行。所以我们要缩短sql的执行时间。

表锁定（myisam存储引擎），一个是行锁定（innodb存储引擎）
1.mysql集群，利用mysql cluster ，mysql proxy，mysql replication，drdb等等
减少节点的sql排队队列中的sql的数量
优点：扩展性好，没有多个分表后的复杂操作（php代码）
缺点：单个表的数据量还是没有变，一次操作所花的时间还是那么多，硬件开销大。

2，预先估计会出现大数据量并且访问频繁的表，将其分为若干个表
hash,求余,根据时间
优点：避免一张表出现几百万条数据，缩短了一条sql的执行时间
缺点：当一种规则确定时，打破这条规则会很麻烦，上面的例子中我用的hash算法是crc32，如果我现在不想用这个算法了，改用md5后，会使同一个用户的消息被存储到不同的表中，这样数据乱套了。扩展性很差。

3，利用merge存储引擎来实现分表
如果要把已有的大数据量表分开比较痛苦，最痛苦的事就是改代码，因为程序里面的sql语句已经写好了。用merge存储引擎来实现分表, 这种方法比较适合.
a，如果你使用 alter table 来把 merge 表变为其它表类型，到底层表的映射就被丢失了。
b，一些说replace不起作用
c.一个 merge 表不能在整个表上维持 unique 约束。
d.当你创建一个 merge 表之时，没有检查去确保底层表的存在以及有相同的机构。
优点：扩展性好，并且程序代码改动的不是很大
缺点：这种方法的效果比第二种要差一点



---
#分布式
[分布式MySQL数据库TDSQL架构分析](http://mp.weixin.qq.com/s?__biz=MzAwNjMxNjQzNA==&mid=207514436&idx=1&sn=c20a2169fbf2339751086734e8a5f036&scene=5#rd)



---
#存储过程
###速查
[MySQL存储过程详解](http://blog.sina.com.cn/s/blog_52d20fbf0100ofd5.html)


http://mp.weixin.qq.com/s?__biz=MzAwNjMxNjQzNA==&mid=207514436&idx=1&sn=c20a2169fbf2339751086734e8a5f036&scene=5#rd
