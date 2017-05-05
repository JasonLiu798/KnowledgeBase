#HTTP HTTPS
---
#
GET      请求获取由Request-URI所标识的资源。
POST 在Request-URI所标识的资源后附加新的数据。
PUT 请求服务器存储一个资源，并用Request-URI作为其标识。
DELETE 请求服务器删除由Request-URI所标识的资源。

TRACE 请求服务器回送收到的请求信息，主要用语测试或诊断。
HEAD 请求获取由Request-URI所标识的资源的响应消息报头。
OPTIONS 请求查询服务器的性能，或查询与资源相关的选项和需求。


---
#协议头

##Content-Type 
[各浏览器对常用或者错误的 Content-Type 类型处理方式不一致](http://blog.csdn.net/maweiqi/article/details/7677411)
content-type 用于定义用户的浏览器或相关设备如何显示将要加载的数据，或者如何处理将要加载的数据，此属性的值可以查看MIME 类型。

MIME (Multipurpose Internet Mail Extensions，多用途互联网邮件扩展) 是描述消息内容类型的因特网标准。MIME 消息能包含文本、图像、音频、视频以及其他应用程序专用的数据。
###content-type 一般以下面的形式出现
Content-Type: [type]/[subtype]; parameter
type 有下面的形式：
Text：用于标准化地表示的文本信息，文本消息可以是多种字符集和或者多种格式的；
Multipart：用于连接消息体的多个部分构成一个消息，这些部分可以是不同类型的数据；
Application：用于传输应用程序数据或者二进制数据；
Message：用于包装一个E-mail消息；
Image：用于传输静态图片数据；
Audio：用于传输音频或者音声数据；
Video：用于传输动态影像数据，可以是与音频编辑在一起的视频数据格式。
###subtype
用于指定 type 的详细形式。“type/subtype”配对的集合和与此相关的参数。下面是最经常用到的一些 MIME 类型：
text/html（HTML 文档）；
text/plain（纯文本）；
text/css（CSS 样式表）；
image/gif（GIF 图像）；
image/jpeg（JPG 图像）；
application/x-javascript（JavaScript 脚本）；
application/x-shockwave-flash（Flash）；
application/x- www-form-urlencoded（使用 HTTP 的 POST 方法提交的表单）；
multipart/form-data（同上，但主要用于表单提交时伴随文件上传的场合）。
关于 content-type 的详细信息，请参考 HTML4.01 规范 6.7 Content types (MIME types) 中的内容。
关于 MIME 的相信信息，请参考 IETF 的 [RFC2045] 及 [RFC2046] 规范。
更多的 MIME 类型参见：
http://www.utoronto.ca/webdocs/HTMLdocs/Book/Book-3ed/appb/mimetype.html
http://www.iana.org/assignments/media-types/






---
#HTTPS
[SSL/TLS协议运行机制的概述](http://www.ruanyifeng.com/blog/2014/02/ssl_tls.html)
不使用SSL/TLS的HTTP通信，就是不加密的通信。所有信息明文传播，带来了三大风险
（1） 窃听风险（eavesdropping）：第三方可以获知通信内容。
（2） 篡改风险（tampering）：第三方可以修改通信内容。
（3） 冒充风险（pretending）：第三方可以冒充他人身份参与通信。
SSL/TLS协议是为了解决这三大风险而设计的，希望达到：
（1） 所有信息都是加密传播，第三方无法窃听。
（2） 具有校验机制，一旦被篡改，通信双方会立刻发现。
（3） 配备身份证书，防止身份被冒充。

##历史
互联网加密通信协议的历史，几乎与互联网一样长。
1994年，NetScape公司设计了SSL协议（Secure Sockets Layer）的1.0版，但是未发布。
1995年，NetScape公司发布SSL 2.0版，很快发现有严重漏洞。
1996年，SSL 3.0版问世，得到大规模应用。
1999年，互联网标准化组织ISOC接替NetScape公司，发布了SSL的升级版TLS 1.0版。
2006年和2008年，TLS进行了两次升级，分别为TLS 1.1版和TLS 1.2版。最新的变动是2011年TLS 1.2的修订版。
目前，应用最广泛的是TLS 1.0，接下来是SSL 3.0。但是，主流浏览器都已经实现了TLS 1.2的支持。
TLS 1.0通常被标示为SSL 3.1，TLS 1.1为SSL 3.2，TLS 1.2为SSL 3.3。

##基本的运行过程
SSL/TLS协议的基本思路是采用公钥加密法，也就是说，客户端先向服务器端索要公钥，然后用公钥加密信息，服务器收到密文后，用自己的私钥解密。
（1）如何保证公钥不被篡改？
解决方法：将公钥放在数字证书中。只要证书是可信的，公钥就是可信的。
（2）公钥加密计算量太大，如何减少耗用的时间？
解决方法：每一次对话（session），客户端和服务器端都生成一个"对话密钥"（session key），用它来加密信息。由于"对话密钥"是对称加密，所以运算速度非常快，而服务器公钥只用于加密"对话密钥"本身，这样就减少了加密运算的消耗时间。
因此，SSL/TLS协议的基本过程是这样的：
（1） 客户端向服务器端索要并验证公钥。
（2） 双方协商生成"对话密钥"。
（3） 双方采用"对话密钥"进行加密通信。
上面过程的前两步，又称为"握手阶段"（handshake）。

###握手阶段
* I.客户端发出请求（ClientHello）
首先，客户端（通常是浏览器）先向服务器发出加密通信的请求，这被叫做ClientHello请求。
在这一步，客户端主要向服务器提供以下信息。
（1） 支持的协议版本，比如TLS 1.0版。
（2） 一个客户端生成的随机数，稍后用于生成"对话密钥"。
（3） 支持的加密方法，比如RSA公钥加密。
（4） 支持的压缩方法。
这里需要注意的是，客户端发送的信息之中不包括服务器的域名。也就是说，理论上服务器只能包含一个网站，否则会分不清应该向客户端提供哪一个网站的数字证书。这就是为什么通常一台服务器只能有一张数字证书的原因。
对于虚拟主机的用户来说，这当然很不方便。2006年，TLS协议加入了一个Server Name Indication扩展，允许客户端向服务器提供它所请求的域名。

* II.服务器回应（SeverHello）
服务器收到客户端请求后，向客户端发出回应，这叫做SeverHello。
服务器的回应包含以下内容:
（1） 确认使用的加密通信协议版本，比如TLS 1.0版本。如果浏览器与服务器支持的版本不一致，服务器关闭加密通信。
（2） 一个服务器生成的随机数，稍后用于生成"对话密钥"。
（3） 确认使用的加密方法，比如RSA公钥加密。
（4） 服务器证书。
除了上面这些信息，如果服务器需要确认客户端的身份，就会再包含一项请求，要求客户端提供"客户端证书"。比如，金融机构往往只允许认证客户连入自己的网络，就会向正式客户提供USB密钥，里面就包含了一张客户端证书。

* III. 客户端回应
客户端收到服务器回应以后，首先验证服务器证书。如果证书不是可信机构颁布、或者证书中的域名与实际域名不一致、或者证书已经过期，就会向访问者显示一个警告，由其选择是否还要继续通信。
如果证书没有问题，客户端就会从证书中取出服务器的公钥。然后，向服务器发送下面三项信息。
（1） 一个随机数。该随机数用服务器公钥加密，防止被窃听。
（2） 编码改变通知，表示随后的信息都将用双方商定的加密方法和密钥发送。
（3） 客户端握手结束通知，表示客户端的握手阶段已经结束。这一项同时也是前面发送的所有内容的hash值，用来供服务器校验。
上面第一项的随机数，是整个握手阶段出现的第三个随机数，又称"pre-master key"。有了它以后，客户端和服务器就同时有了三个随机数，接着双方就用事先商定的加密方法，各自生成本次会话所用的同一把"会话密钥"。
至于为什么一定要用三个随机数，来生成"会话密钥"，dog250解释得很好：
"不管是客户端还是服务器，都需要随机数，这样生成的密钥才不会每次都一样。由于SSL协议中证书是静态的，因此十分有必要引入一种随机因素来保证协商出来的密钥的随机性。
对于RSA密钥交换算法来说，pre-master-key本身就是一个随机数，再加上hello消息中的随机，三个随机数通过一个密钥导出器最终导出一个对称密钥。
pre master的存在在于SSL协议不信任每个主机都能产生完全随机的随机数，如果随机数不随机，那么pre master secret就有可能被猜出来，那么仅适用pre master secret作为密钥就不合适了，因此必须引入新的随机因素，那么客户端和服务器加上pre master secret三个随机数一同生成的密钥就不容易被猜出了，一个伪随机可能完全不随机，可是是三个伪随机就十分接近随机了，每增加一个自由度，随机性增加的可不是一。"
此外，如果前一步，服务器要求客户端证书，客户端会在这一步发送证书及相关信息。

* IV. 服务器的最后回应
服务器收到客户端的第三个随机数pre-master key之后，计算生成本次会话所用的"会话密钥"。然后，向客户端最后发送下面信息。
（1）编码改变通知，表示随后的信息都将用双方商定的加密方法和密钥发送。
（2）服务器握手结束通知，表示服务器的握手阶段已经结束。这一项同时也是前面发送的所有内容的hash值，用来供客户端校验。
至此，整个握手阶段全部结束。接下来，客户端与服务器进入加密通信，就完全是使用普通的HTTP协议，只不过用"会话密钥"加密内容。




HTTPS在传输数据之前需要客户端（浏览器）与服务端（网站）之间进行一次握手，在握手过程中将确立双方加密传输数据的密码信息。
TLS/SSL协议不仅仅是一套加密传输的协议，更是一件经过艺术家精心设计的艺术品
TLS/SSL中使用了非对称加密，对称加密以及HASH算法。握手过程的简单描述如下：

1.浏览器将自己支持的一套加密规则发送给网站。
2.网站从中选出一组加密算法与HASH算法，并将自己的身份信息以证书的形式发回给浏览器。
证书里面包含了
* 网站地址
* 加密公钥
* 证书的颁发机构等信息

3.获得网站证书之后浏览器要做以下工作：
a) 验证证书的合法性（颁发证书的机构是否合法，证书中包含的网站地址是否与正在访问的地址一致等），如果证书受信任，则浏览器栏里面会显示一个小锁头，否则会给出证书不受信的提示。
b) 如果证书受信任，或者是用户接受了不受信的证书，浏览器会生成一串随机数的密码，并用证书中提供的公钥加密。
c) 使用约定好的HASH计算握手消息，并使用生成的随机数对消息进行加密，最后将之前生成的所有信息发送给网站。

