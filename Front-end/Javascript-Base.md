#javascript
---
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


