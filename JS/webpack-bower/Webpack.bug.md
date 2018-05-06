


# 升级
"webpack": "^4.4.1" bug
[Webpack 3.X - 4.X 升级记录](https://blog.csdn.net/qq_16559905/article/details/79404173)
## mainTemplate.applyPluginsWaterfall is not a function
yarn add webpack-contrib/html-webpack-plugin -D
简单来说就是使用webpack官方维护的html-webpack-plugin来代替第三方的。


        var outputName = compilation.mainTemplate.applyPluginsWaterfall('asset-path', outputOptions.filename, {
          hash: childCompilation.hash,
          chunk: entries[0]
        });

## babel问题
npm install -D babel-loader
npm install -D babel-core
npm install -D babel-preset-env





