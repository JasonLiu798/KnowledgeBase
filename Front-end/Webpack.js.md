#webpack
---
#docs
https://github.com/webpack/webpack
npm install -g webpack
[](http://itindex.net/detail/53450-react-webpack)
---
打包工具
npm install --save-dev gulp-webpack
webpack --config webpack.config.js
修改了组件源码之后，不刷新页面就能把修改同步到页面上
这里需要用到两个库 webpack-dev-server和 react-hot-loader
npm install --save-dev webpack-dev-server react-hot-loader



---
#cmd
webpack – for building once for development
webpack -p – for building once for production (minification)
webpack --watch – for continuous incremental build
webpack -d – to include source maps
webpack --colors – for making things pretty


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
[style-loader](https://www.npmjs.com/package/style-loader)
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
#plugin
[如何写一个webpack插件（一）](https://github.com/lcxfs1991/blog/issues/1)














