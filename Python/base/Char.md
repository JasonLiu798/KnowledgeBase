

#json中文
```py
#!/usr/bin/python
# encoding=utf-8
import json
data = [{"a": "中文"}]
print json.dumps(data).decode("unicode-escape")
```


#SyntaxError: Non-ASCII character '\xff'
文本编码
第一种：
```py
#!/usr/bin/python
#coding:utf-8
print "你好吗"
```

第二种：
```py
#!/usr/bin/python
#-*-coding:utf-8 -*-
print "你好吗"
```

第三种：
```py
#!/usr/bin/python
#vim: set fileencoding:utf-8
print "你好吗"
```



