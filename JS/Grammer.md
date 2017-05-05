

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




#prototype
##bind
[理解 JavaScript 中的 Function.prototype.bind](http://blog.jobbole.com/58032/)
```js
Function.prototype.bind = function (scope) {
    var fn = this;
    return function () {
        return fn.apply(scope);
    };
}
```
支持度
Browser	| Version support
--------|------------------
Chrome  | 		7
Firefox (Gecko)		| 4.0 (2)
Internet Explorer	| 9
Opera	|	11.60
Safari	| 	5.1.4

替代方案
```js
if (!Function.prototype.bind) {
  Function.prototype.bind = function (oThis) {
    if (typeof this !== &quot;function&quot;) {
      // closest thing possible to the ECMAScript 5 internal IsCallable function
      throw new TypeError(&quot;Function.prototype.bind - what is trying to be bound is not callable&quot;);
    }
 
    var aArgs = Array.prototype.slice.call(arguments, 1), 
        fToBind = this, 
        fNOP = function () {},
        fBound = function () {
          return fToBind.apply(this instanceof fNOP &amp;amp;&amp;amp; oThis
                                 ? this
                                 : oThis,
                               aArgs.concat(Array.prototype.slice.call(arguments)));
        };
 
    fNOP.prototype = this.prototype;
    fBound.prototype = new fNOP();
 
    return fBound;
  };
}
```



















