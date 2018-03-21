#vue.js

http://cn.vuejs.org/guide/overview.html


#跨域vue
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



组件开发
[](https://www.talkingcoder.com/article/6310724958473489215?from=iview)



# Vue.js中如何动态的加载、卸载组件？
看起来主要矛盾就是只给部分组件加上<keep-alive>啊，在app.vue里这样<!-- 这里是需要keepalive的 -->
```html
<keep-alive>
    <router-view v-if="$route.meta.keepAlive"></router-view>
</keep-alive>

<!-- 这里不会被keepalive -->
<router-view v-if="!$route.meta.keepAlive"></router-view>
然后在设置路由信息的时候这样{
  path: '',
  name: '',
  component: ,
  meta: {keepAlive: true} // 这个是需要keepalive的
},
{
  path: '',
  name: '',
  component: ,
  meta: {keepAlive: false} // 这是不会被keepalive的
}
```























