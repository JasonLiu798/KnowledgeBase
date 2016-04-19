#hibernate
---
#Theory
[Hibernate 3 深度解析](https://www.ibm.com/developerworks/cn/java/j-lo-hibernate3/)

##Hibernate 的对象关系映射
    @Entity
    @Table(name = "TEST", schema = "PUBLIC", catalog = "TEST")
    public class Test implements java.io.Serializable {
        private int id;private String name;
        public Test() {}
        public Test(int id) {this.id = id;}
        public Test(int id, String name) {
            this.id = id;
            this.name = name;}
        @Id
        @Column(name = "ID", unique = true, nullable = false)
        public int getId() {    return this.id;}
        public void setId(int id) {   this.id = id;}
        @Column(name = "NAME", length = 10)
        public String getName() {   return this.name;}
        public void setName(String name) { this.name = name;}
    }


##Hibernate 的事务管理
###基于jdbc
Hibernate 的 JDBC 事务是基于 JDBC Connection 实现的，它的生命周期是在 Connection 之内的，也就是说 Hibernate 的 JDBC 事务是不能跨Connection



###基于JTA
JTA 事务类型是由 JTA 容器来管理的，JTA 容器对当前加入事务的众多 Connection 进行调度，实现其事务性要求。JTA 的事务周期可横跨多个 JDBC Connection 生命周期



##Hibernate 对大数据量的处理

##Hibernate 性能调优

##分库 Hibernate Shards
[Java 开发 2.0: 使用 Hibernate Shards 进行切分](http://www.ibm.com/developerworks/cn/java/j-javadev2-11/)
不支持跨切分连接
需要一个切分访问策略、一个切分选择策略和一个切分处理策略
###ShardAccessStrategy
一种方法是根据序列机制（一次一个）对切分进行查询，直到获得答案为止；另一种方法是并行访问策略，这种方法使用一个线程模型一次对所有切分进行查询。
###ShardSelectionStrategy
用于创建
default RoundRobinShardSelectionStrategy 
###ShardResolutionStrategy
通过键搜索一个对象时，Hibernate Shards 需要一种可以决定首个切分的方法

###配置 Hibernate Shards
ShardedSessionFactory



---
#Usage
##条件查询 Criteria
http://oss.org.cn/ossdocs/framework/hibernate/reference-v3_zh-cn/querycriteria.html

#原生查询 createSQLQuery
http://blog.csdn.net/myxx520/article/details/3281222

---
#整合spring
http://blog.csdn.net/m751075306/article/details/9769475
解决SSH的问题：NoClassDefFoundError: org/aopalliance/aop/Advice
http://modiliany.iteye.com/blog/1505748

hibernate延迟加载的传说级错误org.hibernate.LazyInitializationException: could not initialize proxy - no Session
http://blog.csdn.net/elfenliedef/article/details/6011892
http://stackoverflow.com/questions/21574236/org-hibernate-lazyinitializationexception-could-not-initialize-proxy-no-sess
<property name="hibernate.enable_lazy_load_no_trans">true</property>


---
#Q&A问题
http://blog.csdn.net/selaginella/article/details/8799563

1.问题：Exception in thread "main" java.lang.NoClassDefFoundError: org/dom4j/DocumentException
    at HibernateTest.main(HibernateTest.java:14)
方法：添加dom4j.jar(解析hibernate.cfg.xml文件)
 
2．问题：Exception in thread "main" java.lang.NoClassDefFoundError: org/apache/commons/logging/LogFactory
    at org.hibernate.cfg.Configuration.<clinit>(Configuration.java:116)
    at HibernateTest.main(HibernateTest.java:14)
方法：添加commons-logging.jar(记录解析过程)
 
3．问题：Exception in thread "main" java.lang.NoClassDefFoundError: org/apache/commons/collections/SequencedHashMap
方法：添加commons-collections.jar(在解析映射文件时，需要把所有持久化对象的定义放在一个HashMap中)
 
4．问题：Exception in thread "main" java.lang.NoClassDefFoundError: net/sf/ehcache/CacheException
方法：添加ehcache.jar(高速缓存，提高存取速度)
 
5．问题：2009-2-22 23:45:40 net.sf.ehcache.config.Configurator configure
警告: No configuration found. Configuring ehcache from ehcache-failsafe.xml found in the classpath: jar:file:/F:/MyJava/Hibernate/lib/ehcache-1.1.jar!/ehcache-failsafe.xml
Exception in thread "main" java.lang.NoClassDefFoundError
方法：把ehcache-1.1.jar解压，把其中的ehcache-failsafe.xml改成ehcache.xml。
 
6.问题：Caused by: java.lang.ClassNotFoundException: net.sf.cglib.transform.impl.InterceptFieldEnabled
方法：添加cglib-full-2.0.02.jar
 
7.问题：Caused by: java.lang.NoSuchMethodError: net.sf.cglib.proxy.Enhancer.setInterceptDuringConstruction(Z)V
方法：添加cglib-nodep-2.1_3.jar
 
8.问题:Exception in thread "main" java.lang.NoClassDefFoundError: javax/transaction/Synchronization
方法:添加jta.jar(事务处理)
 

9.问题:Exception in thread "main" java.lang.NoClassDefFoundError: antlr/ANTLRException
方法:添加antlr-2.7.5h3.jar
 
10问题:Caused by: java.sql.SQLException: The statement (1) has no open cursor.
    at com.mysql.jdbc.MysqlIO.checkErrorPacket(MysqlIO.java:2901)
    at com.mysql.jdbc.MysqlIO.checkErrorPacket(MysqlIO.java:773)
方法: <!-- <property name="jdbc.fetch_size">50 </property>  --> 
把上面这个属性按上面这样注释掉就可以了. (如果mysql-connector的版本早于3.2.1而且服务器的版本早于5.0.3,"setFetchSize()"是没有效果的.)

---
#hibernate4
[hibernate4升级](http://itindex.net/detail/50217-%E8%BD%AC%E6%B3%A8-hibernate4-%E5%BC%80%E5%8F%91)




















