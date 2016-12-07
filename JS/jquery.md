#jquery
-----


bug: <script src="asset/jquery-1.11.2.js"/> =>
<script src="asset/jquery-1.11.2.js"></script>


---
#ajax
[ajax()](http://www.w3school.com.cn/jquery/ajax_ajax.asp)
```
$.ajax({
    type: 'GET',
    url: 'http://localhost:8080/',
    data: data ,
    success: success ,
    dataType: dataType
});
```


---
#选择器
$(this)当前 HTML 元素
$("p")所有 <p> 元素
$("p.intro")所有 class="intro" 的 <p> 元素
$(".intro")所有 class="intro" 的元素
$("#intro")id="intro" 的元素
$("ul li:first")每个 <ul> 的第一个 <li> 元素
$("[href$='.jpg']")所有带有以 ".jpg" 结尾的属性值的 href 属性
$("div#intro .head")id="intro" 的 <div> 元素中的所有 class="head" 的元素

#修改属性
$('.div').attr('id','newid');
如果是给标签添加class样式可以这样
$('#div').addClass('css类名');

#ready,onload
页面加载完成有两种事件，一是ready，表示文档结构已经加载完成（不包含图片等非文字媒体文件），二是onload，指示页 面包含图片等文件在内的所有元素都加载完成。(可以说：ready 在onload 前加载！！！)

一般样式控制的，比如图片大小控制放在onload 里面加载;
而：jS事件触发的方法，可以在ready 里面加载;

用jQ的人很多人都是这么开始写脚本的：
```javascript
$(function(){
// do something
});
其实这个就是jq ready()的简写，他等价于：
$(document).ready(function(){
//do something
})
//或者下面这个方法，jQuer的默认参数是：“document”；
$().ready(function(){
//do something
})

visibility:visible
visibility:hidden
```








