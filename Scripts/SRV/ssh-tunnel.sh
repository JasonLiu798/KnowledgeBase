#!/usr/bin/expect -f
set vertify [lindex $argv 0]
set hostname [跳板机ip]
set port [跳板机port]
set dbip [目标机ip]
set dbport [目标机port]
set user [跳板机用户名]
set passwd [跳板机密码]
set timeout 30

set force_conservative 1
if {$force_conservative} {
        set send_slow {128 .1}
}

spawn ssh -L [本地端口]:[本地端口]:$dbip:$dbport $user@$hostname -p $port 

expect {
        "*continue connecting (yes/no)?" {
                send -s "yes\r"; exp_continue
        }
        "Verification code:" {
                send -s "$vertify\r";
                exp_continue
        }
        "Password:" {
                send -s "$passwd\r";
        }
}
interact

