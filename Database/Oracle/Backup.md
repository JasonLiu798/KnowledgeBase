

# Oracle备份实例
仅仅丢失一个普通用户数据文件的恢复A(联机恢复)
（例如，丢失D:\BACKUPDB\USERS01.DBF）
准备工作, 通过下面的工作，如果完全恢复，应该可以看到；insert into test1 values(2);

SQL> conn lunar/lunar
SQL> select * from tab;
TESTBACKUP3 TABLE
SQL> create table test1 (a number);
SQL> insert into test1 values(1);
SQL> alter system switch logfile;
SQL> commit;
SQL> alter system switch logfile;
SQL> insert into test1 values(2);
SQL> commit;
SQL> alter system switch logfile;
SQL> conn internal
SQL> archive log list
数据库日志模式 存档模式
自动存档 启用
存档终点 d:\BACKUPDB\archive
最早的概要信息日志序列 3
下一个存档日志序列 5
当前日志序列 5
shutdown abort关闭例程，模拟数据文件丢失
SQL> shutdown abort
ORACLE 例程已经关闭。
Mount数据库
SQL> startup mount 
数据库装载完毕。

使损坏的数据文件脱机
SQL> alter database datafile 'D:\BACKUPDB\USERS01.DBF' offline;
打开数据库
SQL> alter database open;
拷贝刚才热备的数据文件（USERS01.DBF）
恢复损坏的数据文件
SQL> recover datafile 'D:\BACKUPDB\USERS01.DBF';
ORA-00279: ?? 424116 (? 10/20/2002 20:42:04 ??) ???? 1 ????
ORA-00289: ??: D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: ?? 424116 ???? 1 ???? # 1 ???

指定日志: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00279: ?? 424125 (? 10/20/2002 20:44:14 ??) ???? 1 ????
ORA-00289: ??: D:\BACKUPDB\ARCHIVE\BACKUPT001S00002.ARC
ORA-00280: ?? 424125 ???? 1 ???? # 2 ???
ORA-00278: ??????????? 'D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC'
……………………..
已应用的日志。
完成介质恢复。

使恢复完成的数据文件联机
SQL> alter database datafile 'D:\BACKUPDB\USERS01.DBF' online;
验证恢复的结果：完全恢复
SQL> select * from tab;
TNAME TABTYPE CLUSTERID
SQL> select * from test1;

说明：
1.  shutdown abort关闭例程，模拟数据文件丢失  
2.  Mount数据库  
3.  使损坏的数据文件脱机  
4.  打开数据库  
5.  拷贝刚才热备的数据文件（USERS01.DBF）  
6.  恢复损坏的数据文件  
7.     使恢复完成的数据文件联机


shutdown immedate，恢复全部数据文件(不包括control和redo)
（把热备的数据文件拷贝回来，不包括control和redo）
SQL> conn internal
SQL> shutdown immediate;

复制全部热备的数据文件过来（完全恢复成功！）
mount数据库
SQL> startup mount

完全恢复数据库
SQL> recover database;
ORA-00279: change 424112 generated at 10/20/2002 20:40:52 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: change 424112 for thread 1 is in sequence #1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00279: change 424125 generated at 10/20/2002 20:44:14 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00002.ARC
ORA-00280: change 424125 for thread 1 is in sequence #2
ORA-00278: log file 'D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC' no longer needed
for this recovery
……………………………………………..
Log applied.
Media recovery complete.
打开数据库
SQL> alter database open;

验证恢复结果：完全恢复
SQL> conn lunar/lunar
SQL> select * from test1;

完全恢复成功！
说明：
1.  复制全部热备的数据文件过来
2.  mount数据库  
3.  完全恢复数据库  
4.  打开数据库


shutdown abort的情况，恢复全部控制文件和数据文件(不包括redo)
准备工作 （这样，insert into test1 values(13);就是没有提交的数据了，如果完全恢复，应该一直可以看到insert into test1 values(12);）
SQL> conn lunar/lunar
SQL> select * from test1;
SQL> insert into test1 values(12);
commit;
SQL> insert into test1 values(13);

单开一个session，用来shutdow abort
E:\>sqlplus internal
SQL> shutdown abort
ORACLE 例程已经关闭。

拷贝所有的控制文件和数据文件（不包括redo）
mount数据库，按照提示重建口令文件
SQL> startup mount
ORACLE instance started.
ORA-01991: invalid password file 'd:\oracle1\ora81\DATABASE\PWDbackup.ORA'

SQL> host
E:\>cd d:\oracle1\ora81\DATABASE
D:\oracle1\ora81\database>del PWDbackup.ORA
D:\oracle1\ora81\database>orapwd file=d:\oracle1\ora81\DATABASE\PWDbackup.ORA pa
ssword=oracle entries=10
/*    orapwd   Usage: orapwd file=<fname> password=<password> entries=<users>
      where
        file - name of password file (mand),
        password - password for SYS and INTERNAL (mand),
        entries - maximum number of distinct DBAs and OPERs (opt),
      There are no spaces around the equal-to (=) character. */
D:\oracle1\ora81\database>exit
这时，试图完全恢复数据库是不成功的
SQL> recover database;
ORA-00283: recovery session canceled due to errors
ORA-01610: recovery using the BACKUP CONTROLFILE option must be done
用to trace备份控制文件
SQL>alter database backup controlfile to trace;
SQL>shutdown immediate;
ORA-01109: database not open
Database dismounted.
ORACLE instance shut down.
找到并且编辑控制文件
STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "BACKUP" NORESETLOGS ARCHIVELOG
    MAXLOGFILES 32
    MAXLOGMEMBERS 2
    MAXDATAFILES 254
    MAXINSTANCES 1
    MAXLOGHISTORY 453
