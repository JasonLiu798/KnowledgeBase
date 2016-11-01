#webpack
---
#docs
https://github.com/webpack/webpack
npm install -g webpack
[](http://itindex.net/detail/53450-react-webpack)
[webpack-demos](https://github.com/ruanyf/webpack-demos)
[webpack-seed](https://github.com/Array-Huang/webpack-seed)


---
#打包工具
npm install --save-dev gulp-webpack
webpack --config webpack.config.js
修改了组件源码之后，不刷新页面就能把修改同步到页面上
这里需要用到两个库 webpack-dev-server和 react-hot-loader
npm install --save-dev webpack-dev-server react-hot-loader



---
#cmd
##常用
webpack --display-error-details --progress --colors
webpack --display-error-details --progress --colors --config .\ddl.config.js


##-d 开发模式，附加source maps

##A PRETTIER OUTPUT
webpack --progress --colors

##--watch 模式
webpack --progress --colors --watch

##--display-error-details
推荐加上的，方便出错时能查阅更详尽的信息（比如 webpack 寻找模块的过程），从而更好定位到问题

##--config 指定config文件
webpack --config XXX.js 

##-p 压缩混淆脚本 
for building once for production (minification)
webpack -p 

##生成map映射文件，告知哪些模块被最终打包到哪里了
webpack -d
其中的 -p 是很重要的参数，曾经一个未压缩的 700kb 的文件，压缩后直接降到 180kb （主要是样式这块一句就独占一行脚本，导致未压缩脚本变得很大） 。






---
#全局引入
new webpack.ProvidePlugin({
$: "jquery",
    jQuery: "jquery",
    "window.jQuery": "jquery"
}),

##jquery插件问题
jQuery在 html 中引入，然后在 webpack 中把它配置为全局
```
externals: {
    jquery: 'window.$'
},
```
require webpack 不会它打包进来
var $ = require('jquery');
$ 已经被设置为全局了，那么挂载在它下面的一系列 jQuery 插件 在 html 中引入
```
<script type="text/javascript" src="./src/lib/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="./src/lib/jquery.nail.min.js"></script>
```
js 中引入 jquery 使用
```
var $ = require('jquery');
$('#nav').nail();
```
最后就是打包普通的第三方插件了。
有两种方案，一种是直接用 webpack 打包到引用到插件的 js 里去，这种不用多说，直接引入就行
另一种则是像 jQuery 一样设置为全局变量，同样的方式引入与使用
externals: {
    artTemplate: 'window.template'
},

webpack 没有 requirejs 的那种引入了第三方插件然后可以忽略打包的功能。所以我对于第三方的插件的做法就是以前该怎么引入就怎么引入，在 webpack 中设置一个全局即可





----
#use babel-loader
babel-preset-es2015
babel-preset-react
```
module.exports = {
  entry: './main.jsx',
  output: {
    filename: 'bundle.js'
  },
  module: {
    loaders:[
      {
        test: /\.js[x]?$/,
        exclude: /node_modules/,
        loader: 'babel-loader?presets[]=es2015&presets[]=react',
      },
    ]
  }
};

module: {
  loaders: [
    {
      test: /\.jsx?$/,
      exclude: /node_modules/,
      loader: 'babel',
      query: {
        presets: ['es2015', 'react']
      }
    }
  ]
}

```

---
#css
npm install style-loader
npm install css-loader --save-dev
[style-loader](https://www.npmjs.com/package/style-loader)
insert Style tag into HTML page
```
require('./app.css');

file:app.css
body {
  background-color: blue;
}

    loaders:[
      { test: /\.css$/, loader: 'style-loader!css-loader' },
    ]

#loader css moudle
    loaders:[
      { test: /\.js[x]?$/, exclude: /node_modules/, loader: 'babel-loader?presets[]=es2015&presets[]=react' },
      { test: /\.css$/, loader: 'style-loader!css-loader?modules' }
    ]
```

[css-loader](https://www.npmjs.com/package/css-loader)
read CSS file



---
#img
url-loader transforms image files. 
If the image size is smaller than 8192 bytes, it will be transformed into Data URL; 
otherwise,it will be transformed into normal URL. 
As you see, question mark(?) is be used to pass parameters into loaders.
```
var img1 = document.createElement("img");
img1.src = require("./small.png");
document.body.appendChild(img1);

    loaders:[
      { test: /\.(png|jpg)$/, loader: 'url-loader?limit=8192'}
    ]
```


---
#代码混淆
webpack.config.js
var webpack = require('webpack');
var uglifyJsPlugin = webpack.optimize.UglifyJsPlugin;
module.exports = {
  entry: './main.js',
  output: {
    filename: 'bundle.js'
  },
  plugins: [
    new uglifyJsPlugin({
      compress: {
        warnings: false
      }
    })
  ]
};



---
#plugin
[如何写一个webpack插件（一）](https://github.com/lcxfs1991/blog/issues/1)





---
#自动编译
webpack-dev-server


---
#dll 痛点-打包慢
[彻底解决Webpack打包慢的问题](./docs/Webpack打包慢.md)
##打包ddl包
配置一个这样的 ddl.config.js：
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
path 是 manifest.json 文件的输出路径，这个文件会用于后续的业务代码打包；
name 是dll暴露的对象名，要跟 output.library 保持一致；
context 是解析包路径的上下文，这个要跟接下来配置的 webpack.config.js 一致。

##引用ddl包，打包业务代码
webpack.config.js：
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
context 需要跟之前保持一致，这个用来指导 Webpack 匹配 manifest 中库的路径；
manifest 用来引入刚才输出的 manifest.json 文件。

##bootstrap
https://github.com/ga-wdi-boston/game-project/issues/18





