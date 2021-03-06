# git
---

git checkout -b [分支名] [远程名]/[分支名]
git pull <远程主机名> <远程分支名>:<本地分支名>
git pull repo rbr:lbr
git pull my release/V1.3:release/V1.3

# github repositories
## data
git@github.com:JasonLiu798/KnowledgeBase.git
git@github.com:JasonLiu798/JasonLiu798.github.io.git

## project
git@github.com:JasonLiu798/leetcode.git
git@github.com:JasonLiu798/bashlib.git
git@github.com:JasonLiu798/hbasecomponent.git
git@github.com:JasonLiu798/jsonblog.git
git@github.com:JasonLiu798/BlogSearchWithLucene.git
git@github.com:JasonLiu798/lucenestudy.git
## backup
git@github.com:JasonLiu798/backup.git
## gitcafe
git@gitcafe.com:async/uweatwhat.git


---
# git study
[廖雪峰git](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
[git sheet](http://www.git-tower.com/blog/assets/2013-05-22-git-cheat-sheet/cheat-sheet-large01.png)
![开发一般模式图](http://pic.browser.360.cn/t019342927afbbecc13.png)
[Git Community Book 中文版](http://gitbook.liuhui998.com/index.html)
[pro git](https://www.gitbook.com/book/gitbookio/progit)

---
# common command
## init
    git init

## delete one 删除
    git rm -r --cached {filename}
    git rm -r -n --cached  */src/\*      //-n 展示要删除的文件列表预览

## add one
    git add {filename}
    git add .

## commit
    git commit -m {"comments"}

## chk status
    git status

## chk different
    git diff
    git diff HEAD -- {filename}
    git diff {version1} {version2}
    git diff {version1}:{filename} {version2}:{filename}

    git diff b030b905e5ccd7f85a89da:src/cn/com/cnpc/backGroundServer/component/AH809Component/TransportHandler.java 48a3cf0e615af714d0df7:src/cn/com/cnpc/backGroundServer/component/AH809Component/TransportHandler.java

## git log
    git log
    git log –pretty=oneline

    git reflog
    git rm -r --cached filename
    git show [version id]

## rebase
[git rebase 基础](http://blog.csdn.net/hudashi/article/details/7664631)
[git rebase 讨论 segmentfault](http://segmentfault.com/q/1010000000430041)
在不用-f的前提下，想维持树的整洁，方法就是：在git push之前，先git fetch，再git rebase。
git fetch origin master
git rebase origin/master
解决冲突，最后 git add * ，但不许要git commit
解决后，执行 git rebase --continue
git push


## reset
[git reset简介](http://blog.csdn.net/hudashi/article/details/7664464)

    git reset --hard commit_id      #强制撤销
     git reset HEAD file                    #commited,then upper
     git reset a4e215a7[version] filename   #back to old version

    #冲突解决，强制覆盖本地文件
    git fetch --all
    git reset --hard origin/master

```
#远端回退c3
提交c1->c2->c3
git reset --hard c2
git reset --soft c3

```
[revert](http://christoph.ruegg.name/blog/git-howto-revert-a-commit-already-pushed-to-a-remote-reposit.html)

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


----
#clean
git clean
确认要删除的文件
git clean -fd -n
如果以上命令给出的文件列表是你想删除的， 那么接下来执行
git clean -f -d或者git clean -fd就可以了。
其中-f表示文件-d表示目录, 如果还要删除.gitignore中的文件那么再加上-x
如果git submodule中也存在需要删除的文件那么需要再加个-f， 变成git clean -dff
[reference](http://stackoverflow.com/questions/61212/how-do-i-remove-local-untracked-files-from-my-current-git-branch)


---
# Branch
[远程分支](http://www.lxway.com/12944846.htm)
## new branch
    git branch [branch name]
    git checkout -b [branch name]
    等价于
        git branch [branch name]
        gir checkout [branch name]

## git branch 查看分支
```bash
git branch
git branch -av      #查看远程分支
git br -vv #查看本地分支跟踪的远程分支

```

## 切换分支
    git checkout [branch name]

## git checkout 签出分支
    git checkout <name>
    git checkout -b <name>      #change & new
    git checkout -b [分支名] [远程名]/[分支名]
    git co -b
    
    签出远程分支
    git fetch
    git checkout -b [local-branchname] origin/[remote_branchname]

    git checkout --track origin/serverfix

## git branch 删除
```bash
git branch -d <name>

#删除 本地存在  and 远端不存在 分支
git remote show origin #查看
git fetch -p #删除
#删除远程分支
git push origin --delete <branchName>
```

## git branch 重命名本地分支
    git branch -m {oldName} {newName}
## 重命名远程分支
    git push --delete origin {oldName}      //删除远程分支
    git branch -m {oldName} {newName}
    git push origin {newName}
## 设置远端分支
    git branch --set-upstream-to=xxx
    git branch --unset-upstream xxx
    git push -u origin my_branch

## git pull
FETCH_HEAD：是一个版本链接，记录在本地的一个文件中，指向着目前已经从远程仓库取下来的分支的末端版本
git pull : 首先，基于本地的FETCH_HEAD记录，比对本地的FETCH_HEAD记录与远程仓库的版本号，然后git fetch 获得当前指向的远程分支的后续版本的数据，然后再利用git merge将其与本地的当前分支合并。

## git fetch
    git fetch -p    #fetch之后删除掉没有与远程分支对应的本地分支
    git fetch [remote responsity] [remote branch]:[local branch] #获取远端分支到本地
    git checkout -b [分支名] [远程名]/[分支名] #并创建本地分支


## merge
    git merge --no-ff -m {"merge with no-ff"} {merge branchname}


## git log
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
##moba
git-remote-ftp.exe: error while loading shared libraries:
apt-get install libopenssl100
apt-cyg install ca-certificates
cygcheck /usr/lib/git-core/git-remote-https.exe

















