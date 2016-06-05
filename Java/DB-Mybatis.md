#mybatis
---
#doc
mybatis3官方文档
https://mybatis.github.io/mybatis-3/index.html
https://mybatis.github.io/mybatis-3/zh/index.html

    高级结果映射
mybatis3.2.3+spring整合（附带源码）
http://www.luoshengsha.com/284.html
http://haohaoxuexi.iteye.com/blog/1843309



---
#configuration
[Mybatis整合Spring](http://www.tuicool.com/articles/FVRzI3)
##spring.xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
       <property name="dataSource" ref="dataSource" />  
       <property name="mapperLocations" value="classpath:com/tiantian/ckeditor/mybatis/mappers/*Mapper.xml" />  
       <property name="typeAliasesPackage" value="com.tiantian.ckeditor.model" />  
</bean>
mapperLocations：它表示我们的Mapper文件存放的位置，当我们的Mapper文件跟对应的Mapper接口处于同一位置的时候可以不用指定该属性的值。
configLocation：用于指定Mybatis的配置文件位置。如果指定了该属性，那么会以该配置文件的内容作为配置信息构建对应的SqlSessionFactoryBuilder，但是后续属性指定的内容会覆盖该配置文件里面指定的对应内容。
typeAliasesPackage：它一般对应我们的实体类所在的包，这个时候会自动取对应包中不包括包名的简单类名作为包括包名的别名。多个package之间可以用逗号或者分号等来进行分隔。
typeAliases：数组类型，用来指定别名的。指定了这个属性后，Mybatis会把这个类型的短名称作为这个类型的别名，前提是该类上没有标注@Alias注解，否则将使用该注解对应的值作为此种类型的别名。
<property name="typeAliases">  
    <array>  
        <value>com.tiantian.mybatis.model.Blog</value>  
        <value>com.tiantian.mybatis.model.Comment</value>  
    </array>  
</property>
plugins：数组类型，用来指定Mybatis的Interceptor。
typeHandlersPackage：用来指定TypeHandler所在的包，如果指定了该属性，SqlSessionFactoryBean会自动把该包下面的类注册为对应的TypeHandler。多个package之间可以用逗号或者分号等来进行分隔。
typeHandlers：数组类型，表示TypeHandler。

---

#xml配置
##获取自增字段结果
useGeneratedKeys keyProperty keyProperty是Java对象的属性名
<insert id="insert" parameterType="Spares" useGeneratedKeys="true" keyProperty="id">  
        insert into spares(spares_id,spares_name,spares_type_id,spares_spec)  
        values(#{id},#{name},#{typeId},#{spec})  
</insert>  
自增值通过getId获取

---
#缓存
[MyBatis 缓存](http://www.cnblogs.com/zemliu/archive/2013/08/05/3239014.html)
##一级缓存
基于 PerpetualCache(mybatis自带)的 HashMap 本地缓存,作用范围为session,所以当session commit或close后,缓存就会被清空

    List<User> users = sqlSession.selectList("com.my.mapper.UserMapper.getUser", "jack");
    System.out.println(users);
    //sqlSession.commit();①
    List<User> users2 = sqlSession.selectList("com.my.mapper.UserMapper.getUser", "jack");//②admin
    System.out.println(users);
如果把①处去掉注释,会发现不会有缓存了

##二级缓存
二级缓存默认也是基于 PerpetualCache,但是可以为其制定存储源,比如ehcache 
在配置文件中启用二级缓存
    <setting name="cacheEnabled" value="true" />
在需要进行缓存的mapper文件UserMapper.xml中加上
    <cache readOnly="true"></cache>
注意这里的readOnly设为true,默认是false,表示结果集对象需要被序列化

ehcache
在classpath下添加ehcache.xml
在UserMapper.xml中添加:
    <!-- <cache readOnly="true" type="org.mybatis.caches.ehcache.LoggingEhcache"/>   -->
    <cache type="org.mybatis.caches.ehcache.EhcacheCache"/>
用上面那个会输出更加详细的日志,下面的不会
需要用到ehcache.jar mybatis-ehcache.jar



---
#config
## result map
<resultMap type="TrainRecord" id="trainRecordResultMap">  
    <id column="id" property="id" jdbcType="BIGINT" />  
    <result column="add_time" property="addTime" jdbcType="VARCHAR" />  
    <result column="emp_id" property="empId" jdbcType="BIGINT" />  
    <result column="activity_id" property="activityId" jdbcType="BIGINT" />  
    <result column="flag" property="status" jdbcType="VARCHAR" />  
</resultMap> 


## batch insert 
<insert id="addTrainRecordBatch" useGeneratedKeys="true" parameterType="java.util.List">  
    <selectKey resultType="long" keyProperty="id" order="AFTER">  
        SELECT  
        LAST_INSERT_ID()  
    </selectKey>  
    insert into t_train_record (add_time,emp_id,activity_id,flag)   
    values  
    <foreach collection="list" item="item" index="index" separator="," >  
        (#{item.addTime},#{item.empId},#{item.activityId},#{item.flag})  
    </foreach>  
</insert>


## Q&A
### 连接数据库错误
navicat可以连接到另一网段的mysql
但使用连接池显示如下错误
Access denied for user 'root'@'10.185.8.159' (using password: YES)
10.185.8.159并非配置的IP，而为机器连接的路由器IP
检查数据库配置无任何错误，连接池使用类为
    org.apache.commons.dbcp.BasicDataSource implements javax.sql.DataSource
查看org.mybatis.spring.SqlSessionFactoryBean的setDataSource，类型为
    interface javax.sql.DataSource;
无异常
尝试更换datasource实现类为com.mchange.v2.c3p0.ComboPooledDataSource后正常，原因暂时认定为BasicDataSource bug


---
#分库 分表
[插件m-shard 基于mybatis的shard方案（分表分库、读写分离）](http://blog.csdn.net/xingkong0128/article/details/18268635)


----
#源码学习
[Mybatis3源码分析（一）：从sqlSession说起](http://blog.csdn.net/flashflight/article/details/43039281)























