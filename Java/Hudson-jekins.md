#自动集成
-----
#jekins

Branches to build
*/master
refs/remotes/origin/master
refs/remotes/origin/v1.0.2

##触发器
Poll SCM，表达式示例：
# every fifteen minutes
H/20 * * * *

##build
Root POM

Goals and options
clean deploy -B -e -U    
clean deploy -B -e -U -DskipTests 如果需要跳过测试
http://maven.apache.org/surefire/maven-surefire-plugin/examples/skipping-test.html

-U 该参数能强制让Maven检查所有SNAPSHOT依赖更新，确保集成基于最新的状态，如果没有该参数，Maven默认以天为单位检查更新，而持续集成的频率应该比这高很多。
-e 如果构建出现异常，该参数能让Maven打印完整的stack trace，以方便分析错误原因。
使用-B参数：该参数表示让Maven使用批处理模式构建项目，能够避免一些需要人工参与交互而造成的挂起状态。
-Dmaven.repo.local 如果持续集成服务器有很多任务，每个任务都会使用本地仓库，下载依赖至本地仓库，为了避免这种多线程使用本地仓库可能会引起的冲突，可以使用 -Dmaven.repo.local=/home/jenkins/ci/test-maven1-repo/ 这样的参数为每个任务分配本地仓库。
-Dmaven.repo.local 只有在构建任务怕和其他任务冲突时才建议使用

##E-mail Notification
Recipients 收件人
以下全部选中
Send e-mail for every unstable build
Send separate e-mails to individuals who broke the build
Send e-mail for each failed module

##Archive the artifacts
该配置会归档最新的构建，方便下载和浏览，避免之前需要在 URL 里面加转义，这种方法不需要加，表达式参考：
```
**/target/*.jar
**/target/*.jar,**/target/*.tar.gz
```

----
#hudson
java -jar hudson-3.2.2.war --httpPort=9090
http://127.0.0.1:9090


new mission
    
    Discard Old Builds
    Build trigger
        Poll SCM
            #every ten miniutes
            */10 * * * *