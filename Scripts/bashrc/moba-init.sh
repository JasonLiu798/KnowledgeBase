#!/bin/bash

cd /
ln -sfv /drives/c /c
ln -sfv /drives/d /d
ln -sfv /drives/e /e
ln -sfv /drives/f /f


cd ~
ln -sfv $DOC/Scripts/bashrc/.bash_aliases .bash_aliases
ln -sfv $DOC/Scripts/bashrc/.bash_path .bash_path


ln -sfv /drives/d/tools/cygwin/home/Administrator/.bash_serv .bash_serv
ln -sfv /drives/d/tools/cygwin/home/Administrator/.bash_path .bash_path
ln -sfv /drives/d/tools/cygwin/home/Administrator/.bash_aliases .bash_aliases


ln -sfv /d/tools /opt/tools
ln -sfv /opt/tools/maven/apache-maven-3.3.3 /opt/maven
ln -sfv /opt/mysql /d/tools/MySQL/MySQL5.6
