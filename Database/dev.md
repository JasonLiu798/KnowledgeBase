#database development notes
---
#分库分表
固定哈希
    B:扩容需要迁移数据，如4个库，模4，扩为模6，只有模6、4结果相同数据不迁移
一致性哈希
    节点对应哈希值变为范围，增删节点只涉及上/下一个节点
    虚节点：应对增删节点对附近节点压力的成倍增加，一个物理节点拆分为多个虚节点，分担压力

#读写分离
多从库对一主库
主库备库不同的复制，非对称
引入数据变更平台

平滑的数据迁移

---
#Transaction
第一类丢失更新：撤销一个事务时，把其他事务已提交的更新数据覆盖。　
脏读：一个事务读到另一个事务未提交的更新数据。
虚读：一个事务读到另一个事务已提交的新插入的数据。
不可重复读：一个事务读到另一个事务已提交的更新数据。
第二类丢失更新：这是不可重复读中的特例，一个事务覆盖另一个事务已提交的更新数据。　　
##隔离级别
Serializable(串行化)：一个事务在执行过程中完全看不到其他事务对数据库所做的更新。
Repeatable Read(可重复读)：一个事务在执行过程中可以看到其他事务已经提交的新插入的记录，但是不能看到其他事务对已有记录的更新。
Read Commited（读已提交数据）：一个事务在执行过程中可以看到其他事务已经提交的新插入的记录，而且能看到其他事务已经提交的对已有记录的更新
Read Uncomitted（读未提交数据）：一个事务在执行过程中可以拷打其他事务没有提交的新插入的记录，而且能看到其他事务没有提交的对已有记录的更新。
##锁分类
A.悲观锁：指在应用程序中显示的为数据资源加锁。尽管能防止丢失更新和不可重复读这类并发问题，但是它会影响并发性能，因此应该谨慎地使用。 
b.乐观锁：乐观锁假定当前事务操作数据资源时，不回有其他事务同时访问该数据资源，因此完全依靠数据库的隔离级别来自动管理锁的工作。应用程序采用版本控制手段来避免可能出现的并发问题。
##悲观锁
A.在应用程序中显示指定采用数据库系统的独占所来锁定数据资源。SQL语句：select ... for update，在Hibernate中使用get，load时如session.get(Account.class,new Long(1),LockMode,UPGRADE) 
B.在数据库表中增加一个表明记录状态的LOCK字段，当它取值为“Y”时，表示该记录已经被某个事务锁定，如果为“N”，表明该记录处于空闲状态，事务可以访问它。增加锁标记字段就可以实现。
##乐观锁
是由程序提供的一种机制，这种机制既能保证多个事务并发访问数据，又能防止第二类丢失更新问题。
在应用程序中可以利用Hibernate提供的版本控制功能来视线乐观锁，OR映射文件中的<version>元素和<timestamp>都具有版本控制的功能，一般推荐采用<version>


---
# functionals
## 分页
### mysql
explain SELECT * FROM message ORDER BY id DESC LIMIT 10000, 20
### limit性能问题
select * from t_user t where user_id <> 'root' and rownum>4 order by rownum  asc limit 3
SELECT * FROM message WHERE id > 9527 ORDER BY id ASC LIMIT 20;
SELECT * FROM message WHERE id < 9500 ORDER BY id DESC LIMIT 20;
### oracle
select * from {
    select rownum rn,t.* from{
    select * from t_user t where user_id <> 'root' order by user_id
    } t where rownum <=4
} where rn>2;

## 去重
###交叉列去重
####两列交叉
    select * from t where (c1,c2) not in (
      select  t2.c2,t2.c1 from t t2 join t t3 on t3.c1=t2.c2 where t2.id>t3.id
    );

        select * from t where (c1,c2) not in (
      select  t2.c2,t2.c1 from t t2 join t t3 on t3.c1=t2.c2 where t2.id>t3.id
    );
    
