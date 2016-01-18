#Tornado
------------
[introduce to Tornado](http://demo.pythoner.com/itt2zh/index.html)
[a blog](https://github.com/Shu-Ji/pabo)

C10K

https://github.com/tornadoweb/tornado

```
import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web

from tornado.options import define, options
define("port", default=8000, help="run on the given port", type=int)

class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        greeting = self.get_argument('greeting', 'Hello')
        self.write(greeting + ', friendly user!')

if __name__ == "__main__":
    tornado.options.parse_command_line()
    app = tornado.web.Application(handlers=[(r"/", IndexHandler)])
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
```



RequestHandler


---
#模板
##文件夹路径配置
```
settings=dict(
template_path=os.path.join(os.path.dirname(__file__), "templates"),
static_path=os.path.join(os.path.dirname(__file__), "static"),)
tornado.web.Application.__init__(self, handlers, **settings)

#单独使用
from tornado.template import Template
content = Template("<html><body><h1>{{ header }}</h1></body></html>")
print content.generate(header="Welcome!")
#in handler
class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.render(
            "index.html",
            page_title = "Tools",
        )
```


##控制语句
```
{% for book in books %}
    <li>{{ book }}</li>
{% end %}
```

##函数
>>> from tornado.template import Template
>>> def disemvowel(s):
...     return ''.join([x for x in s if x not in 'aeiou'])
...
>>> disemvowel("george")
'grg'
>>> print Template("my name is {{d('mortimer')}}").generate(d=disemvowel)


static_url
static_path=os.path.join(os.path.dirname(__file__), "static")
1.函数创建了一个基于文件内容的hash值，并将其添加到URL末尾（查询字符串的参数v）。这个hash值确保浏览器总是加载一个文件的最新版而不是之前的缓存版本。
2.另一个好处是你可以改变你应用URL的结构，而不需要改变模板中的代码。

##块和替换
{% extends "main.html" %}


module


---
#C4 db
MongoDB文档 http://www.mongodb.org/display/DOCS/Home
[PyMongo](http://api.mongodb.org/python/current/installation.html)
python -m pip install pymongo
[tutial](http://api.mongodb.org/python/current/tutorial.html)
```
import pymongo
import datetime
from pymongo import MongoClient

client = MongoClient('localhost', 27017)
#client = MongoClient('mongodb://localhost:27017/')
#uri方式 https://docs.mongodb.org/manual/reference/connection-string/
db = client.test_database
db = client['test-database']

collection = db.test_collection

>>> post = {"author": "Mike",
...         "text": "My first blog post!",
...         "tags": ["mongodb", "python", "pymongo"],
...         "date": datetime.datetime.utcnow()}
#第一次插入，以上操作才会执行
posts = db.posts
post_id = posts.insert_one(post).inserted_id
post_id

posts.find_one()
posts.find_one({"author": "Mike"})
post_id
posts.find_one({"_id": post_id})


```

MongoDB是一个"无模式"数据库：
同一个集合中的文档通常拥有相同的结构，但是MongoDB中并不强制要求使用相同结构
db.collection_names() 查看所有

>>>doc = db.widgets.find_one({"name": "flibnip"})
>>>import json
>>>json.dumps(doc)

PyMongo 的json_util库，它同样可以帮你序列化其他MongoDB特定数据类型到JSON
[json_util](http://api.mongodb.org/python/current/api/bson/json_util.html)

db = client.test_database
db.words.insert({"word": "oarlock", "definition": "A device attached to a rowboat to hold the oars in place"})
db.words.insert({"word": "seminomadic", "definition": "Only partially nomadic"})
db.words.insert({"word": "perturb", "definition": "Bother, unsettle, modify"})


---
#C5 async

同步
```
response = client.fetch("http://search.twitter.com/search.json?" + \
                urllib.urlencode({"q": query, "result_type": "recent", "rpp": 100}))
```
siege http://localhost:8000/?q=pants -c10 -t10s
Availability:                 100.00 %
Elapsed time:                   9.55 secs
Data transferred:               0.03 MB
Response time:                  0.02 secs
Transaction rate:              20.10 trans/sec

async
```
@tornado.web.asynchronous装饰器来告诉Tornado保持连接开启

    @tornado.web.asynchronous
    def get(self):
        query = self.get_argument('q')
        [... other request handler code here...]

必须在你的RequestHandler对象中调用finish方法来显式地告诉Tornado关闭连接

```
Availability:                 100.00 %
Elapsed time:                   9.06 secs
Data transferred:               0.03 MB
Response time:                  0.02 secs
Transaction rate:              18.76 trans/sec

[asyncmongo](https://github.com/bitly/asyncmongo)


长轮询
websocket


----
#C6 web安全
Tornado的安全cookies使用加密签名来验证cookies的值没有被服务器软件以外的任何人修改过

XSRF
任何会产生副作用的HTTP请求，比如点击购买按钮、编辑账户设置、改变密码或删除文档，都应该使用HTTP POST方法

要求每个请求包括一个参数值作为令牌来匹配存储在cookie中的对应值。我们的应用将通过一个cookie头和一个隐藏的HTML表单元素向页面提供令牌
```
settings = {
    "cookie_secret": "bZJc2sWbQLKos6GkHn/VB9oXwQt8S0R0kRvJ5/xJ89E=",
    "xsrf_cookies": True
}
application = tornado.web.Application([
    (r'/', MainHandler),
    (r'/purchase', PurchaseHandler),
], **settings)
```



authenticated装饰器

---
#C7第三方认证

---
#C8 部署
Supervisor监控









----
#db
[Torndb](https://github.com/bdarnell/torndb)









































































