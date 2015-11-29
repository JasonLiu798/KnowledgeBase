#!/bin/bash
#swh.sh

#versions:now[comm], test1,test2...
#swh example:swh test1;check comm version; mv comm->version; mv test1->now

NOW_VER=`cat /cygdrive/c/Windows/System32/drivers/etc/hosts|grep version|awk '{print $2}'`
TGT_VER=$1

COMM_FILE=hosts.comm
TEST163_FILE=hosts.test163
TEST168_FILE=hosts.test168
DEV_FILE=hosts.dev

if [ $# -lt 1 ]; then
        echo 'switch host must have one parameter,$1 is the target version,example:swh comm,swh t163,swh t168 '
        exit
fi

if [ "$NOW_VER" == "$TGT_VER" ]; then
	echo "source and target same! now version: $NOW_VER ,target version: $TGT_VER "
	exit
fi

#backup now host
if [ "$NOW_VER" == "comm" ]; then
	TGT_FILE=$COMM_FILE
elif [ "$NOW_VER" == "t163" ]; then
	TGT_FILE=$TEST163_FILE
elif [ "$NOW_VER" == "t168" ]; then
	TGT_FILE=$TEST168_FILE
elif [ "$NOW_VER" == "dev" ]; then
	TGT_FILE=$DEV_FILE
else
	echo 'unknown source version $NOW_VER'
	exit
fi

echo "mv /cygdrive/c/Windows/System32/drivers/etc/hosts /cygdrive/c/Windows/System32/drivers/etc/$TGT_FILE"
mv /cygdrive/c/Windows/System32/drivers/etc/hosts /cygdrive/c/Windows/System32/drivers/etc/$TGT_FILE

#change to new file
if [ "$TGT_VER" == "comm" ]; then
	SRC_FILE=$COMM_FILE
elif [ "$TGT_VER" == "t163" ]; then
	SRC_FILE=$TEST163_FILE
elif [ "$TGT_VER" == "t168" ]; then
	SRC_FILE=$TEST168_FILE
elif [ "$TGT_VER" == "dev" ]; then
	SRC_FILE=$DEV_FILE
else
	echo 'unknown target version $SRC_VER'
	exit
fi

echo "mv /cygdrive/c/Windows/System32/drivers/etc/$SRC_FILE /cygdrive/c/Windows/System32/drivers/etc/hosts"
mv /cygdrive/c/Windows/System32/drivers/etc/$SRC_FILE /cygdrive/c/Windows/System32/drivers/etc/hosts