####三列交叉
有这样一个表relation(f1, f2, c), 要去查询表中记录，并且将不同记录中f1 =  f2, f2 = f1, c = c的结果去重，比如(a, b, c), (b, a, c)只保留一条记录。
答案参考下面：
select * from relation where (f1, f2, c) not in (select a.f1, a.f2, a.c from relation as a inner join relation as b on a.f1 = b.f2 and a.f2 = b.f1 and a.c = b.c where a.f1 > a.f2);
这里面没有考虑a.f1 = a.f2, 加上这个条件,只需增加distinct：
select distinct * from relation where (f1, f2, c) not in (select a.f1, a.f2, a.c from relation as a inner join relation as b on a.f1 = b.f2 and a.f2 = b.f1 and a.c = b.c where a.f1 > a.f2);


---
#sql parser
##druid parser
[druid parser](https://github.com/alibaba/druid/wiki/SQL-Parser)

SQL Parser是Druid的一个重要组成部分，Druid内置使用SQL Parser来实现防御SQL注入（[WallFilter](https://github.com/alibaba/druid/wiki/%E7%AE%80%E4%BB%8B_WallFilter)）、合并统计没有参数化的SQL([StatFilter](https://github.com/alibaba/druid/wiki/%E9%85%8D%E7%BD%AE_StatFilter)的mergeSql)、[SQL格式化](https://github.com/alibaba/druid/wiki/SQL%E6%A0%BC%E5%BC%8F%E5%8C%96)、分库分表。

### 各种语法支持
Druid的sql parser是目前支持各种数据语法最完备的SQL Parser。目前对各种数据库的支持如下：
<table>
<tr><td>数据库</td><td>DML</td><td>DDL</td></tr>
<tr><td>odps</td><td>完全支持</td><td>完全支持</td></tr>
<tr><td>mysql</td><td>完全支持</td><td>完全支持</td></tr>
<tr><td>oracle</td><td>大部分</td><td>支持大部分</td></tr>
<tr><td>postgresql</td><td>完全支持</td><td>支持大部分</td></tr>
<tr><td>sql server</td><td>支持常用的</td><td>支持常用的ddl</td></tr>
<tr><td>db2</td><td>支持常用的</td><td>支持常用的ddl</td></tr>
</table>
druid还缺省支持sql-92标准的语法，所以也部分支持其他数据库的sql语法。

### 性能
Druid的SQL Parser是手工编写，性能是antlr、javacc之类工具生成的数倍甚至10倍以上。

      SELECT ID, NAME, AGE FROM USER WHERE ID = ?

这样的SQL，druid parser处理大约是5us，也就是每秒中可以处理20万次。

* 测试代码看这里： https://github.com/alibaba/druid/blob/master/src/test/java/com/alibaba/druid/benckmark/sql/MySqlPerfTest.java

###  Druid SQL Parser的代码结构
Druid SQL Parser分三个模块：
* Parser
* AST
* Visitor

### parser
parser是将输入文本转换为ast（抽象语法树），parser有包括两个部分，Parser和Lexer，其中Lexer实现词法分析，Parser实现语法分析。

### AST
AST是Abstract Syntax Tree的缩写，也就是抽象语法树。AST是parser输出的结果。

### Visitor
Visitor是遍历AST的手段，是处理AST最方便的模式，Visitor是一个接口，有缺省什么都没做的实现VistorAdapter。

我们可以实现不同的Visitor来满足不同的需求，Druid内置提供了如下Visitor: 
* OutputVisitor用来把AST输出为字符串
* WallVisitor来分析SQL语意来防御SQL注入攻击
* ParameterizedOutputVisitor用来合并未参数化的SQL进行统计
* [EvalVisitor](https://github.com/alibaba/druid/wiki/EvalVisitor) 用来对SQL表达式求值
* ExportParameterVisitor用来提取SQL中的变量参数
* SchemaStatVisitor用来统计SQL中使用的表、字段、过滤条件、排序表达式、分组表达式

### 方言
SQL-92、SQL-99等都是标准SQL，mysql/oracle/pg/sqlserver等都是方言，也就是dialect。parser/ast/visitor都需要针对不同的方言进行特别处理。



#树形表设计
[用depth字段优化指定深度节点的查询](http://www.nowamagic.net/academy/detail/32062020)
[用层级关系字段输出无限级分类](http://www.nowamagic.net/academy/detail/32062013)
depth 表示当前节点的深度的整数。
parentid_list 表示从根节点到当前节点的路径的字符串，采用节点名称不可能出现的字符作为分隔符。




