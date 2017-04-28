




#热部署

[Dynamic Code Evolution VM](http://ssw.jku.at/dcevm/binaries/)
[](https://blog.jetbrains.com/idea/2013/07/get-true-hot-swap-in-java-with-dcevm-and-intellij-idea/)


##Jrebel
[idea-jrebel](https://plugins.jetbrains.com/plugin/4441-jrebel-for-intellij)

[](http://blog.csdn.net/shagoo/article/details/5529352)
然后拷贝到 %REBEL_HOME% 目录并添加该环境变量，进入目录运行 java -jar %REBEL_HOME%/jrebel.jar 生成根据本机 JVM 环境生成的 jrebel-bootstrap.jar 运行文件。
 
然后添加 MAVEN 运行环境变量：MAVEN_OPTS 值为 -noverify -Xbootclasspath/p:%REBEL_HOME%/jrebel-bootstrap.jar;%REBEL_HOME%/jrebel.jar 然后再配置目标项目的 pom.xml，关闭 maven 的 jetty 插件本身的 reload 配置：
 
<plugin>
<groupId>org.mortbay.jetty</groupId>
<artifactId>jetty-maven-plugin</artifactId>
<configuration>
<scanIntervalSeconds>0</scanIntervalSeconds>
</configuration>
</plugin>



