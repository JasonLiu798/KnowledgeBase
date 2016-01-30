#apache
---
#setup

---
#配置
开机不启动
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
开机启动
sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist
unload之后，立刻就发现apache已经无法启动了。
##Virtual hosts
Include /private/etc/apache2/extra/httpd-vhosts.conf
/private/etc/apache2/extra/httpd-vhosts.conf
```
<VirtualHost *:80>
    DocumentRoot /Library/WebServer/Documents/lblog/public
    ServerName www.lblog.com
</VirtualHost>
```

---
#xampp
start&stop server
start   启动 XAMPP。
stop    停止 XAMPP。
restart     重新启动 XAMPP。
startapache     只启动 Apache。
startssl    启动 Apache 的 SSL 支持。该命令将持续激活 SSL 支持，例如：执行该命令后，如果您关闭并重新启动 XAMPP，SSL 仍将处于激活状态。
startmysql  只启动 MySQL 数据库。
startftp    启动 ProFTPD 服务器。通过 FTP，您可以上传文件到您的网络服务器中（用户名“nobody”，密码“lampp”）。该命令将持续激活 ProFTPD，例如：执行该命令后，如果您关闭并重新启动 XAMPP，FTP 仍将处于激活状态。
stopapache  停止 Apache。
stopssl     停止 Apache 的 SSL 支持。该命令将持续停止 SSL 支持，例如：执行该命令后，如果您关闭并重新启动 XAMPP，SSL 仍将处于停止状态。
stopmysql   停止 MySQL 数据库。
stopftp     停止 ProFTPD 服务器。该命令将持续停止 ProFTPD，例如：执行该命令后，如果您关闭并重新启动 XAMPP，FTP 仍将处于停止状态。
security    启动一个小型安全检查程序。

#wamp
403错误
一，Apache部分：
路径：/wamp/bin/apache/Apache2.2.21/conf/httpd.conf
将所有Directory段内的deny条件都修改为allow from all
二，phpmyadmin部分：
路径：/wamp/alias/phpmyadmin.conf
同理，将deny条件修改为allow from all
最后重启所有服务，问题解决




