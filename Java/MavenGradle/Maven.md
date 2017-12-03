#Maven
---

alias mvnv='mvn versions:set -DnewVersion='



#pom.xml配置
##添加本地包
```xml
<dependency>
  <groupId>com.test</groupId>
  <artifactId>test</artifactId>
  <version>1.0.0</version>
  <scope>system</scope>
  <systemPath>${project.basedir}/lib/xxx.jar</systemPath>
</dependency>
```

mvn install:install-file -Dfile=[your file] -DgroupId=[xxxx] -DartifactId=[xxxx] -Dversion=[xxxx] -Dpackaging=[pom|jar|other]  

mvn deploy:deploy-file -Dfile=pom.xml -DgroupId=[xxxx] -DartifactId=[xxxx] -Dversion=[xxxx] -Dpackaging=[pom|jar|other] -DrepositoryId=[id] -Durl=[repo url]  

mvn deploy:deploy-file -Dfile=pom.xml -DgroupId=com.atjl -DartifactId=common-tools-parent -Dversion=1.1.0 -Dpackaging=pom -DrepositoryId=releases -Durl=http://nexus.sf-express.com/nexus/content/repositories/releases/  

#setup
## eclipse.ini
-vm
C:\Program Files\Java\jdk1.7.0_75\bin\javaw.exe
## Q
    <dependency>
      <groupId>jdk.tools</groupId>
      <artifactId>jdk.tools</artifactId>
      <version>1.5</version>
    </dependency>

## evn
M2_HOME

---
#settings.xml
## mirror、repository、profile关系
http://my.oschina.net/qjx1208/blog/201085
#scope
compile
默认的scope，表示 dependency 都可以在生命周期中使用。而且，这些dependencies 会传递到依赖的项目中。适用于所有阶段，会随着项目一起发布
provided
跟compile相似，但是表明了dependency 由JDK或者容器提供，例如Servlet AP和一些Java EE APIs。这个scope 只能作用在编译和测试时，同时没有传递性。????????
runtime
表示dependency不作用在编译时，但会作用在运行和测试时，如JDBC驱动，适用运行和测试阶段。
test
表示dependency作用在测试时，不作用在运行时。 只在测试时使用，用于编译和运行测试代码。不会随项目发布。
system
跟provided 相似，但是在系统中要以外部JAR包的形式提供，maven不会在repository查找它。

<distributionManagement>
    <repository>
        <id>releases</id>
        <name>发布版本仓库地址</name>
        <url>xxx</url>
    </repository>
    <snapshotRepository>
        <id>snapshots</id>
        <name>快照版本仓库地址</name>
        <url>http://xxx</url>
    </snapshotRepository>
</distributionManagement>

<mirror>
  <id>nexus</id>
  <mirrorOf>*</mirrorOf>
  <name>Human Readable Name for this Mirror.</name>
  <url>http://xxxx</url>
</mirror>

<servers>
    <server>
      <id>releases</id>
      <username>aaa</username>
      <password>aaa</password>
    </server>
    <server>
      <id>snapshots</id>
      <username>aaa</username>
      <password>aaa</password>
    </server>
</servers>

##local
```
<profiles>
    <profile>
       <id>jdk-1.7</id>
       <activation>
              <activeByDefault>true</activeByDefault>
              <jdk>1.7</jdk>
       </activation>
       <properties>
              <maven.compiler.source>1.7</maven.compiler.source>
              <maven.compiler.target>1.7</maven.compiler.target>
              <maven.compiler.compilerVersion>1.7</maven.compiler.compilerVersion>
       </properties>
    </profile>
    <profile>
         <id>jason-dev-repositories</id>
         <repositories>
              <repository>
                   <id>jason</id>
                   <url>http://xxx</url>
                   <releases>
                        <enabled>true</enabled>
                   </releases>
                   <snapshots>
                        <enabled>true</enabled>
                        <updatePolicy>always</updatePolicy>
                   </snapshots>
              </repository>
         </repositories>
    </profile>
</profiles>
<activeProfiles>
    <activeProfile>jdk-1.7</activeProfile>
    <activeProfile>jason-dev-repositories</activeProfile>
</activeProfiles>
```



