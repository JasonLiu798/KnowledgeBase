#!/bin/bash

cd /root

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

for i in `cat ip.txt`
do
ip=$(echo "$i"|cut -f1 -d":")
password=$(echo "$i"|cut -f2 -d":")

expect -c "
spawn scp /root/.ssh/authorized_keys /root/remote_operate.sh  root@$ip:/tmp/
        expect {
                \"*yes/no*\" {send \"yes\r\"; exp_continue}
                \"*password*\" {send \"$password\r\"; exp_continue}
                \"*Password*\" {send \"$password\r\";}
        }
"

expect -c "
spawn ssh root@$ip "/tmp/remote_operate.sh"
        expect {
                \"*yes/no*\" {send \"yes\r\"; exp_continue}
                \"*password*\" {send \"$password\r\"; exp_continue}
                \"*Password*\" {send \"$password\r\";}
        }
"

done
