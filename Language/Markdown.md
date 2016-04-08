#markdown
----
#Editor
#sublime text插件
[Sublime插件：Markdown篇](http://www.jianshu.com/p/aa30cc25c91b)
##OmniMarkupPreviewer
[近乎完美的 Markdown 写作体验](http://blog.leanote.com/post/54bfa17b8404f03097000000)
markdown 浏览器实时预览
###配置
```javascript
"browser_command": ["open", "-a", "Google Chrome", "{url}"],
"html_template_name": "Evolution Yellow",
"ignored_renderers": ["CreoleRenderer", "PodRenderer", "RDocRenderer", "TextitleRenderer", "LiterateHaskellRenderer"],
"mathjax_enabled": true,
"renderer_options-MarkdownRenderer": {
 "extensions": ["extra", "codehilite", "toc", "strikeout", "smarty", "subscript", "superscript"]
 }

//支持latex
"mathjax_enabled": true,
下载MathJax：
https://github.com/downloads/timonwong/OmniMarkupPreviewer/mathjax.zip
解压到下面的目录里：
Sublime Text 2\Packages\OmniMarkupPreviewer\public
之后在目录“Sublime Text 2\Packages\OmniMarkupPreviewer”中创建一个空文件MATHJAX.DOWNLOADED
```

###快捷键：
```javascript
"ctrl+alt+o" "command": "omni_markup_preview"
"ctrl+alt+x" "command": "omni_markup_export"
"ctrl+alt+c" "command": "omni_markup_export""args": { "clipboard_only": true }
```

##Markdown Preview
markdown 浏览器查看
```javascript
[
  { "keys": ["alt+m"], "command": "markdown_preview", "args": { "target": "browser"} },
]

```

##markdown editing
[official site](http://sublimetext-markdown.github.io/MarkdownEditing/#installation)
[github](https://github.com/SublimeText-Markdown/MarkdownEditing)
markdown 语法着色
```javascript
//gfm setting
{
  "enable_table_editor": true,
    "line_numbers": true,
    "highlight_line": true,
    "word_wrap": true,
    "wrap_width": 80
}

```

##TableEditor
首先需要用ctrl + shift + p打开这个功能（Table Editor: Enable for current syntax or Table Editor: Enable for current view or "Table Editor: Set table syntax ... for current view"），然后就可以狂用tab来自动完成了~~~

---
#语法速查
##标题
```
# 标题
# 这是 H1 <一级标题>
## 这是 H2 <二级标题>
###### 这是 H6 <六级标题>
```

##文字格式
```
**这是文字粗体格式**
*这是文字斜体格式*
~~在文字上添加删除线~~
#强调
*斜体*   **加粗**
_斜体_   __加粗__
```

##列表
```
无序列表

* 项目1
* 项目2

有序列表

1. 项目1
2. 项目2
3. 项目3
   * 项目1
   * 项目2
3 其它
```

##图片
```markdown
![图片名称](http://gitcafe.com/image.png)
链接
[链接名称](http://gitcafe.com)
```

##引用,代码
```
> 第一行引用文字
> 第二行引用文字

`<hello world>`
代码块高亮

  ```ruby
    def add(a, b)
      return a + b
    end
  ```

保持原有格式的代码段
每一行前面加四个空格或者一个tab

这是普通段落

    这是保持原有格式的
    代码段
```

##区段引用
```
> Email风格的尖括号
> 用作区段引用

> > 并且可以被嵌套

> #### 引文中的标题
> 
> * 也可以引用列表
> * 等等
```

##表格
```
| 表头 | 表头 |
|------|-----|
|单元格内容  | 单元格内容 |
|单元格内容l | 单元格内容 |
```

##水平线
三个以上的点或星号
```
---
* * *
- - - -
```

##强制换行
在行末加两个以上的空格





