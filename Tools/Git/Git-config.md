# git config
---
## gitignore 配置
删除已经commit的文件，但不删除文件本身 `git rm --cached filename`
[gitignore配置模板](https://github.com/github/gitignore)

## generate ssh
github sshkey
ssh-keygen -t rsa -C "jasondliu@qq.com"

## account
git config --global user.name "JasonLiu798"
git config --global user.email "jasondliu@qq.com"

git config --global push.default matching

## format
git config --global color.ui true

## AutoCRLF
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
git config --global alias.s 'status -uno'
git config --global alias.br branch
git config --global alias.bra 'branch -a'
git config --global alias.unstage 'reset HEAD'
git config --global alias.last 'log -1'
git config --global alias.lg "log "
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

`git log颜色版`
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --graph --abbrev-commit --date-order"

--graph 默认 --topo-order
按主分支排序

`git log无颜色版（moba颜色显示有问题）`
git config --global alias.lg "log --pretty=format:'%t-%an-%cr-%s' --abbrev-commit  --date-order"
git config --global alias.lg "log --pretty=format:'%t-%an-%cr-%s' --abbrev-commit --graph"

### --pretty=format参数
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


## git add proxy
http://segmentfault.com/q/1010000000118837

## ssh fix
~/.ssh/config
Host github.*
HostName github.com
PubkeyAuthentication yes
IdentityFile ~/.ssh/github

## 策略设置
本地分支和远程分支的绑定（tracking)，加上 rebase 策略：
[branch "master"]
    remote = origin
    merge = refs/heads/master
    rebase = true
更新代码（pull）的时候就会自动应用 rebase 而不是产生 merge commit，除非有其他情况产生，比如三方合并造成了冲突需要人共去干预。大部分时候还是很聪明的，只要团队里的习惯都良好，那么可以保持一个非常干净漂亮的树形。


---
# all
git config --global user.name "JasonLiu798test"
git config --global user.email "jasondliu@qq.comtest"

git config --global push.default matching
git config --global color.ui true
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.cm 'commit -m'
git config --global alias.cam 'commit -a -m'
git config --global alias.c commit
git config --global alias.cl clone
git config --global alias.s 'status -uno'
git config --global alias.br branch
git config --global alias.bra 'branch -a'
git config --global alias.unstage 'reset HEAD'
git config --global alias.last 'log -1'
git config --global color.status auto  
git config --global color.diff auto  
git config --global color.branch auto
git config --global color.interactive auto
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date-order"


## nocolor(moba color error)
git config --global alias.lg "log --graph --pretty=format:'%t-%an-%cr-%s' --abbrev-commit  --date-order"
git config --global color.diff false  









