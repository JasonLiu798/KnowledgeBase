
Low RBA(Redo byte address)

show parameter fast_start_io
show parameter fast_start_mttr_target

MTTR建议
select MTTR_TARGET_FOR_ESTIMATE MttrEst,  ADVICE_STATUS AD, 
DIRTY_LIMIT DL, 
ESTD_CACHE_WRITES ESTCW, 
ESTD_CACHE_WRITE_FACTOR EstCWF,ESTD_TOTAL_WRITES ESTW, 
ESTD_TOTAL_WRITE_FACTOR ETWF,ESTD_TOTAL_IOS ETIO 
from v$mttr_target_advice; 

show parameter statistics_level
select * from v$statistics_level   where STATISTICS_NAME='MTTR Advice';

实例恢复状态，平均恢复时间
select RECOVERY_ESTIMATED_IOS REIO, 
ACTUAL_REDO_BLKS ARB, 
TARGET_REDO_BLKS TRB, 
LOG_FILE_SIZE_REDO_BLKS LFSRB, 
LOG_CHKPT_TIMEOUT_REDO_BLKS LCTRB, 
LOG_CHKPT_INTERVAL_REDO_BLKS LCIRB, 
FAST_START_IO_TARGET_REDO_BLKS FSIOTRB, 
TARGET_MTTR TMTTR, 
ESTIMATED_MTTR EMTTR, 
CKPT_BLOCK_WRITES CBW 
from v$instance_recovery;

select sid,seq#,event from v$session_wait where event not like 'SQL*Net message%';                                                                

vmstat 2

select RECOVERY_ESTIMATED_IOS REIOS,TARGET_MTTR TMTTR, 
ESTIMATED_MTTR EMTTR,WRITES_MTTR WMTTR,WRITES_OTHER_SETTINGS WOSET, 
CKPT_BLOCK_WRITES CKPTBW, 
WRITES_AUTOTUNE WAUTO,
WRITES_FULL_THREAD_CKPT WFTCKPT 
from v$instance_recovery;


mount状态转储控制文件
alter session set events 'immediate trace name CONTROLF level 12'; 
@gettrcname 






