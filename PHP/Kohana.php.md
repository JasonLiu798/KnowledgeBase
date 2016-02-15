
url
Url::base();
Url::base(TRUE);
echo Url::base(FALSE, TRUE);



# 去除index.php
## bootstrap.php
Kohana::init(array(
        'base_url'   => '/kohana/',
        'errors'     => TRUE,
        'index_file' => FALSE
));
##.htaccess
根据实际情况修改RewriteBase
RewriteEngine On
RewriteBase /kohana/
<Files .*>
    Order Deny,Allow
    Deny From All
</Files>
RewriteRule ^(?:application|modules|system)\b.* index.php/$0 [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule .* index.php/$0 [PT]


# 模板
## 页面
'''
<html xmlns=”http://www.w3.org/1999/xhtml” dir=”ltr” lang=”en-US”>
<head profile=”http://gmpg.org/xfn/11″>
<title><?php echo $title ?></title>
<meta http-equiv=”content-type” content=”text/html; charset=UTF-8″ />
<?php foreach ($styles as $file => $type) echo HTML::style($file, array(‘media’ => $type)), “\n” ?>
<?php foreach ($scripts as $file) echo HTML::script($file), “\n” ?>
</head>
<body>
<?php echo $content ?>
</body>
</html>
'''
## Controller_Template
class Controller_Demo extends Controller_Template
{
    public $template = 'demo/template';
    /**
     * before()方法在你的控制器动作执行前被调用
     * 在我们的模板控制器中，我们覆盖了这个方法，那么我们就能设置默认值。
     * 那么这些变量需要改变的时候我们的控制器也能使用它们
     */
    public function before()
    {
        parent::before();
        if ($this->auto_render)
        {
            // Initialize empty values
            $this->template->title   = '';
            $this->template->content = '';
            $this->template->styles = array();
            $this->template->scripts = array();
        }
    }
    /**
     * after()方法在控制器动作执行后调用
     * 在我们的模板控制器中，我们覆写了这个方法，那么我们就能
     * 在模板显示之前做最后的一些改变
     */
    public function after()
    {
        if ($this->auto_render)
        {
            $styles = array(
                    'media/css/screen.css' => 'screen, projection',
                    'media/css/print.css' => 'print',
                    'media/css/style.css' => 'screen',
                       );
            $scripts = array(
                    'http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js',
                    );
            $this->template->styles = array_merge( $this->template->styles, $styles );
            $this->template->scripts = array_merge( $this->template->scripts, $scripts );
        }
        parent::after();
    }
}


#validate

orm
protected $_rules = array();
protected $_callbacks = array();
protected $_filters = array();
protected $_labels = array();

orm->check()
    $this->_validate()
        $this->_validate->rules($field, $rules);
        $this->_validate->filters($field, $filters);
        $this->_validate->label($field, $label);
        $this->_validate->callback($field, array($this, $callback));
            $validation->callback('username', array($this, 'check_username'));
    $this->_validate->check()



rules($field, array $rules)
    foreach ($rules as $rule)
    {
        $this->rule($field, $rule[0], Arr::get($rule, 1));
    }
    


