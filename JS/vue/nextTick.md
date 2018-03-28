

Vue 实现响应式并不是数据发生变化之后 DOM 立即变化，而是按一定的策略进行 DOM 的更新。
$nextTick 是在下次 DOM 更新循环结束之后执行延迟回调，在修改数据之后使用 $nextTick，则可以在回调中获取更新后的 DOM，API 文档中官方示例如下：

new Vue({
  // ...
  methods: {
    // ...
    example: function () {
      // modify data
      this.message = 'changed'
      // DOM is not updated yet
      this.$nextTick(function () {
        // DOM is now updated
        // `this` is bound to the current instance
        this.doSomethingElse()
      })
    }
  }
})
有些同
```vue
<template>
<div class="app">
	<div ref="msgDiv">{{msg}}</div>
	<div v-if="msg1">Message got outside $nextTick: {{msg1}}</div>
	<div v-if="msg2">Message got inside $nextTick: {{msg2}}</div>
	<div v-if="msg3">Message got outside $nextTick: {{msg3}}</div>
	<button @click="changeMsg">
	Change the Message
	</button>
</div>
</template>
<script>
export default {
	data(){
		return {
			msg: 'Hello Vue.',
			msg1: '',
			msg2: '',
			msg3: ''
		}
	},
	mounted:function(){
	},
	methods: {
		changeMsg() {
			this.msg = "Hello world."
			this.msg1 = this.$refs.msgDiv.innerHTML
			this.$nextTick(() => {
				this.msg2 = this.$refs.msgDiv.innerHTML
			})
			this.msg3 = this.$refs.msgDiv.innerHTML
		}
	},
	components: {

	},
}
</script>
```

考虑这样一种场景，你有一个 jQuery 插件，希望在 DOM 元素中某些属性发生变化之后重新应用该插件，这时候就需要在 $nextTick 的回调函数中执行重新应用插件的方法。




