4.网站接收浏览器发来的数据之后要做以下的操作：
a) 使用自己的私钥将信息解密取出密码，使用密码解密浏览器发来的握手消息，并验证HASH是否与浏览器发来的一致。
b) 使用密码加密一段握手消息，发送给浏览器。

5.浏览器解密并计算握手消息的HASH，如果与服务端发来的HASH一致，此时握手过程结束，之后所有的通信数据将由之前浏览器生成的随机密码并利用对称加密算法进行加密。

这里浏览器与网站互相发送加密的握手消息并验证，目的是为了保证双方都获得了一致的密码，并且可以正常的加密解密数据，为后续真正数据的传输做一次测试。
另外，HTTPS一般使用的加密与HASH算法如下：
非对称加密算法：RSA，DSA/DSS
对称加密算法：AES，RC4，3DES
HASH算法：MD5，SHA1，SHA256

* 非对称加密算法用于在握手过程中加密生成的密码
* 对 称加密算法用于对真正传输的数据进行加密
* HASH算法用于验证数据的完整性
由于浏览器生成的密码是整个数据加密的关键，因此在传输的时候使用了非对称加密算法对其加密。非对称加密算法会生成公钥和私钥，公钥只能用于加密数据，因此可以随意传输，而网站的私钥用于对数据进行解密，所以网站都会非常小心的保管自己的私钥，防止泄漏。

