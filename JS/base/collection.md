

#新建数组
var arr = new Array();
arr[0] = "aaa";
arr[1] = "bbb";
arr[2] = "ccc";

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
