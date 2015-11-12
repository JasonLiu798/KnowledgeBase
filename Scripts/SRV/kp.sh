#!/bin/bash
# kill java program
PID=srv1
ps -ef|grep $PID

PROCESS=`ps -ef|awk '{print $2,$12}'|grep $PID|awk '{print $1}'`
kill -9 $PROCESS
echo "$PROCESS killed"

ps -ef|grep $PID
