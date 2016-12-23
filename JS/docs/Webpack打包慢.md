#彻底解决Webpack打包慢的问题
---
[原文地址](https://segmentfault.com/a/1190000006087638?utm_source=weekly&utm_medium=email&utm_campaign=email_weekly)

这几天写腾讯实习生 Mini 项目的时候用上了 React 全家桶，当然同时引入了 Webpack 作为打包工具。但是开发过程中遇到一个很棘手的问题就是，React 加上 React-Router、superagent、eventproxy 这些第三方轮子一共有好几百个 module，Webpack 的打包速度极慢。这对于开发是非常不好的体验，同时效率也极低。

#问题分析
我们先来看一下完全没有任何优化的时候，Webpack 的打包速度（使用了jsx和babel的loader）。下面是我们的测试文件：
```
//test.js
var react = require('react');
var ReactAddonsCssTransitionGroup = require('react-addons-css-transition-group');
var reactDOM = require('react-dom');
var reactRouter = require('react-router');
var superagent = require("superagent");
var eventproxy = require("eventproxy");
```
运行
```
webpack test.js
```
在我的2015款RMBP13，i5处理器，全SSD下，性能是这样的：
没错你没有看错，这几个第三方轮子加起来有整整668个模块，全部打包需要20多秒。

这意味着什么呢？你每次对业务代码的修改，gulp 或者 Webpack 监测到后都会重新打包，你要足足等20秒才能看到自己的修改结果

但是需要重新打包的只有你的业务代码，这些第三方库是完全不用重新打包的，它们的存在只会拖累打包性能。所以我们要找一些方法来优化这个过程。

#配置externals
Webpack 可以配置 externals 来将依赖的库指向全局变量，从而不再打包这个库，比如对于这样一个文件：
```
import React from 'react';
console.log(React);
```
如果你在 Webpack.config.js 中配置了externals：
```
module.exports = {
    externals: {
        'react': 'window.React'
    }
    //其它配置忽略...... 
};
```
等于让 Webpack 知道，对于 react 这个模块就不要打包啦，直接指向 window.React 就好。不过别忘了加载 react.min.js，让全局中有 React 这个变量。

我们来看看性能，因为不用打包 React 了所以速度自然超级快，包也很小：


#配置externals的缺陷
问题如果就这么简单地解决了的话，那我就没必要写这篇文章了，下面我们加一个 react 的动画库 react-addons-css-transition-group 来试一试：
```
import React from 'react';
import ReactAddonsCssTransitionGroup from 'react-addons-css-transition-group';
console.log(React);
```

对，你没有看错，我也没有截错图，新加了一个很小很小的动画库之后，性能又爆炸了。从模块数来看，一定是 Webpack 又把 react 重新打包了一遍。

我们来看一下为什么一个很小很小的动画库会导致 Webpack 又傻傻地把 react 重新打包了一遍。找到 react-addons-css-transition-group 这个模块，然后看看它是怎么写的：
```
// react-addons-css-transition-group模块
// 入口文件 index.js
module.exports = require('react/lib/ReactCSSTransitionGroup');
```
这个动画模块就只有一行代码，唯一的作用就是指向 react 下面的一个子模块，我们再来看看这个子模块是怎么写的：
```
// react模块
// react/lib/ReactCSSTransitionGroup.js
var React = require('./React');
var ReactTransitionGroup = require('./ReactTransitionGroup');
var ReactCSSTransitionGroupChild = require('./ReactCSSTransitionGroupChild');
//....剩余代码忽略
```
这个子模块又反回去依赖了 react 整个库的入口，这就是拖累 Webpack 的罪魁祸首。

总而言之，问题是这样产生的：

Webpack 发现我们依赖了 react-addons-css-transition-group
Webpack 去打包 react-addons-css-transition-group 的时候发现它依赖了 react 模块下的一个叫 ReactTransitionGroup.js 的文件，于是 Webpack 去打包这个文件。
ReactTransitionGroup.js 依赖了整个 react 的入口文件 React.js，虽然我们设置了 externals ，但是 Webpack 不知道这个入口文件等效于 react 模块本身，于是我们可爱又敬业的 Webpack 就把整个 react 又重新打包了一遍。
读到这里你可能会有疑问，为什么不能把这个动画库也设置到 externals 里，这样不是就不用打包了吗？

问题就在于，这个动画库并没有提供生产环境的文件，或者说这个库根本没有提供 react-addons-css-transition-group.min.js 这个文件。

这个问题不只存在于 react-addons-css-transition-group 中，对于 react 的大多数现有库来说都有这个依赖关系复杂的问题。

---
#初级解决方法
所以对于这个问题的解决方法就是，手工打包这些 module，然后设置 externals ，让 Webpack 不再打包它们。

我们需要这样一个 lib-bundle.js 文件：
window.__LIB["react"] = require("react");
window.__LIB["react-addons-css-transition-group"] = require("react-addons-css-transition-group");
// ...其它依赖包
我们在这里把一些第三方库注册到了 window.__LIB 下，这些库可以作为底层的基础库，免于重复打包。

然后执行 webpack lib-bundle.js lib.js，得到打包好的 lib.js。然后去设置我们的 externals ：
```
var webpack = require('webpack');
module.exports = {
    externals: {
        'react': 'window.__LIB["react"]',
        'react-addons-css-transition-group': 'window.__LIB["react-addons-css-transition-group"]',
        // 其它库
    }
    //其它配置忽略...... 
};
```
这时由于 externals 的存在，Webpack 打包的时候就会避开这些模块超多，依赖关系复杂的库，把这些第三方 module 的入口指向预先打包好的 lib.js 的入口 window.__LIB，从而只打包我们的业务代码。

#终极解决方法
上面我们提到的方法本质上就是一种动态链接库（dll）”的思想，这在 windows 系统下面是一种很常见的思想。一个dll包，就是一个很纯净的依赖库，它本身不能运行，是用来给你的 app 或者业务代码引用的。

同样的 Webpack 最近也新加入了这个功能：webpack.DllPlugin。使用这个功能需要把打包过程分成两步：

* 打包ddl包
* 引用ddl包，打包业务代码
首先我们来打包ddl包，首先配置一个这样的 ddl.config.js：
```
const webpack = require('webpack');

const vendors = [
    'react',
    'react-dom',
    'react-router',
    // ...其它库
];

module.exports = {
    output: {
        path: 'build',
        filename: '[name].js',
        library: '[name]',
    },
    entry: {
        "lib": vendors,
    },
    plugins: [
        new webpack.DllPlugin({
            path: 'manifest.json',
            name: '[name]',
            context: __dirname,
        }),
    ],
};
```

```bash
webpack --config ddl.config.js
```

webpack.DllPlugin 的选项中：

path 是 manifest.json 文件的输出路径，这个文件会用于后续的业务代码打包；
name 是dll暴露的对象名，要跟 output.library 保持一致；
context 是解析包路径的上下文，这个要跟接下来配置的 webpack.config.js 一致。
运行Webpack，会输出两个文件一个是打包好的 lib.js，一个就是 manifest.json，它里面的内容大概是这样的：
```
{
    "name": "vendor_ac51ba426d4f259b8b18",
    "content": {
        "./node_modules/react/react.js": 1,
        "./node_modules/react/lib/React.js": 2,
        "./node_modules/react/node_modules/object-assign/index.js": 3,
        "./node_modules/react/lib/ReactChildren.js": 4,
        "./node_modules/react/lib/PooledClass.js": 5,
        "./node_modules/react/lib/reactProdInvariant.js": 6,
        // ............
    }
}
```

接下来我们就可以快乐地打包业务代码啦，首先写好打包配置文件 webpack.config.js：
```
const webpack = require('webpack');
module.exports = {
    output: {
        path: 'build',
        filename: '[name].js',
    },
    entry: {
        app: './src/index.js',
    },
    plugins: [
        new webpack.DllReferencePlugin({
            context: __dirname,
            manifest: require('./manifest.json'),
        }),
    ],
};
```
webpack.DllReferencePlugin 的选项中：

context 需要跟之前保持一致，这个用来指导 Webpack 匹配 manifest 中库的路径；
manifest 用来引入刚才输出的 manifest.json 文件。
DllPlugin 本质上的做法和我们手动分离这些第三方库是一样的，但是对于包极多的应用来说，自动化明显加快了生产效率。
