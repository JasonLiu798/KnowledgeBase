# .bashrc

alias vi='vim'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
#ls
alias ls='ls --color'
alias ll='ls -l --color'
alias la='ls -al --color'
#grep
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# gbk -> utf-8
alias gu='iconv -f gbk -t utf-8'
#ps
alias psj='ps -ef|grep java'
#df du
alias df='df -h'
alias du='du -h'



# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

#useful path
export C=/c
export D=/d
export E=/e
export F=/f
export YP=$D/yp
export PRJ=$YP/project
export DOC=$YP/documents
export SETUP=/opt/setups
export TL=/opt/tools

BGS=/root/Desktop/GpsBGServer/lib
LOG=/opt/logs
UP=/opt/upload
OPT=/opt
UBIN=/opt/bin
ISO=/mnt/iso
NETWORK=/etc/sysconfig/network-scripts
export BGS UP LOG OPT UBIN ISO NETWORK

#java
JAVA_HOME=/opt/java
WL=/opt/weblogic/user_projects/domains/GPSMonitor
CATALINA_HOME='/opt/tomcat'
TOMCAT=$CATALINA_HOME
CLASSPATH=.:$JAVA_HOME/lib
export JAVA_HOME WL CATALINA_HOME TOMCAT CLASSPATH

#hadoop
HB=/opt/hbase
HDP=/opt/hadoop
HADOOP_HOME=$HDP
HADOOP_PREFIX=$HDP
HADOOP_CONF_DIR=/etc/hadoop
ZP=/opt/ZOOKEEPER
export HDP HB ZP HADOOP_HOME HADOOP_CONF_DIR

#proxy
PROXY=http://proxy.xj.petrochina:8080
http_proxy=$PROXY
https_proxy=$PROXY
ftp_proxy=$PROXY
no_proxy=10.,192.
export http_proxy https_proxy ftp_proxy no_proxy

#path
export PATH=$PATH:$JAVA_HOME/bin:/opt/bin:$CATALINA_HOME/bin:$HADOOP_HOME/bin











