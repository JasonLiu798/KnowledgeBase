server
{
    listen       80;
    server_name  api.tools.com;

    index index.html index.php;
    root  /apps/dat/web/working/api.tools.com;

      if (!-e $request_filename) {
      rewrite "^\/([^\/]+)\/([^\/?]+)([^?]*)?(.*)$" /index.php?vip_c=$1&vip_a=$2&vip_param=$3&$4 break;
      rewrite "^\/[^?]*?(.*)$" /index.php$1 break;
      rewrite "^\/.*$" /index.php break;
      }

      location ~* [^/]\.php(/|$) {
      fastcgi_pass  127.0.0.1:9000;
      fastcgi_param  SCRIPT_FILENAME  /apps/dat/web/working/api.tools.com/index.php;
      fastcgi_index index.php;
      include fcgi.conf;
      }

    access_log  /apps/logs/nginx/cas.access.log   log_access;
}

