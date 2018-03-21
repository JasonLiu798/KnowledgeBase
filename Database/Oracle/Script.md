全库导出
#设置客户端字符集
$export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
#数据库全库导出
$exp system/oracle@MONITOR file=/home/oracle/data.dmp full=y log=/home/oracle/data.log buffer=64000000


查找前十条性能差的sql. 

SELECT * FROM (select PARSING_USER_ID,EXECUTIONS,SORTS, 
COMMAND_TYPE,DISK_READS,sql_text FROM v$sqlarea 
order BY disk_reads DESC )where ROWNUM<10 ; 

查看占io较大的正在运行的session 

SELECT se.sid,se.serial#,pr.SPID,se.username,se.status, 
se.terminal,se.program,se.MODULE,se.sql_address,st.event,st. 
p1text,si.physical_reads, 
si.block_changes FROM v$session se,v$session_wait st, 
v$sess_io si,v$process pr WHERE st.sid=se.sid AND st. 
sid=si.sid AND se.PADDR=pr.ADDR AND se.sid>6 AND st. 
wait_time=0 AND st.event NOT LIKE '%SQL%' ORDER BY physical_reads DESC;

