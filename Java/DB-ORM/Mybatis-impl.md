




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
#事务
[Spring Transaction + MyBatis SqlSession事务管理机制研究学习](https://my.oschina.net/realfighter/blog/366089)