---

#加密
--encrypt-master-password
--encrypt-password 
${user.home}/.m2 目录下创建settings-security.xml
```xml
<?xml version="1.0" encoding="UTF-8"?> 
<settingsSecurity> 
<master>123</master> 
</settingsSecurity>
```



#cmd
常用
alias mccpi='mvn clean compile package install -Dmaven.test.skip=true'
alias mvni='mvn clean compile package install -Dmaven.test.skip=true'
alias mvnp='mvn clean compile package -Dmaven.test.skip=true'
##lifecycle
mvn clean compile
mvn clean test
mvn clean package -Prelease
mvn clean install

mvn archetype:generate
##create
mvn archetype:create -DgroupId=com.jason -DartifactId=jersey -DarchetypeArtifactId=maven-archetype-webapp

##导出依赖jar包
mvn dependency:copy-dependencies
mvn dependency:copy-dependencies -DoutputDirectory=lib
mvn dependency:copy-dependencies -DoutputDirectory=lib   -DincludeScope=compile

##指定项目
-pl xxx,xxx
## 导出jar包
mvn dependency:copy-dependencies
mvn dependency:copy-dependencies -DoutputDirectory=lib -DincludeScope=compile

mvn dependency:list   #最终列表
mvn dependency:tree   #树型结构
mvn dependency:analyze

##跳过测试
-Dmaven.test.skip=true

##-U
该参数能强制让Maven检查所有SNAPSHOT依赖更新，确保集成基于最新的状态，如果没有该参数，Maven默认以天为单位检查更新，而持续集成的频率应该比这高很多
##-e
如果构建出现异常，该参数能让Maven打印完整的stack trace，以方便分析错误原因。

##-B参数
该参数表示让Maven使用批处理模式构建项目，能够避免一些需要人工参与交互而造成的挂起状态。

##-Dmaven.repo.local参数
如果持续集成服务器有很多任务，每个任务都会使用本地仓库，下载依赖至本地仓库，为了避免这种多线程使用本地仓库可能会引起的冲突，可以使用-Dmaven.repo.local=/home/juven/ci/foo-repo/这样的参数为每个任务分配本地仓库。

##source 生成源码包
mvn source:jar
##发布源码
```xml
    <build>
        <plugins>
            <!-- 要将源码放上去，需要加入这个插件 -->
            <plugin>
                <artifactId>maven-source-plugin</artifactId>
                <version>2.1</version>
                <configuration>
                    <attach>true</attach>
                </configuration>
                <executions>
                    <execution>
                        <phase>compile</phase>
                        <goals>
                            <goal>jar</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

```

##source 下源码/文档
mvn dependency:sources
mvn dependency:resolve -Dclassifier=javadoc

## mirrors
<mirror>
<id>central</id>
<mirrorOf>central</mirrorOf> <!-- replace central-->
<name>central</name>
<url>https://repo1.maven.org/maven2</url>
</mirror>
<mirror>
<id>ibiblio</id>
<mirrorOf>external:*,!repo-osc-thirdparty,!repo-iss</mirrorOf>
<name>Human Readable Name for this Mirror.</name>
<url>http://mirrors.ibiblio.org/maven2/</url>
</mirror>
<mirror>
<id>mirror-osc</id>
<mirrorOf>external:*,!repo-osc-thirdparty,!repo-iss</mirrorOf>
<url>http://maven.oschina.net/content/groups/public/</url>
</mirror>


