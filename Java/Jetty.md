
```xml
<plugin>
    <groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-maven-plugin</artifactId>
    <version>9.2.1.v20140609</version>
    <configuration>
        <reload>automatic</reload>
        <scanIntervalSeconds>0</scanIntervalSeconds>
        <stopKey>foo</stopKey>
        <stopPort>9999</stopPort>
        <httpConnector>
            <port>8080</port>
        </httpConnector>
<!--    <scanTargets>
        <scanTarget>../aaa/target/classes</scanTarget>
    </scanTargets>-->
<!--<useTestClasspath>true</useTestClasspath>-->
        <webAppConfig>
            <contextPath>/</contextPath>
            <defaultsDescriptor>
                D:\tools\jetty\jetty-distribution-9.2.7.v20150116\etc\webdefault.xml
            </defaultsDescriptor>
        </webAppConfig>
    </configuration>
</plugin>
```


            <!--
            <plugin>
                <groupId>org.zeroturnaround</groupId>
                <artifactId>jrebel-maven-plugin</artifactId>
                <version>1.1.5</version>
                <executions>
                    <execution>
                        <id>generate-rebel-xml</id>
                        <phase>process-resources</phase>
                        <goals>
                            <goal>generate</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <rebelXmlDirectory>${basedir}/src/main/webapp/WEB-INF/classes</rebelXmlDirectory>
                </configuration>
            </plugin>-->
