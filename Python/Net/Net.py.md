#net
----
#urllib2
[](http://www.pythontab.com/html/2014/pythonhexinbiancheng_1128/928.html)
[](http://www.cnblogs.com/yuxc/archive/2011/08/01/2123995.html)
```
import urllib2
c=urllib2.urlopen('http://www.zhihu.com')
print c

#Request对象
import urllib2 
req = urllib2.Request('http://www.pythontab.com') 
response = urllib2.urlopen(req) 
the_page = response.read()

#data
import urllib 
import urllib2 
url = 'http://www.pythontab.com' 
values = {'name' : 'Michael Foord', 
          'location' : 'pythontab', 
          'language' : 'Python' } 
data = urllib.urlencode(values) 
req = urllib2.Request(url, data) 
response = urllib2.urlopen(req) 
the_page = response.read()
#data未写，使用GET

#header
user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)' 
headers = { 'User-Agent' : user_agent } 
req = urllib2.Request(url, data, headers) 

#exception
try: 
    urllib2.urlopen(req) 
except HTTPError, e: 
    print 'The server couldn/'t fulfill the request.' 
    print 'Error code: ', e.code     #http状态码
except URLError, e: 
    print 'We failed to reach a server.' 
    print 'Reason: ', e.reason  
    
```

##HTTPBasicAuthHandler
使用一个密码管理的对象来处理URLs和realms来映射用户名和密码

##超时
urllib 使用http.client库，再调用socket库实现
可以给所有的sockets设置全局的超时
```
socket.setdefaulttimeout(10) # 10 秒钟后超时
urllib2.socket.setdefaulttimeout(10) # 另一种方式
```
Python 2.6 版本中，超时可以通过 urllib2.urlopen() 的 timeout 参数直接设置。
```
import urllib2
response = urllib2.urlopen('http://www.google.com', timeout=10)
```
##代理
```
import urllib2
enable_proxy = True
proxy_handler = urllib2.ProxyHandler({"http" : 'http://some-proxy.com:8080'})
null_proxy_handler = urllib2.ProxyHandler({})
 
if enable_proxy:
    opener = urllib2.build_opener(proxy_handler)
else:
    opener = urllib2.build_opener(null_proxy_handler)
urllib2.install_opener(opener)
```
##重定向后的url
redirected = response.geturl() 

##cookie
```
import urllib2
import cookielib
cookie = cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookie))
response = opener.open('http://www.google.com')
for item in cookie:
    if item.name == 'some_cookie_item_name':
        print item.value
```

##put/delete
```

import urllib2
 
request = urllib2.Request(uri, data=data)
request.get_method = lambda: 'PUT' # or 'DELETE'
response = urllib2.urlopen(request)
```
##debuglog
```
import urllib2

httpHandler = urllib2.HTTPHandler(debuglevel=1)
httpsHandler = urllib2.HTTPSHandler(debuglevel=1)
opener = urllib2.build_opener(httpHandler, httpsHandler)
 
urllib2.install_opener(opener)
response = urllib2.urlopen('http://www.google.com')
```































