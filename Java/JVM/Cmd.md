
# CMD
http://blog.hesey.net/2013/09/common-troubleshooting-tools-and-methods-on-java.html
## jinfo
jinfo 33673|more
可以输出并修改运行时的java 进程的opts。

## jps
与unix上的ps类似，用来显示本地的java进程，可以查看本地运行着几个java程序，并显示他们的进程号。

## jps
-q only lvmid
-m parameter passed to main()
-l class full name
-v init parameter
jps -lv

## jconsole


## jmap
使用情况
jmap -heap pid

输出所有内存中对象的工具，甚至可以将VM 中的heap，以二进制输出成文本
jmap -dump:format=b,file=heap.bin <pid>

强制FGC：
jmap -histo:live


## jstat
jstat -gcutil pid time_interval

监视VM内存工具。可以用来监视VM内存内的各种堆和非堆的大小及其内存使用量
```bash
jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]
```

### jstat -gc pid
可以显示gc的信息，查看gc的次数，及时间。
其中最后五项，分别是young gc的次数，young gc的时间，full gc的次数，full gc的时间，gc的总时间。


### jstat -gccapacity pid
可以显示，VM内存中三代（young,old,perm）对象的如：PGCMN显示的是最小perm的内存使用量，PGCMX显使用量，PGC是当前新生成的perm内存占用量，PC是但前perm内其他的可以根据这个类推， OC是old内纯的占用量。
```shell
jstat -gccapacity 887| awk -F '\n' '{printf $1}'|awk 'BEGIN{FS="[ ]+"} {for( i=2; i <=19; i++){ j=i+18; printf "%s:%s  ",$i,$j; } }'
```

PGCMN显示的是最小perm的内存使用量，PGCMX显示的是perm的内存最大使用量，PGC是当前新生成的perm内存占用量，PC是但前perm内存占用量

### jstat -gcutil pid
jstat -gcutil {pid} {interval} {count}
jstat -gcutil 529 1000 30
统计gc信息统计
```
  S0     S1     E      O      M     CCS    YGC     YGCT    FGC    FGCT     GCT
  0.00   0.00  64.49  28.47  98.13  96.26     35    1.443     8    1.931    3.374

#
   S0: Survivor space 0 utilization as a percentage of the space's current capacity.

   S1: Survivor space 1 utilization as a percentage of the space's current capacity.

   E: Eden space utilization as a percentage of the space's current capacity.

   O: Old space utilization as a percentage of the space's current capacity.

   M: Metaspace utilization as a percentage of the space's current capacity.

   CCS: Compressed class space utilization as a percentage.

   YGC: Number of young generation GC events.

   YGCT: Young generation garbage collection time.

   FGC: Number of full GC events.

   FGCT: Full garbage collection time.

   GCT: Total garbage collection time.
```


jstat -class pid:显示加载class的数量，及所占空间等信息。
jstat -compiler pid:显示VM实时编译的数量等信息。
jstat -gc pid:可以显示gc的信息，查看gc的次数，及时间。其中最后五项，分别是young gc的次数，young gc的时间，full gc的次数，full gc的时间，gc的总时间。
jstat -gccapacity:可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小，如：PGCMN显示的是最小perm的内存使用量，PGCMX显示的是perm的内存最大使用量，PGC是当前新生成的perm内存占用量，PC是但前perm内存占用量。其他的可以根据这个类推， OC是old内纯的占用量。
jstat -gcnew pid:new对象的信息。
jstat -gcnewcapacity pid:new对象的信息及其占用量。
jstat -gcold pid:old对象的信息。
jstat -gcoldcapacity pid:old对象的信息及其占用量。
jstat -gcpermcapacity pid: perm对象的信息及其占用量。
jstat -util pid:统计gc信息统计
jstat -printcompilation pid:当前VM执行的信息。



##jhat

##MAT
mat: eclipse memory analyzer, 基于eclipse RCP的内存分析工具。
详细信息参见：http://www.eclipse.org/mat/
jhat：JDK自带的java heap analyze tool


##jstack
[jstack和线程dump分析](http://jameswxx.iteye.com/blog/1041173)
[Java自带的性能监测工具用法简介——jstack、jconsole、jinfo、jmap、jdb、jsta、jvisualvm](http://blog.csdn.net/feihong247/article/details/7874063)

32598

top -Hp 32598
32678 work      20   0 4539m 456m 6036 S  0.0 11.9  23:36.49 java
32614 work      20   0 4539m 456m 6036 S  0.3 11.9  16:57.43 java
32627 work      20   0 4539m 456m 6036 S  0.0 11.9   7:42.35 java

printf "%x\n" 32678
7fa6

jstack 100093 |grep 1876f


###TDA

---
# 图形

## visualvm


## 
[greys-anatomy](https://github.com/oldmanpushcart/greys-anatomy)


https://github.com/CSUG/HouseMD


https://github.com/alibaba/TBJMap


http://tsar.taobao.org/

