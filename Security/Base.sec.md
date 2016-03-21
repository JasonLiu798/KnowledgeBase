#base
---
#docs
[mozila安全编程指南](https://wiki.mozilla.org/WebAppSec/Secure_Coding_Guidelines)
信息安全的三要素
保密性、完整性、可用性


---
#XSS攻击
[DOM-based XSS 与 存储性XSS、反射型XSS有什么区别](http://www.zhihu.com/question/26628342)
##反射型
点击恶意脚本url，脚本自动攻击
##存储型
恶意脚本存储在web站点
##对比
易用上，存储型XSS > DOM - XSS > 反射型 XSS

##XSS Worm

##Flash XSS

##js框架漏洞
dojo1.4.1 DOM Based XSS
YUI2.8.1
jQuery html()方法可能
[AngularJS – 如何处理 XSS 漏洞](http://www.oschina.net/translate/angularjs-handle-xss-vulnerability-scenarios)

##防御
* 消毒
    过滤标签，特殊字符，转义
* HttpOnly
* Cookie IP绑定


---
#注入攻击
##SQL注入
开源
错误回显
盲注

##防御
* 消毒，过滤sql
* 参数绑定
OS注入

---
#CSRF攻击
跨站点请求伪造
##防御
* 表单Token
* 验证码
* Refere check


---
#web应用防火墙
ModSecurity







---
#单点登录SSO
[SSO](http://blog.csdn.net/cutesource/article/details/5838693)
[单点登录SSO原理](http://hansionxu.blog.163.com/blog/static/24169810920149155440886/)
CAS v1 非常原始，传送一个用户名居然是 ”yes\ndavid.turing” 的方式， CAS v2 开始使用了 XML 规范，大大增强了可扩展性， CAS v3 开始使用 AOP技术，让 Spring 爱好者可以轻松配置 CAS Server 到现有的应用环境中。

CAS 是通过 TGT(Ticket Granting Ticket) 来获取 ST(Service Ticket) ，通过 ST 来访问服务

---
#编译器
[给开源编译器插入后门](https://ring0.me/2014/11/insert-backdoor-into-compiler/)


---

[jdbctoken](https://github.com/spring-projects/spring-security-oauth/blob/master/docs/JdbcTokenStore)

## spring-security-oauth2
http://pan.baidu.com/s/1F979k





---
#攻击类型
##session fixation攻击
Session fixation有人翻译成“Session完成攻击”[1]，实际上fixation是确知和确定的意思，在此是指Web服务的会话ID是确知不变的，攻击者为受害着确定一个会话ID从而达到攻击的目的。在维基百科中专门有个词条Session fixation，在此引述其攻击情景，防范策略参考原文。
###攻击情景
原文中Alice是受害者，她使用的一个银行网站http://unsafe/存在session fixation漏洞，Mallory是攻击者，他想盗窃Alice的银行中的存款，而Alice会点击Mallory发给她的网页连接（原因可能是Alice认识Mallory，或者她自己的安全意识不强）。

攻击情景1：最简单：服务器接收任何会话ID
过程如下：
Mallory发现http://unsafe/接收任何会话ID，而且会话ID通过URL地址的查询参数携带到服务器，服务器不做检查
Mallory给Alice发送一个电子邮件，他可能假装是银行在宣传自己的新业务，例如，“我行推出了一项新服务，率先体验请点击：http://unsafe/?SID=I_WILL_KNOW_THE_SID"，I_WILL_KNOW_THE_SID是Mallory选定的一个会话ID。
Alice被吸引了，点击了 http://unsafe/?SID=I_WILL_KNOW_THE_SID，像往常一样，输入了自己的帐号和口令从而登录到银行网站。
因为服务器的会话ID不改变，现在Mallory点击 http://unsafe/?SID=I_WILL_KNOW_THE_SID 后，他就拥有了Alice的身份。可以为所欲为了。

攻击情景2：服务器产生的会话ID不变
过程如下：

Mallory访问 http://unsafe/ 并获得了一个会话ID（SID），例如服务器返回的形式是：Set-Cookie: SID=0D6441FEA4496C2
Mallory给Alice发了一个邮件：”我行推出了一项新服务，率先体验请点击：http://unsafe/?SID=0D6441FEA4496C2"
Alice点击并登录了，后面发生的事与情景1相同
攻击情景3：跨站cookie(cross-site cooking)
利用浏览器的漏洞，即使 http://good 很安全，但是，由于浏览器管理cookie的漏洞，使恶意网站 http://evil/ 能够向浏览器发送 http://good 的cookie。过程如下：

Mallory给Alice发送一个邮件“有个有趣的网站：http://evil 很好玩，不妨试试”
Alice访问了这个链接，这个网站将一个会话ID取值为I_WILL_KNOW_THE_SID 的 http://good/ 域的cookie设置到浏览器中。
Mallory又给Alice发了个邮件：“我行推出了一项新服务，率先体验请点击：http://good/”
如果Alice登录了，Mallory就可以利用这个ID了







---


##DDOS
攻击 可用性，该攻击方式利用目标系统网络服务功能缺陷或者直接消耗其系统资源，使得该目标系统无法提供正常的服务。
总体思路：带宽消耗型以及资源消耗型。
网络过载；向服务器提交大量请求；阻断某一用户；阻断某服务与特定系统或个人的通讯

##带宽消耗型攻击
ping of death（死亡之Ping）：产生超过IP协议能容忍的数据包数，若系统没有检查机制，就会死机。
ICMP floods，ICMPfloods是通过向未良好设置的路由器发送广播信息占用系统资源的做法。
User Datagram Protocol（UDP）floods:UDP无连接，不需要握手，
泪滴攻击：每个数据要发送前，该数据包都会经过切割，每个小切割都会记录位移的信息，以便重组，但此攻击模式就是捏造位移信息，造成重组时发生问题，造成错误。

##资源消耗型攻击
协议分析攻击（SYN flood，SYN洪水），不断发送新的SYN[限制同时打开的Syn半连接数目,缩短Syn半连接的time out 时间]
LAND attack，与SYN floods类似，攻击包中的原地址和目标地址都是攻击对象的IP。这种攻击会导致被攻击的机器死循环，最终耗尽资源而死机。
CC攻击，代理服务器向受害服务器发送大量貌似合法的请求（通常使用HTTP GET)
僵尸网络攻击，僵尸主机只有在执行特定指令时才会与服务器进行通讯，僵尸网络根据网络通讯协议的不同分为IRC、HTTP或P2P类等。
Application level floods（应用程序级洪水攻击），与前面叙说的攻击方式不同，Application level floods主要是针对应用软件层的，也就是高于OSI的。它同样是以大量消耗系统资源为目的，通过向IIS这样的网络服务程序提出无节制的资源申请来迫害正常的网络服务。
（获取客户端IP：http://www.cnblogs.com/belie8/articles/2368957.html
REMOTE_ADDR
HTTP_X_FORWARDED_FOR
）


##跨网站脚本（Cross-site scripting)
攻击者使被攻击者在浏览器中执行脚本后，让被攻击者通过JavaScript等方式把收集好的数据作为参数提交，随后以数据库等形式记录在攻击者自己的服务器上。

常用的XSS攻击手段和目的有：
盗用 cookie ，获取敏感信息。
利用植入 Flash ，通过 crossdomain 权限设置进一步获取更高权限；或者利用Java等得到类似的操作。
利用 iframe、frame、XMLHttpRequest或上述Flash等方式，以（被攻击）用户的身份执行一些管理动作，或执行一些一般的如发微博、加好友、发私信等操作。
利用可被攻击的域受到其他域信任的特点，以受信任来源的身份请求一些平时不允许的操作，如进行不当的投票活动。
在访问量极大的一些页面上的XSS可以攻击一些小型网站，实现DDoS攻击的效果。

防范
1、过滤特殊字符
避免XSS的方法之一主要是将用户所提供的内容进行过滤，许多语言都有提供对HTML的过滤：
PHP的htmlentities()或是htmlspecialchars()。
Python的cgi.escape()。
Java的xssprotect(Open Source Library)。http://liuzidong.iteye.com/blog/1744023
Node.js的node-validator




---
##安全登录
http://sunxboy.iteye.com/blog/209156
rsa加解密
具体实现思路如下：
1。服务端生成公钥与私钥，保存。
2。客户端在请求到登录页面后，随机生成一字符串。
3。后此随机字符串作为密钥加密密码，再用从服务端获取到的公钥加密生成的随机字符串。
4。将此两段密文传入服务端，服务端用私钥解出随机字符串，再用此私钥解出加密的密文。
这其中有一个关键是解决服务端的公钥，传入客户端，客户端用此公钥加密字符串后，后又能在服务端用私钥解出。
此文即为实现此步而作。
加密算法为RSA：
1。服务端的RSA java实现。



