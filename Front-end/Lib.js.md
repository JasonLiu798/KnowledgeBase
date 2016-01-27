#lib

----
#encodeURI



---
#url
//获取当前网址，如： http://localhost:8080/Tmall/index.jsp
var curWwwPath=window.document.location.href;
//获取主机地址之后的目录如：/Tmall/index.jsp
var pathName=window.document.location.pathname;
var pos=curWwwPath.indexOf(pathName);
//获取主机地址，如： http://localhost:8080
var localhostPath=curWwwPath.substring(0,pos);
//获取带"/"的项目名，如：/Tmall
var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);

----
#ajax
[fetch](https://github.com/bitinn/node-fetch)
[superagent](https://github.com/visionmedia/superagent)

[request]()

---
#包管理
JavaScript 构建工具： Grunt , Gulp 和 Brocolli .
#bower
npm install -g bower
bower help
bower install jquery --save     #安装 --save write bower.json
bower update jquery             #更新
bower uninstall jquery          #卸载
bower info jquery               #查看信息
##.bowerrc
```
{
        "directory" : "js/lib"
}
```
##bower.json
```
{
  "name": "tools",
  "version": "0.0.1",
  "authors": [
    "jasonliu <jasondliu@qq.com>"
  ],
  "moduleType": [
    "amd"
  ],
  "license": "MIT",
  "ignore": [
    "**/.*",
    "node_modules",
    "bower_components",
    "js/lib",
    "test",
    "tests"
  ],
  "dependencies": {
    "bootstrap": "~3.3.6"
  }
}
```


#browserify
https://github.com/substack/node-browserify
browserify --x superagent input.js -o output.js

#Babel-兼容
[Babel-现在开始使用 ES6](http://www.tuicool.com/articles/biiyAfI)
npm install -g babel
babel -d lib/ src/
babel src --out-dir build
npm install --save-dev babel-loader




---
#图像处理
## 二维码
https://github.com/kazuhikoarase/qrcode-generator.git



---
#文字处理
## markdown parser
https://github.com/jgm/CommonMark.git

[websocket rfc6455](https://tools.ietf.org/html/rfc6455)


##editor
###tinyMCE
[插件 图片上传](https://github.com/vikdiesel/justboil.me)
---
#文件处理
##JS压缩
[Javaweb配置](http://www.blogjava.net/badqiu/archive/2007/08/01/85461.html)




-----
#Font
#字体渲染
[字体渲染](http://blog.jobbole.com/50061/)


---
#other



#面试题
https://github.com/paddingme/Front-end-Web-Development-Interview-Question
https://github.com/hawx1993/Front-end-Interview-questions
https://github.com/qiu-deqing/FE-interview
http://segmentfault.com/a/1190000002562454
















