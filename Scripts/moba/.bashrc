#!/bin/bash

export LANG="zh_CN.UTF-8"
alias vi='vim'
alias mac='ssh liujianlong@192.168.1.103'

if [ -f "${HOME}/.bash_aliases" ]; then
	source "${HOME}/.bash_aliases"
fi

#PS1="\[\033[1;32;40m[\033[0;32;40m\u@\h:\033[1;35;40m\w\033[1;32;40m]\033[1;31;40m\$\033[1;32;40m \]"
PS1='\[\033]0;\h\007\]
\[\033[36m\][\D{%Y-%m-%d %H:%M.%S}]\[\033[0m\]  \[\033[36m\]\w\[\033[0m\]
\[\033[36m\][\u.\h]\[\033[0m\]  '



export C=/drives/c
export D=/drives/d
export E=/drives/e
export F=/drives/f
export Y=/drives/y

# export C=/c
# export D=/d
# export E=/e
# export Y=/y


export PRJ=/d/project/java
export PRL=/d/project
export PHP=$PRJ/php



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


# 网络相关
export HOST=/cygdrive/c/Windows/System32/drivers/etc



export JPRJ=$PRJ/java
export TBX=$JPRJ/toolbox-java

alias tl='cd /d/project/java/toolbox-java'


#maven
alias mvnc='mvn compile -Dmaven.test.skip=true'
alias mvni='mvn clean compile package install -Dmaven.test.skip=true'
alias mvnp='mvn clean package -U -e -Dmaven.test.skip=true'
alias mvnv='mvn versions:set -DnewVersion= '
alias mvnlib='mvn dependency:copy-dependencies -DoutputDirectory=lib'










