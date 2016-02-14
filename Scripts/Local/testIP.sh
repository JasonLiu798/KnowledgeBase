#!/bin/bash
#main---
network=10.185.224
ping_count=3
IP=1
:>IP_use
:>IP_idle
:>ping_action
echo "`date "+%Y%m%d %H:%M:%S"`----->脚本开始执行......"
while [ $IP -lt 255 ]
do
host=$network.$IP
echo "-------->开始检测$host服务器通迅是否正常,ping次数$ping_count."
ping -c $ping_count $host >.ping_tmp
sleep 1
cat .ping_tmp  >>ping_action
echo "-------->服务器$host检测已完成."
sum_ping=`tail -2 .ping_tmp |head -1 |awk -F, '{print$2}' |cut -c 2-2`
loss_ping=`tail -2 .ping_tmp |head -1 |awk -F, '{print$4}'|cut -c 2-5`
if [ $sum_ping -eq $ping_count ];then
    echo "-->$host  IP 已经在使用中"
    echo "-->$host  IP 已经在使用中"  >>IP_use
  else
    echo "$host IP 目前空闲:$loss_ping"
    echo "$host IP 目前空闲"  >>IP_idle
fi
IP=$((IP+1))
done
echo "`date "+%Y%m%d %H:%M:%S"`----->脚本运行完毕......"
