
# 主要组件

SqlSession            作为MyBatis工作的主要顶层API，表示和数据库交互的会话，完成必要数据库增删改查功能
Executor              MyBatis执行器，是MyBatis 调度的核心，负责SQL语句的生成和查询缓存的维护
StatementHandler   封装了JDBC Statement操作，负责对JDBC statement 的操作，如设置参数、将Statement结果集转换成List集合。
ParameterHandler   负责对用户传递的参数转换成JDBC Statement 所需要的参数，
ResultSetHandler    负责将JDBC返回的ResultSet结果集对象转换成List类型的集合；
TypeHandler          负责java数据类型和jdbc数据类型之间的映射和转换
MappedStatement   MappedStatement维护了一条<select|update|delete|insert>节点的封装，
SqlSource            负责根据用户传递的parameterObject，动态地生成SQL语句，将信息封装到BoundSql对象中，并返回
BoundSql             表示动态生成的SQL语句以及相应的参数信息
Configuration        MyBatis所有的配置信息都维持在Configuration对象之中。






[原理](https://www.zhihu.com/question/25007334)



#SqlSessionManager
动态代理
localSqlSession（threadLocal）

## SqlSessionTemplate
Thread safe
Spring managed



## DefaultSqlSession
not Thread-Safe

#配置相关
[mybatis的源代码解析(1)--xml文件解析](https://www.cnblogs.com/wangjiuyong/articles/6720501.html)

## 配置读取
org.apache.ibatis.builder.xml.XMLConfigBuilder

parse()
解析mapper.xml

# 执行
org.apache.ibatis.session.Configuration.addMappers
	org.apache.ibatis.binding.MapperRegistry.addMapper

org.apache.ibatis.binding.MapperProxyFactory.newInstance

# org.apache.ibatis.binding.MapperProxy

# org.apache.ibatis.binding.MapperMethod

---
# 其他
[Mybatis源码分析(四)--TypeHandler的解析](https://zhuanlan.zhihu.com/p/32123101)

---
#事务
[Spring Transaction + MyBatis SqlSession事务管理机制研究学习](https://my.oschina.net/realfighter/blog/366089)







