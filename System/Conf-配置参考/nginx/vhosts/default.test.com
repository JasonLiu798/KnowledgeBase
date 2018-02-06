 server
 {
    listen       80 default;
    server_name  default.vip.com redis.test.com zhushou.tools.test.com pf.tools.test.com;
    index index.html index.htm index.php;
    root  /apps/dat/web/working/tools.test.com;

    # Tomcat,Nodejs,Jar and etc
    #location / {
    #    proxy_pass http://127.0.0.1:8080;
    #    include /apps/conf/nginx/proxy.conf;
    #}

    location ~ .*\.(php|php5)?$
    {
      #fastcgi_pass  unix:/tmp/php-cgi.sock;
      fastcgi_pass  127.0.0.1:9000;
      fastcgi_index index.php;
      include fcgi.conf;
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|flv|ico)$
    {
      expires      302400s;
    }

    location ~ .*\.(js|css)?$
    {
      expires      302400s;
    }

    location ~ .*\.(html|htm|php)$
    {
      expires     180s;
    }

    access_log  off;

    location /vip-nginx-status {
      allow 125.76.229.113;
      allow 60.195.252.106;
      allow 60.195.249.83;
      allow 10.0.0.0/8;
      allow 127.0.0.1;
      deny all;
      stub_status on;
    }

    location = /php5fpm-status {
      allow 127.0.0.1;
      fastcgi_pass  127.0.0.1:9000;
      fastcgi_index index.php;
      include fcgi.conf;
    }

    location = /php5fpm-ping {
      allow 127.0.0.1;
      fastcgi_pass  127.0.0.1:9000;
      fastcgi_index index.php;
      include fcgi.conf;
    }
}
