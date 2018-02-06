

#数组
##新建
var arr = new Array();
arr[0] = "aaa";
arr[1] = "bbb";
arr[2] = "ccc";

##修改
push()、pop()和unshift()、shift()
这两组同为对数组的操作，并且会改变数组的本身的长度及内容。
不同的是 push()、pop() 是从数组的尾部进行增减，unshift()、shift() 是从数组的头部进行增减。

##删除
arr.pop();

arr2 = arr2.slice(0,arr2.length-1); 
//alert(arr2.length);//0
arr2[0] = "aaa";
arr2[1] = "bbb";
arr2[2] = "ccc";
arr2 = arr2.slice(0,1); 
alert(arr2.length);//1
alert(arr2[0]);//aaa
alert(arr2[1]);//undefined

##遍历
for (x in mycars)
{
	mycars[x]
}

```
var arr = new Array(13.5,3,4,5,6);
for(var i=0;i<arr.length;i++){
 	arr[i] = arr[i]/2.0;
}
```