## 仓库搜索
* [Sonatype Nexus](http://repository.sonatype.org/)
* [Jarvana](http://www.jarvana.com/jarvana/)
* [MVNbrowser](http://www.mvnbrowser.com)
* [MVNRepository](http://mvnRepository.com/)

---
# local add jar
## oracle jdbc
mvn install:install-file -DgroupId=com.oracle -DartifactId=ojdbc14 -Dversion=10.2.0.4.0 -Dpackaging=jar -Dfile=ojdbc14-10.2.0.4.0.jar

mvn install:install-file -DgroupId=org.apache.hbase -DartifactId=hbase -Dversion=1.0.1 -Dpackaging=jar -Dfile=hbase-client-1.0.1.1.jar

## jdk-tools
    C:\Program Files\Java\jdk1.7.0_75\lib>
    mvn install:install-file -DgroupId=jdk.tools -DartifactId=jdk.tools -Dpackaging=jar -Dversion=1.7 -Dfile=tools.jar -DgeneratePom=true

    <dependency>
        <groupId>jdk.tools</groupId>
        <artifactId>jdk.tools</artifactId>
        <version>1.6</version>
    </dependency>


---
#plugins 常用插件
##编译插件
```xml
<!-- 统一编译版本 -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.1</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <!-- 这下面的是可选项 -->
        <meminitial>128m</meminitial>
        <maxmem>512m</maxmem>
        <fork>true</fork> <!-- fork is enable,用于明确表示编译版本配置的可用 -->
        <encoding>UTF-8</encoding>
        <compilerArguments>
            <!--<extdirs>../web/src/main/webapp/WEB-INF/lib</extdirs>-->
        </compilerArguments>
    </configuration>
</plugin>
```

##跳过测试
http://maven.apache.org/surefire/maven-surefire-plugin/examples/inclusion-exclusion.html
```xml
<!-- 跳过测试 -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>2.9</version>
    <configuration>
        <skipTests>true</skipTests>
    </configuration>
</plugin>

<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>  
    <configuration>  
        <argLine>-Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=256m</argLine>    
        <additionalClasspathElements>  
            <additionalClasspathElement>  
                ${basedir}/target/test-classes  
            </additionalClasspathElement>  
        </additionalClasspathElements>  
        <includes>  
            <include>**/*Test.java</include> 
        </includes> 
        <excludes> 
            <exclude>**/TestConstants.java</exclude>  
        </excludes>  
        <forkMode>pertest</forkMode>  
    </configuration>  
</plugin>

```
forkmode属性中指明是要为每个测试创建一个进程，还是所有测试在同一个进程中完成。
forkMode 可设置值有 “never”， “once”， “always” 和 “pertest”。
pretest： 每一个测试创建一个新进程，为每个测试创建新的JVM是单独测试的最彻底方式，但也是最慢的，不适合hudson上持续回归。
once：在一个进程中进行所有测试。once为默认设置，在Hudson上持续回归时建议使用默认设置。
always：在一个进程中并行的运行脚本，Junit4.7以上版本才可以使用，surefire的版本要在2.6以上提供这个功能，其中 threadCount：执行时，指定可分配的线程数量。只和参数parallel配合使用有效。默认：5。
<forkMode>always</forkMode>  
<parallel>methods</parallel>  
<threadCount>4</threadCount>



##打包可执行 jar包
```xml
<!-- 打包可执行 jar -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>2.4</version>
    <configuration>
        <archive>
            <manifest>
                <addClasspath>true</addClasspath>
                <classpathPrefix>lib/</classpathPrefix>
                <mainClass>com.sf.inv.test.TestClient</mainClass>
            </manifest>
        </archive>
    </configuration>
</plugin>
```

##拷贝依赖lib jar
```xml
<!-- 拷贝 依赖jar -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-dependency-plugin</artifactId>
    <executions>
        <execution>
            <id>copy</id>
            <phase>package</phase>
            <goals>
                <goal>copy-dependencies</goal>
            </goals>
            <configuration>
                <outputDirectory>
                    ${project.build.directory}/lib
                </outputDirectory>
            </configuration>
        </execution>
    </executions>
</plugin>
```

##version 版本号插件，统一修改版本号
mvn versions:set -DnewVersion=2.3-SNAPSHOPT
```xml
<plugin>
    <artifactId>versions-maven-plugin</artifactId>
    <groupId>org.codehaus.mojo</groupId>
    <version>2.2</version>
    <configuration>
        <newVersion>1.1.1</newVersion>
    </configuration>
</plugin>
```

##代码混淆
proguard-maven-plugin
```xml
  <plugin>
      <groupId>com.pyx4me</groupId>
      <artifactId>proguard-maven-plugin</artifactId>
      <executions>
         <execution>
             <phase>package</phase>
             <goals><goal>proguard</goal></goals>
         </execution>
      </executions>
      <configuration>
          <proguardVersion>4.4</proguardVersion>
          <libs>
              <lib>${java.home}/lib/rt.jar</lib>
          </libs>
      </configuration>
      <dependencies>
          <dependency>
              <groupId>net.sf.proguard</groupId>
              <artifactId>proguard</artifactId>
              <version>4.4</version>
              <scope>runtime</scope>
          </dependency>
      </dependencies>
  </plugin>
```

assembly
http://blueram.iteye.com/blog/1684070
## main class
    shade
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-shade-plugin</artifactId>
        <version>1.4</version>
        <executions>
          <execution>
            <phase>package</phase>
            <goals>
              <goal>shade</goal>
            </goals>
            <configuration>
              <transformers>
                <transformer
                  implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                  <mainClass>com.jason.dao.GpsDAO</mainClass>
                </transformer>
              </transformers>
            </configuration>
          </execution>
        </executions>
      </plugin>

##check-type 代码检查
http://blog.csdn.net/kongxx/article/details/7750015


##tomcat7-maven-plugin
[maven自动部署到tomcat](http://blog.csdn.net/smilevt/article/details/8212075)

http://tomcat.apache.org/maven-plugin-2.0-beta-1/

    <plugin>
        <groupId>org.apache.tomcat.maven</groupId>
        <artifactId>tomcat7-maven-plugin</artifactId>
        <version>2.1</version>
        <configuration>
            <port>9090</port>
            <path>/mgr</path>
            <uriEncoding>UTF-8</uriEncoding>
            <finalName>mgr</finalName>
            <server>tomcat7</server>
        </configuration>
    </plugin>





---
#eclipse setting
maven转eclipse
http://blog.csdn.net/qjyong/article/details/9098213

Window->Preference->Java->Installed JREs->Edit
在Default VM arguments中设置
-Dmaven.multiModuleProjectDirectory=$M2_HOME

## plugin
### ruby dsl
https://github.com/takari/polyglot-maven

---
#idea setting
view->tool window->Maven Projects
## 插件
org.apache.maven.plugins:maven-idea-plugin:2.2.1:idea
http://maven.apache.org/plugins/maven-idea-plugin/idea-mojo.html

---
# Q&A
## -Dmaven.multiModuleProjectDirectory system propery is not set. Check $M2_HOME environment variable and mvn script match.

## No compiler is provided in this environment. Perhaps you are running on a JRE rather than a JDK?
下载java jdk，并安装java jdk。下载地址：http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
在eclipse的菜单中，进入 Window > Preferences > Java > Installed JREs > Execution Environments，选择JavaSE-1.6, 在右侧选择jdk.
然后在maven菜单中使用 “update project ...”.



## spring xsd
http://blog.csdn.net/leonzhouwei/article/details/9978771




---
#Maven仓库
http://tianya23.blog.51cto.com/1081650/386908/
```xml
<mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>
</mirror>
```

1、maven 仓库地址：
共有的仓库
http://repo1.maven.org/maven2/
http://repository.jboss.com/maven2/
http://repository.sonatype.org/content/groups/public/
http://mirrors.ibiblio.org/pub/mirrors/maven2/org/acegisecurity/

私有的仓库
http://repository.codehaus.org/
http://snapshots.repository.codehaus.org/
http://people.apache.org/repo/m2-snapshot-repository
http://people.apache.org/repo/m2-incubating-repository/

同时可以搭建自己的maven仓库：私服， 搭建的方式参考如下：
http://juvenshun.javaeye.com/blog/349534
2、收集的外部仓库地址
http://www.ibiblio.org/maven/mule/dependencies/maven2/






