#blog
----
# 常用
## 生成
hugo --theme=hyde --baseUrl="http://JasonLiu798.github.io"
## 调试
hugo server --theme=hyde --buildDrafts --watch
hugo server --theme=hyde --buildDrafts


#hugo
##setup
golang
https://gohugo.io/
http://blog.coderzh.com/2015/08/29/hugo/

##新建
* 新建站点
```
hugo new site path/to/site
```

* 新建博文
进入目录
```
hugo new xxxpost.md
```
标准格式
```
+++
title = "文章标题"
tags = ["标签1", "标签2"]
categories = ["分类1","分类2"]
date        = "2015-01-01"
+++

正文，你好 Hugo ！

```

##配置
config.toml
```
# 基本信息
baseurl = "http://ihuangmx.github.io"
languageCode = "en-us"
title = "Never But Life"
theme ="hugo-multi-bootswatch"

[params]

github = "https://github.com/ihuangmx"

[params.strings]

    # 导航标题
    home_navbar_link = "首页"
    blog_navbar_link = "文章"

    date_format = '2006.01.02'
    posts_list_header = "文章列表"

[params.theme]

    inverse = true
    name = "flatly"
```

##themes
git clone --depth 1 --recursive https://github.com/spf13/hugoThemes.git themes

##运行
```
hugo server --theme=hyde --buildDrafts --watch
hugo server --theme=hyde --buildDrafts
```
--theme 用于选择主题，如果在配置文件中选择了主题，这里就不需要使用了
--buildDrafts 用于是否显示草稿文章
--watch 用于实时监控变化，方便调试

##deploy 部署
hugo --theme=hyde --baseUrl="http://JasonLiu798.github.io"
应当通过命令来生成 public 目录，然后将 public 部署到服务器，如果原来存在 public 目录，记得先删除。

如果一切顺利，所有静态页面都会生成到 public 目录，将pubilc目录里所有文件 push 到刚创建的Repository的 master 分支

##添加about
编辑 /themes/hugo-multi-bootswatch/layouts/partials/navbar.html 文件，在适当位置添加 About 链接：
```
<li><a href="{{ .Site.BaseURL }}/page/about">{{ if .Site.Params.strings.about_navbar_link }}{{ .Site.Params.strings.about_navbar_link }}{{ else }}About{{ end }}</a></li>
```
在 config.toml 文件中进行配置:
about_navbar_link = "关于我"

##添加不同的文章导航
```
 <li><a href="{{ .Site.BaseURL }}/life/">{{ if .Site.Params.strings.life_navbar_link }}{{ .Site.Params.strings.life_navbar_link }}{{ else }}Life{{ end }}</a></li>
```
接着，我们将 /themes/hugo-multi-bootswatch/layouts/post/single.html 文件移动到 /themes/hugo-multi-bootswatch/layouts/_default/single.html。这样，显示 post 或者 life 下的某篇文章时，都会默认调用 _default 下的 single.html 文件。
最后，创建一篇文章，看看是否正常:

##添加评论系统
首先，创建 /themes/hugo-multi-bootswatch/layouts/partials/duoshuo.html 文件
```
<section id="comments" class="themeform">
<div class="ds-thread" data-thread-key="{{ .RelPermalink }}" data-title="{{ .Title }}" data-url="{{ .Permalink }}"></div>
<script type="text/javascript">
var duoshuoQuery = {short_name:"Zen"};
    (function() {
        var ds = document.createElement('script');
        ds.type = 'text/javascript';ds.async = true;
        ds.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') + '//static.duoshuo.com/embed.js';
        ds.charset = 'UTF-8';
        (document.getElementsByTagName('head')[0] 
         || document.getElementsByTagName('body')[0]).appendChild(ds);
    })();
</script>
</section>
```
然后，在 /themes/hugo-multi-bootswatch/layouts/_default/single.html中添加
```
    <div class="row">
        <div class="col-md-12">
            <hr>
        </div>
    </div>
    {{ partial "duoshuo.html" . }}  // 添加内容
</div>
```

##为代码添加高亮功能
默认的代码显示是没有高亮功能的，可以使用 highlight 来完成，在 /themes/hugo-multi-bootswatch/layouts/partials/header.html 里面添加这几行即可：
```
<script src="http://cdn.bootcss.com/highlight.js/9.0.0/highlight.min.js"></script>
<link href="http://cdn.bootcss.com/highlight.js/9.0.0/styles/default.min.css" rel="stylesheet">
<script>hljs.initHighlightingOnLoad();</script>
```
为了方便辨识，可以在 开头的 ``` 后面添加相应的程序语言。

##自动生成目录
对于创建好的文章，可以让其自动生成目录，这里使用的是ztree_toc。首先，下载该项目，将里面的 zTreeStyle.css 文件拷贝到 static/css 目录下，将 jquery.ztree.core-3.5.min.js 和 ztree_toc.js 文件拷贝到 static/js 目录下。然后，简单的重写

/themes/hugo-multi-bootswatch/layouts/_default/single.html 页面
```
{{ partial "header.html" . }}

<div>
    <div class="container col-md-9 ">
        <div class="row">
            <div class="col-md-offset-1 col-md-10">
                <h3>{{ .Title }}</h3>
                    <span class="label label-primary">{{ if .Site.Params.strings.date_format }}{{ .Date.Format .Site.Params.strings.date_format }}{{ else }}{{ .Date.Format "Mon, Jan 2, 2006" }}{{ end }}</span> in 
                    {{ range $i, $e :=.Params.categories }}
                        {{if $i}} , {{end}}
                        <a href="/categories/{{ . | urlize }}">{{ . }}</a>
                    {{ end }} using tags
                    {{ range $i, $e :=.Params.tags }}
                        {{if $i}} , {{end}}
                        <a href="/tags/{{ . | urlize }}">{{ . }}</a>
                    {{ end }}
                </small>
            </div>
        </div>
        <div class="row">
            <div class="col-md-offset-1 col-md-10">
                <br>
                {{ .Content }}
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <hr>
            </div>
        </div>
        {{ partial "duoshuo.html" . }}
    </div>
    <div class="col-md-3 panel panel-success">
         <ul id="tree" class="ztree" style="list-style-type:none"></ul>
    </div>

</div>

<link rel="stylesheet" href="{{ .Site.BaseURL }}/css/zTreeStyle.css" type="text/css">
<script src="{{ .Site.BaseURL }}/js/jquery.ztree.core-3.5.min.js"></script>
<script src="{{ .Site.BaseURL }}/js/ztree_toc.js"></script>
<script>

$(document).ready(function(){
    $('#tree').ztree_toc({
        is_posion_top:false,
        is_expand_all: true
    });
});

</script>
{{ partial "footer.html" . }}
```
为了让页面显示不冲突，需要去掉 ztree_toc.js 里面的这几行
```
ztreeStyle: {
    // width:'260px',
    // overflow: 'auto',
    // position: 'fixed',
    // 'z-index': 2147483647,
    // border: '0px none',
    // left: '0px',
    // bottom: '0px',
    // height:'100px'
},
```

##替换字体库
默认的字体库采用 Google 的，可以替换成 360 的，搜索所有的 https://fonts.googleapis.com ，替换成 http://fonts.useso.com，然后保存对应文件。

##其他命令
hugo help



---
#octopress
http://sonnewilling.com/blog/2013/11/14/shi-yong-octopressda-jian-ge-ren-bo-ke/
