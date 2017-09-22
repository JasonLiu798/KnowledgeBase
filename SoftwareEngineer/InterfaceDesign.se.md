

#Fluent Interface
[关于接口设计，还有Fluent Interface，这种有趣的接口设计风格](http://www.raychase.net/263)
```
List<User> userList = new UserService().setName(name).setAge(18).setSex(User.SEX_MALE).query(UserService.QUERY_TYPE_NORMAL);

new MyNumber(x+y).sqrt().sin().log();
```

[CommandQuerySeperation](http://martinfowler.com/bliki/CommandQuerySeparation.html)这篇文章把一个对象的方法大致分成下面两种
Queries: Return a result and do not change the observable state of the system (are free of side effects).
Commands: Change the state of a system but do not return a value.
对于Fluent Interface而言，它的接口调用既改变了对象的状态，又返回了对象（this或其他），并不属于上面的两种类型。


