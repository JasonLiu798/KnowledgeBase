#!/bin/bash
. $BLIB/const.sh

function showfile()
{
local FILE=$1
local GREP_TXT=$2
local PARAM=$3
#echo "$FILE"
cat $FILE|grep -C $PARAM $GREP_TXT
}


function exchange_file()
{
local RAW=$1
local BAK_FILE=${RAW}.bak
local TMP_FILE=${RAW}.tmp
set -x
mv $RAW $TMP_FILE
mv $BAK_FILE $RAW
mv $TMP_FILE $BAK_FILE
set +x
}


function is_infile()
{
# $1 filename $2 sstr
local filename=$1
local sstr=$2
if [ "$filename" = "" ]; then
	return $E_FILE_NE
fi
local res=$SUCCESS
CHK=`cat $filename |awk '{if($1~/^'"${sstr}"'$/)print $1}'|wc -l`
#echo "chk $CHK"
if [ "$CHK" != "1" ]; then #not exist
        #echo "$0 ,no server match $SRV ,add $SRV to $SRVFILE "
	res=$FAIL
fi
return $res
}

function getline()
{
#$1 filename $2 sstr
local filename=$1
local sstr=$2
is_infile $filename $sstr
local infile_res=$?
#echo "in file $infile_res"
if [ "$infile_res" != "0" ]; then
	exit $FAIL
fi
local line=`cat $filename|grep $2`
#set -x
echo $line
}

function parse_server()
{
#$1 profile $2=ip $3=port $4=user $5 password
#dp113 192.168.143.113 22 work work
#0     1               2  3    4
local arr=(`getline $SRVFILE $1`)
if [ "${arr[0]}" = "$FAIL" ]; then
	return $FAIL
fi
#echo "srvinfo $SRVINFO"
eval $2="${arr[1]}"
eval $3="${arr[2]}"
eval $4="${arr[3]}"
eval $5='${arr[4]}'
return 0
}
#set -x
:<< aaa
set -x
parse_server dm118 IP PORT SUSER SPASS
echo $?
echo "ip $IP,port $PORT,user $SUSER,pass $SPASS"
aaa
#parse dev PROFILE SRVMARK
function parse_deploy()
{
#dev -Pdev dm118
#0   1     2
local DPINFO=(`getline $DPFILE $1`)
echo "deploy info $DPINFO"
eval $2="${DPINFO[1]}"
eval $3="${DPINFO[2]}"
}

function parse_redis()
{
#echo $REDISFILE
#$1  $2=IP           $3=PORT
#dev 192.168.143.112 6379
#0   1		     2
#echo "file $REDISFILE $1"
local arr=(`getline $REDISFILE $1`)
#set -x
#echo "redis info ${arr[@]}"
if [ "${arr[0]}" = "$FAIL" ]; then
	return $FAIL
fi
eval $2="${arr[1]}"
eval $3="${arr[2]}"
return 0
}

#set -x
:<< aaa
parse_redis dev IP PORT
echo "res $?"
echo "IP port $IP $PORT"
aaa

#$PR_RES=$?
#if [ "$PR_RES" = "$FAIL" ]; then
#	echo "fail"

#REDIS_INFO=`getline $REDISFILE dev`
#echo $REDIS_INFO
#is_infile $DPFILE devd
#echo $?
#RES=`getline /d/yp/project/member/db.dat devsd`


