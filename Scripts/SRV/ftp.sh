#!/bin/bash
#ftps v2 by jason

HOST="10.185.234.139"
USER="ftpuser"
PASS="Xxzx2013@)!#"
METHOD=$1
FILE=$2

function ftplist()
{
ftp -n<<EOF
open $HOST
user $USER $PASS
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
ftp -n<<EOF
open $HOST
user $USER $PASS
binary
cd code
prompt
$METHOD $FILE
close
bye
EOF
}

if [ $# -eq 1 ]; then
        echo "FTP list"
        ftplist
elif [ $# -eq 2 ]; then
        METHOD=$1
        FILE=$2
        echo "FTP $HOST $USER $METHOD $FILE"
        ftpgetput
else
        echo "FTPS must have one parameter at lestest!"
fi

#------------------------------------------------------------------------------------------------

#lftp
#!bin/bash
if [ $# -lt 2 ]; then
        echo 'FTP must have two parameter!'
        exit
fi
METHOD=$1
FILE=$2
echo "`date +%Y-%m-%d %H:%M:%S1` FTP $METHOD $FILE"
HOST="10.185.234.139"
USER="ftpuser"
PASS="Xxzx2013@)!#"
#LCD="/d/"
RCD="code"
lftp <<EOF
open ftp://$USER:$PASS@$HOST
$METHOD -o $FILE
EOF
echo "`date +%Y-%m-%d %H:%M:%S` FTP END"

#-----------------------------------------SCP-------------------------------------------------------
#scp v2
#!/bin/bash

METHOD=$1
FILE=$2

USR=root
HOST=10.185.234.135
UPPATH=/opt/upload/

if [ $# -lt 2 ]; then
        echo 'SCP must have one parameter!'
        exit
fi

if [ "$METHOD" == "put" ]; then
	echo "SCP $FILE $USR@$HOST:$UPPATH$FILE"
	scp $FILE $USR@$HOST:$UPPATH$FILE
elif [ "$METHOD" == "get" ]; then
	echo "SCP $USR@$HOST:$UPPATH$FILE" $FILE
	scp $USR@$HOST:$UPPATH$FILE $FILE
fi