LOGFILE
  GROUP 1 'D:\BACKUPDB\REDO01.LOG' SIZE 1M,
  GROUP 2 'D:\BACKUPDB\REDO02.LOG' SIZE 1M,
  GROUP 3 'D:\BACKUPDB\REDO03.LOG' SIZE 1M
DATAFILE
  'D:\BACKUPDB\SYSTEM01.DBF',
  'D:\BACKUPDB\RBS01.DBF',
  'D:\BACKUPDB\USERS01.DBF',
  'D:\BACKUPDB\TEMP01.DBF',
  'D:\BACKUPDB\TOOLS01.DBF',
  'D:\BACKUPDB\INDX01.DBF'
CHARACTER SET ZHS16GBK;
RECOVER DATABASE
ALTER SYSTEM ARCHIVE LOG ALL;
ALTER DATABASE OPEN;
重建控制文件
SQL> startup nomount
SQL> @D:\BACKUPDB\udump\ORA01532.sql
ORA-01081: cannot start already-running ORACLE - shut it down first
Control file created.
ORA-00279: change 424112 generated at 10/20/2002 20:40:52 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: change 424112 for thread 1 is in sequence #1
ORA-00308: cannot open archived log 'ALTER'
ORA-27041: unable to open file
OSD-04002: 无法打开文件
O/S-Error: (OS 2) 系统找不到指定的文件。
ALTER DATABASE OPEN
*
ERROR at line 1:
ORA-01113: file 1 needs media recovery
ORA-01110: data file 1: 'D:\BACKUPDB\SYSTEM01.DBF'

shutdown immediate，然后重新恢复数据库
SQL> shutdown immediate;
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.
SQL> startup mount
ORACLE instance started.

完全恢复数据库
SQL> recover database;
ORA-00279: change 424112 generated at 10/20/2002 20:40:52 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: change 424112 for thread 1 is in sequence #1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00279: change 424125 generated at 10/20/2002 20:44:14 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00002.ARC
ORA-00280: change 424125 for thread 1 is in sequence #2
ORA-00278: log file 'D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC' no longer needed
for this recovery
………………………………………..
Log applied.
Media recovery complete.
打开数据库
SQL> alter database open;
SQL> conn lunar/lunar
SQL> select * from test1;

说明：
1.  拷贝所有的控制文件和数据文件（不包括redo）  
2.  mount数据库，按照提示重建口令文件  
3.  这时，试图完全恢复数据库是不成功的  
4.  用to trace备份控制文件  
5.  找到并且编辑控制文件  
6.  重建控制文件  
7.  shutdown immediate，然后重新恢复数据库  
8.  完全恢复数据库  
9.  打开数据库 


仅仅丢失一个普通用户数据文件的恢复B(脱机恢复)
准备工作 按照下面的输入，如果全部恢复，应该可以看到insert into test1 values(13)，因为insert into test1 values(14)没提交。
SQL> conn lunar/lunar
SQL> insert into test1 values(13);
SQL> insert into test1 values(14);

Shutdown immediate，然后模拟数据文件丢失
单开一个session，执行shutdown immediate（保证insert into test1 values(14);没有被隐式提交）
E:\>sqlplus internal
SQL>shutdown immediate
ORACLE 例程已经关闭。
模拟数据文件丢失，然后用热备覆盖这个文件
mount数据库
E:\>sqlplus internal
SQL>shutdown immediate
ORA-01034: ORACLE not available
ORA-27101: shared memory realm does not exist

SQL> startup mount
使损坏的数据文件脱机
SQL>alter database datafile 'D:\BACKUPDB\USERS01.DBF' offline;
Database altered.
恢复数据文件
SQL> recover datafile 'D:\BACKUPDB\USERS01.DBF';
ORA-00279: change 424116 generated at 10/20/2002 20:42:04 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: change 424116 for thread 1 is in sequence #1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00279: change 424125 generated at 10/20/2002 20:44:14 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00002.ARC
ORA-00280: change 424125 for thread 1 is in sequence #2
ORA-00278: log file 'D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC' no longer needed
for this recovery
…………………………………………………………
Log applied.
Media recovery complete.
使恢复的数据文件联机
SQL>alter database datafile 'D:\BACKUPDB\USERS01.DBF' online;
打开数据库
SQL>alter database open;
Database altered.

这时需要重新启动数据库，并完全恢复数据库
SQL> conn lunar/lunar
SQL> select count(*) from test;
select count(*) from test
                  *
ERROR at line 1:
ORA-00942: table or view does not exist
SQL> conn internal
SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
重新启动数据库，
SQL> startup
ORACLE instance started.

用recover database再次恢复数据库
SQL> conn internal
SQL> recover database;
ORA-00283: recovery session canceled due to errors
ORA-01124: cannot recover data file 1 - file is in use or recovery
ORA-01110: data file 1: 'D:\BACKUPDB\SYSTEM01.DBF'

重新使恢复的表空间联机
SQL> alter database datafile 'D:\BACKUPDB\USERS01.DBF' online;
SQL> conn lunar/lunar
SQL> select * from test1;    ok.

验证恢复结果：完全恢复
说明：
1.  用热备覆盖这个文件  
2.  mount数据库  
3.  使损坏的数据文件脱机  
4.  恢复数据文件  
5.  使恢复的数据文件联机  
6.  打开数据库  
7.  这时需要重新启动数据库，并完全恢复数据库  
8.  重新启动数据库，  
9.  用recover database再次恢复数据库  
10.  重新使恢复的表空间联机 

