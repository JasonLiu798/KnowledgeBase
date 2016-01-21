#!/bin/bash
#function returns
SUCCESS=0
FAIL=1

#script name
ARG0=`basename $0`

#timestamp
function ts()
{
echo date '+%s'
}
TS=`ts`

#default path
DDIR=$UBIN/data
BLIB=$UBIN/lib
SRVFILE=$DDIR/servers.dat
DBFILE=$DDIR/db.dat
REDISFILE=$DDIR/redis_server.dat
DPFILE=$DDIR/deploy.dat
#default upload path
DFTUPATH=/data
#potocol
HTTP="http://"
FTP="ftp://"
HTTPS="https://"
SSH="ssh://"
#upload download
DOWN=download
UP=upload

YES="yes"
NO="no"
TRUE="true"
FLASE="false"
T="true"
F="false"
#profile
DEV="dev"
PDEV="-Pdev"
#format
SEPLINE="--------------------------------"

#error code
#file not exist
E_FILE_NE=201


