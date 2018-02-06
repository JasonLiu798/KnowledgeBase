
#包装对象
== 		包装对象 等于 原始对象
===  	包装对象 不等于 原始对象


##类型转换
== 会做类型转换
=== 不做类型转换


指定位数转换字符串
toFixed
转为科学计数法
toExponential

---
#检测对象中是否存在某个属性
* in关键字
var o={x:1};
"x" in o;            //true，自有属性存在
"y" in o;            //false
"toString" in o;     //true，是一个继承属性
限制：对象不能为null

* 对象的hasOwnProperty()方法
```
var o={x:1};
o.hasOwnProperty("x");    　　 //true，自有属性中有x
o.hasOwnProperty("y");    　　 //false，自有属性中不存在y
o.hasOwnProperty("toString"); //false，这是一个继承属性，但不是自有属性
```

* 用undefined判断
自有属性和继承属性均可判断。
var o={x:1};
o.x!==undefined;        //true
o.y!==undefined;        //false
o.toString!==undefined  //true
该方法存在一个问题，如果属性的值就是undefined的话，该方法不能返回想要的结果，如下。

var o={x:undefined};
o.x!==undefined;        //false，属性存在，但值是undefined
o.y!==undefined;        //false
o.toString!==undefined  //true*

* 在条件语句中直接判断
```js
var o={};
if(o.x) o.x+=1;//如果x是undefine,null,false," ",0或NaN,它将保持不变
```



















