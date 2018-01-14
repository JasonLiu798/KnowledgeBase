

start nginx : 启动nginx
nginx -s reload  ：修改配置后重新加载生效
nginx -s reopen  ：重新打开日志文件
nginx -t -c /path/to/nginx.conf 测试nginx配置文件是否正确

关闭nginx：
nginx -s stop  :快速停止nginx
nginx -s quit  ：完整有序的停止nginx



[Nginx+Https配置](https://segmentfault.com/a/1190000004976222)


[解决访问ajax.googleapis.com链接失败方法](https://www.cnblogs.com/hzijone/p/4857376.html)

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout nginx.key -out nginx.crt


