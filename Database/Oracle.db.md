#Oracle 
---

Oracle配置：
安装
关闭部分服务

卸载
1.停止所有服务
2.运行Installer
3.修改注册表
Oracle软件有关键值
HKEY_Local_Machine\Software\Oracle
Oracle服务
HKEY_Local_Machine\System\CurrentControlSet\services
Oracle事件日志
HKEY_Local_Machine\System\CurrentControlSet\Services\Eventlog\Application
4.Oracle系统目录C：\Program Files\oracle
5.删除Oracle环境变量
6.重启 删除主工作目录

---
#objects
    select OWNER,count(*) cnt from dba_objects 
    where  OBJECT_TYPE='TABLE' group by OWNER order by cnt ;
    select distinct OBJECT_TYPE from dba_objects 



---
#settings
10G
listener.ora
D:\ProgramFiles\Oracle\product\10.2.03\db_1\network\ADMIN\listener.ora
tnsnames.ora
D:\ProgramFiles\Oracle\product\10.2.03\db_1\network\ADMIN\tnsnames.ora
——————————————————————————————————————————
10g启动
@echo off  
net start OracleDBConsoleorcl10g
net start OracleOraDb10g_homeiSQL*Plus
net start OracleOraDb10g_homeTNSListener
net start OracleServiceORCL10G
10g停止
@echo off  
net stop OracleDBConsoleorcl10g
net stop OracleOraDb10g_homeiSQL*Plus
net stop OracleOraDb10g_homeTNSListener
net stop OracleServiceORCL10G
——————————————————————————————————————————



---
#sqlplus
/home/oracle/product/10.2.0/db/sqlplus/admin/login.sql
=======



select OWNER,count(*) cnt from dba_objects 
where  OBJECT_TYPE='TABLE'
group by OWNER order by cnt ;

select distinct OBJECT_TYPE from dba_objects 





## /home/oracle/product/10.2.0/db/sqlplus/admin/login.sql
define _editor=vim
set serveroutput on size 1000000
set trimspool on
set long 5000
set linesize 300
set pagesize 9999
column plan_plus_exp format a80
column global_name new_value gname
set termout off
define gname=idle
column global_name new_value gname
select lower(user) || '@' || substr( global_name, 1, decode( dot, 0, length(global_name), dot-1) ) global_name
  from (select global_name, instr(global_name,'.') dot from global_name );
set sqlprompt '&gname> '
set termout on

## SHOW
show all --查看所有68个系统变量值 
SQL> show user --显示当前连接用户 
SQL> show error　　 --显示错误 
SQL> set heading off --禁止输出列标题，默认值为ON 
SQL> set feedback off --禁止显示最后一行的计数反馈信息，默认值为"对6个或更多的记录，回送ON"
SQL> set timing on --默认为OFF，设置查询耗时，可用来估计SQL语句的执行时间，测试性能 
SQL> set sqlprompt "SQL> " --设置默认提示符，默认值就是"SQL> " 
SQL> set linesize 1000 --设置屏幕显示行宽，默认100 
SQL> set autocommit ON --设置是否自动提交，默认为OFF 
SQL> set pause on --默认为OFF，设置暂停，会使屏幕显示停止，等待按下ENTER键，再显示下一页 
SQL> set arraysize 1 --默认为15 
SQL> set long 1000 --默认为80 
说明： long值默认为80，设置1000是为了显示更多的内容，因为很多数据字典视图中用到了long数据类型，如： 
SQL> desc user_views 
列名 可空值否 类型 



