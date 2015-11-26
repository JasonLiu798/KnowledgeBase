#!/bin/bash
#swh.sh
#versions:now[comm], test1,test2...
#swh example:swh test1;check comm version; mv comm->version; mv test1->now
#多套host按如下配置：


#获取现在文件的版本
NOW_VER=`cat /cygdrive/c/Windows/System32/drivers/etc/hosts|grep version|awk '{print $2}'`
#目标版本
TGT_VER=$1

#候选 host自行添加，文件名：host.[版本号] ,文件第一行：version [版本号] 剩下填写正常host内容
FILE1=hosts.1
VER1=1
FILE2=hosts.2
VER2=2
#...

if [ $# -lt 1 ]; then
    echo "switch host must have one parameter,$1 is the target version,example:
          swh -l [显示目前版本]
		  swh $FILE1/$FILE2..... [切换到目标版本]"
    exit;
fi

#-l 显示目前版本
if [ "$1" == "-l" ]; then
	echo "now version: $NOW_VER"
	exit
fi
# 目标与目前版本相同
if [ "$NOW_VER" == "$TGT_VER" ]; then
	echo "source and target same! now version: $NOW_VER ,target version: $TGT_VER "
	exit
fi

#获取版本对应文件名
function getfile()
{
if [ "$1" == "$VER1" ]; then
	TGT=$FILE1
elif [ "$1" == "$VER2" ]; then
	TGT=$FILE2
#....按版本继续添加
else
	echo 'unknown version $1'
	exit
fi
echo $TGT
}

TGT_FILE=`getfile $NOW_VER`


set -x
#备份目前版本
mv /cygdrive/c/Windows/System32/drivers/etc/hosts /cygdrive/c/Windows/System32/drivers/etc/$TGT_FILE

#change to new file
SRC_FILE=`getfile $TGT_VER`
#选定版本激活为hosts
mv /cygdrive/c/Windows/System32/drivers/etc/$SRC_FILE /cygdrive/c/Windows/System32/drivers/etc/hosts



