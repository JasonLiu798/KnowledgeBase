#!/bin/bash

alias vi='vim'
alias vgr='vagrant reload'
export LANG="zh_CN.UTF-8"

#PS1="\[\033[1;32;40m[\033[0;32;40m\u@\h:\033[1;35;40m\w\033[1;32;40m]\033[1;31;40m\$\033[1;32;40m \]"

export PRJ=/drives/c/project

export SRV=/drives/c/servers
export C=/drives/c
export D=/drives/d
export E=/drives/e
export DOC=/drives/c/project/documents
#export JAVA_HOME="C:\Program Files\Java\jdk1.7.0_75"

export WWW=/drives/d/xampp/htdocs
export PYPRJ=/drives/c/project/python
export UBIN=/home/mobaxterm/bin
export FE=/drives/c/project/GPSFrontend
export BG=/drives/c/project/GPSBGSERVER
export UP=/drives/d/up

export VG=/drives/c/vm/ubuntu14
export SAE=/drives/c/servers/sae/wwwroot

#java
JAVA_HOME=/opt/java
M2_HOME=/opt/maven
HADOOP_HOME=/opt/hadoop
export M2_HOME HADOOP_HOME

export PATH=$PATH:'/home/mobaxterm/bin':$JAVA_HOME/bin:/drives/c/HashiCorp/Vagrant/bin:$M2_HOME/bin
#files 
export NBG=/drives/c/project/gps-bgserver
