

#visualVm
[Jvisualvm--JAVA性能分析工具](http://zhouanya.blog.51cto.com/4944792/1370017/)


---
#Eclipse MAT

要定位问题，首先你需要获取服务器jvm某刻内存快照。jdk自带的jmap可以获取内存某一时刻的快照，导出为dmp文件后，就可以用Eclipse MAT来分析了，找出是那个对象使用内存过多，使用命令为：$JAVA_HOME/bin/jmap -dump:format=b,file=String <进程号> 
下面用一个实例来演示内存溢出，然后通过Eclipse MAT定位出导致内存溢出的对象。 


jmap -dump:format=b,file=f:/mdt/dmp/1716.bin 1716 


打开mat，【File】->【Open Heap Dump】导入dump文件，自动分析dump数据显示如下图： 


切换到Histogram视图页面，点击点击标题头排序后发现byte数组占用内存f非常大，50多兆。 


在byte[]行上，点击右键。在右键菜单选择【Show objects of class】->【by incoming references】，弹出一个新窗口，显示byte数组引用关系，展开如果下图： 



从图中可以看到有多个地方存在byte数组，但只有HashMap对象占用比较大，有55个class java.util.HashMap$Entry对象，每个对象大小超过1m，而HashMap在LeafMap中被使用。因此我们可以定位到 LeafMap存在内存泄露的风险。 

在实际使用当中，可以获取多个时刻的内存快照，进行前后比较，如果某一对象前后一直在增长，说明该处存在内存泄露的可能。



一句话 分析 heap profile 文件

1 运行应用程序（使用jre版本为1.6以上）

2 命令行执行

            jmap -dump:format=b,file=d:\heap.hprof <pid>

   其中d:\heap.hprof   是dump出来的内存映像发文件，可以取任何后缀的名字。

3 使用eclipse 的MAT分析d:\heap.hprof 文件，可以查看哪些对象占据大多数的内存空间。

   http://www.eclipse.org/mat/

4 个人感觉MAT最重要的是leak suspects，帮助分析出那些可疑对象：

 

5 获得hprof文件的其他途径：

java -Xms20M -Xmx20M -Xmn10m -XX:+UseSerialGC  -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:PretenureSizeThreshold=3000000  -Xloggc:D:/gc.log  -XX:+HeapDumpOnOutOfMemoryError   -XX:HeapDumpPath=d:/test.hprof gc.SerialGCDemo

其中红色部分表示内存OOM的时刻，将内存镜像输出文件到D:/test.hprof

-XX:+HeapDumpOnOutOfMemoryError  打开选项

-XX:HeapDumpPath=d:/test.hprof             指定路径


调用jdk工具jps查看当前的java进程 
C:\>jps 
3504 Jps 
3676 Bootstrap 
3496 org.eclipse.equinox.launcher_1.0.201.R35x_v20090715.jar 
调用jmap工具得到信息 
C:\>jmap -dump:format=b,file=heap.bin 3676 
Dumping heap to C:\heap.bin ... 
Heap dump file created 
这时，我们的C盘根目录，就生成了heap.bin文件，用eclipse的file---->open打开这个文件







