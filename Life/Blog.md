#hugo
golang
https://gohugo.io/
http://blog.coderzh.com/2015/08/29/hugo/

```
hugo new site path/to/site
```

新建博文：进入目录
```
hugo new xxxpost.md
```

##themes
git clone --depth 1 --recursive https://github.com/spf13/hugoThemes.git themes

hugo server --theme=hyde --buildDrafts --watch
hugo server --theme=hyde --buildDrafts

hugo help

##deploy
hugo --theme=hyde --baseUrl="http://JasonLiu798.github.io"
如果一切顺利，所有静态页面都会生成到 public 目录，将pubilc目录里所有文件 push 到刚创建的Repository的 master 分支


---
#octopress
http://sonnewilling.com/blog/2013/11/14/shi-yong-octopressda-jian-ge-ren-bo-ke/
