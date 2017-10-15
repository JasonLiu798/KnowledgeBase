#Browser

shell
内核
    渲染引擎(layout engineer或者Rendering Engine)
        Firefox Gecko
        Safari/Chrome Webkit
        Chrome/Opera Blink
        IE Trident
    JS引擎

#流程
解析HTML构建DOM树
Rule Tree渲染树构建
渲染树布局
绘制渲染树


#浏览器加载和渲染HTML的顺序
##浏览器加载和渲染html的顺序
IE浏览器下载的顺序是从上到下，渲染的顺序也是从上到下，下载和渲染是同时进行的。
在渲染到页面的某一部分时，其上面的所有部分都已经下载完成（并不是说所有相关联的元素都已经下载完）
如果遇到语义解释性的标签嵌入文件（JS脚本，CSS样式），那么此时IE的下载过程会启用单独连接进行下载。
并且在下载后进行解析，解析过程中，停止页面所有往下元素的下载，阻塞加载。
样式表在下载完成后，将和以前下载的所有样式表一起进行解析，解析完成后，将对此前所有元素（含以前已经渲染的）重新进行渲染。
JS、CSS中如有重定义，后定义函数将覆盖前定义函数。
##JS的加载
不能并行下载和解析（阻塞下载）
当引用了JS的时候，浏览器发送一个js request就会一直等待该request的返回。因为浏览器需要一个稳定的DOM树结构，而JS中很有可能有代码直接改变了DOM树结构，比如使用 document.write 或 appendChild，甚至是直接使用的location.href进行跳转，浏览器为了防止出现JS修改DOM树，需要重新构建DOM树的情况，所以 就会阻塞其他的下载和呈现。

