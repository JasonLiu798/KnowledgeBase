#!/bin/bash

function ftplist()
{
#$1 HOST
#$2 USER
#$3 PASS
ftp -n<<EOF
open $1
user $2 $3
binary
cd code
prompt
ls
close
bye
EOF
}

function ftpgetput()
{
#$1 HOST
#$2 USER
#$3 PASS
#$4 METHOD
#$5 FILE
ftp -n<<EOF
open $1
user $2 $3
binary
cd code
prompt
$4 $5
close
bye
EOF
}


