#ssh no password
#http://www.cnblogs.com/jdksummer/articles/2521550.html
ssh-keygen -t rsa
#if still use password,execute scripts as below
chmod o-w ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

ps -Af | grep agent 
