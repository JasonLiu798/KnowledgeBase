#!/bin/bash
if [ $# -lt 1 ]; then
        echo "Usage:unpack version"
        exit
fi

#EXDIR=/root/Oracle/Middleware/user_projects/domains/GPSMonitor/servers/AdminServer/upload/tmp
EXDIR=/newpart/weblogic/upload/tmp/
FILEDIR=/newpart/weblogic/upload/
#/root/Oracle/Middleware/user_projects/domains/GPSMonitor/servers/AdminServer/upload/tmp
#EXDIR="/drives/d/tmp"
echo "rm -rf $EXDIR*"
rm -rf $EXDIR*
JARNAME="gps"
OLDVER=$1
FILETYPE=".war"
FILENAME="$JARNAME$OLDVER$FILETYPE"
echo "$FILENAME"

mv $FILENAME $EXDIR$FILENAME
echo "cd $EXDIR"
cd $EXDIR
pwd
jar xvf $FILENAME

mv $FILENAME $FILEDIR$FILENAME

cd $FILEDIR
