#vue.js

http://cn.vuejs.org/guide/overview.html


#跨域
```
// 后端设置 header 头
res.setHeader('Access-Control-Allow-Origin', 你的域名);
res.setHeader('Access-Control-Allow-Credentials', true); // 允许带上 cookie
// 前端 xhr 设置 withCredentials。以 Zepto 为例：
$.ajax({
  url: 请求 API 地址,
  data: 请求数据,
  beforeSend: function (xhr) {
    xhr.withCredentials = true
  }
})
.done(成功后的回调函数)
```
