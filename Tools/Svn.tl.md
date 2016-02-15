#svn
---
[SVN命令使用详解](http://blog.sina.com.cn/s/blog_963453200101eiuq.html)
##检出
    svn checkout [svn://192.168.1.1/pro/domain] --username xxx --password xxxx
    简写：svn co
    svn add [filename]
##提交
svn　commit　-m　“提交备注信息文本“　[-N]　[--no-unlock]　文件名
svn　ci　-m　“提交备注信息文本“　[-N]　[--no-unlock]　文件名
必须带上-m参数，参数可以为空，但是必须写上-m

    svn commit -m "add test file for my test" filename
    svn ci

    svn lock -m "lock test file" filename
    svn unlock PATH

##更新文件
svn　update
svn　update　-r　修正版本　文件名
svn　update　文件名
    svn update -r m path

##
    svn status path

##导出
导出(导出一个干净的不带.svn文件夹的目录树)
svn  export  [-r 版本号]  http://路径(目录或文件的全路径) [本地目录全路径]　--username　用户名
svn  export  [-r 版本号]  svn://路径(目录或文件的全路径) [本地目录全路径]　--username　用户名
svn  export  本地检出的(即带有.svn文件夹的)目录全路径  要导出的本地目录全路径

##删除文件
svn　delete　svn://路径(目录或文件的全路径) -m “删除备注信息文本”
推荐如下操作：
svn　delete　文件名 
svn　ci　-m　“删除备注信息文本”

##加锁/解锁 
svn　lock　-m　“加锁备注信息文本“　[--force]　文件名 
svn　unlock　文件名
例子：
svn lock -m “锁信测试用test.php文件“ test.php 
svn unlock test.php


##比较差异 
svn　diff　文件名 
svn　diff　-r　修正版本号m:修正版本号n　文件名

##查看文件或者目录状态
svn st 目录路径/名
svn status 目录路径/名＜－ 目录下的文件和子目录的状态，正常状态不显示 
　　　　　　　　　　　　　【?：不在svn的控制中；  M：内容被修改；C：发生冲突；
　　　　　　　　　　　　　　A：预定加入到版本库；K：被锁定】 
svn  -v 目录路径/名
svn status -v 目录路径/名＜－ 显示文件和子目录状态
　　　　　　　　　　　　　　【第一列保持相同，第二列显示工作版本号，
　　　　　　　　　　　　　　　第三和第四列显示最后一次修改的版本号和修改人】 
注：svn status、svn diff和 svn revert这三条命令在没有网络的情况下也可以执行的，
　　原因是svn在本地的.svn中保留了本地版本的原始拷贝。 

##查看文件详细信息
svn　info　文件名
例子：
svn info test.php
