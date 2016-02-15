#git theory
---
#docs
[Git 使用规范流程](http://www.ruanyifeng.com/blog/2015/08/git-use-process.html)


---
#工作流
[Git Workflows and Tutorials](https://github.com/oldratlee/translations/blob/master/git-workflows-and-tutorials/README.md)
##集中式工作流
集中式工作流以中央仓库作为项目所有修改的单点实体
开发者开始先克隆中央仓库。在自己的项目拷贝中像SVN一样的编辑文件和提交修改；但修改是存在本地的，和中央仓库是完全隔离的。开发者可以把和上游的同步延后到一个方便时间点。
git pull --rebase
git rebase --continue
git rebase --abort

##功能分支工作流
功能分支工作流背后的核心思路是所有的功能开发应该在一个专门的分支，而不是在master分支上。 这个隔离可以方便多个开发者在各自的功能上开发而不会弄乱主干代码。 另外，也保证了master分支的代码一定不会是有问题的，极大有利于集成环境。

Pull Requests

生成一个快进的合并的命令行：（感觉步骤有些多:sweat:，欢迎给出更简捷的做法:two_hearts:）
```bash
git checkout marys-feature
git pull # 确认是最新的
git pull --rebase origin master # rebase新功能到master分支的顶部

git checkout master
git merge marys-feature # 合并marys-feature分支的修改，因为这个分支之前对齐（rebase）了master，一定是快进合并
git push
```

##Gitflow工作流
Gitflow工作流定义了一个围绕项目发布的严格分支模型
为不同的分支分配一个很明确的角色，并定义分支之间如何和什么时候进行交互。 除了使用功能分支，在做准备、维护和记录发布也使用各自的分支。 当然你可以用上功能分支工作流所有的好处：Pull Requests、隔离实验性开发和更高效的协作。

Gitflow工作流使用2个分支来记录项目的历史
    master分支存储了正式发布的历史
    develop分支作为功能的集成分支，也方便master分支上的所有提交分配一个版本号

##Forking工作流
 这种工作流不是使用单个服务端仓库作为『中央』代码基线，而让各个开发者都有一个服务端仓库。 这意味着各个代码贡献者有2个Git仓库而不是1个：一个本地私有的，另一个服务端公开的。
###优势
贡献的代码可以被集成，而不需要所有人都能push代码到仅有的中央仓库中。 开发者push到自己的服务端仓库，而只有项目维护者才能push到正式仓库。 这样项目维护者可以接受任何开发者的提交，但无需给他正式代码库的写权限。
效果就是一个分布式的工作流，能为大型、自发性的团队（包括了不受信的第三方）提供灵活的方式来安全的协作。 也让这个工作流成为开源项目的理想工作流。

##Pull Request工作流
开发者在本地仓库中新建一个专门的分支开发功能。
开发者push分支修改到公开的Bitbucket仓库中。
开发者通过Bitbucket发起一个Pull Request。
团队的其它成员review code，讨论并修改。
项目维护者合并功能到官方仓库中并关闭Pull Request。



---
#fetch-theory
理解 fetch 的关键, 是理解 FETCH_HEAD
FETCH_HEAD指的是: 某个branch在服务器上的最新状态'.
每一个执行过fetch操作的项目'都会存在一个FETCH_HEAD列表
位于.git/FETCH_HEAD
当前分支指向的FETCH_HEAD, 就是这个文件第一行对应的那个分支
* 如果没有显式的指定远程分支, 则远程分支的master将作为默认的FETCH_HEAD.
* 如果指定了远程分支, 就将这个远程分支作为FETCH_HEAD.
git fetch 这一步其实是执行了两个关键操作:
* 创建并更新所有远程分支的本地远程分支
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

git fetch origin branch_remote:branch_local
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



----

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
#git分支管理示例（本地开发分支）
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




