# 一、DOM创建

DOM节点（Node）通常对应于一个标签，一个文本，或者一个HTML属性。DOM节点有一个nodeType属性用来表示当前元素的类型，它是一个整数：

Element，元素
Attribute，属性
Text，文本
DOM节点创建最常用的便是document.createElement和document.createTextNode方法：
```js
var node1 = document.createElement('div');
var node2 = document.createTextNode('hello world!');
```

# 二、DOM查询
```js
// 返回当前文档中第一个类名为 "myclass" 的元素
var el = document.querySelector(".myclass");

// 返回一个文档中所有的class为"note"或者 "alert"的div元素
var els = document.querySelectorAll("div.note, div.alert");

// 获取元素
var el = document.getElementById('xxx');
var els = document.getElementsByClassName('highlight');
var els = document.getElementsByTagName('td');
```

Element也提供了很多相对于元素的DOM导航方法：
```js
// 获取父元素、父节点
var parent = ele.parentElement;
var parent = ele.parentNode;//只读，没有兼容性问题
var offsetParent=ele.offsetParent;//只读，找到最近的有定位的父节点。
　　　　　　　　　　　　　　　　　　　　　//没有定位父级时，默认是body;但在IE7以下，如果当前元素没有定位属性，返回body，如果有，返回HTML;
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　 //如果当前元素某个父级触发了haslayout，则返回触发了haslayout这个元素。

// 获取子节点，子节点可以是任何一种节点，可以通过nodeType来判断
var nodes = ele.children;//标准下、非标准下都只含元素类型，但对待非法嵌套的子节点，处理方式与childNodes一致。   
var nodes = ele.childNodes;//非标准下：只包含元素类型，不会包含非法嵌套的子节点。
　　　　　　　　　　　　　　　　//标准下：包含元素和文本类型，会包含非法嵌套的子节点。 

//获取元素属性列表
var attr = ele.attributes;

// 查询子元素
var els = ele.getElementsByTagName('td');
var els = ele.getElementsByClassName('highlight');

// 当前元素的第一个/最后一个子元素节点
var el = ele.firstChild;//对待标准和非标准模式，如childNods
var el = ele.lastChild;
var el = ele.firstElementChild;//非标准不支持
var el = ele.lastElementChild;
// 下一个/上一个兄弟元素节点
var el = ele.nextSibling;
var el = ele.previousSibling;
var el = ele.nextElementSibling;
var el = ele.previousElementSibling;
```
 

兼容的获取第一个子元素节点方法：
```js
var first=ele.firstElementChild||ele.children[0];
```
 

# 三、DOM更改
```js
// 添加、删除子元素
ele.appendChild(el);
ele.removeChild(el);

// 替换子元素
ele.replaceChild(el1, el2);

// 插入子元素
parentElement.insertBefore(newElement, referenceElement);

//克隆元素
ele.cloneNode(true) //该参数指示被复制的节点是否包括原节点的所有属性和子节点
```
 

# 四、属性操作
```js
// 获取一个{name, value}的数组
var attrs = el.attributes;

// 获取、设置属性
var c = el.getAttribute('class');
el.setAttribute('class', 'highlight');

// 判断、移除属性
el.hasAttribute('class');
el.removeAttribute('class');

// 是否有属性设置
el.hasAttributes();     
```


# innerHTML与outerHTML的区别
 比如对于这样一个HTML元素：<div>content<br/></div>。

innerHTML：内部HTML，content<br/>；
outerHTML：外部HTML，<div>content<br/></div>；
innerText：内部文本，content；
outerText：内部文本，content；












