#markdown
----
#Editor
#sublime text插件
##OmniMarkupPreviewer
markdown 浏览器实时预览
快捷键：
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
{
  "line_numbers": true,
  "highlight_line": true
}
```


---
#语法速查
# 标题
# 这是 H1 <一级标题>
## 这是 H2 <二级标题>
###### 这是 H6 <六级标题>
文字格式

**这是文字粗体格式**
*这是文字斜体格式*
~~在文字上添加删除线~~

---
#强调
*斜体*   **加粗**
_斜体_   __加粗__


---
# 列表
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


---
# 图片

![图片名称](http://gitcafe.com/image.png)
链接

[链接名称](http://gitcafe.com)

---
#引用

> 第一行引用文字
> 第二行引用文字

---
# 代码

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

---
# 区段引用
> Email风格的尖括号
> 用作区段引用

> > 并且可以被嵌套

> #### 引文中的标题
> 
> * 也可以引用列表
> * 等等


---
# 表格

    表头  | 表头
    ------------- | -------------
   单元格内容  | 单元格内容
   单元格内容l  | 单元格内容


---
# 水平线
三个以上的点或星号

---

* * *

- - - -

---
# 强制换行
在行末加两个以上的空格
玫瑰是红的   
紫罗兰是蓝的
