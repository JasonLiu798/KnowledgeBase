CI默认过滤了$_GET

需要传递get参数时一般直接 /参数一/参数二
详见手册说明：http://codeigniter.org.cn/user_guide/general/controllers.html#passinguri

但是有时候需要传递很长的复杂的url，比如常用的 http://www.nicewords.cn/index.php/controller/method/?backURL=http://baidu.com/blog/hi

这时 这种模式就行不通了。参数中本身的/会与默认的分隔符冲突

解决方案：

1) 在config.php 中，将‘uri_protocol’ 设置为 ‘PATH_INFO’.
PHP复制代码
$config['uri_protocol'] = "PATH_INFO”;

2) 在需要使用$_GET的之前加：
parse_str($_SERVER['QUERY_STRING'], $_GET);

这样，形如 index.php/blog/list?parm=hello&page=52 就可以运行了。

官网说明：
http://codeigniter.com/wiki/QUERY_STRING_GET/
