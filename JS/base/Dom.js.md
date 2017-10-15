


#移动节点
```javascript
function moveNode() {
    var list = document.getElementById("list");
    var lis = list.childNodes;
    var lia = null;
    var lib = null;
    for(var i = 0, len = lis.length; i < len; i++) {
        if(lis[i].nodeName.toLowerCase() == "li") {
            if(lis[i].getAttribute("class") == "a") {
            lia = lis[i];
            }
            if(lis[i].getAttribute("class") == "b") {
                lib = lis[i].cloneNode(true);
                list.removeChild(lis[i]);
                list.insertBefore(lib, lia);
                return;
            }
        }
    }
}
```


[事件冒泡](http://www.cnblogs.com/dolphinX/p/3239530.html)


#表单拦截回车提交
```javascript
    $('#post_tag').bind('keydown',function(event){
    var e = e || event;
var keyNum = e.which || e.keyCode;
return keyNum==13 ? false : true;
    });
```


---
#window
属性  值
href    完整的 URL
protocol    协议
hostname    主机名
host    主机名加端口号
port    的端口号
pathname    当前 URL 的路径部分
search  URL 的查询部分
hash    #开始的锚具体获取方法：window.location.hostname 等；

window.location.host