shutdown abort后，丢失全部文件(除了archive log和init.ora)
即，丢失了全部：数据文件、控制文件和redo log file
准备工作 下面的信息说明了如果是完全恢复，可以看到insert into test1 values(16);，否则可以看到15，就是被归档的那个。17因为没有提交，是不会被恢复的。

SQL> conn internal
SQL> archive log list;
Database log mode Archive Mode
Automatic archival Enabled
Archive destination d:\BACKUPDB\archive
Oldest online log sequence 14
Next log sequence to archive 16
Current log sequence 16
SQL> conn lunar/lunar
SQL> select * from test1 where a>10;
SQL> insert into test1 values(15);
SQL> alter system switch logfile;
System altered.
SQL> insert into test1 values(16);
SQL> insert into test1 values(17);
新开一个session，进行shutdown abort

E:\>sqlplus internal
SQL> shutdown abort
ORACLE 例程已经关闭。

把热备的数据文件和控制文件拷贝过来
mount数据库
E:\>sqlplus internal
SQL> startup mount
ORACLE instance started.

ORA-01991: invalid password file 'd:\oracle1\ora81\DATABASE\PWDbackup.ORA'

根据提示重建口令文件
SQL> host
E:\>del d:\oracle1\ora81\DATABASE\PWDbackup.ORA
E:\>orapwd file=d:\oracle1\ora81\DATABASE\PWDbackup.ORA password=oracle entries=
10

用to trace备份控制文件
SQL> alter database backup controlfile to trace;
Database altered.
找到这个跟踪文件并编辑它
STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "BACKUP" NORESETLOGS ARCHIVELOG
    MAXLOGFILES 32
    MAXLOGMEMBERS 2
    MAXDATAFILES 254
    MAXINSTANCES 1
    MAXLOGHISTORY 453
LOGFILE
  GROUP 1 'D:\BACKUPDB\REDO01.LOG' SIZE 1M,
  GROUP 2 'D:\BACKUPDB\REDO02.LOG' SIZE 1M,
  GROUP 3 'D:\BACKUPDB\REDO03.LOG' SIZE 1M
DATAFILE
  'D:\BACKUPDB\SYSTEM01.DBF',
  'D:\BACKUPDB\RBS01.DBF',
  'D:\BACKUPDB\USERS01.DBF',
  'D:\BACKUPDB\TEMP01.DBF',
  'D:\BACKUPDB\TOOLS01.DBF',
  'D:\BACKUPDB\INDX01.DBF'
CHARACTER SET ZHS16GBK
;
RECOVER DATABASE
ALTER SYSTEM ARCHIVE LOG ALL;
ALTER DATABASE OPEN;

重建控制文件（这种丢失的状态重建控制文件是错误的）
SQL> shutdown immediate
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.
SQL> startup nomount
ORACLE instance started.

Total System Global Area 25856028 bytes
Fixed Size 75804 bytes
Variable Size 8925184 bytes
Database Buffers 16777216 bytes
Redo Buffers 77824 bytes

SQL> @D:\BACKUPDB\udump\ORA02176.sql
ORA-01081: cannot start already-running ORACLE - shut it down first
CREATE CONTROLFILE REUSE DATABASE "BACKUP" NORESETLOGS ARCHIVELOG
*
ERROR at line 1:
ORA-01503: CREATE CONTROLFILE failed
ORA-01565: error in identifying file 'D:\BACKUPDB\REDO01.LOG'
ORA-27041: unable to open file
OSD-04002: 无法打开文件
O/S-Error: (OS 2) 系统找不到指定的文件。

ORA-01507: database not mounted
ALTER SYSTEM ARCHIVE LOG ALL
*
ERROR at line 1:
ORA-01507: database not mounted
ALTER DATABASE OPEN
*
ERROR at line 1:
ORA-01507: database not mounted

可见，因为缺少所有的redo，重建控制文件是行不通的。
Mount数据库
SQL> alter database mount;
Database altered.
用using backup controlfile进行恢复
SQL> alter database mount;
Database altered.
SQL> recover database until cancel using backup controlfile;
ORA-00279: change 424112 generated at 10/20/2002 20:40:52 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: change 424112 for thread 1 is in sequence #1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00279: change 424125 generated at 10/20/2002 20:44:14 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00002.ARC
ORA-00280: change 424125 for thread 1 is in sequence #2
ORA-00278: log file 'D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC' no longer needed
for this recovery
……………………………………………………

ORA-00308: cannot open archived log 'D:\BACKUPDB\ARCHIVE\BACKUPT001S00017.ARC'
ORA-27041: unable to open file
OSD-04002: 无法打开文件
O/S-Error: (OS 2) 系统找不到指定的文件。

用Open Resetlog 打开数据库
SQL> alter database open;
alter database open
*
ERROR at line 1:
ORA-01589: must use RESETLOGS or NORESETLOGS option for database open
SQL> alter database open RESETLOGS;
Database altered.

验证恢复结果：不完全恢复，redo里面的数据丢失了
SQL> conn lunar/lunar
SQL> select * from test1 where a>10;
SQL> conn internal
SQL> archive log list;
Database log mode Archive Mode
Automatic archival Enabled
Archive destination d:\BACKUPDB\archive
Oldest online log sequence 0
Next log sequence to archive 1
Current log sequence 1
说明：
1.  把热备的数据文件和控制文件拷贝过来  
2.  mount数据库  
3.  根据提示重建口令文件
4.  用using backup controlfile进行恢复  
5.  用Open Resetlog 打开数据库 

