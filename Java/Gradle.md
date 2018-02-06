#gradle
---
#doc
[Gradle 1.12 翻译——第十六章. 使用文件](http://blog.csdn.net/maosidiaoxian/article/details/41113353)
[Gradle 1.12用户指南翻译——第三十九章. IDEA 插件](http://blog.csdn.net/maosidiaoxian/article/details/47291703)








---
#常用命令 cmd
##查看版本号
gradle -v
##编译执行某个task
gradle Task名
##静默编译执行某个task
gradle -q Task名（q表示quiet模式，表示编译执行Gradle脚本的过程中，只输出必要的信息. 除了quiet模式外，Gradle中还有其他三种模式）
##编译执行某个Project中的某个task
gradle -b Project名 Task名（Gradle默认只执行build.gradle文件中，自定义其他文件xxx.gradle编译运行显式指定Project名称，这里的build.gradle其实表示的就是build Project）
##显示所有的Project
gradle projects
##显示所有的task
gradle tasks
##显示gradle的gui
gradle --gui 或 gradle --gui&（后台运行）
##查找所有的gradle命令
gradle --help

##依赖树
gradle projects列出子项目
没有子项目
gradle dependencies
否则
Root project 'my-project'
+--- Project ':core'
|    +--- Project ':core:core1'
|    +--- Project ':core:core2'
gradle :core:core1:dependencies


http://www.jiechic.com/archives/the-idea-and-gradle-use-summary

---
#配置
##maven库
```
repositories {
    maven {
        url "http://maven.petrikainulainen.net/repo"
    }
}
//文件
flatDir {
        dirs 'lib'
    }
```


##依赖
```gradle
dependencies {
    compile group: 'foo', name: 'foo', version: '0.1'
}
//[group]:[name]:[version]
dependencies {
    compile 'foo:foo:0.1'
}
//多个
dependencies {
    compile (
        [group: 'foo', name: 'foo', version: '0.1'],
        [group: 'bar', name: 'bar', version: '0.1']
    )
}
dependencies {
    compile 'foo:foo:0.1', 'bar:bar:0.1'
}
```


---
#多模块
http://www.cnblogs.com/softidea/p/4525236.html



---
#setup
GRADLE_HOME=/opt/gradle
gradle -v

---
#仓库
##配置本地仓库
默认
GRADLE_USER_HOME=~/.gradle

##配置中央库
###单个项目
build.gradle
allprojects {
    repositories {
        maven{ url 'http://maven.oschina.net/content/groups/public/'}
    }
}

##总体
USER_HOME/.gradle/init.gradle
```
allprojects{
    repositories {
        def REPOSITORY_URL = 'http://maven.oschina.net/content/groups/public'
        all { ArtifactRepository repo ->
            if(repo instanceof MavenArtifactRepository){
                def url = repo.url.toString()
                if (url.startsWith('https://repo1.maven.org/maven2') || url.startsWith('https://jcenter.bintray.com/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $REPOSITORY_URL."
                    remove repo
                }
            }
        }
        maven {
            url REPOSITORY_URL
        }
    }
}

```


---
#download
https://gradle.org


---
#doc
http://www.cnblogs.com/CloudTeng/p/3417762.html

http://www.infoq.com/cn/news/2011/04/xxb-maven-6-gradle

---
#Q&A
##IDEA导入项目问题
Cannot change dependencies of configuration ':spring-orm-hibernate4:runtimeMerge' after it has been resolved.
https://github.com/spring-gradle-plugins/dependency-management-plugin/issues/56

