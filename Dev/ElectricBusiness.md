#Electric Business
---
#basic
[电商检索系统总结——功能篇](http://segmentfault.com/a/1190000000519171)


##QPS（Query Per Second，每秒处理请求数）
高并发的实际场景下，机器都处于高负载的状态，在这个时候平均响应时间会被大大增加->QPS降低->恶性循环最终导致“雪崩”


[电商参考架构第一部分：搭建一个灵活、可搜索、响应快速的产品目录系统](http://segmentfault.com/a/1190000002973405)

[亿级Web系统搭建——单机到分布式集群](http://hansionxu.blog.163.com/blog/static/24169810920141099520309/)



---
#秒杀
[徐汉彬：Web系统大规模并发——电商秒杀与抢购](http://www.csdn.net/article/2014-11-28/2822858)
商品详情页面的静态化，varnish加速，秒杀商品库独立部署服务器
##库存
###库层面解决办法
[秒杀核心设计(减库存部分)-防超卖与高并发](http://www.dataguru.cn/thread-485176-1-1.html)

2张表：
第一张：判重表(buy_record)，该用户有没秒杀过该商品
字段: id, uid, goods_id, addtime
第二张表：商品表 goods
字段： goods_id   goods_num
####方案1
  start transaction;
  select id from buy_record where uid=$uid and goods_id=$goods_id;
  if(结果不为空)
      抛异常，回滚。
  insert into buy_record。。。
  if(受影响行数<=0)
          抛异常，回滚。。。  
  select goods_num from goods where goods_id=$good_id;
  if(库存<=0)
          抛异常，回滚。。。  
  update goods set goods_num=goods_num-1 where goods_id=$goods_id;
  if(受影响行数<=0)该方法在高并发下几乎必然导致超卖。当库存为1的时候刚好多个用户同时    select goods_num from goods where goods_id=$good_id;此时库存刚好大于0，做update操作的时候必然减到小于0.  同时上面进行是否秒杀过的判重同样会出现类似问题

####方案二
  start transaction;
      select id from buy_record where uid=$uid and goods_id=$goods_id          for       update        ;  
  if(结果不为空)
      抛异常，回滚。
  insert into buy_record。。。
  if(受影响行数<=0)
      抛异常，回滚。。。
      select goods_num from goods where goods_id=$good_id    for update    ;  
  if(库存<=0)
      抛异常，回滚。。。
      update goods set goods_num=goods_num-1     where goods_id=$goods_id    ;  
  if(受影响行数<=0)
      抛异常，回滚。。。
      该方法有效的防止了超卖，但是在每次select的时候加上了排它锁，每次select操作都会被堵塞    ，并发性能大大降低。  

####方案三
对（uid,goods_id）加唯一索引！！      
  start transaction;
    insert into buy_record。。。  
  if(唯一索引报错？)
    抛异常，已经秒过了，回滚。。。
    update goods set goods_num=goods_num-1 where goods_id=$goods_id and goods_num>0;      
  if(受影响行数<=0)
    抛异常，商品秒完了，回滚。。。
    该方法完美的解决了超卖与select排它锁导致的并发低的问题，并且4个sql缩减成2个sql语句。极大提升性能  

###重启与过载保护
如果系统发生“雪崩”，贸然重启服务，是无法解决问题的。最常见的现象是，启动起来后，立刻挂掉。这个时候，最好在入口层将流量拒绝，然后再将重启。如果是redis/memcache这种服务也挂了，重启的时候需要注意“预热”，并且很可能需要比较长的时间。

如果检测到系统满负载状态，拒绝请求也是一种保护措施。
在前端设置过滤是最简单的方式，但是，这种做法是被用户“千夫所指”的行为。更合适一点的是，将过载保护设置在CGI入口层，快速将客户的直接请求返回。


##作弊：进攻与防守
1. 同一个账号，一次性发出多个请求
导致某些判断条件被绕过，判断过程中的多个请求结果相同，被绕过
M：在程序入口处，一个账号只允许接受1个请求，其他请求过滤，可以通过Redis这种内存缓存服务，写入一个标志位（只允许1个请求写成功，结合watch的乐观锁的特性），成功写入的则可以继续参加。
2. 多个账号（僵尸账号），一次性发送多个请求
通过检测指定机器IP请求频率就可以解决，如果发现某个IP请求频率很高，可以给它弹出一个验证码或者直接禁止它的请求：验证码；直接禁止IP
3. 多个账号，不同IP发送不同请求
通常只能通过设置业务门槛高来限制这种请求了，或者通过账号行为的”数据挖掘“来提前清理掉它们。
僵尸账号也还是有一些共同特征的，账号很可能属于同一个号码段甚至是连号的，活跃度不高，等级低，资料不全等等。
4. 火车票的抢购
唯一可以动心思的也许是对账号数据进行“数据挖掘”，这些黄牛账号也是有一些共同特征的，例如经常抢票和退票，节假日异常活跃等等。将它们分析出来，再做进一步处理和甄别。

##高并发下的数据安全
###悲观锁思路
###FIFO队列思路
但是，系统处理完一个队列内请求的速度根本无法和疯狂涌入队列中的数目相比，队列内的请求会越积累越多，最终Web系统平均响应时候还是会大幅下降，系统还是陷入异常。
###乐观锁思路
Redis中的watch

---
查看，搜索，比价，折扣，查看评价
下单
付款
发货
收货
评价

[电商参考架构第一部分：搭建一个灵活、可搜索、响应快速的产品目录系统](http://segmentfault.com/a/1190000002973405)
[电商参考架构第二部分：库存优化方法](http://segmentfault.com/a/1190000002989219)










