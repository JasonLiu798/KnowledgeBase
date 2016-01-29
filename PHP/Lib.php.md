#lib
---




----
#序列化
[hession2](http://blog.sina.com.cn/s/blog_46d93f190102uz6a.html)


----
#functions 
chr() 函数从指定的 ASCII 值返回字符。



[高性能的PHP socket 服务器框架](http://www.workerman.net/workerman)




---
#mysql
```java
mysql -u root -p

$con = mysql_connect('localhost','root','root');
if (!$con){
     die('Could not connect: ' . mysql_error());
}

mysql_select_db("blog", $con);

$result = mysql_query("SELECT post_content FROM posts where ID=22");

$row = mysql_fetch_array($result);
$str = $row['post_content'];

mysql_close($con);
$cont = Post::get_adjust_post($str,500);
```



















