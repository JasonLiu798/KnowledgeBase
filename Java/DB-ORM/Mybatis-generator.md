



# insert返回主键
```xml
<!-- tableName:用于自动生成代码的数据库表；domainObjectName:对应于数据库表的javaBean类名；不需要生成Example类 -->
<table schema="" tableName="ACT_SecurityBlockLog" domainObjectName="BlockLog"
       enableCountByExample="false" enableUpdateByExample="false"
       enableDeleteByExample="false" enableSelectByExample="false"
       selectByExampleQueryId="false">
    <property name="useActualColumnNames" value="true"/>
    <generatedKey column="id" sqlStatement="MySql" identity="true"/>
</table>
```
或者手动增加：
```xml
<insert id="insert" parameterType="Activity" keyProperty="id"
     keyColumn="ID" useGeneratedKeys="true">
```

在insert里面加入selectKey标签就可以了. 一般都是返回的int类型.对应数据库是自增长字段.

要注意的是: ibatis会直接返回int值. Mybatis则把int值包装在参数对象里面.
```java
public int insert(User user) {
	//ibatis方式.
	int result = UserMapper.insert(user);
	return result;

	//Mybatis方式
	user = UserMapper.insert(user);
	return user.getId();
}
```
还要注意的是数据库类型不一样,生成ID的策略也不一样. 可以对selectKey添加属性(名字忘记了), pre---先生成ID. post---后生成ID. default是post.


---
# 分页
http://www.cnblogs.com/isoftware/p/3750219.html




























