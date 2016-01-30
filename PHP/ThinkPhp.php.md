#thinkphp
---

#URL重写
1.在配置文件将URL模式改成
'URL_MODEL' => '2', //REWRITE模式
2.Apache服务器的话，将下面的内容保存为.htaccess文件放到入口文件的同级目录
```
<IfModule mod_rewrite.c>
RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]
</IfModule>
```

Nginx.conf中配置
```
location / { // …..省略部分代码
if (!-e $request_filename) {
rewrite ^(.*)$ /index.php?s=$1 last;
break;
}
}
```
参考资料：
http://doc.thinkphp.cn/manual/url_rew...
http://doc.thinkphp.cn/manual/hidden_...


