
横表就是普通的建表方式，如一个表结构为： 
主键、字段1、字段2、字段3。。。 
如果变成纵表后，则表结构为： 
主键、字段代码、字段值。 
而字段代码则为字段1、字段2、字段3。  

具体为电信行业的例子。以用户帐单表为例一般出账时用户有很多费用客户，其数据一般存储为：时间，客户ID,费用科目，费用。这种存储结构一般称为纵表，其特点是行数多，字段少。 纵表在使用时由于行数多，统计用户数或对用户进行分档时还需要进行GROUP BY 操作，性能低，且操作不便，为提高性能，通常根据需要将纵表进行汇总，形成横表，比如：时间、客户ID,基本通话费、漫游通话费，国内长途费、国际长途费....。通常形成一个客户一行的表，这种表统计用户数或做分档统计时比较方便。另外，数据挖掘时用到的宽表一般也要求是横表结构。 

纵表对从数据库到内存的映射效率是有影响的，但细一点说也要一分为二： 
纵表的初始映射要慢一些； 
纵表的变更的映射可能要快一些，如果只是改变了单个字段时，毕竟横表字段比纵表要多很多。 

我想这个还是在讨论如何优化数据库数据结构的问题。 
另：我亲身遭受过帐务系统表的横表和纵表的问题的折磨，横表使结构一目了然，但几乎不能扩展，当用户部署新业务时捉襟见肘，纵表似乎有无限的扩展性，但代价是有些凌乱，不便于理解，更要命的是数据管理上不够安全，我就知道某地方的帐务系统帐务配置表（纵表）被某位专家级操作者无意删除了一条，就是一条啊！结果......，而横表，你要改他的结构不是那么容易的，不过两者对帐务程序性能的影响几乎没有任何区别。 

# 性能

# 使用便利性
纵表：可以用mybatis-generator自动生成一些常用的增删查改操作，通过插件还可以生成更多的类型的操作，如批量的新增、修改、删除，逻辑删除，过滤逻辑删除的查询等，初期比较节省时间；
连表的查询操作一般比较好写
在有generator的情况下，修改操作基本也不需要单独写sql了

横表：体现在强大的灵活性，初期
不便利体现在关系查询

id|  c1  |  c2 
--|------|------
1 | v1-1 | v1-2
2 | v2-1 | v2-2

id | pk | type | key | value
---|----|------|-----|-------
1  | 1  | t1   | c1  |  v1
1  | 1  | t1   | c2  |  v2



# 扩展性



















