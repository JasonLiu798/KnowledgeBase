#ruby env
---
#setup
##windows
http://rubyinstaller.org/downloads/
libffi下载：https://sourceware.org/libffi/
ltconfig: you must specify a host type if you use `--no-verify'
Try `ltconfig --help' for more information.
configure: error: libtool configure failed
cp /usr/share/libtool/config.guess ./


##包安装
sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common autoconf bison libreadline6-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev


##rbenv
cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.1.2
rbenv global 2.1.2


#gem
change source http://ruby.taobao.org/
$ gem sources --remove https://rubygems.org/
$ gem sources -a https://ruby.taobao.org/
$ gem sources -l
*** CURRENT SOURCES ***

https://ruby.taobao.org
# 请确保只有 ruby.taobao.org
$ gem install rails
