#!/bin/bash

cd /
ln -sfv /drives/c /c
ln -sfv /drives/d /d
ln -sfv /drives/e /e
ln -sfv /drives/f /f

ln -sfv /drives/d/yp/documents/Scripts/bashrc/.bash_path ~/.bash_path
ln -sfv /drives/d/yp/documents/Scripts/bashrc/.bash_aliases ~/.bash_aliases

ln -sfv /drives/d/yp/documents/Scripts/bashrc/.bash_serv ~/.bash_serv

source ~/.bashrc

ln -sfv /d/tools /opt/tools
ln -sfv /opt/tools/maven/apache-maven-3.3.3 /opt/maven
ln -sfv /opt/mysql /d/tools/MySQL/MySQL5.6

ln -sfv /d/yp/documents/Scripts/ubin/lib ~/bin/lib
