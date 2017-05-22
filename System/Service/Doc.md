
[STEVEY对AMAZON和GOOGLE平台的吐槽](http://coolshell.cn/articles/5701.html)

1) 所有团队的程序模块都要以通过Service Interface 方式将其数据与功能开放出来。（陈皓注：Service Interface也就是Web Service）
2) 团队间的程序模块的信息通信，都要通过这些接口。
3) 除此之外没有其它的通信方式。其他形式一概不允许：不能使用直接链结程序、不能直接读取其他团队的数据库、不能使用共享内存模式、不能使用别人模块的后门、等等，等等，唯一允许的通信方式只能是能过调用 Service Interface。
4) 任何技术都可以使用。比如：HTTP、Corba、Pubsub、自定义的网络协议、等等，都可以，Bezos不管这些。（陈皓注：Bezos不是微控经理吗？呵呵。）
5) 所有的Service Interface，毫无例外，都必须从骨子里到表面上设计成能对外界开放的。也就是说，团队必须做好规划与设计，以便未来把接口开放给全世界的程序员，没有任何例外。
6) 不这样的做的人会被炒鱿鱼。
7) 谢谢，祝你有个愉快的一天！



监控

QA

服务发现


Accessibility

平台的黄金守则，“Eat Your Own Dogfood 吃自己的狗食”，换句话说，“先打造出自己使用平台，然后把它用在所有的地方”



