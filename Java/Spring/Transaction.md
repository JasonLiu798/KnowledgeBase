

#隔离级别
##  Dirty reads--读脏数据
 也就是说，比如事务A的未提交（还依然缓存）的数据被事务B读走，如果事务A失败回滚，会导致事务B所读取的的数据是错误的。
## non-repeatable reads--数据不可重复读
比如事务A中两处读取数据-total-的值。在第一读的时候，total是100，然后事务B就把total的数据改成 200，事务A再读一次，结果就发现，total竟然就变成200了，造成事务A数据混乱。
## phantom reads--幻象读数据
这个和non-repeatable reads相似，也是同一个事务中多次读不一致的问题。但是non-repeatable reads的不一致是因为他所要取的 **数据集** 被改变了（比如total的数据），但是phantom reads所要读的数据的不一致却不是他所要读的数据集改变，而是他的 **条件数据集** 改变。比如Select account.id where account.name="ppgogo*",第一次读去了6个符合条件的id，第二次读取的时候，由于事务b把一个帐号的名字由"dd"改成"ppgogo1"，结果取出来了7个数据。

					| 脏读 	|不可重复读	| 幻读 
--------------------|-------|-----------|------
Serializable 		| 不会 	| 不会		| 不会 
REPEATABLE READ 	| 不会	| 不会 		| 会 
READ COMMITTED 		| 不会 	| 会 		| 会 
Read Uncommitted 	| 会	| 会 		| 会

## Spring事务的隔离级别Isolation
* ISOLATION_DEFAULT：PlatfromTransactionManager默认的隔离级别，使用数据库默认的事务隔离级别.
另外四个与JDBC的隔离级别相对应
* ISOLATION_READ_UNCOMMITTED:这是事务最低的隔离级别，它充许令外一个事务可以看到这个事务未提交的数据。这种隔离级别会产生脏读，不可重复读和幻像读。
* ISOLATION_READ_COMMITTED:保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据
* ISOLATION_REPEATABLE_READ:这种事务隔离级别可以防止脏读，不可重复读。但是可能出现幻读。它除了保证一个事务不能读取另一个事务未提交的数据外，还保证了避免下面的情况产生(不可重复读)。
* ISOLATION_SERIALIZABLE 

---
#传播
##PropagationBehavior
    REQUIRED 不存在创建新事务，存在则加入
    SUPPORTS 不存在则直接执行，存在则加入
    MANDATORY 强制存在，不存在抛出异常，自身不新建事务
    REQUIRES_NEW 不管存在与否，都创建，[独立于已经存在事务]
    NOT_SUPPORTED 不支持当前事务，没有事务的情况下执行
    NEVER 存在则异常
    NESTED 存在，则在当前的嵌套事务执行，不存在创建新事务
Timeout
ReadOnly


