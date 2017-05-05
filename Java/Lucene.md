Lucene 的analysis 模块主要负责词法分析及语言处理而形成Term 。
Lucene 的index 模块主要负责索引的创建，里面有IndexWriter 。
Lucene 的store 模块主要负责索引的读写。
Lucene 的QueryParser 主要负责语法分析。
Lucene 的search 模块主要负责对索引的搜索。
Lucene 的similarity 模块主要负责对相关性打分的实现。

solar
https://cwiki.apache.org/confluence/display/solr/Using+SolrJ


#lucene示例
##建立索引
```java
//使用lucene api建立索引
IndexWriter writer = new IndexWriter("D:/index/", new PanGuAnalyzer(), true); 
Document doc = new Document();
doc.Add(new Field("id", item.id.ToString(), Field.Store.YES, Field.Index.UN_TOKENIZED));
doc.Add(new Field("productname", item.productname, Field.Store.YES, Field.Index.TOKENIZED));
doc.Add(new Field("productdes", item.productdes, Field.Store.YES, Field.Index.UN_TOKENIZED));
doc.Add(new Field("tradename", item.tradename, Field.Store.YES, Field.Index.UN_TOKENIZED));
doc.Add(new Field("companyname", item.companyname, Field.Store.YES, Field.Index.UN_TOKENIZED));
doc.Add(new Field("fhdes", item.fhdes, Field.Store.YES, Field.Index.TOKENIZED));
doc.Add(new Field("pic", item.pic, Field.Store.YES, Field.Index.UN_TOKENIZED));
writer.AddDocument(doc);
writer.Optimize(); 
writer.Close();

```

##查询
```java
//使用 lucene api做查询
Analyzer analyzer=new StandardAnalyzer(Version.LUCENE_46);  
LuceneIndex.createIndex(analyzer);  
QueryParser parser = new QueryParser(Version.LUCENE_46, "content", analyzer);   
Query query = parser.parse("人"); 
Directory dire=FSDirectory.open(new File(Constants.INDEX_STORE_PATH));  
IndexReader ir=DirectoryReader.open(dire);  
IndexSearcher is=new IndexSearcher(ir);  
TopDocs td=is.search(query, 1000);  
log.info("共为您查找到"+td.totalHits+"条结果");  
ScoreDoc[] sds =td.scoreDocs;  
for (ScoreDoc sd : sds) {   
    Document d = is.doc(sd.doc);   
    log.info(d.get("path") + ":["+d.get("path")+"]");   
}  
is.close();

```

##原生AIP缺点
1. 代码繁琐，就像使用jdbc api
2. 应用中耦合索引逻辑
3.不能做到服务化
4.不能做到分布式高可用

##目标
1. 服务化
2.分布式，“大无边界”，支持动态扩容
3.速度够快，“快无边界”

##问题
1.数据分片
2.分区容错（高可用）
3.路由
4.扩容
5.分布式查询



















