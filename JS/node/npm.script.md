
npm root -g     #查看在你的系统中全局的路径。
npm config set prefix "D:\tools\nodejs\win"
npm config get prefix

# npm相关脚本
---
## 查看
npm -g outdated

## 升级
npm update <name>
升级自己
npm install -g npm

## 配置相关
npm config ls -l
npm config set cache "D:\\log\\npmc"
npm config get cache

## 依赖相关
npm install xxx -g 将模块安装到全局环境中
npm ls 查看安装的模块及依赖
npm ls -g 查看全局安装的模块及依赖
npm install xxx         安装模块
npm install xxx@1.1.1   安装1.1.1版本的xxx
npm uninstall xxx  (-g) 卸载模块

-save和save-dev可以省掉你手动修改package.json文件的步骤。
spm install module-name -save 自动把模块和版本号添加到dependencies部分
spm install module-name -save-dve 自动把模块和版本号添加到devdependencies部分



npm cache clean         清理缓存
npm help xxx            帮助
npm info xxx 		查看可用版本	
npm view moudleName dependencies  查看包的依赖关系
npm view moduleNames              查看node模块的package.json文件夹
npm view moduleName labelName     查看package.json文件夹下某个标签的内容
npm view moduleName repository.url  查看包的源文件地址
npm view moduleName engines       查看包所依赖的Node的版本
npm help folders                  查看npm使用的所有文件夹
npm rebuild moduleName            用于更改包内容后进行重建
npm outdated                      检查包是否已经过时，列出所有已经过时的包
npm update moduleName             更新node模块

add-user, adduser, apihelp, author, bin, bugs, c, cache,
completion, config, ddp, dedupe, deprecate, docs, edit,
explore, faq, find, find-dupes, get, help, help-search,
home, i, info, init, install, isntall, issues, la, link,
list, ll, ln, login, ls, outdated, owner, pack, prefix,
prune, publish, r, rb, rebuild, remove, repo, restart, rm,
root, run-script, s, se, search, set, show, shrinkwrap,
star, stars, start, stop, submodule, t, tag, test, tst, un,
uninstall, unlink, unpublish, unstar, up, update, v,
version, view, whoami


