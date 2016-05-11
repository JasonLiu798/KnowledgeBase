#git
---
# github repositories
##data
git@github.com:JasonLiu798/KnowledgeBase.git
git@github.com:JasonLiu798/JasonLiu798.github.io.git

##project
git@github.com:JasonLiu798/leetcode.git
git@github.com:JasonLiu798/bashlib.git
git@github.com:JasonLiu798/hbasecomponent.git
git@github.com:JasonLiu798/jsonblog.git
git@github.com:JasonLiu798/BlogSearchWithLucene.git
git@github.com:JasonLiu798/lucenestudy.git
##backup
git@github.com:JasonLiu798/backup.git
##gitcafe
git@gitcafe.com:async/uweatwhat.git


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
```bash
git branch
git branch -av      #查看远程分支
git br -vv #查看本地分支跟踪的远程分支

```

##切换分支
    git checkout [branch name]

## git checkout 签出分支
    git checkout <name>
    git checkout -b <name>      #change & new
    git checkout -b [分支名] [远程名]/[分支名]
    git co -b 
    签出远程分支
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

##git pull
FETCH_HEAD：是一个版本链接，记录在本地的一个文件中，指向着目前已经从远程仓库取下来的分支的末端版本
git pull : 首先，基于本地的FETCH_HEAD记录，比对本地的FETCH_HEAD记录与远程仓库的版本号，然后git fetch 获得当前指向的远程分支的后续版本的数据，然后再利用git merge将其与本地的当前分支合并。

##git fetch
    git fetch -p    #fetch之后删除掉没有与远程分支对应的本地分支
    git fetch [remote responsity] [remote branch]:[local branch] #获取远端分支到本地
    git checkout -b [分支名] [远程名]/[分支名] #并创建本地分支


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




---
#git config common configuration
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
    
##配色
git config --global color.ui auto
git config --global color.status auto  
git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto

##useful shortcut
co表示checkout，ci表示commit，br表示branch：
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.cm 'commit -m'
git config --global alias.cam 'commit -a -m'
git config --global alias.c commit
git config --global alias.cl clone
git config --global alias.s status
git config --global alias.br branch
git config --global alias.bra 'branch -a'
git config --global alias.unstage 'reset HEAD'
git config --global alias.last 'log -1'
git config --global alias.lg "log "
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

`git log颜色版`
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --graph --abbrev-commit"

`git log无颜色版（moba颜色显示有问题）`
git config --global alias.lg "log --pretty=format:'%t-%an-%cr-%s' --abbrev-commit" 
git config --global alias.lg "log --pretty=format:'%t-%an-%cr-%s' --abbrev-commit --graph"

###--pretty=format参数
%H   提交对象（commit）的完整哈希字串 
%h   提交对象的简短哈希字串 
%T   树对象（tree）的完整哈希字串 
%t   树对象的简短哈希字串 
%P   父对象（parent）的完整哈希字串 
%p   父对象的简短哈希字串 
%an  作者（author）的名字 
%ae  作者的电子邮件地址
%ad  作者修订日期-（可以用 -date= 选项定制格式）
%ar  作者修订日期-相对格式(1 day ago)
%aD  作者修订日期-RFC2822格式
%ar  作者修订日期-相对日期
%at  作者修订日期-UNIX timestamp
%ai  作者修订日期-ISO 8601 格式
%cn  提交者(committer)的名字 
%ce  提交者的电子邮件地址
%cd  提交日期-(--date= 制定的格式)
%cD  提交日期-RFC2822格式
%cr  提交日期-相对日期
%ct  提交日期-UNIX timestamp
%ci  提交日期-ISO 8601 格式
%d:  ref名称
%s:  提交的信息标题
%b:  提交的信息内容
%Cred: 切换到红色 
%Cgreen: 切换到绿色 
%Cblue: 切换到蓝色
%Creset: 重设颜色 
%C(...): 制定颜色, as described in color.branch.* config option 
%n:  换行
作者（author）和提交者（committer）之间差别:作者指的是实际作出修改的人，提交者指的是最后将此工作成果提交到仓库的人。所以，当你为某个项目发布补丁，然后某个核心成员将你的补丁并入项目时，你就是作者，而那个核心成员就是提交者


##git add proxy
http://segmentfault.com/q/1010000000118837

##ssh fix
~/.ssh/config
Host github.*
HostName github.com
PubkeyAuthentication yes
IdentityFile ~/.ssh/github

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
##moba
git-remote-ftp.exe: error while loading shared libraries:
apt-get install libopenssl100
apt-cyg install ca-certificates
cygcheck /usr/lib/git-core/git-remote-https.exe



---
#gitignore
```
# maven ignore
target/
*.jar
*.war
*.zip
*.tar
*.tar.gz

# eclipse ignore
.settings/
.project
.classpath
classes/

# idea ignore
.idea/
*.ipr
*.iml
*.iws

#python 
*.pyc

# temp ignore
*.log
*.cache
*.diff
*.patch
*.tmp
*.logs
*.bak
*.swp
*.swo

```

