---
#Job
工作中我们经常用Oracle的JOB执行一些定时任务，实践中我们发现，设定执行时间和间隔后，每次执行的时间都会有点延迟，经过一段时间后，推迟累计的效应就相当明显，必须要重新调整时间才能满足要求，为什么会出现这种现象呢？经过研究，我们发现了问题所在。下面举例说明这个问题。
建立一个JOB，内容为插入系统时间到数据库，执行间隔为1分钟，即inteval是sysdate+1/(24*60)，我们发现记录的时间是不断推迟的，即：
2012-06-27 12:32:08
2012-06-27 12:33:13
2012-06-27 12:34:18
2012-06-27 12:35:23
2012-06-27 12:36:28
2012-06-27 12:37:33
2012-06-27 12:38:38
检查JOB的执行时间，发现也是不断推后的，发生这种现象的原因是什么呢？
原因是计算下次执行时间用的间隔是sysdate+1/(24*60)，可能是JOB的启动要时间或者是扫描精度的原因，计算下次执行时间时用的标准时间已经不是启动JOB的时间，而是推迟几秒，所以下次执行时间会不断推迟，找到问题所在，解决起来也就简单了，那就是选一个标准时间计算下次执行时间。如果每分钟执行一次，我们可以将当前时间截取到分钟作为标准时间，
即inteval 取trunc(sysdate,'mi')+1/(24*60)，这样就不会有累积效应了。看执行结果：
2012-06-27 12:42:03
2012-06-27 12:43:03
2012-06-27 12:44:03
2012-06-27 12:45:03
2012-06-27 12:46:03
2012-06-27 12:47:03
2012-06-27 12:48:03
对于不同的间隔，时间截取可以采用不同的精度，比如每天执行一次，可以用trunc(sysdate,'dd')将时间截取到00:00:00，如每天2:00执行，inteval 取trunc(sysdate,'dd')+2/24+1或者trunc(sysdate)+2/24+1就可以了。
关于trunc截断日期的用法，可以查相关资料。JOB的执行时间有以下实验结论：
1、JOB在运行结束之后才会更新next_date，但是计算的方法是JOB刚开始的时间加上interval设定的间隔。
2、如果interval的时长短于JOB执行的时间，作业仍然会继续进行，只是执行间隔变为了JOB真实运行的时长。
3、用于计算next_date的JOB启动时间总是比设定的时间推迟几秒，原因可能是JOB的启动时间或者是扫描精度。
4、如果JOB因为某些原因延迟执行了一次，就会导致下一次的执行时间也同样顺延了，如本文所描述的延迟累积。因此用正确的时间间隔就很重要。比如，我们要JOB在每天的凌晨2:30执行而不管上次执行到底是几点，设置interval为trunc(sysdate)+2.5/24+1就可以了。


附：oracle JOB常见的执行时间
1、每分钟执行
TRUNC(sysdate,'mi')+1/(24*60)

2、每天定时执行
例如：
每天凌晨0点执行
TRUNC(sysdate+1)
每天凌晨1点执行
TRUNC(sysdate+1)+1/24
每天早上8点30分执行
TRUNC(SYSDATE+1)+(8*60+30)/(24*60)

3、每周定时执行
例如：
每周一凌晨2点执行
TRUNC(next_day(sysdate,1))+2/24
TRUNC(next_day(sysdate,'星期一'))+2/24
每周二中午12点执行
TRUNC(next_day(sysdate,2))+12/24
TRUNC(next_day(sysdate,'星期二'))+12/24

4、每月定时执行
例如：
每月1日凌晨0点执行
TRUNC(LAST_DAY(SYSDATE)+1)
每月1日凌晨1点执行
TRUNC(LAST_DAY(SYSDATE)+1)+1/24

5、每季度定时执行
每季度的第一天凌晨0点执行
TRUNC(ADD_MONTHS(SYSDATE,3),'q')
每季度的第一天凌晨2点执行
TRUNC(ADD_MONTHS(SYSDATE,3),'q')+2/24
每季度的最后一天的晚上11点执行
TRUNC(ADD_MONTHS(SYSDATE+ 2/24,3),'q')-1/24

6、每半年定时执行
例如：
每年7月1日和1月1日凌晨1点执行
ADD_MONTHS(TRUNC(sysdate,'yyyy'),6)+1/24

7、每年定时执行
例如：
每年1月1日凌晨2点执行
ADD_MONTHS(TRUNC(sysdate,'yyyy'),12)+2/24




---
#AWR
AWR所在目录
cd $ORACLE_HOME/rdbms/admin/
awrrpt.sql



