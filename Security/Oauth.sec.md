#Oauth
---
#docs
[OAuth的改变](http://huoding.com/2011/11/08/126)
[OAuth 2.0对Web有害吗？](http://www.infoq.com/cn/news/2010/09/oauth2-bad-for-web)
[OAuth学习笔记](http://www.biaodianfu.com/learn-oauth.html)


---
##oauth1.0
OAuth1.0定义了三种角色：User、Service Provider、Consumer
假设我们做了一个SNS，它有一个功能，可以让会员把他们在Google上的联系人导入到SNS上，那么此时的会员是User，Google是Service Providere，而SNS则是Consumer。
 +----------+                                           +----------+
 |          |--(A)- Obtaining a Request Token --------->|          |
 |          |                                           |          |
 |          |<-(B)- Request Token ----------------------|          |
 |          |       (Unauthorized)                      |          |
 |          |                                           |          |
 |          |      +--------+                           |          |
 |          |>-(C)-|       -+-(C)- Directing ---------->|          |
 |          |      |       -+-(D)- User authenticates ->|          |
 |          |      |        |      +----------+         | Service  |
 | Consumer |      | User-  |      |          |         | Provider |
 |          |      | Agent -+-(D)->|   User   |         |          |
 |          |      |        |      |          |         |          |
 |          |      |        |      +----------+         |          |
 |          |<-(E)-|       -+-(E)- Request Token ------<|          |
 |          |      +--------+      (Authorized)         |          |
 |          |                                           |          |
 |          |--(F)- Obtaining a Access Token ---------->|          |
 |          |                                           |          |
 |          |<-(G)- Access Token -----------------------|          |
 +----------+                                           +----------+

A Consumer申请Request Token（/oauth/1.0/request_token）：
oauth_consumer_key
oauth_signature_method
oauth_signature
oauth_timestamp
oauth_nonce
oauth_version

B Service Provider返回Request Token：
oauth_token
oauth_token_secret

C D Consumer重定向User到Service Provider（/oauth/1.0/authorize）：
oauth_token
oauth_callback

E Service Provider在用户授权后重定向User到Consumer：
oauth_token

F Consumer申请Access Token（/oauth/1.0/access_token）：
oauth_consumer_key
oauth_token
oauth_signature_method
oauth_signature
oauth_timestamp
oauth_nonce
oauth_version

G Service Provider返回Access Token：
oauth_token
oauth_token_secret

##OAuth1.0a
OAuth1.0存在安全漏洞，详细介绍：[Explaining the OAuth Session Fixation Attack](http://hueniverse.com/2009/04/23/explaining-the-oauth-session-fixation-attack/)，还有这篇：[How the OAuth Security Battle Was Won, Open Web Style](http://readwrite.com/2009/04/25/how_the_oauth_security_battle_was_won_open_web_sty)

简单点来说，这是一种会话固化攻击，和常见的会话劫持攻击不同的是，在会话固化攻击中，攻击者会初始化一个合法的会话，然后诱使用户在这个会话上完成后续操作，从而达到攻击的目的。反映到OAuth1.0上，攻击者会先申请Request Token，然后诱使用户授权这个Request Token，接着针对回调地址的使用，又存在以下几种攻击手段：

如果Service Provider没有限制回调地址（应用设置没有限定根域名一致），那么攻击者可以把oauth_callback设置成成自己的URL，当User完成授权后，通过这个URL自然就能拿到User的Access Token。
如果Consumer不使用回调地址（桌面或手机程序），而是通过User手动拷贝粘贴Request Token完成授权的话，那么就存在一个竞争关系，只要攻击者在User授权后，抢在User前面发起请求，就能拿到User的Access Token。



修复项：
1 Consumer申请Request Token时，必须传递oauth_callback，而Consumer申请Access Token时，不需要传递oauth_callback。通过前置oauth_callback的传递时机，让oauth_callback参与签名，从而避免攻击者假冒oauth_callback。
2 Service Provider获得User授权后重定向User到Consumer时，返回oauth_verifier，它会被用在Consumer申请Access Token的过程中。攻击者无法猜测它的值。

A Consumer申请Request Token（/oauth/1.0a/request_token）：
oauth_consumer_key
oauth_signature_method
oauth_signature
oauth_timestamp
oauth_nonce
oauth_version
oauth_callback

B Service Provider返回Request Token：
oauth_token
oauth_token_secret
oauth_callback_confirmed

C Consumer重定向User到Service Provider（/oauth/1.0a/authorize）：
oauth_token

E Service Provider在用户授权后重定向User到Consumer：
oauth_token
oauth_verifier

F Consumer申请Access Token（/oauth/1.0a/access_token）：
oauth_consumer_key
oauth_token
oauth_signature_method
oauth_signature
oauth_timestamp
oauth_nonce
oauth_version
oauth_verifier

G Service Provider返回Access Token：
oauth_token
oauth_token_secret
注：Service Provider返回Request Token时，附带返回的oauth_callback_confirmed是为了说明Service Provider是否支持OAuth1.0a版本。

签名参数中，oauth_timestamp表示客户端发起请求的时间，如未验证会带来安全问题。

在探讨oauth_timestamp之前，先聊聊oauth_nonce，它是用来防止重放攻击的，Service Provider应该验证唯一性，不过保存所有的oauth_nonce并不现实，所以一般只保存一段时间（比如最近一小时）内的数据。

如果不验证oauth_timestamp，那么一旦攻击者拦截到某个请求后，只要等到限定时间到了，oauth_nonce再次生效后就可以把请求原样重发，签名自然也能通过，完全是一个合法请求，所以说Service Provider必须验证oauth_timestamp和系统时钟的偏差是否在可接受范围内（比如十分钟），如此才能彻底杜绝重放攻击。

##OAuth2.0
OAuth1.0虽然在安全性上经过修补已经没有问题了，但还存在其它的缺点，其中最主要的莫过于以下两点：其一，签名逻辑过于复杂，对开发者不够友好；其二，授权流程太过单一，除了Web应用以外，对桌面、移动应用来说不够友好。

首先，去掉签名，改用SSL（HTTPS）确保安全性，所有的token不再有对应的secret存在，这也直接导致OAuth2.0不兼容老版本。

其次，针对不同的情况使用不同的授权流程，和老版本只有一种授权流程相比，新版本提供了四种授权流程，可依据客观情况选择。

在详细说明授权流程之前，我们需要先了解一下OAuth2.0中的角色：

OAuth1.0定义了三种角色：User、Service Provider、Consumer。而OAuth2.0则定义了四种角色：Resource Owner、Resource Server、Client、Authorization Server：

Resource Owner：User
Resource Server：Service Provider
Client：Consumer
Authorization Server：Service Provider

OAuth2.0把原本OAuth1.0里的Service Provider角色分拆成Resource Server和Authorization Server两个角色，在授权时交互的是Authorization Server，在请求资源时交互的是Resource Server，当然，有时候他们是合二为一的。

###Authorization Code
可用范围：此类型可用于有服务端的应用，是最贴近老版本的方式。

 +----------+
 | resource |
 |   owner  |
 |          |
 +----------+
      ^
      |
     (B)
 +----|-----+          Client Identifier      +---------------+
 |         -+----(A)-- & Redirection URI ---->|               |
 |  User-   |                                 | Authorization |
 |  Agent  -+----(B)-- User authenticates --->|     Server    |
 |          |                                 |               |
 |         -+----(C)-- Authorization Code ---<|               |
 +-|----|---+                                 +---------------+
   |    |                                         ^      v
  (A)  (C)                                        |      |
   |    |                                         |      |
   ^    v                                         |      |
 +---------+                                      |      |
 |         |>---(D)-- Authorization Code ---------'      |
 |  Client |          & Redirection URI                  |
 |         |                                             |
 |         |<---(E)----- Access Token -------------------'
 +---------+       (w/ Optional Refresh Token)

A Client向Authorization Server发出申请（/oauth/2.0/authorize）：
response_type = code
client_id
redirect_uri
scope
state

C Authorization Server在Resource Owner授权后给Client返回Authorization Code：
code
state

D Client向Authorization Server发出申请（/oauth/2.0/token）：
grant_type = authorization_code
code
client_id
client_secret
redirect_uri

E B Authorization Server在Resource Owner授权后给Client返回Access Token：
access_token
token_type
expires_in
refresh_token
说明：基本流程就是拿Authorization Code换Access Token。

###Implicit Grant
可用范围：此类型可用于没有服务端的应用，比如Javascript应用。

 +----------+
 | Resource |
 |  Owner   |
 |          |
 +----------+
      ^
      |
     (B)
 +----|-----+          Client Identifier     +---------------+
 |         -+----(A)-- & Redirection URI --->|               |
 |  User-   |                                | Authorization |
 |  Agent  -|----(B)-- User authenticates -->|     Server    |
 |          |                                |               |
 |          |<---(C)--- Redirection URI ----<|               |
 |          |          with Access Token     +---------------+
 |          |            in Fragment
 |          |                                +---------------+
 |          |----(D)--- Redirection URI ---->|   Web-Hosted  |
 |          |          without Fragment      |     Client    |
 |          |                                |    Resource   |
 |     (F)  |<---(E)------- Script ---------<|               |
 |          |                                +---------------+
 +-|--------+
   |    |
  (A)  (G) Access Token
   |    |
   ^    v
 +---------+
 |         |
 |  Client |
 |         |
 +---------+

A Client向Authorization Server发出申请（/oauth/2.0/authorize）：
response_type = token
client_id
redirect_uri
scope
state

G Authorization Server在Resource Owner授权后给Client返回Access Token：
access_token
token_type
expires_in
scope
state
说明：没有服务端的应用，其信息只能保存在客户端，如果使用Authorization Code授权方式的话，无法保证client_secret的安全。BTW：不返回Refresh Token。


###Resource Owner Password Credentials
可用范围：不管有无服务端，此类型都可用。

 +----------+
 | Resource |
 |  Owner   |
 |          |
 +----------+
      v
      |    Resource Owner
     (A) Password Credentials
      |
      v
 +---------+                                  +---------------+
 |         |>--(B)---- Resource Owner ------->|               |
 |         |         Password Credentials     | Authorization |
 | Client  |                                  |     Server    |
 |         |<--(C)---- Access Token ---------<|               |
 |         |    (w/ Optional Refresh Token)   |               |
 +---------+                                  +---------------+

A B Clien向Authorization Server发出申请（/oauth/2.0/token）：
grant_type = password
username
password
scope

C AuthorizationServer给Client返回AccessToken：
access_token
token_type
expires_in
refresh_token
说明：因为涉及用户名和密码，所以此授权类型仅适用于可信赖的应用。

###Client Credentials
可用范围：不管有无服务端，此类型都可用。

 +---------+                                  +---------------+
 |         |                                  |               |
 |         |>--(A)- Client Authentication --->| Authorization |
 | Client  |                                  |     Server    |
 |         |<--(B)---- Access Token ---------<|               |
 |         |                                  |               |
 +---------+                                  +---------------+

* A Client向Authorization Server发出申请（/oauth/2.0/token）：
grant_type = client_credentials
client_id
client_secret
scope

* B Authorization Server给Client返回Access Token：
access_token
token_type
expires_in
说明：此授权类型仅适用于获取与用户无关的公共信息。BTW：不返回Refresh Token。

###Access Token和Refresh Token
流程中涉及两种Token，分别是Access Token和Refresh Token。通常，Access Token的有效期比较短，而Refresh Token的有效期比较长，如此一来，当Access Token失效的时候，就需要用Refresh Token刷新出有效的Access Token：

 +--------+                                         +---------------+
 |        |--(A)------- Authorization Grant ------->|               |
 |        |                                         |               |
 |        |<-(B)----------- Access Token -----------|               |
 |        |               & Refresh Token           |               |
 |        |                                         |               |
 |        |                            +----------+ |               |
 |        |--(C)---- Access Token ---->|          | |               |
 |        |                            |          | |               |
 |        |<-(D)- Protected Resource --| Resource | | Authorization |
 | Client |                            |  Server  | |     Server    |
 |        |--(E)---- Access Token ---->|          | |               |
 |        |                            |          | |               |
 |        |<-(F)- Invalid Token Error -|          | |               |
 |        |                            +----------+ |               |
 |        |                                         |               |
 |        |--(G)----------- Refresh Token --------->|               |
 |        |                                         |               |
 |        |<-(H)----------- Access Token -----------|               |
 +--------+           & Optional Refresh Token      +---------------+

A Client向Authorization Server发出申请（/oauth/2.0/token）：
grant_type = refresh_token
refresh_token
client_id
client_secret
scope

H Authorization Server给Client返回Access Token：
access_token
expires_in
refresh_token
scope

[OAuth 2.0对Web有害吗？](http://www.infoq.com/cn/news/2010/09/oauth2-bad-for-web)



---
#dev
##oauth2.0
spring security
[OAuth2.0开发人员指南（Spring security oauth2）](http://www.linuxidc.com/Linux/2014-10/107716.htm)
[OAuth 2 开发人员指南（Spring security oauth2）](http://www.open-open.com/lib/view/open1412731740452.html)


---
#openid
[OpenID学习笔记](http://www.biaodianfu.com/learn-openid.html)














