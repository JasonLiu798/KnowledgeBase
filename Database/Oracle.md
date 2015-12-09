#Oracle 
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

