

[SteveY对Amazon和Google平台的吐槽](http://coolshell.cn/articles/5701.html)


#最终一致性
过去，所有的一切都是写在纸上的假象，至少过去几十年一直如此，即时一致性是IT人发明的，他们纸上谈兵地认为：不同组织不同地方的数据如果没有即时一致性(高一致性)几乎不可能的。
##Amazon推荐
Amazon的商品购买模式是一个巨大的用户/产品关联矩阵，立即全部更新几乎是不可能的，每次一个商品被购买这个页面将被锁住(banq注：这可能是前段时间我在京东商城购买进入购物车后出现无法连接的问题所在)。
那么，Amazon如何在同一个时间销售数百商品同时生成带有推荐的专有页面呢？，只有一个简单办法：缓存层。
每一个缓存都是基于最终一致性，当然要排除下面情况，当缓存失效必须确定性的，缓存的最终一致性和NoSQL一致性区别是：过段时间缓存将失效，你能够缓存一个HTML页面10秒，但是CouchDB的内容总是有效，即使这个数据结果非常陈旧被丢在什么旮旯，通过CouchDB查询都能通过无等待的堵塞获得，无需再重新计算后缓存。

##Google搜索案例
相同的一致性模型适用于谷歌（和任何搜索引擎）：爬虫爬行花费大量的时间，搜索结果总是与被搜索网络的当前状态不一致。
尽管2011年时的Index索引每小时更新一次，但是跨多个数据中心更新将是持续很长时间，专业词语：Google dance：当每次PageRank更新时，每个数据中心返回不同的排序的SERP结果。这些都没有妨碍google成为一个Web超级大国。

##Dropbox案例
尽管Dropbox 在很多场合通过同步实现即时一致性，这样你无论使用什么设备无论在什么地方都可以保证你设备中目录文件始终一致相同的。
这种即时一致性背后隐藏了很多复杂性，象Delta压缩算法和管理冲突，以及如有局域网尽可能用局域网，其他情况用互联网等等。
Dropbox积极面对最终一致性，事务一致性将是不可能在一个大型网络如互联网上进行的，正如你的文字处理器在你每次按Ctrl+S时能够暂停一下那样，将更新发往其他设备，这些是不可能的，即时实时一致性也是不可能在一个网络分区需要网络连接的环境中实现的。
这样最后的结果是：你在编辑你的文档，当连接可用时，这些更新将被发往其他设备，有时会花费很长时间同步，特别是你有大文件上传时。


##银行和钞票案例
在意大利银行之间转帐还是要花费一定的时间，你可以想象装满钞票和警察的运钞车来回忙碌，尽管很多是通过数字化网络进行，但是商业业务协议还是和以前一样，电汇当天结束，次日才真正办理。

银行转帐总是选择一个典型的数据库事务实现，如果两个账户在同一家银行也许是可能实现的，但这种情况并不普遍......

银行提供了各种日志以便钞票不会消失，但是你看到的是系统外部状态，你看到你的账户钱少了，但不知道电汇正在发生。

有时即时一致性实现需要一种创新：Paypal能够在全世界几秒内实现转帐，允许电子商务网站买卖家能够瞬间完成交易。

但是商家在接受Paypal支付时，经常告诉你：我们已经接受处理你的订单，请等待我们的处理结果，而同时他们也许正在他们仓库中寻找那个商品，在线服务并不总是和实际库存是一致的。















