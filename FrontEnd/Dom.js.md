


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


表单拦截回车提交
```javascript
    $('#post_tag').bind('keydown',function(event){
    var e = e || event;
var keyNum = e.which || e.keyCode;
return keyNum==13 ? false : true;
    });
```



