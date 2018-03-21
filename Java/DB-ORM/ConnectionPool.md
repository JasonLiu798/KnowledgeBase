
org.apache.commons.dbcp.BasicDataSource连接池配备属性 
池配置属性	指定的内容
initialSize	池启动时创建的连接数量
maxActive	同一时间可以从池分配的最多连接数量。设置为0时表示无限制。
maxIdle	池里不会被释放的最多空闲连接数量。设置为0时表示无限制。
maxOpenPreparedStatements	同一时间能够从语句池里分配的已备语句的最大数量。设置为0时表示无限制。
maxWait	在抛出异常之前，池等待连接被回收的最长时间（当没有可用连接时）。设置为-1表示无限等待。
minEvictableIdleTimeMillis	连接保持空闲而不被驱逐的最长时间。
minIdle	在不新建连接的条件下，池中保持空闲的最少连接数。
poolPreparedStatements	是否对已备语句进行池管理（布尔值）。
timeBetweenEvictionRunsMillis 	毫秒秒检查一次连接池中空闲的连接,
minEvictableIdleTimeMillis       	把空闲时间超过minEvictableIdleTimeMillis毫秒的连接断开, 直到连接池中的连接数到minIdle为止 连接池中连接可空闲的时间,毫秒







