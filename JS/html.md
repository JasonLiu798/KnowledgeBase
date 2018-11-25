

# <a> 标签
## 打开新标签
<a target="_blank" href="xxxxx">xxx</a>
1、超链接a  有href属性、target为_blank
2、iframe，其target为_blank
3、window.open<可能会被拦截，看用户的浏览器安全设置>
4、form表单提交，同样target也必须设为_blank

### 安全问题
https://juejin.im/entry/59f97d3851882558513203d9
如果是a标签要在新窗口中打开，添加noopener属性
如果是js中打开新窗口，手动将新窗口的opener置为null











