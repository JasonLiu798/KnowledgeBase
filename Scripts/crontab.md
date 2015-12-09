#
cron
Unix下
cron 进程运行时，会读取/etc/cronlog.conf 配置文件来指定运行日志的存储信息。
如果用户未配置cronlog.conf，则cron进程将运行的日志信息存储在/var/adm/cron/log 文件里


crontab
crontab [ -e [UserName] | -l [UserName] | -r [UserName] | -v [UserName] | File ]
添加
-e 
crontab 命令调用一个编辑会话，允许创建一个 crontab 文件。在这个文件中，为每个 cron 创建条目。每个条目必须是一种 cron 守护进程可接受的格式。要得到创建条目的信息，参阅 crontab 文件条目格式。当创建完条目和退出文件后，crontab 命令将它拷贝到 /var/spool/cron/crontabs 目录，并把它放到一个文件中，此文件的名称是当前的用户名。如果以用户名命名的文件已存在于 crontabs 目录中，crontab 命令会覆盖它。
列出 crontab 文件的内容，就指定 crontab 命令并采用 -l 标志。
删除，采用 -r 标志。


crontab
0 11 * * * /usr/bin/errclear -d S,O 30
0 12 * * * /usr/bin/errclear -d H 90
0 15 * * *  /usr/lib/ras/dumpcheck >/dev/null 2>&1
55 23 * * * /var/perf/pm/bin/pmcfg  >/dev/null 2>&1     #Enable PM Data Collection
# SSA warning : Deleting the next two lines may cause errors in redundant
# SSA warning : hardware to go undetected.
01 5 * * * /usr/lpp/diagnostics/bin/run_ssa_ela 1>/dev/null 2>/dev/null
0 * * * * /usr/lpp/diagnostics/bin/run_ssa_healthcheck 1>/dev/null 2>/dev/null
# SSA warning : Deleting the next line may allow enclosure hardware errors to go undetected
30 * * * * /usr/lpp/diagnostics/bin/run_ssa_encl_healthcheck 1>/dev/null 2>/dev/null
# SSA warning : Deleting the next line may allow link speed exceptions to go undetected
30 4 * * * /usr/lpp/diagnostics/bin/run_ssa_link_speed 1>/dev/null 2>/dev/null
* * * * * iostat >> /jiankong/disk.txt
0 8 * * * nmon -f -s 600 -c 72 -m /tmp/nmonrep









