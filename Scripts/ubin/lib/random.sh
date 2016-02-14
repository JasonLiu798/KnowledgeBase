#!/bin/bash

function random_num()
{
local min=$1  
if [ "$min" = "" ];then
	min=0
fi
local max=$2
if [ "$max" = "" ];then
	max=100
else
	max=$(($2-$min+1))
fi
#echo "min $min max $max"
#set -x
local num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')  
#echo $num
echo $(($num%$max+$min))  
}


function random_ip()
{
local IP
local a
for a in `seq 4`
do
    IP[$((a-1))]=`random_num 0 254`
done
local WIP=${IP[0]}.${IP[1]}.${IP[2]}.${IP[3]}
echo ${WIP}
}

#echo `random_num 0 254`

function random_num1()
{
local min=$1
if [ "$min" = "" ];then
        min=0
fi
local max=$2
if [ "$max" = "" ];then
        max=100
else
        max=$(($2-$min+1))
fi
local num=$(($RANDOM+1000000000)) #增加一个10位的数再求余  
echo $(($num%$max+$min))
}

function random_md5()
{
local LEN
if [ "$1" = "" ];then
	LEN=32
else
	LEN=$1
fi
set -x
echo date +%s%N | md5sum | head -c $LEN
}

#echo `random `
#echo `random_num 1 10`
#echo `random_num1 1 10`