##注解
[@Transactional spring 配置事务 注意事项 ](http://blog.sina.com.cn/s/blog_667ac0360102ebem.html)
@Transactional

    <!-- 使用annotation定义事务 -->
    <tx:annotation-driven transaction-manager="transactionManager" proxy-target-class="true" />
    <!-- 定义aspectj -->
    <aop:aspectj-autoproxy proxy-target-class="true" />
cglib与java动态代理最大区别是代理目标对象不用实现接口,那么注解要是写到接口方法上，要是使用cglib代理，这是注解事物就失效了，为了保持兼容注解最好都写到实现类方法上。
事务开启 ，或者是基于接口的 或者是基于类的代理被创建。同一个类中一个方法调用另一个方法有事务的方法，事务是不会起作用的。
默认情况下，如果被注解的数据库操作方法中发生了unchecked异常，所有的数据库操作将rollback；如果发生的异常是checked异常，默认情况下数据库操作还是会提交的。

####checked exception回滚
@Transactional(rollbackFor=Exception.class)
//rollbackFor这属性指定了，既使你出现了checked这种例外，那么它也会对事务进行回滚

####传播设定
@Transactional(propagation=Propagation.NOT_SUPPORTED)

###分布式事务
[JOTM例子](http://log-cd.iteye.com/blog/807607)


---
# 不回滚的情况
## 不回滚的异常
spring声明式事务管理默认对非检查型异常和运行时异常进行事务回滚，而对检查型异常则不进行回滚操作。

1.继承自runtimeexception或error的是非检查型异常，而继承自exception的则是检查型异常（当然，runtimeexception本身也是exception的子类）。
2.对非检查型类异常可以不用捕获，而检查型异常则必须用try语句块进行处理或者把异常交给上级方法处理总之就是必须写代码处理它。所以必须在service捕获异常，然后再次抛出，这样事务方才起效。

一个统一的异常层次结构对于提供服务抽象是必需的。 最重要的就是org.springframework.dao.DataAccessException以及其子类了。 需要强调的是Spring的异常机制重点在于应用编程模型。与SqlException和其他数据存取API不同的是: Spring的异常机制是为了让开发者使用最少, 最清晰的代码。DataAccessException和其他底层异常都是非检查性异常(unchecked exception)。 spring的原则之一就是基层异常就应该是非检查性异常. 原因如下: 
1. 基层异常通常来说是不可恢复的。 
2. 检查性异常将会降低异常层次结构的价值.如果底层异常是检查性的, 那么就需要在所有地方添加catch语句进行捕获。 
3.try/catch代码块冗长混乱, 而且不增加多少价值。 
使用检查异常理论上很好, 但是实际上好象并不如此。 

## 直接用jdbc操作

## orm框架

## 使用注解，没有加配置
```xml
<tx:annotation-driven transaction-manager="transactionManager"/>
```

## 只读被忽略
```java
@Transactional(readOnly = true, propagation=Propagation.SUPPORTS)   
public long insertTrade(TradeData trade) throws Exception {
   //JDBC Code...

}

@Transactional(readOnly = true, propagation=Propagation.SUPPORTS)
public long insertTrade(TradeData trade) throws Exception {
   //JDBC Code...

}
```
SUPPORTS 如果没有事务，则readOnly会被忽略





---------
#实现
## interface TransactionDefinition
    transaction.support.DefaultTransactionDefinition
        TransactionTemplate

## TransactionStatus
SavepointManager 支持嵌套事务
interface transaction.TransactionStatus
    DefaultTransactionStatus
    SimpleTransactionStatus

## PlatformTransactionManager (strategy模式)
实现类
JDBC/myBatis    DataSourceTransactionManager
Hibernate       HibernateTransactionManager
全局事务    jta.JtaTransactionManager

TransactionSynchronization 事务处理过程中的回调接口
TransactionSynchronizationManager 资源绑定目的地

## AbastractTransactionManager
    DataSourceTransactionManager
    Hibernate...

AbastractTransactionManager处理流程
    判断是否存在当前事务
    根据TransactionDefinition的PropagationBehavior传播行为执行逻辑
    根据情况挂起或恢复事务
    提前事务前检查readOnly是否设置，是则回滚代替提交
    如回滚则恢复状态
    如Synchronization为active，触发回调接口

getTransaction(TransactionDefinition definition)
开启事务，并判断之前是否有事务，如存在则决定挂起或异常
    Object transaction=doGetTransaction();//根据实现类各异，返回transactionObject
    if( definition == null ){
        definition = new DefaultTransactionDefinition();
    }
    if( isExistiongTransaction(transaction)){//是否存在事务
        return handleExistingTransaction(definition,transaction,debugEnabled);
    }

    isExistiongTransaction = true
    handleExistingTransaction
        REQUIRES_NEW    挂起后返回新事务
        NOT_SUPPORTED   挂起后返回
        NEVER 抛出异常
        NESTED 根据情况创建嵌套事务，通过Savepoint或JTA的TransactionManager

    isExistiongTransaction=false
        MANDATORY   抛出异常







