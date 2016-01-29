#javascript
---
#docs
《浏览器体系结构》：浏览器就是我们前端应用运行的“虚拟机”，类比本科阶段计算机专业学习的《计算机组成原理》，其目的是帮助计算机本科学生掌握计算机基本体系结构，前端从业者学习浏览器体系结构是非常有助于掌握浏览器的“脾气”的；
《JavaScript引擎原理》：在《编译原理》的基础上，介绍现代浏览器的js引擎设计理念，这是一门理论与实践结合的课程，帮助学生掌握引擎工作原理，了解语言的内部机制；
《浏览器内核设计》：类比本科专业课的《操作系统》课程，介绍浏览器的排版和渲染算法，工作原理以及各个系统模块的调度机制。这也是一门理论和实验课程，学生的实验作业是实现一个简易的浏览器内核；
《CSS渲染原理》：在《浏览器内核设计》课程的基础上，深入学习CSS渲染原理，了解CSS的发展史，设计思想，渲染的规则树，盒模型的内核工作机制。
《HTTP协议》：在《网络工程》课程基础上，深入学习HTTP协议，1.0/1.1/2 等版本的发展史，HTTP协议的格式、RESTFul语义等，《HTTP权威指南》是不错的教材
《前端工程》：在《软件工程》课程基础上，学习前端有别于传统GUI软件的工程化部分，可能涉及到开发框架、设计模式、组织架构、系统测试、前端安全、统计监控、性能优化等；


---
#变量
#Number
NaN; // NaN表示Not a Number，当无法计算结果时用NaN表示
Infinity; // Infinity表示无限大，当数值超过了JavaScript的Number所能表示的最大值时，就表示为Infinity


==比较，它会自动转换数据类型再比较，很多时候，会得到非常诡异的结果；
===比较，它不会自动转换数据类型，如果数据类型不一致
null表示一个空的值，而undefined表示值未定义
undefined仅仅在判断函数参数是否传递的情况下有用

#string
substring
toUpperCase
toLowerCase

#集合
#map
{}可以视为其他语言中的Map或Dictionary的数据结构，即一组键值对
var m = new Map([['Michael', 95], ['Bob', 75], ['Tracy', 85]]);
#set
var s2 = new Set([1, 2, 3]);

##操作
sort
头部添加若干元素，使用unshift()方法，shift()方法则把Array的第一个元素删掉


#对象
访问属性是通过.操作符完成的，但这要求属性名必须是一个有效的变量名。如果属性名包含特殊字符，就必须用''括起来
访问这个属性也无法使用.操作符，必须用['xxx']来访问

#for in
for (var key in o) {
    alert(key); // 'name', 'age', 'city'
}
while

do ... while

---
#控制语句
#for of (es6支持)
for (var x of a) {
}

#foreach
ES5.1引入
```
var a = ['A', 'B', 'C'];
a.forEach(function (element, index, array) {
    // element: 指向当前元素的值
    // index: 指向当前索引
    // array: 指向Array对象本身
    alert(element);
});
//set
s.forEach(function (element, sameElement, set) {
    alert(element);
});
//map
m.forEach(function (value, key, map) {
    alert(value);
});
```


---
#函数
```
//M1
function abs(x) {
    if (x >= 0) {
        return x;
    } else {
        return -x;
    }
}
//M2
var abs = function (x) {
    if (x >= 0) {
        return x;
    } else {
        return -x;
    }
};
```
1.没有return语句，函数执行完毕后也会返回结果，只是结果为undefined。
2.M2方式下，function (x) { ... }是一个匿名函数，它没有函数名。但是，这个匿名函数赋值给了变量abs，所以，通过变量abs就可以调用该函数。
3.M1,M2上述两种定义完全等价，注意第二种方式按照完整语法需要在函数体末尾加一个;

arguments
它只在函数内部起作用，并且永远指向当前函数的调用者传入的所有参数。arguments类似Array但它不是一个Array

rest
参数只能写在最后，前面用...标识，从运行结果可知，传入的参数先绑定a、b，多余的参数以数组形式交给变量rest，所以，不再需要arguments我们就获取了全部参数。
function foo(a, b, ...rest) {
    console.log('a = ' + a);
    console.log('b = ' + b);
    console.log(rest);
}

return
JavaScript引擎在行末自动添加分号的机制
```
function foo() {
    return
        { name: 'foo' };
}
改为
function foo() {
    return { // 这里不会自动加分号，因为{表示语句尚未结束
        name: 'foo'
    };
}
```

#作用域
1.如果一个变量在函数体内部申明，则该变量的作用域为整个函数体，在函数体外不可引用该变量
2.内部函数可以访问外部函数定义的变量，反过来则不行
3.内部函数的变量将“屏蔽”外部函数的变量
4.变量提升
```
'use strict';
function foo() {
    var x = 'Hello, ' + y;
    alert(x);
    var y = 'Bob';
}
foo();
```
自动提升了变量y的声明，但不会提升变量y的赋值

