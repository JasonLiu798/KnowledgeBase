



---
#原型链
[JS原型与原型链终极详解](http://www.108js.com/article/article1/10201.html?id=1092)










----

#跨域
相同域必须忙住协议相同、端口相同、域名相同. 只要其中一点不满足那就是跨域
Access-Control-Allow-Origin
Access-Control-Allow-Origin是HTML5中定义的一种服务器端返回Response header，用来解决资源（比如字体）的跨域权限问题。
它定义了该资源允许被哪个域引用，或者被所有域引用（google字体使用*表示字体资源允许被所有域引用）。

##jsonp
[JSONP](http://kb.cnblogs.com/page/139725/)
JSONP，CORS，HTTP 协议，浏览器安全机制，PreFlight Request，反向代理

```js
$.ajax({
     url: "http://localhost:8080/msg/front/jcj/1.jsp?callback=?",
     dataType: "jsonp",
     jsonpCallback: "m1",
     success: function(data) {}
});
function m1(data) {
    alert(data);
}

```

服务端
```
String str = "{[\"name1\": \"json\",\"name2\": \"json\",\"name3\": \"json\"]}";
ObjectMapper mapper = new ObjectMapper();
String json = mapper.writeValueAsString(str);
json = "m1(" + json + ")";
response.getWriter().print(json);
```

##header meta
站点www.a.com需要调用comment.a.com/api/post.php,那么这个post.php必须加上如下代码

header("Access-Control-Allow-Origin: http://www.a.com");
header("Access-Control-Allow-Origin: http://www.a.com");

header方式不能使用正则，例如*.a.com，不过我们可以使用如下方法，将内容echo到php响应内容中

echo '<meta http-equiv="Access-Control-Allow-Origin" content="*.a.com">';
echo '<meta http-equiv="Access-Control-Allow-Origin" content="*.a.com">';
header里面用不了正则，而meta里面可以用正则
从上面的代码可以看出, 代码1安全性不够，但是使用接口的人只会获取到响应的body内容。代码2相对安全，但是响应的body内容体里面包含<meta http-equiv="Access-Control-Allow-Origin" content="*.a.com">，多少影响接口的使用.


---
#动态加载
动态加载JS脚本有4种方法： 
##1、直接document.write 
```html
<script language="javascript"> 
    document.write("<script src='test.js'><\/script>"); 
</script> 
```
##2、动态改变已有script的src属性 
```html
<script src='' id="s1"></script> 
<script language="javascript"> 
    s1.src="test.js" 
</script> 
```
##3、动态创建script元素 
<script> 
    var oHead = document.getElementsByTagName('HEAD').item(0); 
    var oScript= document.createElement("script"); 
    oScript.type = "text/javascript"; 
    oScript.src="test.js"; 
    oHead.appendChild( oScript); 
</script> 

这三种方法都是异步执行的，也就是说，在加载这些脚本的同时，主页面的脚本继续运行，如果用以上的方法，那下面的代码将得不到预期的效果。 
要动态加载的JS脚本：a.js，以下是该文件的内容。 
var str = "中国"; 
alert( "这是a.js中的变量：" + str ); 
主页面代码： 
<script language="JavaScript"> 
function LoadJS( id, fileUrl ) { 
    var scriptTag = document.getElementById( id ); 
    var oHead = document.getElementsByTagName('HEAD').item(0); 
    var oScript= document.createElement("script"); 
    if ( scriptTag  ) oHead.removeChild( scriptTag  ); 
    oScript.id = id; 
    oScript.type = "text/javascript"; 
    oScript.src=fileUrl ; 
    oHead.appendChild( oScript); 
}
LoadJS( "a.js" ); 
alert( "主页面动态加载a.js并取其中的变量：" + str ); 
</script> 

上述代码执行后 a.js 的 alert 执行并弹出消息， 
但是 主页面产生了错误，没有弹出对话框。原因是 'str' 未定义，为什么呢？因为主页面在取 str 的时候 a.js 并没有完全加载成功。遇到需要同步执行脚本的时候，可以用下面的第四种方法。 

##4、原理：用XMLHTTP取得要脚本的内容，再创建 Script 对象。 
注意：a.js必须用UTF8编码保存，要不会出错。因为服务器与XML使用UTF8编码传送数据。
主页面代码： 
<script language="JavaScript"> 
function GetHttpRequest() { 
    if ( window.XMLHttpRequest ) // Gecko 
        return new XMLHttpRequest() ; 
    else if ( window.ActiveXObject ) // IE 
        return new ActiveXObject("MsXml2.XmlHttp") ; 
}
function AjaxPage(sId, url){ 
    var oXmlHttp = GetHttpRequest() ; 
    oXmlHttp.OnReadyStateChange = function(){ 
        if ( oXmlHttp.readyState == 4 ) { 
            if ( oXmlHttp.status == 200 || oXmlHttp.status == 304 ){ 
                IncludeJS( sId, url, oXmlHttp.responseText ); 
            }else{
                alert( 'XML request error: ' + oXmlHttp.statusText + ' (' + oXmlHttp.status + ')' ) ; 
            } 
        } 
    }
    oXmlHttp.open('GET', url, true); 
    oXmlHttp.send(null);
} 
function IncludeJS(sId, fileUrl, source){ 
    if ( ( source != null ) && ( !document.getElementById( sId ) ) ){ 
        var oHead = document.getElementsByTagName('HEAD').item(0); 
        var oScript = document.createElement( "script" ); 
        oScript.language = "javascript"; 
        oScript.type = "text/javascript"; 
        oScript.id = sId; 
        oScript.defer = true;
        oScript.text = source;
        oHead.appendChild( oScript ); 
    }
} 
AjaxPage( "scrA", "b.js" ); 
alert( "主页面动态加载JS脚本。"); 
alert( "主页面动态加载a.js并取其中的变量：" + str ); 
</script> 
现在完成了一个JS脚本的动态加载。 














