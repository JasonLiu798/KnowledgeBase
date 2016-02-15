#Java search engine
---
#design
[亿级数据的高并发通用搜索引擎架构设计](http://zyan.cc/post/385/)

#对比
[主流全文索引工具的比较（ Lucene, Sphinx, solr, elastic search)](http://sg552.iteye.com/blog/1560834)
[Comparison of full text search engine - Lucene, Sphinx, Postgresql, MySQL?](http://stackoverflow.com/questions/737275/comparison-of-full-text-search-engine-lucene-sphinx-postgresql-mysql)
[搜索引擎选择： Elasticsearch与Solr](http://m.blog.csdn.net/blog/fz2543122681/44905643)
##ElasticSearch
It has a very advance distributed model, speaks natively JSON, and exposes many advance search features, all seamlessly expressed through JSON DSL. 
##Solr
Solr 是 apache的项目，是apache2的license. 
也是一个通过HTTP 访问的检索/查询解决方案，但是我觉得 ElasticSearch 提供了更好的分布式模型，也更容易使用

面向于大数据量下的高效率的建立索引，搜索

Solr很容易就可以集成到JAVA项目中。
Solr 是基于Lucene 的，后者已经8岁了，有着庞大的用户群体。Lucene 有啥功能，Solr就能享受到啥功能。而且Solr的 开发人员很多也参与了Lucene的开发。 

Solr 可以检索 WORD， PDF。 Sphinx不行 
Solr 还带有拼写检查器。 
Sphinx 不支持针对field data 的partial index的更新 
Solr 支持field collapsing 来避免相似搜索结果的重复性。 Sphinx没这个功能。 

Solr 跑在 java web 容器中，例如Tomcat 或 Jetty. 所以我们就可以进行配置和调试，优化。  Sphinx 则没有额外的配置选项。 


##Sphinx
Sphinx是GPL,也就是说，如果你想把Sphinx放到某个商业性的项目中，你就得买个商业许可证。 
面向于大数据量下的高效率的建立索引，搜索

Sphinx 跟 RDBMS （特别是MYSQL） 绑定的特别紧密。 而且Solr 可以和 Hadoop 集成，成为分布式系统。 也可以 和 Nutch集成，成为一个功能完备的搜索引擎，以及网络爬虫(crawler) 

Sphinx中，所有的 document id 必须是 unique , unsigned, non-zero 整数（估计是用C语言的名词来解释）。 Solr的很多操作，甚至不需要unique key。 而且unique key 可以是整数，也可以是字符串。 

sphinx不支持 live index update. 支持的话也非常有限。 


Lucene



#elasticsearch
https://www.gitbook.com/book/looly/elasticsearch-the-definitive-guide-cn/details

solar



