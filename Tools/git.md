#git
[Git 使用规范流程](http://www.ruanyifeng.com/blog/2015/08/git-use-process.html)

---
# github repositories
##github
git@github.com:JasonLiu798/documents.git
git@github.com:JasonLiu798/hbasecomponent.git
git@github.com:JasonLiu798/mypythonlib.git
git@github.com:JasonLiu798/jsonblog.git
git@github.com:JasonLiu798/JasonLiu798.github.io.git
git@github.com:JasonLiu798/BlogSearchWithLucene.git
git@github.com:JasonLiu798/lucenestudy.git
git@github.com:JasonLiu798/leetcode-java.git
git@github.com:JasonLiu798/gpsfrontend.git
git@github.com:JasonLiu798/background-server.git

##backup
git@github.com:JasonLiu798/sublimetext3backup.git
git@github.com:JasonLiu798/linuxhomebackup.git


##gitcafe
git@gitcafe.com:async/uweatwhat.git

##lan
gpsbg
git@10.185.235.70:~/project/bsh/bgserver.git
git@10.185.2.45:~/project/gpsbg.git
git@10.185.234.135:~/project/gpsbg.git

git@10.185.234.135:~/project/bgserver-parent.git
git@10.185.234.135:~/project/bgserver-hbase.git
git@10.185.234.135:~/project/bgserver-communication.git

gpsfe
git@10.185.235.70:~/project/bsh/gpsfe.git
git@10.185.234.135:~/project/gpsfe.git
git@10.185.2.45:~/project/gpsfe.git

birt
git@10.185.2.45:~/project/birt.git

zf
git@10.185.2.45:~/project/sdzf.git
git@10.185.234.135:~/project/sdzf.git

config lib
git@10.185.234.135:~/project/servers.git
git@10.185.234.135:~/project/njzfcon.git
git@10.185.234.135:~/project/ahzfcon.git

##server
10.185.2.45 git xxzx2012
10.185.235.70 git xxzx2012

---
#git study
[廖雪峰git](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
[git sheet](http://www.git-tower.com/blog/assets/2013-05-22-git-cheat-sheet/cheat-sheet-large01.png)
![开发一般模式图](http://pic.browser.360.cn/t019342927afbbecc13.png)
[Git Community Book 中文版](http://gitbook.liuhui998.com/index.html)
[pro git](https://www.gitbook.com/book/gitbookio/progit)

---
#common command
##init
    git init

##delete one 删除
    git rm -r --cached {filename}
    git rm -r -n --cached  */src/\*      //-n 展示要删除的文件列表预览

##add one
    git add {filename}
    git add .

##commit
    git commit -m {"comments"}

##chk status
    git status

##chk different
    git diff
    git diff HEAD -- {filename}
    git diff {version1} {version2}
    git diff {version1}:{filename} {version2}:{filename}
    
    git diff b030b905e5ccd7f85a89da:src/cn/com/cnpc/backGroundServer/component/AH809Component/TransportHandler.java 48a3cf0e615af714d0df7:src/cn/com/cnpc/backGroundServer/component/AH809Component/TransportHandler.java

##git log
    git log
    git log –pretty=oneline
   
    git reflog
    git rm -r --cached filename
    git show [version id]

##rebase
[git rebase 基础](http://blog.csdn.net/hudashi/article/details/7664631)
[git rebase 讨论 segmentfault](http://segmentfault.com/q/1010000000430041)
在不用-f的前提下，想维持树的整洁，方法就是：在git push之前，先git fetch，再git rebase。
git fetch origin master
git rebase origin/master
解决冲突，最后 git add * ，但不许要git commit 
解决后，执行 git rebase --continue
git push

###git分支管理示例（本地开发分支）
[Git 问题, 一个 master, 多个新功能分支, 怎样有序地合并和提交?](http://segmentfault.com/q/1010000000181403)
git支持很多种工作流程，我们采用的一般是这样，远程创建一个主分支，本地每人创建功能分支，日常工作流程如下：
去自己的工作分支
$ git checkout -b work
工作
....
提交工作分支的修改
$ git commit -a
回到主分支
$ git checkout master
获取远程最新的修改，此时不会产生冲突
$ git pull
回到工作分支
$ git checkout work
用rebase合并主干的修改，如果有冲突在此时解决
$ git rebase master
处理冲突
git add ...
git rebase --continue
回到主分支
$ git checkout master
合并工作分支的修改，此时不会产生冲突。
$ git merge work
提交到远程主干
$ git push
这样做的好处是，远程主干上的历史永远是线性的。每个人在本地分支解决冲突，不会在主干上产生冲突。

[Git分支管理策略](http://www.ruanyifeng.com/blog/2012/07/git.html)



##reset
[git reset简介](http://blog.csdn.net/hudashi/article/details/7664464)

     git reset –-hard commit_id      #强制撤销
     git reset HEAD file                    #commited,then upper
     git reset a4e215a7[version] filename   #back to old version

    #冲突解决，强制覆盖本地文件
    git fetch --all  
    git reset --hard origin/master


##checkout
    git checkout -- filename        #not commit
    恢复某个已修改的文件（撤销未提交的修改）：
    $ git checkout file-name
    还原已提交的修改（已经提交过的修改，可以反悔～）
    git checkout -f

##revert
    还原最近一次提交的修改：
    $ git revert HEAD
    还原指定版本的修改：
    $ git revert commit-id

##git remote
    git remote add [origin] [git@server-name:path/repo-name.git]
    git remote add [origin] [git@10.185.235.70:/home/git/project/sdtrans/sdtrans.git]
    git remote show [remoteRespName]
###rename
    git remote rename {oldName} {newName}
    git remote rename origin s70
    git remote rename github gh
###change url
    git remote set-url [name] [newurl]
###clone one
    git clone git@10.185.235.70:/home/git/project/sdtrans/sdtrans.git


##push
    git push -u origin master   #first time
    git push origin master      #after first

##git tag 
    git tag 查看所有标签。
    git tag 用于新建一个标签，默认为HEAD，也可以指定一个commit id；
    git tag -a -m “blablabla…”可以指定标签信息；
    git tag -s -m “blablabla…”可以用PGP签名标签；
    命令git push origin 可以推送一个本地标签；
    命令git push origin –tags可以推送全部未推送过的本地标签；
    命令git tag -d 可以删除一个本地标签；
    命令git push origin :refs/tags/可以删除一个远程标签。

##git stash 
    git stash list
    git stash apply恢复，但是恢复后，stash内容并不删除，你需要用git stash drop来删除；
    git stash pop
    feature 分支分支还没有被合并，如果删除，将丢失掉修改，如果要强行删除，需要使用命令
    git branch -D feature-vulcan。
    查看远端库git remote -v
    git push origin master


---
#Branch
[远程分支](http://www.lxway.com/12944846.htm)
## new branch
    git branch [branch name]
    git checkout -b [branch name]
    等价于
        git branch [branch name]
        gir checkout [branch name]
    
## git branch 查看分支
    git branch
    git branch -av      #查看远程分支
##切换分支
    git checkout [branch name]
## git checkout 签出分支
    git checkout <name>
    git checkout -b <name>      #change & new
    git checkout -b [分支名] [远程名]/[分支名]
    签出远程分支
    git checkout --track origin/serverfix

## git branch 删除
    git branch -d <name>
## git branch 重命名本地分支
    git branch -m {oldName} {newName}
## 重命名远程分支
    git push --delete origin {oldName}      //删除远程分支
    git branch -m {oldName} {newName}
    git push origin {newName}

##git pull
FETCH_HEAD：是一个版本链接，记录在本地的一个文件中，指向着目前已经从远程仓库取下来的分支的末端版本
git pull : 首先，基于本地的FETCH_HEAD记录，比对本地的FETCH_HEAD记录与远程仓库的版本号，然后git fetch 获得当前指向的远程分支的后续版本的数据，然后再利用git merge将其与本地的当前分支合并。

##git fetch
    git fetch -p    #fetch之后删除掉没有与远程分支对应的本地分支
    git fetch [remote responsity] [remote branch]:[local branch]
###theory
理解 fetch 的关键, 是理解 FETCH_HEAD
FETCH_HEAD指的是: 某个branch在服务器上的最新状态'.
每一个执行过fetch操作的项目'都会存在一个FETCH_HEAD列表
位于.git/FETCH_HEAD
当前分支指向的FETCH_HEAD, 就是这个文件第一行对应的那个分支
* 如果没有显式的指定远程分支, 则远程分支的master将作为默认的FETCH_HEAD.
* 如果指定了远程分支, 就将这个远程分支作为FETCH_HEAD.

git fetch 这一步其实是执行了两个关键操作:
* 创建并更新所有远程分支的本地远程分支.
* 设定当前分支的FETCH_HEAD为远程服务器的master分支 (上面说的第一种情况)
PS:和push不同, fetch会自动获取远程`新加入'的分支.

git fetch origin
同上, 只不过手动指定了remote.

git fetch origin branch1
设定当前分支的 FETCH_HEAD' 为远程服务器的branch1分支`.
PS:在这种情况下, 不会在本地创建本地远程分支, 这是因为:
这个操作是git pull origin branch1的第一步, 而对应的pull操作,并不会在本地创建新的branch.
一个附加效果是:
这个命令可以用来测试远程主机的远程分支branch1是否存在, 如果存在, 返回0, 如果不存在, 返回128, 抛出一个异常.

git fetch origin branch1:branch2
* 首先执行上面的fetch操作
* 使用远程branch1分支在本地创建branch2(但不会切换到该分支), 
    如果本地不存在branch2分支, 则会自动创建一个新的branch2分支, 
    如果本地存在branch2分支, 并且是`fast forward', 则自动合并两个分支, 否则, 会阻止以上操作
* git fetch origin :branch2
等价于: git fetch origin master:branch2

1. git fetch            →→ 这将更新git remote 中所有的远程repo 所包含分支的最新commit-id, 将其记录到.git/FETCH_HEAD文件中
2. git fetch remote_repo         →→ 这将更新名称为remote_repo 的远程repo上的所有branch的最新commit-id，将其记录。 
3. git fetch remote_repo remote_branch_name        →→ 这将这将更新名称为remote_repo 的远程repo上的分支： remote_branch_name
4. git fetch remote_repo remote_branch_name:local_branch_name       →→ 这将这将更新名称为remote_repo 的远程repo上的分支： remote_branch_name ，并在本地创建local_branch_name 本地分支保存远端分支的所有数据。





##merge
    git merge --no-ff -m {"merge with no-ff"} {merge branchname}


##git log
[Git日志](http://gitbook.liuhui998.com/3_4.html)
    git log --graph --pretty=oneline --abbrev-commit
    git log --author=bob
    --pretty 参数可以使用若干表现格式
    git log --pretty=oneline 
    git log --pretty=short
    git log --pretty=format:'%h was %an, %ar, message: %s'
    git log --pretty=format:'%h : %s' --graph

    git log --graph --oneline --decorate --all
    See only which files have changed:
    git log --name-status
    see more:
    git log --help


    git reflog show或git log -g命令来看到所有的操作日志
    误操作恢复的过程很简单：
    1. 通过git log -g命令来找到我们需要恢复的信息对应的commitid，可以通过提交的时间和日期来辨别  <git reflog show>
    2. 通过git branch recover_branch commitid 来建立一个新的分支
    这样，我们就把丢失的东西给恢复到了recover_branch分支上了



[merge conflict](http://blog.csdn.net/chain2012/article/details/7476493)
问题（Non-fast-forward）的出现原因在于：git仓库中已经有一部分代码，所以它不允许你直接把你的代码覆盖上去。于是你有2个选择方式：
1，强推，即利用强覆盖方式用你本地的代码替代git仓库内的内容
git push -f
2，先把git的东西fetch到你本地然后merge后再push
`git fetch`
`git merge`
这2句命令等价于
`git pull`
`[branch "master"]
    remote = origin
    merge = refs/heads/master`
这等于告诉git2件事:
1，当你处于master branch, 默认的remote就是origin。
2，当你在master branch上使用git pull时，没有指定remote和branch，那么git就会采用默认的remote（也就是origin）来merge在master branch上所有的改变
如果不想或者不会编辑config文件的话，可以在bush上输入如下命令行：
`git config branch.master.remote origin`
`git config branch.master.merge refs/heads/master`


---
#git common configuration
##gitignore 配置
删除已经commit的文件，但不删除文件本身 `git rm --cached filename`
[gitignore配置模板](https://github.com/github/gitignore)

## generate ssh
github sshkey 
ssh-keygen -t rsa -C "jasondliu@qq.com"

## account
git config --global user.name "JasonLiu798"
git config --global user.email "jasondliu@qq.com"

## format
git config --global color.ui true

##useful shortcut
co表示checkout，ci表示commit，br表示branch：
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.unstage 'reset HEAD'
git config --global alias.last 'log -1'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

git config --global alias.lg "log --graph --pretty=oneline --abbrev-commit"

##配色
git config --global color.ui auto

##git add proxy
http://segmentfault.com/q/1010000000118837

##ssh fix
~/.ssh/config
Host github.*
HostName github.com
PubkeyAuthentication yes
IdentityFile ~/.ssh/github

##AutoCRLF
commit LF,chk out CRLF,win
    git config --global core.autocrlf true
commit LF,chk out nochange,mac
    git config --global core.autocrlf input
commit nochange,chk out nochange,linux
    git config --global core.autocrlf false

##SafeCRLF
refuse mix format
    git config --global core.safecrlf true
allow mix format
    git config --global core.safecrlf false
warn commit mix format
    git config --global core.safecrlf warn

##策略设置
本地分支和远程分支的绑定（tracking)，加上 rebase 策略：
[branch "master"]
    remote = origin
    merge = refs/heads/master
    rebase = true
更新代码（pull）的时候就会自动应用 rebase 而不是产生 merge commit，除非有其他情况产生，比如三方合并造成了冲突需要人共去干预。大部分时候还是很聪明的，只要团队里的习惯都良好，那么可以保持一个非常干净漂亮的树形。

---
#git server
sudo adduser git
sudo git init –bare sample.git
禁用shell登录
/etc/passwd文件完成。找到类似下面的一行：
git:x:1001:1001:,,,:/home/git:/bin/bash
改为：
git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell
git clone git@server:/srv/sample.git
##公钥管理
/home/git/.ssh/authorized_keys文件里就是可行的。如果团队有几百号人，就没法这么玩了，这时，可以用Gitosis来管理公钥
要像SVN那样变态地控制权限，用Gitolite。

---
#submodule
http://blog.csdn.net/wangjia55/article/details/24400501

---
#其他
##彻底删除文件
http://www.cnblogs.com/shines77/p/3460274.html
## 权限管理
https://github.com/sitaramc/gitolite/
##清理svn
find . -type d -name ".svn"|xargs rm -rf
find . -type d -name ".settings"|xargs rm -rf
##不跟踪已commit的文件
git update-index --assume-unchanged /path/to/file
##修改最近一次提交的注释
git commit --amend

---
#svn
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





















