#lib

----
#encodeURI


判断图片加载
http://www.frontopen.com/2614.html


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
fckeditor,ckeditor,
kindeditor tinymce, ewebEditor 。。。
jqurey比较好的在线编辑器插件也可以
tumblr 用的是tinymce
开源在线编辑器推荐
1.TinyMCE
简介：一款非常小巧和精致的在线编辑器，第一个推荐它是应为Wordpresss的默认编辑器就是它。正式非常的喜欢这个在线编辑器。
地址：http://tinymce.moxiecode.com/
2.CKEditor
简介：很多人不知道CKEdotor是什么，其实CKEditor其实就是原先的FCKEditor，CKEdotor强大的功能不得不让你折服，但是他的强大也会对一些用户感觉繁琐。功能虽然强大、插件众多，但代码量和占用的客户端的资源也是巨大的。在现在中国的网络情况下，不太适合。不过有人做了精简版。
官方地址：http://ckeditor.com/
精简版地址：http://www.sablog.net/blog/archives/457/
3.YUI Editor
简介：来自雅虎的在线编辑器，对于YUI不是很了解，所以也未曾使用过。不过对于Yahoo的作品，不能不推荐。
地址：http://developer.yahoo.com/yui/editor/
附由阿里巴巴团队翻译的YUI中文文档：http://code.google.com/p/yui-doc-zh/
4.NicEdit
简介：一款洁面很像FCKeditor的编辑器，但是却非常的小巧。还是要推荐一下的。
地址：http://nicedit.com/
5.KindEditor
简介：国内开发的一款在线编辑器。功能叶很不错，支持。
地址：http://www.kindsoft.net/index.php
6.xheditor
简介：xhEditor是一个基于jQuery开发的简单迷你并且高效的可视化XHTML编辑器。个人非常的推崇。
地址：http://code.google.com/p/xheditor/
7.淘宝开源编辑器Kissy
简介：基于YUI创建，感觉很不错。
地址：http://kissy.googlecode.com/svn/trunk/src/editor/demo/basic.html
8.SinaEditor
简介：浪编辑器应该算是最贴近网友体验的编辑器，简洁、大方，并且使用方便、功能强大。
下载地址：http://www.box.net/shared/ng1hsamkd6
9.bespin
简介：Bespin 是由 Mozilla Labs 所推出的一个新项目，该项目旨在构建基于 Web 的代码编辑工具，支持HTML5。Bespin 具有的一些亮点包括：支持语法高亮显示、能够实时协作编辑、集成类似 vi/Emacs 的命令行、高效的文件浏览器、可扩展、跨平台等。
地址：https://bespin.mozilla.com/


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
#图片
[裁剪插件](http://www.open-open.com/ajax/ImageCropper.htm)
http://deepliquid.com/content/Jcrop_Download.html
中文API http://www.tuquu.com/Tutorial/wd1903.html

图片上传
ajaxuploadfile.js bug分析
http://www.360doc.com/content/14/0208/15/7566064_350731886.shtml


---
#other


##超链接不跳转
在web页面开发时，我们经常会遇到下列情况：
1.一个标签仅仅是要触发onclick行为；
2.表现上要有鼠标的pointer指针显示,或者其他类似a标签的视觉效果。
比如执行删除操作时，为了避免误操作，我们要弹出对话框让用户确定是否删除。因此我们经常会用链接<a></a>形式代替<button> 触发onclick事件。
代码如下：
```html
    <script type="text/javascript">
          function del(){
               if(confirm("确定删除该记录？")){
                   parent.window.location="执行删除.jsp";
                  return true;
               }
           return false;
            }
    </script>
    <a href=""  target="mainFrame" class="STYLE4" onclick="del()" >删除</a>
```
这样做的后果是js代码会跳转到"执行删除.jsp"页面，而<a>标签也会跳转打开一个空页面。因为html本身对 <a>标签的href属性做了处理，所以就会先执行我们自己定义的方法，接着再运行它自身的方法（跳转的方法）。

解决方法主要有四种，如下：
1. 不用a标签,设定css或用js来表现（有点复杂）；
2. 用a标签,onclick属性或onclick事件中返回false；(个人喜欢)
    如：<a href=""  target="mainFrame" class="STYLE4" onclick="del();return false" >删除</a>
    这是个执行顺序的问题，<a>这个标签的执行顺序应该是先执行onclick    的脚本，最后才进行href参数指定页面的跳转。在onclick中返回false，就可以中止<a>标签的工作流程，也就是不让页面跳转到href参数指定的页面。
3. 用href="javascript:void(0)"这种伪协议；（这种伪协议，少写的好）
    即：<a href="javascript:void(0)"  target="mainFrame" class="STYLE4" onclick="del()" >删除</a>
4. <a href="#"  class="STYLE4" onclick="del()" >删除</a>。



#面试题
https://github.com/paddingme/Front-end-Web-Development-Interview-Question
https://github.com/hawx1993/Front-end-Interview-questions
https://github.com/qiu-deqing/FE-interview
http://segmentfault.com/a/1190000002562454


[百度 Baidu FEX team](https://github.com/fex-team)
第一阶段： 规范与设计
开发规范约定
组件分拆方案
第二阶段： 技术选型
前端组件化框架（seajs, requirejs, ...）
选择前端基础库（jquery, tangram, ...）
选择模板语言（php, smarty, ...）
选择模板插件（xss修复）
第三阶段： 自动化与拆分
选择或开发自动化工具（打包，压缩，校验）
将系统拆分为几个子系统，以便大团队并行开发
适当调整框架以适应工具产出
第四阶段： 性能优化
小心剔除已下线的功能
优化http请求
适当调整自动化工具以适应性能优化
使用架构级优化方案：BigPipe、BigRender等

