TLS握手过程中如果有任何错误，都会使加密连接断开，从而阻止了隐私信息的传输。



##漏洞
[HTTPS和SSL协议存在安全漏洞](http://netsecurity.51cto.com/art/201007/215356.htm)




---
#常见httpcode
302 | 28323
502 | 11280
503 | 34269
404 | 260
499 | 2052
408 | 5
200 | 6117851
400 | 15


##302
[cookie系列（二）header302跳转引发的思考](http://www.jianshu.com/p/a95df73bdae4)

[ajax与302响应](http://www.cnblogs.com/dudu/p/ajax_302_found.html)

You can't handle redirects with XHR callbacks because the browser takes care of them automatically. You will only get back what at the redirected location.

原来，当服务器将302响应发给浏览器时，浏览器并不是直接进行ajax回调处理，而是先执行302重定向——从Response Headers中读取Location信息，然后向Location中的Url发出请求，在收到这个请求的响应后才会进行ajax回调处理。大致流程如下：

ajax -> browser -> server -> 302 -> browser(redirect) -> server -> browser -> ajax callback

如何解决？

【方法一】
继续用ajax，修改服务器端代码，将原来的302响应改为json响应，比如下面的ASP.NET MVC示例代码：
return Json(new { status = 302, location = "/oauth/respond" });
ajax代码稍作修改即可：

$.ajax({
    url: '/oauth/respond',
    type: 'post',
    data: data,
    dataType: 'json',
    success: function (data) {
        if (data.status == 302) {
            location.href = data.location;
        }
    }
});
【方法二】
 不用ajax，改用form。 

<form method="post" action="/oauth/respond">
</form>



----
#cookie

var xhr = new XMLHttpRequest();  
xhr.open("POST", "http://xxxx.com/demo/b/index.php", true);  
xhr.withCredentials = true; //支持跨域发送cookies
xhr.send();
jquery的post方法请求：

 $.ajax({
    type: "POST",
    url: "http://xxx.com/api/test",
    dataType: 'jsonp',
    xhrFields: {withCredentials: true},
    crossDomain: true,
})
服务器端设置：

header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Origin: http://www.xxx.com");



#OPTION
http://blog.csdn.net/leikezhu1981/article/details/7402272








