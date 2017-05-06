#!/bin/bash

export LANG="zh_CN.UTF-8"
alias vi='vim'
alias mac='ssh liujianlong@192.168.1.103'



#PS1="\[\033[1;32;40m[\033[0;32;40m\u@\h:\033[1;35;40m\w\033[1;32;40m]\033[1;31;40m\$\033[1;32;40m \]"

export PRJ=/d/project
export PRL=/d/project
export C=/c
export D=/d
export E=/e
export Y=/y

export YP=$Y/yp

export DOC=$PRJ/documents
export JAVA_HOME="/c/Program Files (x86)/Java/jdk1.7.0_79"

export WWW=/drives/d/xampp/htdocs
export PYPRJ=/drives/c/project/python
export UBIN=/home/mobaxterm/bin
export SRCFE=/drives/c/project/GPSFrontend
export SRCBG=/drives/c/project/GPSBGSERVER


export M2_HOME=/opt/maven

export PATH=$PATH:'/home/mobaxterm/bin':$JAVA_HOME/bin:$M2_HOME/bin
export DK=/home/mobaxterm/Desktop


export BG=/drives/c/project/gps-bgserver

export JPRJ=$PRJ/java
export TBX=$JPRJ/toolbox-java

alias tl='cd /d/project/java/toolbox-java'


#maven
alias mccpi='mvn clean compile package install -Dmaven.test.skip=true'
alias mvni='mvn clean compile package install -Dmaven.test.skip=true'
alias mvnp='mvn clean compile package -Dmaven.test.skip=true'