##名字冲突
减少冲突的一个方法是把自己的所有变量和函数全部绑定到一个全局变量中

##常量
const与let都具有块级作用域：
const PI = 3.14;

##方法
绑定到对象上的函数称为方法，和普通函数也没啥区别，内部可用this
如果单独调用函数，比如getAge()，此时，该函数的this指向全局对象，也就是window。
strict模式下让函数的this指向undefined
```
'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};

xiaoming.age();
```

##apply
要指定函数的this指向哪个对象，可以用函数本身的apply方法，它接收两个参数，第一个参数就是需要绑定的this变量，第二个参数是Array，表示函数本身的参数
```
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25
getAge.apply(xiaoming, []); 
```

##装饰器，利用apply
var count = 0;
var oldParseInt = parseInt; // 保存原函数

window.parseInt = function () {
    count += 1;
    return oldParseInt.apply(null, arguments); // 调用原函数
};

// 测试:
parseInt('10');
parseInt('20');
parseInt('30');
count; // 3


##高阶函数
###map
function pow(x) {
    return x * x;
}

var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9];
arr.map(pow); // [1, 4, 9, 16, 25, 36, 49, 64, 81]

reduce
reduce()把一个函数作用在这个Array的[x1, x2, x3...]上，这个函数必须接收两个参数，reduce()把结果继续和序列的下一个元素做累积计算，其效果就是：

[x1, x2, x3, x4].reduce(f) = f(f(f(x1, x2), x3), x4)

###filter
var arr = [1, 2, 4, 5, 6, 9, 10, 15];
var r = arr.filter(function (x) {
    return x % 2 !== 0;
});
r; // [1, 5, 9, 15]

###sort
[10, 20, 1, 2].sort(); // [1, 10, 2, 20]
Array的sort()方法默认把所有元素先转换为String再排序
```
var arr = [10, 20, 1, 2];
arr.sort(function (x, y) {
    if (x < y) {
        return -1;
    }
    if (x > y) {
        return 1;
    }
    return 0;
});
```

---
#闭包
```
function lazy_sum(arr) {
    var sum = function () {
        return arr.reduce(function (x, y) {
            return x + y;
        });
    }
    return sum;
}
```
注意到返回的函数在其定义内部引用了局部变量arr，所以，当一个函数返回了一个函数后，其内部的局部变量还被新函数引用，所以，闭包用起来简单，实现起来可不容易。
另一个需要注意的问题是，返回的函数并没有立刻执行，而是直到调用了f()才执行

返回函数不要引用任何循环变量，或者后续会发生变化的变量。

function count() {
    var arr = [];
    for (var i=1; i<=3; i++) {
        arr.push((function (n) {
            return function () {
                return n * n;
            }
        })(i));
    }
    return arr;
}

创建一个匿名函数并立刻执行”的语法：
(function (x) {
    return x * x;
})(3); // 9

闭包实现私有变量
```
function create_counter(initial) {
    var x = initial || 0;
    return {
        inc: function () {
            x += 1;
            return x;
        }
    }
}
//它用起来像这样：
var c1 = create_counter();
c1.inc(); // 1
c1.inc(); // 2
c1.inc(); // 3
```

##箭头函数 ES6
var fn = x => x * x;
x => {
    if (x > 0) {
        return x * x;
    }
    else {
        return - x * x;
    }
}

箭头函数和匿名函数有个明显的区别：箭头函数内部的this是词法作用域，由上下文确定

##generator ES6
function* fib(max) {
    var
        t,
        a = 0,
        b = 1,
        n = 1;
    while (n < max) {
        yield a;
        t = a + b;
        a = b;
        b = t;
        n ++;
    }
    return a;
}
var f = fib(5);
f.next(); // {value: 0, done: false}
f.next(); // {value: 1, done: false}
f.next(); // {value: 1, done: false}

try {
    r1 = yield ajax('http://url-1', data1);
    r2 = yield ajax('http://url-2', data2);
    r3 = yield ajax('http://url-3', data3);
    success(r3);
}
catch (err) {
    handle(err);
}

---
#标准对象
typeof 123; // 'number'
typeof NaN; // 'number'
typeof 'str'; // 'string'
typeof true; // 'boolean'
typeof undefined; // 'undefined'
typeof Math.abs; // 'function'
typeof null; // 'object'
typeof []; // 'object'
typeof {}; // 'object'

不要使用new Number()、new Boolean()、new String()创建包装对象；
用parseInt()或parseFloat()来转换任意类型到number；
用String()来转换任意类型到string，或者直接调用某个对象的toString()方法；
通常不必把任意类型转换为boolean再判断，因为可以直接写if (myVar) {...}；
typeof操作符可以判断出number、boolean、string、function和undefined；
判断Array要使用Array.isArray(arr)；
判断null请使用myVar === null；
判断某个全局变量是否存在用typeof window.myVar === 'undefined'；
函数内部判断某个变量是否存在用typeof myVar === 'undefined'。

