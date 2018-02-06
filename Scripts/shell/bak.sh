#!/bin/bash
set -x

echo 'backup .bashrc'
cp ~/.bashrc $BAK/cygwin/.bashrc

echo 'backup .vimrc'
cp ~/.vimrc $BAK/cygwin/.vimrc

echo 'backup idea'
cp $USR/.ideavimrc $BAK/idea/.ideavimrc
tar zpcvf idea.tar.gz $USR/.IntelliJIdea14 --exclude=$USR/.IntelliJIdea14/system --exclude=$USR/.IntelliJIdea14/restart
mv idea.tar.gz $BAK/idea/idea.tar.gz

echo 'backup bak.sh'
cp ~/bak.sh $BAK/bak.sh

echo 'backup maven settings'
cp /opt/maven/conf/settings.xml $BAK/maven/settings.xml

echo 'backup vagrant'
cp /e/vm/ubuntu64/Vagrantfile $BAK/vagrant/win/Vagrantfile

echo 'backup host'
cp /c/Windows/System32/drivers/etc/hosts* $BAK/network/win/

echo 'backup moba'
cp /d/moba/home/.bashrc $BAK/moba/.bashrc
cp /d/moba/home/.gitconfig $BAK/moba/.gitconfig
cp /d/moba/home/.vimrc $BAK/moba/.vimrc

echo 'backup scripts'
tar zpcvf ubin.tar.gz $UBIN
mv ubin.tar.gz $BAK/script/ubin.tar.gz
rm -f ubin.tar.gz