丢失非系统非当前活动回滚段表空间中的一个数据文件
首先是做一次热备份（因为上次已经做了不完全恢复resetlogs）
Microsoft Windows 2000 [Version 5.00.2195]

E:\>sqlplus internal
SQL>archive log list;
数据库日志模式 存档模式
自动存档 启用
存档终点 d:\BACKUPDB\archive
最早的概要信息日志序列 0
下一个存档日志序列 1
当前日志序列 1
SQL> @e:\backupdb\other\aa
TO_CHAR(SYSDATE,'' ………………..YY'2002-10-21 08:10:22'
SQL> @e:\backupdb\other\backup_ts.sql
SQL> set echo off head off feedback off pagesize 0;
21-10月-02

BEGINING ARCHIVE LOG NUMBER IS :
数据库日志模式 存档模式
自动存档 启用
存档终点 d:\BACKUPDB\archive
最早的概要信息日志序列 0
下一个存档日志序列 1
当前日志序列 1

Begin Backup Tablespace SYSTEM.'D:\BACKUPDB\SYSTEM01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace RBS.'D:\BACKUPDB\RBS01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace USERS.'D:\BACKUPDB\USERS01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace TEMP.'D:\BACKUPDB\TEMP01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace TOOLS.'D:\BACKUPDB\TOOLS01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .

Begin Backup Tablespace INDX.'D:\BACKUPDB\INDX01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .

Begin Backup CONTROLFILE 'D:\BACKUPDB\CONTROL01.CTL' ...
Successed End Backup The CONTROLFILE .

Begin Backup CONTROLFILE To Trace ...
Successed End Backup The CONTROLFILE .

Before Switch Log, The Current Log is:
数据库日志模式 存档模式
自动存档 启用
存档终点 d:\BACKUPDB\archive
最早的概要信息日志序列 0
下一个存档日志序列 1
当前日志序列 1

Begin Backup Switch Current Log ...
Successed End Switch Log .

After Switch Log, The Ending Archive Log Number Is :
数据库日志模式 存档模式
自动存档 启用
存档终点 d:\BACKUPDB\archive
最早的概要信息日志序列 1
下一个存档日志序列 2
当前日志序列 2
21-10月-02
SQL> --set termout on;
SQL> select to_char(sysdate,'''yyyy-mm-dd hh:mm:ss''') from dual;
'2002-10-21 08:10:54'

数据准备工作1
从下面的情况看，因为改变了数据库的结构，所以，首先需要一个热备或者冷备才能进行恢复。如果已经备份，可以找回数据insert into test2 values(2);，因为2是几经commit;的，3是没有commit的，所以能找会到2。3则会丢失。

SQL> alter tablespace system add datafile 'D:\BACKUPDB\SYSTEM02.DBF' size 10M;
表空间已更改。
SQL> alter tablespace users add datafile 'D:\BACKUPDB\USERS02.DBF' size 10M;
表空间已更改。
SQL> create tablespace test datafile 'D:\BACKUPDB\test01.dbf' size 10M;
表空间已创建。
SQL> archive log list;
数据库日志模式 存档模式
自动存档 启用
存档终点 d:\BACKUPDB\archive
最早的概要信息日志序列 1
下一个存档日志序列 2
当前日志序列 2
SQL> alter user lunar quota 10m on test;
SQL> create table test2(a number) tablespace test;
SQL> insert into test2 values(1);
SQL> alter system switch logfile;
系统已更改。
SQL> conn lunar/lunar
SQL> select * from tab;
TESTBACKUP3 TABLE

SQL> insert into test2 values(2);
SQL> insert into test2 values(3);
以上改动后需要作一次热备或者冷备，否则数据文件丢失后不能恢复（增加表空间，数据文件都要备份数据库）
SQL> conn internal
SQL> @e:\backupdb\other\aa
SQL> select to_char(sysdate,'''yyyy-mm-dd hh:mm:ss''') from dual;
'2002-10-21 08:10:05'
SQL> set termout off
SQL> @e:\backupdb\other\backup_ts.sql
SQL> --set termout off;
SQL> set echo off head off feedback off pagesize 0;
21-OCT-02
BEGINING ARCHIVE LOG NUMBER IS :
Database log mode Archive Mode
Automatic archival Enabled
Archive destination d:\BACKUPDB\archive
Oldest online log sequence 3
Next log sequence to archive 5
Current log sequence 5

Begin Backup Tablespace SYSTEM.'D:\BACKUPDB\SYSTEM01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace RBS.'D:\BACKUPDB\RBS01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace USERS.'D:\BACKUPDB\USERS01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace TEMP.'D:\BACKUPDB\TEMP01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace TOOLS.'D:\BACKUPDB\TOOLS01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace INDX.'D:\BACKUPDB\INDX01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace SYSTEM.'D:\BACKUPDB\SYSTEM02.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace USERS.'D:\BACKUPDB\USERS02.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup Tablespace TEST.'D:\BACKUPDB\TEST01.DBF' ...
已复制 1 个文件。
Successed End Backup This File .
Begin Backup CONTROLFILE 'D:\BACKUPDB\CONTROL01.CTL' ...
Successed End Backup The CONTROLFILE .
Begin Backup CONTROLFILE To Trace ...
Successed End Backup The CONTROLFILE .
Before Switch Log, The Current Log is:
Database log mode Archive Mode
Automatic archival Enabled
Archive destination d:\BACKUPDB\archive
Oldest online log sequence 3
Next log sequence to archive 5
Current log sequence 5

Begin Backup Switch Current Log ...
Successed End Switch Log .

After Switch Log, The Ending Archive Log Number Is :
Database log mode Archive Mode
Automatic archival Enabled
Archive destination d:\BACKUPDB\archive
Oldest online log sequence 4
Next log sequence to archive 6
Current log sequence 6
21-OCT-02

SQL> --set termout on;
SQL> select to_char(sysdate,'''yyyy-mm-dd hh:mm:ss''') from dual;
'2002-10-21 08:10:31'
1 row selected.

数据准备工作2
可以找回数据insert into test2 values(4);，因为4是几经commit;的，5是没有commit的，所以能找会到2。3则会丢失。
SQL> conn lunar/lunar
SQL> insert into test2 values(4);
SQL> commit;
SQL> insert into test2 values(5);
1 row created.

Shutdow abort，然后删除test01.dbf，模拟数据文件丢失
SQL> conn internal
SQL> shutdown abort
ORACLE instance shut down.

删除test01.dbf，把备份的数据文件test01.dbf拷贝过来
Mount数据库
SQL> startup mount;
………………

Database mounted.
SQL> alter database open;
alter database open
*
ERROR at line 1:
ORA-01113: file 9 needs media recovery
ORA-01110: data file 9: 'D:\BACKUPDB\TEST01.DBF'

在打开数据库的时候，提示'D:\BACKUPDB\TEST01.DBF'需要介质恢复，因为他和其他的文件时间点不一致。

恢复数据文件（把最近的热备的文件拷贝过来）
SQL> recover datafile 'D:\BACKUPDB\TEST01.DBF';
Media recovery complete.
打开数据库
SQL> alter database open;
验证恢复结果：完全恢复
SQL> conn lunar/lunar
SQL> select * from test2;
说明：
Ÿ  首先是做一次热备（因为上次已经做了不完全恢复resetlogs）  
Ÿ  以上改动后需要作一次热备或者冷备，否则数据文件丢失后不能恢复（增加表空间，数据文件都要备份数据库）  

1.  Shutdow abort，然后删除test01.dbf，模拟数据文件丢失  
2.  删除test01.dbf，把备份的数据文件test01.dbf拷贝过来  
3.  Mount数据库  
4.  恢复数据文件（把最近的热备的文件拷贝过来）  
5.  打开数据库 


shutdown abort的情况，恢复全部数据文件(不包括control和redo)
用热备的数据文件恢复（把热备的数据文件拷贝回来，不包括control和redo）
SQL> conn internal
SQL> shutdown abort
ORACLE instance shut down.

复制全部热备的数据文件过来（完全恢复成功！）
mount数据库
SQL> startup mount
ORACLE instance started.

完全恢复数据库
SQL> recover database;
ORA-00279: change 424112 generated at 10/20/2002 20:40:52 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: change 424112 for thread 1 is in sequence #1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00279: change 424125 generated at 10/20/2002 20:44:14 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00002.ARC
ORA-00280: change 424125 for thread 1 is in sequence #2
ORA-00278: log file 'D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC' no longer needed
for this recovery
…………………………………………………
Log applied.
Media recovery complete.

打开数据库
SQL> alter database open;
Database altered.
验证恢复结果：完全恢复
SQL> conn lunar/lunar
SQL> select * from test1;
完全恢复成功！

说明：
1.  复制全部热备的数据文件过来
2.  mount数据库  
3.  完全恢复数据库  
4.  打开数据库

shutdown immediate的情况，丢失全部控制文件和数据文件(不包括redo)，方法1
准备工作
下面的操作，说明如果完全恢复，可以看到insert into test1 values(11);，因为11是redo中已经commit的，12是redo中没有commit的
SQL> insert into test1 values(8);
SQL> commit;
SQL> insert into test1 values(9);
SQL> alter system switch logfile;
System altered.
SQL> conn internal
SQL> archive log list;
Database log mode Archive Mode
Automatic archival Enabled
Archive destination d:\BACKUPDB\archive
Oldest online log sequence 11
Next log sequence to archive 13
Current log sequence 13
SQL> conn lunar/lunar
SQL> insert into test1 values(10);
SQL> commit;
SQL> insert into test1 values(11);
SQL> conn internal
SQL> conn lunar/lunar
SQL> insert into test1 values(12);
1 row created.
然后单独开启一个实例，再shutdown immediate
（这样，insert into test1 values(12);就是没有提交的数据了，如果完全恢复应该一直可以看到insert into test1 values(11);）
E:\>sqlplus internal
SQL>shutdown immediate
数据库已经关闭。
已经卸载数据库。
ORACLE 例程已经关闭。
拷贝热备的所有控制文件和数据文件
mount数据库
SQL> startup mount
ORACLE 例程已经启动。
Total System Global Area 25856028 bytes
Fixed Size 75804 bytes
Variable Size 8925184 bytes
Database Buffers 16777216 bytes
Redo Buffers 77824 bytes
ORA-01991: ???????'d:\oracle1\ora81\DATABASE\PWDbackup.ORA'

根据提示，重建口令文件
SQL> host
E:\>cd d:\oracle1\ora81\DATABASE\PWDbackup
系统找不到指定的路径。
E:\>cd d:\oracle1\ora81\DATABASE
E:\>d:
D:\oracle1\ora81\database>del PWDbackup.ORA
D:\oracle1\ora81\database>dir PWDbackup.ORA
驱动器 D 中的卷是 Program
卷的序列号是 D0E6-FA1C
D:\oracle1\ora81\database 的目录
找不到文件
D:\oracle1\ora81\database>orapwd file=d:\oracle1\ora81\DATABASE\PWDbackup.ORA pa
ssword=oracle entries=10;
D:\oracle1\ora81\database>exit
用to trace备份控制文件
SQL> alter database backup controlfile to trace;
数据库已更改。
shutdown immediate关闭数据库
SQL> shutdown immediate;
ORA-01109: ??????

已经卸载数据库。
ORACLE 例程已经关闭。
找到那个控制文件，然后编辑：
STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "BACKUP" NORESETLOGS ARCHIVELOG
    MAXLOGFILES 32
    MAXLOGMEMBERS 2
    MAXDATAFILES 254
    MAXINSTANCES 1
    MAXLOGHISTORY 453
LOGFILE
  GROUP 1 'D:\BACKUPDB\REDO01.LOG' SIZE 1M,
  GROUP 2 'D:\BACKUPDB\REDO02.LOG' SIZE 1M,
  GROUP 3 'D:\BACKUPDB\REDO03.LOG' SIZE 1M
DATAFILE
  'D:\BACKUPDB\SYSTEM01.DBF',
  'D:\BACKUPDB\RBS01.DBF',
  'D:\BACKUPDB\USERS01.DBF',
  'D:\BACKUPDB\TEMP01.DBF',
  'D:\BACKUPDB\TOOLS01.DBF',
  'D:\BACKUPDB\INDX01.DBF'
CHARACTER SET ZHS16GBK
;
RECOVER DATABASE
ALTER SYSTEM ARCHIVE LOG ALL;
ALTER DATABASE OPEN;

重建控制文件，并且恢复数据库
SQL> startup nomount
ORACLE 例程已经启动。

SQL> @D:\BACKUPDB\udump\ORA01904.sql
ORA-01081: cannot start already-running ORACLE - shut it down first
Cluster altered.

ORA-00279: change 424112 generated at 10/20/2002 20:40:52 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: change 424112 for thread 1 is in sequence #1

ORA-00308: cannot open archived log 'ALTER'
ORA-27041: unable to open file
OSD-04002: 无法打开文件
O/S-Error: (OS 2) 系统找不到指定的文件。

ALTER DATABASE OPEN
*
ERROR at line 1:
ORA-01113: file 1 needs media recovery
ORA-01110: data file 1: 'D:\BACKUPDB\SYSTEM01.DBF'

关闭数据库
除了redo log file中没有提交的数据，其他都可以找回来
SQL> shutdown immediate;
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.

重新mount，作完全恢复（recover database;）
SQL> startup mount
ORACLE instance started.


SQL> recover database;
ORA-00279: change 424112 generated at 10/20/2002 20:40:52 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC
ORA-00280: change 424112 for thread 1 is in sequence #1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00279: change 424125 generated at 10/20/2002 20:44:14 needed for thread 1
ORA-00289: suggestion : D:\BACKUPDB\ARCHIVE\BACKUPT001S00002.ARC
ORA-00280: change 424125 for thread 1 is in sequence #2
ORA-00278: log file 'D:\BACKUPDB\ARCHIVE\BACKUPT001S00001.ARC' no longer needed
for this recovery
…………………………………………..
Log applied.
Media recovery complete.

打开数据库
SQL> alter database open;
Database altered.

验证恢复结果：完全恢复
SQL> conn lunar/lunar
SQL> select * from test1;
SQL> conn internal
SQL> archive log list;
Database log mode Archive Mode
Automatic archival Enabled
Archive destination d:\BACKUPDB\archive
Oldest online log sequence 12
Next log sequence to archive 14
Current log sequence 14
说明：
1.  把热备的控制文件和数据文件拷贝过来
2.  mount数据库  
3.  根据提示，重建口令文件  
4.  用to trace备份控制文件  
5.  shutdown immediate关闭数据库  
6.  找到那个控制文件，然后编辑
7.  重建控制文件，并且恢复数据库  
8.  关闭数据库  
9.  重新mount，作完全恢复（recover database;）  
10.  打开数据库 



shutdown immediate的情况，丢失全部控制文件和数据文件(不包括redo)，方法2
准备工作
如果数据不丢失，应该可以恢复到insert into test1 values(14);，因为14是redo中commit的，15是redo中没有commit的
SQL> conn lunar/lunar
SQL> select * from test1;

SQL> insert into test1 values(14);
SQL> commit;
SQL> insert into test1 values(15);

把热备的控制文件和数据文件拷贝过来
mount数据库
SQL> startup mount
ORACLE instance started.

ORA-01991: invalid password file 'd:\oracle1\ora81\DATABASE\PWDbackup.ORA'

根据提示，重建口令文件
SQL> host
E:\>del d:\oracle1\ora81\DATABASE\PWDbackup.ORA

E:\>orapwd file=d:\oracle1\ora81\DATABASE\PWDbackup.ORA password=oracle entries=
10

尝试恢复数据库（现在恢复是不可以的）
SQL> recover database;
ORA-00283: recovery session canceled due to errors
ORA-01610: recovery using the BACKUP CONTROLFILE option must be done

SQL> recover database using BACKUP CONTROLFILE;
ORA-00279: change 424123 generated at 10/20/2002 20:44:12 needed for thread 1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00266: name of archived log file needed

SQL> recover database until cancel using backup controlfile;
ORA-00279: change 424123 generated at 10/20/2002 20:44:12 needed for thread 1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00266: name of archived log file needed

ORA-01547: warning: RECOVER succeeded but OPEN RESETLOGS would get error below
ORA-01152: file 1 was not restored from a sufficiently old backup
ORA-01110: data file 1: 'D:\BACKUPDB\SYSTEM01.DBF'
可见这样恢复是不行的

试图打开数据库（现在打开是不可以的）
SQL> alter database open;
alter database open
*
ERROR at line 1:
ORA-01589: must use RESETLOGS or NORESETLOGS option for database open

SQL> alter database open resetlogs;
alter database open resetlogs
*
ERROR at line 1:
ORA-01152: file 1 was not restored from a sufficiently old backup
ORA-01110: data file 1: 'D:\BACKUPDB\SYSTEM01.DBF'
可见现在打开是不行的

重新mount数据库
SQL> shutdown immediate;
ORA-01109: database not open
Database dismounted.
ORACLE instance shut down.
SQL> startup mount;
ORACLE instance started.

备份控制文件
SQL> alter database backup controlfile to trace;
Database altered.
SQL> shutdown immediate
ORA-01109: database not open
Database dismounted.
ORACLE instance shut down.

找到那个控制文件，并且编辑它
STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "BACKUP" NORESETLOGS ARCHIVELOG
    MAXLOGFILES 32
    MAXLOGMEMBERS 2
    MAXDATAFILES 254
    MAXINSTANCES 1
    MAXLOGHISTORY 453
LOGFILE
  GROUP 1 'D:\BACKUPDB\REDO01.LOG' SIZE 1M,
  GROUP 2 'D:\BACKUPDB\REDO02.LOG' SIZE 1M,
  GROUP 3 'D:\BACKUPDB\REDO03.LOG' SIZE 1M
DATAFILE
  'D:\BACKUPDB\SYSTEM01.DBF',
  'D:\BACKUPDB\RBS01.DBF',
  'D:\BACKUPDB\USERS01.DBF',
  'D:\BACKUPDB\TEMP01.DBF',
  'D:\BACKUPDB\TOOLS01.DBF',
  'D:\BACKUPDB\INDX01.DBF'
CHARACTER SET ZHS16GBK
;
RECOVER DATABASE
ALTER SYSTEM ARCHIVE LOG ALL;
ALTER DATABASE OPEN;

重建控制文件，并自动完全恢复数据库
SQL> startup nomount
ORACLE instance started.

Total System Global Area 25856028 bytes
Fixed Size 75804 bytes
Variable Size 8925184 bytes
Database Buffers 16777216 bytes
Redo Buffers 77824 bytes
SQL> @D:\BACKUPDB\udump\ORA02020.sql
ORA-01081: cannot start already-running ORACLE - shut it down first
Control file created.

ORA-00283: recovery session canceled due to errors
ORA-00264: no recovery required
System altered.
Database altered.

验证恢复结果：完全恢复
SQL> conn lunar/lunar
SQL> select * from test1 where a>10;

说明：
1.  把热备的控制文件和数据文件拷贝过来  
2.  mount数据库  
3.  根据提示，重建口令文件  
4.  尝试恢复数据库（现在恢复是不可以的）  
如，这三个，都不能恢复数据库：
recover database;
recover database using BACKUP CONTROLFILE;
recover database until cancel using backup controlfile;
5.  试图打开数据库（现在打开是不可以的）
   如，这两个，都不能打开数据库
   alter database open;
   alter database open resetlogs;
6.  重新mount数据库  
7.  备份控制文件  
8.  找到那个控制文件，并且编辑它  
9.  重建控制文件，并自动完全恢复数据库 


shutdown abort的情况，恢复全部控制文件(不包括数据文件和redo)
准备工作
以下说明，如果完全恢复数据库，应该可以看到insert into test1 values(7);
SQL> insert into test1 values(3);
SQL> insert into test1 values(4);
SQL> commit;
SQL> alter system switch logfile;
SQL> conn internal
SQL> archive log list;
Database log mode Archive Mode
Automatic archival Enabled
Archive destination d:\BACKUPDB\archive
Oldest online log sequence 8
Next log sequence to archive 10
Current log sequence 10
SQL> select * from test1;
SQL> insert into test1 values(5);
SQL> commit;
SQL> insert into test1 values(6);
SQL> alter system switch logfile;
System altered.
SQL> conn internal
SQL> conn lunar/lunar
SQL> insert into test1 values(7);
1 row created.
SQL> shutdown abort;
ORA-01031: insufficient privileges
SQL> conn internal
SQL> shutdown abort;
ORACLE instance shut down.
删除那个控制文件，把热备的控制文件拷贝过来
mount数据库
SQL> startup mount
ORACLE instance started.
ORA-01991: invalid password file 'd:\oracle1\ora81\DATABASE\PWDbackup.ORA'

根据提示，重建口令文件
SQL> host
E:\>cd d:\oracle1\ora81\DATABASE
E:\>d:
D:\oracle1\ora81\database>del PWDbackup.ORA
D:\oracle1\ora81\database>dir
驱动器 D 中的卷是 Program
卷的序列号是 D0E6-FA1C

D:\oracle1\ora81\database 的目录

2002-10-21 00:42 <DIR> .
2002-10-21 00:42 <DIR> ..
2002-10-05 15:36 <DIR> archive
2002-10-17 13:39 40 initBACKUP.ora
2002-10-05 16:09 50 inittest.ora
2002-10-05 15:36 31,744 oradba.exe
2002-10-07 23:39 206 oradim.log
2002-10-16 18:21 1,536 PWDtest.ora
               5 个文件 33,576 字节
               3 个目录 2,775,724,032 可用字节

D:\oracle1\ora81\database>
D:\oracle1\ora81\database>orapwd file=d:\oracle1\ora81\DATABASE\PWDbackup.ORA password=oracle entries=10;

D:\oracle1\ora81\database>exit
用to trace;备份控制文件
SQL> alter database backup controlfile to trace;
SQL> shutdown immediate
ORA-01109: database not open
Database dismounted.
ORACLE instance shut down.

找到那个控制文件，然后编辑
STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "BACKUP" NORESETLOGS ARCHIVELOG
    MAXLOGFILES 32
    MAXLOGMEMBERS 2
    MAXDATAFILES 254
    MAXINSTANCES 1
    MAXLOGHISTORY 453
LOGFILE
  GROUP 1 'D:\BACKUPDB\REDO01.LOG' SIZE 1M,
  GROUP 2 'D:\BACKUPDB\REDO02.LOG' SIZE 1M,
  GROUP 3 'D:\BACKUPDB\REDO03.LOG' SIZE 1M
DATAFILE
  'D:\BACKUPDB\SYSTEM01.DBF',
  'D:\BACKUPDB\RBS01.DBF',
  'D:\BACKUPDB\USERS01.DBF',
  'D:\BACKUPDB\TEMP01.DBF',
  'D:\BACKUPDB\TOOLS01.DBF',
  'D:\BACKUPDB\INDX01.DBF'
CHARACTER SET ZHS16GBK
;
RECOVER DATABASE
ALTER SYSTEM ARCHIVE LOG ALL;
ALTER DATABASE OPEN;

重建控制文件，并且恢复数据库(完全恢复成功！)
SQL> @D:\BACKUPDB\udump\ORA02092.sql
ORA-01081: cannot start already-running ORACLE - shut it down first
Cluster altered.

Media recovery complete.
System altered.
Database altered.
SQL> conn lunar/lunar
SQL> select * from test1;
完全恢复成功！

说明：
当shutdown abort的以后，如果丢失全部控制文件（不包括数据文件和redo），需要用热备的控制文件恢复数据库的时候，要想完全恢复（一直恢复到redo中commit的数据），必须执行以下步骤：
1.  mount数据库，
2.  backup controlfile to trace
3.  修改这个生成的控制文件
4.  nomount
5.  重建控制文件，


shutdown immediate，丢失全部控制文件(不包括数据文件和redo)，A[完全恢复]
SQL> conn internal
SQL> shutdown immediate;

用热备的控制文件恢复（把热备的控制文件拷贝回来）
mount数据库
SQL> startup mount
ORACLE instance started.

完全恢复和until cancel using backup controlfile都失败
SQL> recover database;
ORA-00283: recovery session canceled due to errors
ORA-01610: recovery using the BACKUP CONTROLFILE option must be done

SQL> recover database until cancel using backup controlfile;
ORA-00279: change 424123 generated at 10/20/2002 20:44:12 needed for thread 1

Specify log: {<RET>=suggested | filename | AUTO | CANCEL}
auto
ORA-00266: name of archived log file needed

ORA-01547: warning: RECOVER succeeded but OPEN RESETLOGS would get error below
ORA-01152: file 1 was not restored from a sufficiently old backup
ORA-01110: data file 1: 'D:\BACKUPDB\SYSTEM01.DBF'

重建控制文件
SQL> alter database backup controlfile to trace;
Database altered.

找到那个控制文件，然后编辑
STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "BACKUP" NORESETLOGS ARCHIVELOG
    MAXLOGFILES 32
    MAXLOGMEMBERS 2
    MAXDATAFILES 254
    MAXINSTANCES 1
    MAXLOGHISTORY 453
LOGFILE
  GROUP 1 'D:\BACKUPDB\REDO01.LOG' SIZE 1M,
  GROUP 2 'D:\BACKUPDB\REDO02.LOG' SIZE 1M,
  GROUP 3 'D:\BACKUPDB\REDO03.LOG' SIZE 1M
DATAFILE
  'D:\BACKUPDB\SYSTEM01.DBF',
  'D:\BACKUPDB\RBS01.DBF',
  'D:\BACKUPDB\USERS01.DBF',
  'D:\BACKUPDB\TEMP01.DBF',
  'D:\BACKUPDB\TOOLS01.DBF',
  'D:\BACKUPDB\INDX01.DBF'
CHARACTER SET ZHS16GBK
;
RECOVER DATABASE
ALTER SYSTEM ARCHIVE LOG ALL;
ALTER DATABASE OPEN;

重建控制文件，并且恢复数据库（完全恢复成功！）
SQL> shutdown immediate;
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.
SQL> startup nomount;
ORACLE instance started.

SQL>@D:\BACKUPDB\udump\ORA02120.sql
ORA-01081: cannot start already-running ORACLE - shut it down first
Cluster altered.
ORA-00283: recovery session canceled due to errors
ORA-00264: no recovery required
System altered.
Database altered.

验证恢复结果：完全恢复
SQL> conn lunar/lunar
SQL> select * from test1;
完全恢复成功！

说明：
当shutdown immediate的以后，如果丢失全部控制文件（不包括数据文件和redo），需要用热备的控制文件恢复数据库的时候，要想完全恢复（一直恢复到redo中commit的数据），必须执行以下步骤：
1.  mount数据库，
2.  backup controlfile to trace
3.  修改这个生成的控制文件
4.  nomount
5.  重建控制文件












