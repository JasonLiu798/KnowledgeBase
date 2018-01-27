

[spring事件通知机制详解](https://www.cnblogs.com/zhangxiaoguang/p/spring-notification.html)


ContextStartedEvent,，ConfigurableApplicationContext接口中的start()方法被调用会触发

ContextStoppededEvent,，ConfigurableApplicationContext接口中的stop()方法被调用会触发

ContextClosedEvent,AppliactionContext被关闭时触发该事件，所有容器管理的单例bean被销毁。

RequestHandledEvent，当一个http请求结束时触发该事件












