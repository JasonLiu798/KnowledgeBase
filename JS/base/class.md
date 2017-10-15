#类 对象
---
#语法
var o = new Object();

---
#属性描述符
[阮一峰Javascript标准参考教程——属性描述对象](http://javascript.ruanyifeng.com/stdlib/attributes.html)
对象属性描述符的类型分为两种： 数据属性 访问器属性

##数据属性 data property
包含一个数据值的位置，在这个位置可以读取和写入值。数据属性有4个特性

* Configurable(可配置性) 
可配置性决定是否可以使用delete删除属性，以及是否可以修改属性描述符的特性，默认值为true

* Enumerable(可枚举性) 
可枚举性决定属性是否出现在对象的属性枚举中，比如是否可以通过for-in循环返回该属性，默认值为true

* Writable(可写性)
可写性决定是否可以修改属性的值，默认值为true

* Value(属性值)
属性值包含这个属性的数据值，读取属性值的时候，从这个位置读；写入属性值的时候，把新值保存在这个位置。默认值为undefined

##访问器属性 accessor property
对象属性是名字、值和一组属性描述符构成的。而属性值可以用一个或两个方法替代，这两个方法就是getter和setter，而这种属性类型叫访问器属性

* Configurable(可配置性)
	可配置性决定是否可以使用delete删除属性，以及是否可以修改属性描述符的特性，默认值为true

* Enumerable(可枚举性)
　　可枚举性决定属性是否出现在对象的属性枚举中，比如是否可以通过for-in循环返回该属性，默认值为true

* getter
　　在读取属性时调用的函数。默认值为undefined

* setter
　　在写入属性时调用的函数。默认值为undefined

和数据属性不同，访问器属性不具有可写性(Writable)。
如果属性同时具有getter和setter方法，那么它是一个读/写属性。如果它只有getter方法，那么它是一个只读属性。如果它只有setter方法，那么它是一个只写属性。读取只写属性总是返回undefined

##描述符方法
前面介绍了属性描述符，要想设置它们，就需要用到描述符方法。
描述符方法总共有以下4个：

###Object.getOwnPropertyDescriptor(o,name)
查询 一个属性的描述符，并以对象的形式返回

查询obj.a属性时，可配置性、可枚举性、可写性都是默认的true，而value是a的属性值1
查询obj.b属性时，因为obj.b属性不存在，该方法返回undefined
```js
var obj = {a:1};
//Object {value: 1, writable: true, enumerable: true, configurable: true}
console.log(Object.getOwnPropertyDescriptor(obj,'a'));
//undefined
console.log(Object.getOwnPropertyDescriptor(obj,'b'));
```

###Object.defineProperty(o,name,desc)
创建或配置对象的一个属性的描述符，返回配置后的对象

使用该方法创建或配置对象属性的描述符时，如果不针对该属性进行描述符的配置，则该项描述符默认为false

```js
var obj = {};
//{a:1}
console.log(Object.defineProperty(obj,'a',{
        value:1,
        writable: true
    }));

//由于没有配置enumerable和configurable，所以它们的值为false
//{value: 1, writable: true, enumerable: false, configurable: false}
console.log(Object.getOwnPropertyDescriptor(obj,'a'));
```

###Object.defineProperty(o,descriptors)
创建或配置对象的多个属性的描述符，返回配置后的对象

```js
var obj = { a:1 };
//{a: 1, b: 2}
console.log(Object.defineProperties(obj,{
        a:{writable:false},
        b:{value:2}
	}));
//{value: 1, writable: false, enumerable: true, configurable: true}
console.log(Object.getOwnPropertyDescriptor(obj,'a'));
//{value: 2, writable: false, enumerable: false, configurable: false}
console.log(Object.getOwnPropertyDescriptor(obj,'b'));
```

###Object.create(proto,descriptors)
使用指定的原型和属性来创建一个对象
```js
var o = Object.create(Object.prototype,{
    a:{writable: false,value:1,enumerable:true}
});
//{value: 1, writable: false, enumerable: true, configurable: true}
console.log(Object.getOwnPropertyDescriptor(obj,'a'));
```


##描述符详述
　　前面分别介绍了数据属性和访问器属性的描述符，但没有详细说明其含义及使用，接下来逐一进行说明 

###可写性(writable)
决定是否可以修改属性的值，默认值为true
```js
var o = {a:1};
o.a = 2;
console.log(o.a);//2
```

设置writable:false后，赋值语句会静默失效
```js
var o = {a:1};
Object.defineProperty(o,'a',{
    writable:false
});
console.log(o.a);//1
//由于设置了writable为false，所以o.a=2这个语句会静默失效
o.a = 2;
console.log(o.a);//1
Object.defineProperty(o,'a',{
    writable:true
});
//由于writable设置为true，所以o.a可以被修改为2
o.a = 2;
console.log(o.a);//2
```

在严格模式下通过赋值语句为writable为false的属性赋值，会提示类型错误TypeError
```js
'use strict';
var o = {a:1};
Object.defineProperty(o,'a',{
    writable:false
});
//Uncaught TypeError: Cannot assign to read only property 'a' of object '#<Object>'
o.a = 2;
```
[注意]设置writable:false后，通过Object.defineProperty()方法改变属性value的值不会受影响，因为这也意味着在重置writable的属性值为false
```js
var o = {a:1};
Object.defineProperty(o,'a',{
    writable:false
});
console.log(o.a);//1
Object.defineProperty(o,'a',{
    value:2
});
console.log(o.a);//2
```

###可配置性(Configurable)
决定是否可以使用delete删除属性，以及是否可以修改属性描述符的特性，默认值为true
1. 设置Configurable:false后，无法使用delete删除属性
```js
var o = {a:1};
Object.defineProperty(o,'a',{
    configurable:false
});
delete o.a;//false
console.log(o.a);//1
```

严格模式下删除为configurable为false的属性，会提示类型错误TypeError
```js
'use strict';
var o = {a:1};
Object.defineProperty(o,'a',{
    configurable:false
});
//Uncaught TypeError: Cannot delete property 'a' of #<Object>
delete o.a;
```

[注意]使用var命令声明变量时，变量的configurable为false
```js
var a = 1;
//{value: 1, writable: true, enumerable: true, configurable: false}
Object.getOwnPropertyDescriptor(this,'a');
```

2.一般地，设置Configurable:false后，将无法再使用defineProperty()方法来修改属性描述符
```js
var o = {a:1};
Object.defineProperty(o,'a',{
    configurable:false
});
//Uncaught TypeError: Cannot redefine property: a
Object.defineProperty(o,'a',{
    configurable:true
});
```

有一个例外，设置Configurable:false后，只允许writable的状态从true变为false
```js
var o = {a:1};
Object.defineProperty(o,'a',{
    configurable:false,
    writable:true
});
o.a = 2;
console.log(o.a);//2
Object.defineProperty(o,'a',{
    writable:false
});
//由于writable:false生效，对象a的o属性无法修改值，所以o.a=3的赋值语句静默失败
o.a = 3;
console.log(o.a);//2
```
 
###可枚举性(Enumerable)
决定属性是否出现在对象的属性枚举中，具体来说，for-in循环、Object.keys方法、JSON.stringify方法是否会取到该属性

用户定义的普通属性默认是可枚举的，而原生继承的属性默认是不可枚举的
```js
//由于原生继承的属性默认不可枚举，所以只取得自定义的属性a:1
var o = {a:1};
for(var i in o){
    console.log(o[i]);//1
}
//由于enumerable被设置为false，在for-in循环中a属性无法被枚举出来
var o = {a:1};
Object.defineProperty(o,'a',{enumerable:false});
for(var i in o){
    console.log(o[i]);//undefined
}
```
propertyIsEnumerable()方法用于判断对象的属性是否可枚举
```js
var o = {a:1};
console.log(o.propertyIsEnumerable('a'));//true
Object.defineProperty(o,'a',{enumerable:false});
console.log(o.propertyIsEnumerable('a'));//false
```

###get和set
get是一个隐藏函数，在获取属性值时调用。set也是一个隐藏函数，在设置属性值时调用，它们的默认值都是undefined。
Object.definedProperty()中的get和set对应于对象字面量中get和set方法

[注意]getter和setter取代了数据属性中的value和writable属性

1. 给只设置get方法，没有设置set方法的对象赋值会静默失败，在严格模式下会报错
```js
var o = {
    get a(){
        return 2;
    }
}    
console.log(o.a);//2
//由于没有设置set方法，所以o.a=3的赋值语句会静默失败
o.a = 3;
console.log(o.a);//2
```
在严格模式下，给没有设置set方法的访问器属性赋值会报错
```js
'use strict';
var o = {
    get a(){
        return 2;
    }
}    
console.log(o.a);//2
//由于没有设置set方法，所以o.a=3的赋值语句会报错
//Uncaught TypeError: Cannot set property a of #<Object> which has only a getter
o.a = 3;
```

2.只设置set方法，而不设置get方法，则对象属性值为undefined
```js
var o = {
    set a(val){
        return 2;
    }
}    
o.a = 1;
console.log(o.a);//undefined
```

3.一般地，set和get方法是成对出现的
```js
var o ={
    get a(){
        return this._a;
    },
    set a(val){
        this._a = val*2;
    }
}
o.a = 1;
console.log(o.a);//2
```

##对象状态
属性描述符只能用来控制对象中一个属性的状态。而如果要控制对象的状态，就要用到下面的6种方法 

###Object.preventExtensions()(禁止扩展)
方法使一个对象无法再添加新的属性，并返回当前对象

###Object.isExtensible()(测试扩展)
方法用来检测该对象是否可以扩展

```js
var o = {a:1};
console.log(Object.isExtensible(o));//true
o.b = 2;
console.log(o);//{a: 1, b: 2}
console.log(Object.preventExtensions(o));//{a: 1, b: 2}
//由于对象o禁止扩展，所以该赋值语句静默失败
o.c = 3;
console.log(Object.isExtensible(o));//false
console.log(o);//{a: 1, b: 2}
```

在严格模式下，给禁止扩展的对象添加属性会报TypeError错误
```js
'use strict';
var o = {a:1};
console.log(Object.preventExtensions(o));//{a:1}
//Uncaught TypeError: Can't add property c, object is not extensible
o.c = 3;
```
Object.preventExtensions()方法并不改变对象中属性的描述符状态
```js
var o = {a:1};
//{value: 1, writable: true, enumerable: true, configurable: true}
console.log(Object.getOwnPropertyDescriptor(o,'a'));
Object.preventExtensions(o);
//{value: 1, writable: true, enumerable: true, configurable: true}
console.log(Object.getOwnPropertyDescriptor(o,'a'));
```

###Object.seal()(对象封印)
对象封印又叫对象密封，使一个对象不可扩展并且所有属性不可配置，并返回当前对象

###Object.isSealed()(测试封印)
检测该方法是否被封印
```js
var o = {a:1,b:2};
console.log(Object.isSealed(o));//false
console.log(Object.seal(o));//{a:1,b:2}
console.log(Object.isSealed(o));//true
console.log(delete o.b);//false
o.c = 3;
console.log(o);//{a:1,b:2}
```
在严格模式下，删除旧属性或添加新属性都会报错
```js
'use strict';
var o = {a:1,b:2};
console.log(Object.seal(o));//{a:1,b:2}
//Uncaught TypeError: Cannot delete property 'b' of #<Object>
delete o.b;
```
这个方法实际上会在现有对象上调用Object.preventExtensions()方法，并把所有现有属性的configurable描述符置为false
```js
var o = {a:1,b:2};
//{value: 1, writable: true, enumerable: true, configurable: true}
console.log(Object.getOwnPropertyDescriptor(o,'a'));
console.log(Object.seal(o));//{a:1,b:2}
//{value: 1, writable: true, enumerable: true, configurable: false}
console.log(Object.getOwnPropertyDescriptor(o,'a'));
```

###Object.freeze()(对象冻结)
使一个对象不可扩展，不可配置，也不可改写，变成一个仅可以枚举的只读常量，并返回当前对象

###Object.isFrozen()(检测冻结)
检测一个对象是否被冻结

```js
var o = {a:1,b:2};
console.log(Object.isFrozen(o));//false
console.log(Object.freeze(o));//{a:1,b:2}
console.log(Object.isFrozen(o));//true
o.a = 3;
console.log(o);//{a:1,b:2}
```
在严格模式下，删除旧属性、添加新属性、更改现有属性都会报错
```js
'use strict';
var o = {a:1,b:2};
console.log(Object.freeze(o));//{a:1,b:2}
//Uncaught TypeError: Cannot assign to read only property 'a' of object '#<Object>'
o.a = 3;
```
这个方法实际上会在现有对象上调用Object.seal()方法，并把所有现有属性的writable描述符置为false
```js
var o = {a:1};
//{value: 1, writable: true, enumerable: true, configurable: true}
console.log(Object.getOwnPropertyDescriptor(o,'a'));
console.log(Object.freeze(o));//{a:1}
//{value: 1, writable: false, enumerable: true, configurable: false}
console.log(Object.getOwnPropertyDescriptor(o,'a'));
```









---
#原型链 prototype
[JS原型与原型链终极详解](http://www.108js.com/article/article1/10201.html?id=1092)

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
```
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