##date
var d = new Date(2015, 5, 19, 20, 15, 30, 123);
d; // Fri Jun 19 2015 20:15:30 GMT+0800 (CST)
你可能观察到了一个非常非常坑爹的地方，就是JavaScript的月份范围用整数表示是0~11，0表示一月，1表示二月

var d = new Date(1435146562875);
d.toLocaleString(); // '2015/6/24 下午7:49:22'，本地时间（北京时区+8:00），显示的字符串与操作系统设定的格式有关
d.toUTCString(); // 'Wed, 24 Jun 2015 11:49:22 GMT'，UTC时间，与本地时间相差8小时



----
#原型
arr ----> Array.prototype ----> Object.prototype ----> null
Array.prototype定义了indexOf()、shift()等方法，因此你可以在所有的Array对象上直接调用这些方法。
foo ----> Function.prototype ----> Object.prototype ----> null

继承
```
// PrimaryStudent构造函数:
function PrimaryStudent(props) {
    Student.call(this, props);
    this.grade = props.grade || 1;
}
// 空函数F:
function F() {
}
// 把F的原型指向Student.prototype:
F.prototype = Student.prototype;
// 把PrimaryStudent的原型指向一个新的F对象，F对象的原型正好指向Student.prototype:
PrimaryStudent.prototype = new F();
// 把PrimaryStudent原型的构造函数修复为PrimaryStudent:
PrimaryStudent.prototype.constructor = PrimaryStudent;
// 继续在PrimaryStudent原型（就是new F()对象）上定义方法：
PrimaryStudent.prototype.getGrade = function () {
    return this.grade;
};
// 创建xiaoming:
var xiaoming = new PrimaryStudent({
    name: '小明',
    grade: 2
});
xiaoming.name; // '小明'
xiaoming.grade; // 2
// 验证原型:
xiaoming.__proto__ === PrimaryStudent.prototype; // true
xiaoming.__proto__.__proto__ === Student.prototype; // true
// 验证继承关系:
xiaoming instanceof PrimaryStudent; // true
xiaoming instanceof Student; // true
```















#js虚拟机
[虚拟机随谈（一）：解释器，树遍历解释器，基于栈与基于寄存器，大杂烩](http://rednaxelafx.iteye.com/blog/492667)




#use strict
[Javascript 严格模式详解](http://www.ruanyifeng.com/blog/2013/01/javascript_strict_mode.html)
标记 严格模式后
其一：如果在语法检测时发现语法问题，则整个代码块失效，并导致一个语法异常。
其二：如果在运行期出现了违反严格模式的代码，则抛出执行异常。
注：经过测试IE6,7,8,9均不支持严格模式。

缺点：
现在网站的JS 都会进行压缩，一些文件用了严格模式，而另一些没有。这时这些本来是严格模式的文件，被 merge 后，这个串就到了文件的中间，不仅没有指示严格模式，反而在压缩后浪费了字节。













#异步调用

Promise 库

[ES6 JavaScript Promise的感性认知](http://www.zhangxinxu.com/wordpress/2014/02/es6-javascript-promise-%E6%84%9F%E6%80%A7%E8%AE%A4%E7%9F%A5/)


https://github.com/then/promise.git
npm install promise
<script src="https://www.promisejs.org/polyfills/promise-6.1.0.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/es5-shim/3.4.0/es5-shim.min.js"></script>
var Promise = require('promise');
var promise = new Promise(function (resolve, reject) {
  get('http://www.google.com', function (err, res) {
    if (err) reject(err);
    else resolve(res);
  });
});


#内存管理
javascript heap profiler

[JavaScript 应用程序中的内存泄漏](http://www.ibm.com/developerworks/cn/web/wa-jsmemory/)

[js的闭包和回调到底怎么才会造成真的内存泄漏呢？](http://segmentfault.com/q/1010000000414875)

#class
[ES6 class讨论](http://www.zhihu.com/question/34568340)



#DWR
[在 Spring Web MVC 环境下使用 DWR](http://www.ibm.com/developerworks/cn/java/j-lo-springdwr/)



---
#跨域共享
JSONP，CORS，HTTP 协议，浏览器安全机制，PreFlight Request，反向代理



---
#JS模板引擎
[五款流行的JavaScript模板引擎](http://www.csdn.net/article/2013-09-16/2816951-top-five-javascript-templating-engines)
jade
HandlebarsJS
[HandlebarsJS 教程](http://www.cnblogs.com/iyangyuan/archive/2013/12/12/3471227.html)
Embedded JS Templates
Underscore Templates
Mustache

sodaRender

xtmpleate, juicer

dust(linkin)


---
#other
grunt gulp
Sass 


