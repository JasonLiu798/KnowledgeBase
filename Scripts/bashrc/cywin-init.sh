#!/bin/bash


#install apt-cyg
lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
install apt-cyg /bin


#
ln -s /cygdrive/c /c
ln -s /cygdrive/d /d
ln -s /cygdrive/e /e

git config --global color.ui auto

echo "none /cygdrive cygdrive binary,noacl,posix=0,user 0 0">>/etc/fstab

echo "chk /etc/fstab"
cat /etc/fstab


ln -sfv /cygdrive/d/setups /opt/setups
ln -sfv /cygdrive/d/tools /opt/tools

ln -sfv /opt/tools/maven/apache-maven-3.3.3 /opt/maven

ln -sfv /d/yp/documents/Scripts/.vimrc .vimrc