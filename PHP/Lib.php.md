#lib
---
#docs
[php trick](https://www.quora.com/What-are-some-cool-PHP-tricks)
[一个基于PHP的事件机制](http://www.oschina.net/code/snippet_59519_2937)
##框架
php55-phalcon C语言
php55-swoole 国产的PHP高性能网络通信框架
mq-beanstalk

---
#变量
##判空
* empty()       
如果 变量 是非空或非零的值，则 empty() 返回 FALSE。
换句话说，""、0、"0"、NULL、FALSE、array()、var $var、未定义;
以及没有任何属性的对象都将被认为是空的，如果 var 为空，则返回 TRUE

* isset()   
如果 变量 存在(非NULL)则返回 TRUE，否则返回 FALSE(包括未定义）。
变量值设置为：null，返回也是false;unset一个变量后，变量被取消了。
PS:isset对于NULL值变量，特殊处理。

* is_null()
为真：不存在存在的变量、存在的变量=null
检测传入值【值，变量，表达式】是否是null,只有一个变量定义了，且它的值是null，它才返回TRUE . 其它都返回 FALSE 
PS:未定义变量传入后会出错！

empty,isset输入参数必须是一个变量（php变量是以$字符开头的），而is_null输入参数只要是能够有返回值就可以。（常量，变量，表达式等）。在php手册里面，对于他们解析是：empty,isset 是一个语言结构而非函数，因此它无法被变量函数调用

##常用常量
$_SERVER['HTTPS'];
$_SERVER['SERVER_PORT'];
$_SERVER['HTTP_HOST'];
$_SERVER['SERVER_NAME'];
$_SERVER['SERVER_ADDR'];
$_SERVER['HTTP_X_FORWARDED_HOST'];

echo $_SERVER['PHP_SELF']; //The filename of the currently executing script, relative to the document root.

##获取文件所在目录        
`__FILE__`    文件所在全路径，如 D:\wamp\www\mbaobao\test.php
define('ROOT_PATH', str_replace('includes/init.php', '', str_replace('\\', '/', __FILE__)));   
获取根目录，如 D:/wamp/www/aaa/

##序列化
[hession2](http://blog.sina.com.cn/s/blog_46d93f190102uz6a.html)

##编码解码
```javascript
<script language="javascript">
var a = encodeURI("电影");
alert(a);
var b = decodeURI(a);
alert(b)
</script>
<?php
$a = urlencode(iconv("gb2312", "UTF-8", "电影")); //等同于javascript encodeURI("电影");
echo $a;
$b = iconv("utf-8","gb2312",urldecode("%E7%94%B5%E5%BD%B1")); //等同于javascript decodeURI("%E7%94%B5%E5%BD%B1");
echo $b;
?>
```
如果编码是UTF-8的话就可以直接用urlencode 或 urldecode 转换

---
#函数
#常用函数
* chr() 函数从指定的 ASCII 值返回字符。
* gettype() 获取类型 


---
#网络
[高性能的PHP socket 服务器框架](http://www.workerman.net/workerman)


---
#其他
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


---
#webservice
[php中soap的使用实例以及生成WSDL文件，提供自动生成WSDL文件的类库——SoapDiscovery.class.php类](http://blog.csdn.net/wbandzlhgod/article/details/29806677)
[实战](http://koda.iteye.com/blog/152042)
[分享一个PHP写的简单webservice服务端+客户端](http://hmw.iteye.com/blog/1322406)
[wsdl方式](http://www.open-open.com/lib/view/open1324368162639.html)
[手写wsdl](http://blog.csdn.net/rrr4578/article/details/24451943)
[错误排查 搞定PHP的WEBservice，尤其是BT的WSDL](http://www.huliang.com/homepage/nd.php?id=2305)

---
#PHPUnit
打开CMD，进入PHP目录，分别运行如下指令：
```
pear upgrade-all
pear channel-discover pear.phpunit.de
pear channel-discover components.ez.no
pear channel-discover pear.symfony-project.com
pear update-channels
```
然后，安装PHPUnit：
```
pear install --alldeps --force phpunit/PHPUnit
pear install  phpunit
```
最后，查看PHPUnit是否已经安装成功
```
phpunit -v
```

---
#消息推送
[方案](http://www.cnblogs.com/hnrainll/archive/2013/05/07/3064874.html)
##ajax长轮询
PHP实现: Jquery+php实现comet

##Comet
[基于 HTTP 长连接的“服务器推”技术](https://www.ibm.com/developerworks/cn/web/wa-lo-comet/#resources)
##websocket
[websocket](http://code.tutsplus.com/tutorials/start-using-html5-websockets-today--net-13270)

---
#图片处理
[gd库](http://www.ccvita.com/401.html)
[mac brew安装](https://github.com/Homebrew/homebrew-php)
[缩略图](http://www.open-open.com/lib/view/open1378556584084.html)
```php
imagecopyresized ( resource $dst_image , resource $src_image ,
int $dst_x , int $dst_y ,
int $src_x , int $src_y ,
int $dst_w , int $dst_h ,
int $src_w , int $src_h );
```
拷贝部分图像并调整大小，如果源和目标的宽度和高度不同，则会进行相应的图像收缩和拉伸。
创建纯黑图片
```
resource imagecreatetruecolor ( int $width , int $height )
```

---
#上传
Jquery ajaxsubmit 上传图片
http://www.cnblogs.com/ryanding/archive/2010/10/31/1865630.html

tiny mce
http://justboil.me/translating-to-other-languages/
https://github.com/zhaoda/tinymce-upload


---
#session
```php
session_start();
ini_set('session.save_path','/tmp/');
//6个钟头
ini_set('session.gc_maxlifetime',21600);
//保存一天
$lifeTime = 24 * 3600;
setcookie(session_name(), session_id(), time() + $lifeTime, "/");
```
php.ini关于Session的相关设置，在[Session]部分    
1、session.use_cookies    
默认的值是“1”，代表SessionID使用Cookie来传递，反之就是使用Query_String来传递；    
2、session.name    
这个就是SessionID储存的变量名称，可能是Cookie，也可能是Query_String来传递，默认值是“PHPSESSID”；     
3、session.cookie_lifetime       
这个代表SessionID在客户端Cookie储存的时间，默认是0，代表浏览器一关闭SessionID就作废……就是因为这个所以Session不能永久使用！      
4、session.gc_maxlifetime                这个是Session数据在服务器端储存的时间，如果超过这个时间，那么Session数据就自动删除

使用永久Session的原理和步骤       
服务器通过SessionID来读取Session的数据，但是一般浏览器传送的SessionID在浏览器关闭后就没有了，那么我们只需要人为的设置SessionID并且保存下来      
1、把session.use_cookies设置为1，打开Cookie储存SessionID，不过默认就是1，一般不用修改      
2、把session.cookie_lifetime改为正无穷（当然没有正无穷的参数，不过999999999和正无穷也没有什么区别）       
3、把session.gc_maxlifetime设置为和session.cookie_lifetime一样的时间；      
在PHP的文档中明确指出，设定session有效期的参数是session.gc_maxlifetime。可以在php.ini文件中，或者通过ini_set()函数来修改这一参数。问题在于，经过多次测试，修改这个参数基本不起作用，session有效期仍然保持24分钟的默认值。
由于PHP的工作机制，它并没有一个daemon线程，来定时地扫描session信息并判断其是否失效。当一个有效请求发生时，PHP会根据全局变量session.gc_probability/session.gc_divisor（同样可以通过php.ini或者ini_set()函数来修改）的值，来决定是否启动一个GC（Garbage Collector）。
默认情况下，session.gc_probability ＝ 1，session.gc_divisor ＝100，也就是说有1%的可能性会启动GC。GC的工作，就是扫描所有的session信息，用当前时间减去session的最后修改时间（modified date），同session.gc_maxlifetime参数进行比较，如果生存时间已经超过gc_maxlifetime，就把该session删除。
到此为止，工作一切正常。那为什么会发生gc_maxlifetime无效的情况呢？
在默认情况下，session信息会以文本文件的形式，被保存在系统的临时文件目录中。在Linux下，这一路径通常为\tmp，在 Windows下通常为C:\Windows\Temp。当服务器上有多个PHP应用时，它们会把自己的session文件都保存在同一个目录中。同样地，这些PHP应用也会按一定机率启动GC，扫描所有的session文件。
问题在于，GC在工作时，并不会区分不同站点的session。举例言之，站点A的gc_maxlifetime设置为2小时，站点B的 gc_maxlifetime设置为默认的24分钟。当站点B的GC启动时，它会扫描公用的临时文件目录，把所有超过24分钟的session文件全部删除掉，而不管它们来自于站点A或B。这样，站点A的gc_maxlifetime设置就形同虚设了。
找到问题所在，解决起来就很简单了。修改session.save_path参数，或者使用session_save_path()函数，把保存session的目录指向一个专用的目录，gc_maxlifetime参数工作正常了。
严格地来说，这算是PHP的一个bug？
还有一个问题就是，gc_maxlifetime只能保证session生存的最短时间，并不能够保存在超过这一时间之后session信息立即会得到删除。因为GC是按机率启动的，可能在某一个长时间内都没有被启动，那么大量的session在超过gc_maxlifetime以后仍然会有效。
解决这个问题的一个方法是，把session.gc_probability/session.gc_divisor的机率提高，如果提到100%，就会彻底解决这个问题，但显然会对性能造成严重的影响。另一个方法是自己在代码中判断当前session的生存时间，如果超出了 gc_maxlifetime，就清空当前session。
但是如果你没有服务器的操作权限，那就比较麻烦了，你需要通过PHP程序改写SessionID来实现永久的Session数据保存。查查php.net的函数手册，可以见到有“session_id”这个函数：如果没有设置参数，那么将返回当前的SessionID，如果设置了参数，就会将当前的SessionID设置为给出的值……
只要利用永久性的Cookie加上“session_id”函数，就可以实现永久Session数据保存了！
但是为了方便，我们需要知道服务器设置的“session.name”，但是一般用户都没有权限查看服务器的php.ini设置，不过PHP提供了一个非常好的函数“phpinfo”，利用这个可以查看几乎所有的PHP信息！



























