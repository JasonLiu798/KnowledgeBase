
[JSON Web Token - 在Web应用间安全地传递信息](http://blog.leapoahead.com/2015/09/06/understanding-jwt/)


#组成
##载荷
```js
{
    "iss": "John Wu JWT",
    "iat": 1441593502,
    "exp": 1441594722,
    "aud": "www.example.com",
    "sub": "jrocket@example.com",
    "from_user": "B",
    "target_user": "A"
}
```
前五个字段都是由JWT的标准所定义的。
iss: 该JWT的签发者
sub: 该JWT所面向的用户
aud: 接收该JWT的一方
exp(expires): 什么时候过期，这里是一个Unix时间戳
iat(issued at): 在什么时候签发的

base64编码]可以得到下面的字符串，这个字符串我们将它称作JWT的Payload（载荷）
eyJpc3MiOiJKb2huIFd1IEpXVCIsImlhdCI6MTQ0MTU5MzUwMiwiZXhwIjoxNDQxNTk0NzIyLCJhdWQiOiJ3d3cuZXhhbXBsZS5jb20iLCJzdWIiOiJqcm9ja2V0QGV4YW1wbGUuY29tIiwiZnJvbV91c2VyIjoiQiIsInRhcmdldF91c2VyIjoiQSJ9

##头部
头部用于描述关于该JWT的最基本的信息，例如其类型以及签名所用的算法等。这也可以被表示成一个JSON对象

```js
{
  "typ": "JWT",
  "alg": "HS256"
}
```
Base64编码，之后的字符串就成了JWT的Header（头部）
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9

##签名
将上面的两个编码后的字符串都用句号.连接在一起（头部在前），就形成了
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcm9tX3VzZXIiOiJCIiwidGFyZ2V0X3VzZXIiOiJBIn0

最后，我们将上面拼接完的字符串用HS256算法进行加密。在加密的时候，我们还需要提供一个密钥（secret）。如果我们用mystar作为密钥的话，那么就可以得到我们加密后的内容
rSWamyAYwuHCo7IFAgd1oRpSP7nzL7BF5t7ItqpKViM

最后将这一部分签名也拼接在被签名的字符串后面，我们就得到了完整的JWT
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcm9tX3VzZXIiOiJCIiwidGFyZ2V0X3VzZXIiOiJBIn0.rSWamyAYwuHCo7IFAgd1oRpSP7nzL7BF5t7ItqpKViM

最后一步签名的过程，实际上是对头部以及载荷内容进行签名。一般而言，加密算法对于不同的输入产生的输出总是不一样的。对于两个不同的输入，产生同样的输出的概率极其地小（有可能比我成世界首富的概率还小）。所以，我们就把“不一样的输入产生不一样的输出”当做必然事件来看待吧。


#安全
在JWT中，不应该在载荷里面加入任何敏感的数据。在上面的例子中，我们传输的是用户的User ID。这个值实际上不是什么敏感内容，一般情况下被知道也是安全的。



#JWT的适用场景

我们可以看到，JWT适合用于向Web应用传递一些非敏感信息。例如在上面提到的完成加好友的操作，还有诸如下订单的操作等等。

其实JWT还经常用于设计用户认证和授权系统，甚至实现Web应用的单点登录。在下一次的文章中，我将为大家系统地总结JWT在用户认证和授权上的应用。如果想要及时地收到下一篇文章的更新，您可以在下方订阅我的半月刊：）
























