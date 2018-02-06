

#log
```xml
        <!-- log start -->
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.2</version>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.2.1</version>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-core</artifactId>
            <version>1.2.1</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>1.7.16</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>log4j-over-slf4j</artifactId>
            <version>1.7.12</version>
        </dependency>
        <!--log end -->
```


#proguard
```xml
			<plugin>
				<groupId>com.github.wvengen</groupId>
				<artifactId>proguard-maven-plugin</artifactId>
				<version>2.0.11</version>
				<executions>
					<execution>
						<!-- 混淆时刻，这里是打包的时候混淆-->
						<phase>package</phase>
						<goals>
							<!-- 使用插件的什么功能，当然是混淆-->
							<goal>proguard</goal>
						</goals>
					</execution>
				</executions>
				<configuration>
					<!-- 是否将生成的PG文件安装部署-->
					<attach>true</attach>
					<!-- 是否混淆-->
					<obfuscate>true</obfuscate>
					<!-- 指定生成文件分类 -->
					<attachArtifactClassifier>pg</attachArtifactClassifier>
					<options>
						<!-- 不混淆所有包名，本人测试混淆后WEB项目问题实在太多，毕竟Spring配置中有大量固定写法的包名-->
						<option>-keeppackagenames</option>
						<!-- 不混淆所有的set/get方法，毕竟项目中使用的部分第三方框架（例如Shiro）会用到大量的set/get映射-->
						<option>-keepclassmembers public class * {void set*(***);*** get*();}</option>

						<!-- JDK目标版本1.8-->
						<option>-target 1.8</option>
						<!-- 不做收缩（删除注释、未被引用代码）-->
						<option>-dontshrink</option>
						<!-- 不做优化（变更代码实现逻辑）-->
						<option>-dontoptimize</option>
						<!-- 不路过非公用类文件及成员-->
						<option>-dontskipnonpubliclibraryclasses</option>
						<option>-dontskipnonpubliclibraryclassmembers</option>
						<!-- 优化时允许访问并修改有修饰符的类和类的成员 -->
						<option>-allowaccessmodification</option>
						<!-- 确定统一的混淆类的成员名称来增加混淆-->
						<option>-useuniqueclassmembernames</option>

						<!-- 不混淆所有特殊的类-->
						<option>-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,LocalVariable*Table,*Annotation*,Synthetic,EnclosingMethod</option>

						<!-- 不混淆xx包下的所有类名，且类中的方法也不混淆
						<option>-keep class com.atjl.xx.** { &lt;methods&gt;; }</option>-->
					</options>
					<outjar>${project.build.finalName}-pg.jar</outjar>
					<!-- 添加依赖，这里你可以按你的需要修改，这里测试只需要一个JRE的Runtime包就行了
					<libs>
						<lib>${java.home}/lib/rt.jar</lib>
					</libs>-->
					<!-- 加载文件的过滤器，就是你的工程目录了-->
					<!--<inFilter>com/xxx/**</inFilter>-->
					<!-- 对什么东西进行加载，这里仅有classes成功，毕竟你也不可能对配置文件及JSP混淆吧-->
					<injar>classes</injar>
					<!-- 输出目录-->
					<outputDirectory>${project.build.directory}</outputDirectory>
				</configuration>
			</plugin>
```





