
#settings

##tag
[laravel angular标签冲突](https://scotch.io/quick-tips/quick-tip-using-laravel-blade-with-angularjs)
Change the Laravel Blade Tags
Laravel uses Blade and Blade comes with a way to change the tags. If you want to keep the Angular syntax default, then use this method.
Blade::setContentTags('<%', '%>'); // for variables and all things Blade
Blade::setEscapedContentTags('<%%', '%%>'); // for escaped data


##sql调试
```php
$queries = DB::getQueryLog();
$last_query = end($queries);
Log::info('post stat:'.$last_query['query']);

‘query’=>
‘bindings’=>
‘time’=>
```

---
#坑
关系函数名不能有下划线
