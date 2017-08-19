#!/bin/bash


function usage()
{
echo "$ARG0 usage:
	$ARG0 -d [dir1,dir2] -t [/backupdir]
	$ARG0 -p [prof] -s [sql]"
}

PRJ='/d/project'
PRJJ="$PRJ/java"
DIRS="$PRJ/documents,$PRJJ/toolbox-java"
TGT='/y/OneDrive/backup'

while getopts p:s: opts
do
	case $opts in
	d)
	if [ "$OPTARG" != "" ];then
		echo "backup dirs "$DIRS
		DIRS=$OPTARG
	fi
	;;
	t)
	if [ "$OPTARG" = "" ];then

		echo "backup target dir "$
		SQL=$OPTARG
	fi
	;;
	esac
done


DIRS=${DIRS//,/ }


