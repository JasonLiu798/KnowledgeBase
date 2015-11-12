#!/bin/bash
#file format
#1:serverMark 2:IP 3:Port 4:username 5:password


IP=`cat servers.dat |awk '{if($1~/^'"$1"'$/)print $2}'`
PORT=`cat servers.dat |awk '{if($1~/^'"$1"'$/)print $3}'`
USER=`cat servers.dat |awk '{if($1~/^'"$1"'$/)print $4}'`
PASS=`cat servers.dat |awk '{if($1~/^'"$1"'$/)print $5}'`


set -x
$UBIN/ssh_expect $IP $PROT $USER $PASS