---
#DTD
[DTD：DOCTYPE与浏览器解析渲染的背景知识](http://www.nowamagic.net/academy/detail/48110310)
www.w3.org/TR/html4/strict.dtd

BackCompat：标准兼容模式（Standards-compliant mode）未开启；
CSS1Compat：标准兼容模式已开启。
标准兼容模式未开启即“混杂模式”（又叫怪异模式，Quirks mode），标准兼容模式已开启即“标准模式”（又叫严格模式，Standards mode 或者 Strict mode）。 所以前面那个测试样例中，没有书写 DOCTYPE 的 HTML 文档在所有浏览器中均会以混杂模式进行渲染和解析。

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
上面的 DOCTYPE 包含 6 部分：
* 字符串“<!DOCTYPE”
* 根元素通用标识符“HTML”
* 字符串“PUBLIC”
* 被引号括起来的公共标识符（publicId）“-//W3C//DTD HTML 4.01//EN”
* 被引号括起来的系统标识符（systemId）“http://www.w3.org/TR/html4/strict.dtd”
* 字符串“>”

根元素通用标识符、公共标识符、系统标识符均可以通过脚本调用 DOM 接口获得，分别对应 document.doctype.name、document.doctype.publicId、document.doctype.systemId（IE6 IE7 不支持）

如果力求最简，则 HTML5 的 DOCTYPE 是最佳选择：
<!DOCTYPE html>
较早的 HTML4.01 Strict 的 DOCTYPE 也是一种好的选择：
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">，它在各主流浏览器中触发的模式与上面的 HTML5 的完全一致。
近似标准模式，则可选择：
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">。

DOCTYPE 之前可能出现的这些内容分类，它们包括:
普通文本、HTML 标签
    各浏览器均进入了混杂模式
HTML 注释、XML 声明
    非 IE 浏览器均会忽略它们的存在，DOCTYPE 被正确解析
    但是在 IE6 中，DOCTYPE 之前的 XML 声明会导致页面进入混杂模式，而所有的 IE 均会使 DOCTYPE 之前出现了 HTML 注释的页面进入混杂模式
IE 条件注释
    上面这些 IE 条件注释在非 IE 浏览器中，可能完全被忽略，可能被解释为普通 HTML 注释。但是在 IE 中它们全部消失了，因为这就是 IE 条件注释的作用。

---
#DOM
[浏览器的DOM（文本对象模型）结构](http://www.nowamagic.net/academy/detail/48110315)
www.w3.org/TR/2003/REC-DOM-Level-2-HTML-20030109/idl-definitions.html

                                        JS Engine
                                           |
                                   ECMAScript Binding
                                           |
    Stream->Tokenizer/Parser->DOM Builder->DOM->Layout Engine->Rendering out
                        |                  |
               HTML Validator             CSS
                                           |
                                       CSS Parser 

DOM Core
DOM HTML

---
#html解析
[浏览器的HTML解析算法](http://www.nowamagic.net/academy/detail/48110319)
HTML5 规范详细地描述了解析算法。此算法由两个阶段组成：标记化和树构建。
    * 标记化是词法分析过程，将输入内容解析成多个标记。HTML 标记包括起始标记、结束标记、属性名称和属性值。
    * 标记生成器识别标记，传递给树构造器，然后接受下一个字符以识别下一个标记；如此反复直到输入的结束。


##标记化算法
遇到字符 < 时，状态更改为“标记打开状态”。接收一个a-z字符会创建“起始标记”，状态更改为“标记名称状态”。这个状态会一直保持到接收 > 字符。在此期间接收的每个字符都会附加到新的标记名称上。
遇到 > 标记时，会发送当前的标记，状态改回“数据状态”

##DOM树构建算法

[A vocabulary and associated APIs for HTML and XHTML](http://www.w3.org/TR/html5/syntax.html#html-parser)

##容错机制
[浏览器HTML解析里的容错机制](http://www.nowamagic.net/academy/detail/48110335)
解析器对标记化输入内容进行解析，以构建文档树。如果文档的格式正确，就直接进行解析。
遗憾的是，我们不得不处理很多格式错误的HTML文档，所以解析器必须具备一定的容错性
我们至少要能够处理以下错误情况：
* 明显不能在某些外部标记中添加的元素。在此情况下，我们应该关闭所有标记，直到出现禁止添加的元素，然后再加入该元素。
* 我们不能直接添加的元素。这很可能是网页作者忘记添加了其中的一些标记（或者其中的标记是可选的）。这些标签可能包括：HTML HEAD BODY TBODY TR TD LI（还有遗漏的吗？）
* 向 inline 元素内添加 block 元素。关闭所有inline元素，直到出现下一个较高级的 block 元素。
* 如果这样仍然无效，可关闭所有元素，直到可以添加元素为止，或者忽略该标记。

[HTML字符编码解析是如何影响浏览器性能的](http://www.nowamagic.net/academy/detail/48110375)
不同浏览器需要缓冲的字节流数量不同，另外如果找不到编码设定，各浏览器默认的编码也不同。但是不管哪一种浏览器，如果在已经缓冲了足够的字节流、开始渲染页面之后才发现指定的编码设定与其默认值不同，都会导致重新解析文档并重绘页面。如果编码的变化影响到了外部资源（例如css\js\media），浏览器甚至会重新对资源进行请求。

为了避免这些延迟，对任何超过1k（精确地说是1024字节，这是我们测试过的所有浏览器的最大缓冲限制）的HTML文档，要尽早指定字符编码。

---
#CSS解析
[Appendix G. Grammar of CSS 2.1](http://www.w3.org/TR/CSS2/grammar.html)
CSS是上下文无关文法，如果一个语言的文法是上下文无关的，则它可以用正则解析器来解析

Webkit中的CSS解析
解析器会将CSS文件解析成StyleSheet对象，且每个对象都包含CSS规则。CSS规则对象包含选择器和声明对象，以及其他与CSS语法对应的对象。

解析器先创建一个CSSStyleSheet对象，然后在对样式进行解析时，创建CSSStyleRule，并添加到已解析的样式对象列表中。解析完后，样式表中的所有样式规则都转化成了Webkit的内部模型对象CSSStyleRule对象。

所有的CSSStyleRule对象都存储在CSSStyleSheet对象中。然后将CSSStyleSheet对象转换为CSSRuleSet对象。后面就基于这些CSSRuleSet对象来决定每个页面中的元素样式。


呈现器是和 DOM 元素相对应的，但并非一一对应

##样式计算存在以下难点
1 样式数据是一个超大的结构，存储了无数的样式属性，这可能造成内存问题。
2 如果不进行优化，为每一个元素查找匹配的规则会造成性能问题。要为每一个元素遍历整个规则列表来寻找匹配规则，这是一项浩大的工程。选择器会具有很复杂的结构，这就会导致某个匹配过程一开始看起来很可能是正确的，但最终发现其实是徒劳的，必须尝试其他匹配路径。
例如下面这个组合选择器：

div div div div{
  ...
}
这意味着规则适用于作为 3 个 div 元素的子代的 div。如果您要检查规则是否适用于某个指定的 div 元素，应选择树上的一条向上路径进行检查。您可能需要向上遍历节点树，结果发现只有两个 div，而且规则并不适用。然后，您必须尝试树中的其他路径。
3 应用规则涉及到相当复杂的层叠规则（用于定义这些规则的层次）。

##解决办法
共享样式数据[类似flyweight]
Webkit 节点会引用样式对象 (RenderStyle)。这些对象在某些情况下可以由不同节点共享。这些节点是同级关系，并且：
这些元素必须处于相同的鼠标状态（例如，不允许其中一个是“:hover”状态，而另一个不是）
任何元素都没有 ID
标记名称应匹配
类属性应匹配
映射属性的集合必须是完全相同的
链接状态必须匹配
焦点状态必须匹配
任何元素都不应受属性选择器的影响，这里所说的“影响”是指在选择器中的任何位置有任何使用了属性选择器的选择器匹配
元素中不能有任何 inline 样式属性
不能使用任何同级选择器。WebCore 在遇到任何同级选择器时，只会引发一个全局开关，并停用整个文档的样式共享（如果存在）。这包括 + 选择器以及 :first-child 和 :last-child 等选择器。

Firefox 还采用了另外两种树：规则树和样式上下文树

样式上下文包含端值。要计算出这些值，应按照正确顺序应用所有的匹配规则，并将其从逻辑值转化为具体的值。
[规则树是如何解决样式计算的难点？](http://www.nowamagic.net/academy/detail/48110523)

Webkit 中没有规则树，因此会对匹配的声明遍历 4 次。首先应用非重要高优先级的属性（由于作为其他属性的依据而应首先应用的属性，例如 display），接着是高优先级重要规则，然后是普通优先级非重要规则，最后是普通优先级重要规则。这意味着多次出现的属性会根据正确的层叠顺序进行解析。

###样式表层叠顺序
根据 CSS2 规范，层叠的顺序为（优先级从低到高）：
浏览器声明
用户普通声明
作者普通声明
作者重要声明
用户重要声明

###选择器的特异性
选择器的特异性由 CSS2 规范定义如下：
如果声明来自于“style”属性，而不是带有选择器的规则，则记为 1，否则记为 0 (= a)
记为选择器中 ID 属性的个数 (= b)
记为选择器中其他属性和伪类的个数 (= c)
记为选择器中元素名称和伪元素的个数 (= d)
将四个数字按 a-b-c-d 这样连接起来（位于大数进制的数字系统中），构成特异性。
使用的进制取决于上述类别中的最高计数。

###利用浏览器CSS渲染原理写出高性能的CSS代码
CSS 引擎查找样式表，对每条规则都按从右到左的顺序去匹配。
总结出如下性能提升的方案：
* 避免使用通配规则。如 *{} 计算次数惊人！只对需要用到的元素进行选择
* 尽量少的去对标签进行选择，而是用class。如：#nav li{},* 可以为li加上nav_item的类名，如下选择.nav_item{}
* 不要去用标签限定ID或者类选择符。如：ul#nav,应该简化为#nav
* 尽量少的去使用后代选择器，降低选择器的权重值。后代选择器的开销是最高的，尽量将 选择器的深度降到最低，最高不要超过三层，更多的使用类来关联每一个标签元素。
* 考虑继承。了解哪些属性是可以通过继承而来的，然后避免对这些属性重复指定规则

##下列各类规则被认为是低效的：
###后代选择器的规则
1. 通配选择器作为键的规则
    body * {...}
    .hide-scrollbars * {...}

2. 标签选择器作为键的规则
```
    ul li a {...}
    #footer h3 {...}
    + html #atticPromo ul li a {...}
```

###子代选择器和相邻选择器的规则
1. 通配选择器作为键的规则
body > * {...}
.hide-scrollbars > * {...}
2. 标签选择器作为键的规则
    ul > li > a {...}
    #footer > h3 {...}
子代选择器和相邻选择器是低效的，因为对每个匹配的元素，浏览器必须评估另一个节点。这样导致规则中的每个子选择器加倍消耗。同样，键越不具体，需要进行评估的节点数量就越大。尽管如此，虽然同样效率低下，在性能方面相对后代选择器而言，它们仍然是可取的。

###有多余修饰的规则
例如：
ul#top_blue_nav {...}
form#UserLogin {...}
ID选择是唯一的定义。加上标签或类的限制只增加了多余的、引起不必要评估的信息。

###对非链接元素应用:hover伪选择器的规则
例如：
    h3:hover {...}
    .foo:hover {...}
    #foo:hover {...}
    div.faa:hover {...}
非链接元素上的:hover伪选择器在某些情况下*会使IE 7 和IE 8 变慢。当页面没有一个严格的doctype时，IE 7 和IE 8 将忽略除了链接外的任何元素的:hover。当页面有严格的doctype，在非链接元素上的:hover将导致性能下降。

##建议
避免通配选择器。允许元素继承祖先的样式，或者使用一个类来给多个元素应用样式。
使您的规则尽可能具体。尽量使用class和ID选择器而非标签选择器。
删除多余的修饰语。比如这些修饰语是多余的：ID选择器被class选择器和/或者标签选择器限制。class选择器被标签选择器限制(当一个类只是用于一个标签，无论如何这都是一个很好的设计实践)。
避免使用后代选择器，特别是那些指定多余祖先的。例如，这一个规则 body ul li a {...} 指定了一个多余的body选择器, 因为所有的元素都是body标签的后代。
使用class选择器代替后代选择器。例如，如果您需要有序列表项和无序列表项有不同的两个样式，而不是使用两个规则：
ul li {color: blue;}
ol li {color: red;}
你可以将样式编码成两个类名并在规则中使用，例如：
.unordered-list-item {color: blue;}
.ordered-list-item {color: red;}
如果您必须使用后代选择器，尽量使用子代选择器，这最少只需评估一个额外的节点，而非中间直至祖先的所有节点。

在IE中避免对非链接元素应用:hover。如果您对非链接元素应用:hover，请在IE7和IE8中测试并确保页面可用。如果您发现:hover导致性能问题，可以考虑条件性的为IE使用JavaScript onmouseover事件（只对IE写mouseover事件）。
附加资源
更多关于Mozilla里的高效CSS规则的细节，请看https://developer.mozilla.org/en/Writing_Efficient_CSS。





---

## Render树的建立
DOM树的document节点；
DOM树中的可视化节点，例如HTML，BODY，DIV等，非可视化节点不会建立Render树节点，例如HEAD，META，SCRIPT等；
某些情况下需要建立匿名的Render节点，该节点不对应于DOM树中的任何节点；

##RenderLayer树
RenderLayer树是基于Render树建立起来的一颗新的树。
[WebKit渲染基础之RenderLayer树](http://www.nowamagic.net/academy/detail/48110560)
需要建立新的RenderLayer节点情况：
DOM树的document节点对应的RenderView节点
DOM树中的document 的子女节点，也就是HTML节点对应的RenderBlock节点
显式的CSS位置
有透明效果的对象
节点有溢出（overflow），alpha或者反射等效果的
Canvas 2D和3D (WebGL)
Video节点对应的RenderObject对象


---
#呈现器的布局与绘制
##Dirty bit system
dirty
children are dirty

当呈现器为 dirty 时，会异步触发增量布局

[呈现器的布局处理与宽度计算](http://www.nowamagic.net/academy/detail/48110614)

[呈现器的绘制方法与绘制顺序]()
全局绘制和增量绘制

呈现引擎采用了单线程。几乎所有操作（除了网络操作）都是在单线程中进行的


##为何不用table做布局
由于浏览器的流布局，对渲染树的计算通常只需要遍历一次就可以完成。但table及其内部元素除外，它可能需要多次计算才能确定好其在渲染树中节点的属性，通常要花3倍于同等元素的时间。这也是为什么我们要避免使用table做布局的一个原因。

##重绘
是一个元素外观的改变所触发的浏览器行为，例如改变vidibility、outline、背景色等属性。浏览器会根据元素的新属性重新绘制，使元素呈现新的外观。重绘不会带来重新布局，并不一定伴随重排。

##重排
是更明显的一种改变，可以理解为渲染树需要重新计算。关于重排，可以参考这篇文章：浏览器渲染过程中的reflow是什么 。

触发重排的操作：
1. DOM元素的几何属性变化。
2.DOM树的结构变化。


比较好的实践是尽量减少重排次数和缩小重排的影响范围。例如：
1. 将多次改变样式属性的操作合并成一次操作。
2. 将需要多次重排的元素，position属性设为absolute或fixed，这样此元素就脱离了文档流，它的变化不会影响到其他元素。
3. 在内存中多次操作节点，完成后再添加到文档中去。
4. 由于display属性为none的元素不在渲染树中，对隐藏的元素操作不会引发其他元素的重排。如果要对一个元素进行复杂的操作时，可以先隐藏它，操作完成后再显示。这样只在隐藏和显示时触发2次重排。
    clone一个DOM结点到内存里，然后想怎么改就怎么改，改完后，和在线的那个的交换一下。
5. 在需要经常取那些引起浏览器重排的属性值时，要缓存到变量。
6. 不要把DOM结点的属性值放在一个循环里当成循环里的变量。不然这会导致大量地读写这个结点的属性。
7. 尽可能的修改层级比较低的DOM。当然，改变层级比较底的DOM有可能会造成大面积的 reflow，但是也可能影响范围很小。
8. 最好不要使用table布局。因为可能很小的一个小改动会造成整个table的重新布局。

下面这些动作有很大可能会是成本比较高的。
当你增加、删除、修改DOM结点时，会导致Reflow或Repaint
当你移动DOM的位置，或是搞个动画的时候。
当你修改CSS样式的时候。
当你Resize窗口的时候（移动端没有这个问题），或是滚动的时候。
当你修改网页的默认字体时。
注：display:none会触发reflow，而visibility:hidden只会触发repaint，因为没有发现位置变化。

##关于滚屏
滚屏的事，通常来说，如果在滚屏的时候，我们的页面上的所有的像素都会跟着滚动，那么性能上没什么问题，因为我们的显卡对于这种把全屏像素往上往下移的算法是很快。但是如果你有一个fixed的背景图，或是有些Element不跟着滚动，有些Elment是动画，那么这个滚动的动作对于浏览器来说会是相当相当痛苦的一个过程。你可以看到很多这样的网页在滚动的时候性能有多差。因为滚屏也有可能会造成reflow。


##reflow有如下的几个原因：
Initial。网页初始化的时候。
Incremental。一些Javascript在操作DOM Tree时。
Resize。其些元件的尺寸变了。
StyleChange。如果CSS的属性发生变化了。
Dirty。几个Incremental的reflow发生在同一个frame的子树上。

























