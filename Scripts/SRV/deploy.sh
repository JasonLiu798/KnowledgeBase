#!/bin/bash

DATA=/data
SRVNAME=membernew
OPBIN=opbin
VERSION=1.0.0
VTYPE=SNAPSHOT

OPBIN_PATH=$DATA/$SRVNAME/$OPBIN
FILENAME=xxx-member-$VERSION-$VTYPE
TAR_FILENAME=$FILENAME-assembly.tar.gz

set -x
sh $OPBIN_PATH/stop.sh

tar zxvf $DATA/$TAR_FILENAME  -C $DATA
mv $DATA/$FILENAME $DATA/$SRVNAME

dos2unix $OPBIN_PATH/* 

sh $OPBIN_PATH/start.sh


