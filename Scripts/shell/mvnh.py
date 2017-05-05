#!/bin/env python

print '''#deploy source
grep -rn "hello,world!" *
find -type f -name '*.xml'|xargs grep 'xxx'

'''

<dependency>
  <groupId>com.test</groupId>
  <artifactId>test</artifactId>
  <version>1.0.0</version>
  <scope>system</scope>
  <systemPath>${project.basedir}/lib/xxx.jar</systemPath>
</dependency>
