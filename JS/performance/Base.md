#doc
[Web前端应该从哪些方面来优化网站?](https://www.zhihu.com/question/21658448)


---
#域名收敛
[域名收敛--前端优化](https://segmentfault.com/a/1190000004641599)

Why should we choose domain of convergence?
一般来说，在手机端上的域名数不能超过5个。 基本上的分配就是
html +1
css +1 
img +1
js +1
fonts +1



#域名发散 Domain Sharding
[What is Domain Sharding?](https://blog.stackpath.com/glossary/domain-sharding/)
By default, web browsers limit the number of active connections for each domain. When the number of resources to download exceeds that limit, users experience slow page load times as downloads are queued.

To work around this limitation, developers may split content across multiple subdomains. Since browsers reset the connection limit for each domain, each additional domain allows an additional number of active connections. This lets the user retrieve files from the same source with greater throughput.









