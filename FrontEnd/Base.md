


#跨域
相同域必须忙住协议相同、端口相同、域名相同. 只要其中一点不满足那就是跨域
Access-Control-Allow-Origin
Access-Control-Allow-Origin是HTML5中定义的一种服务器端返回Response header，用来解决资源（比如字体）的跨域权限问题。
它定义了该资源允许被哪个域引用，或者被所有域引用（google字体使用*表示字体资源允许被所有域引用）。

##jsonp
[JSONP](http://kb.cnblogs.com/page/139725/)
JSONP，CORS，HTTP 协议，浏览器安全机制，PreFlight Request，反向代理

##header meta
站点www.a.com需要调用comment.a.com/api/post.php,那么这个post.php必须加上如下代码

header("Access-Control-Allow-Origin: http://www.a.com");
header("Access-Control-Allow-Origin: http://www.a.com");

header方式不能使用正则，例如*.a.com，不过我们可以使用如下方法，将内容echo到php响应内容中

echo '<meta http-equiv="Access-Control-Allow-Origin" content="*.a.com">';
echo '<meta http-equiv="Access-Control-Allow-Origin" content="*.a.com">';
header里面用不了正则，而meta里面可以用正则
从上面的代码可以看出, 代码1安全性不够，但是使用接口的人只会获取到响应的body内容。代码2相对安全，但是响应的body内容体里面包含<meta http-equiv="Access-Control-Allow-Origin" content="*.a.com">，多少影响接口的使用.


















