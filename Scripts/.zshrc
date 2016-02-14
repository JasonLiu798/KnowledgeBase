# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export NSITE=/usr/local/etc/nginx/sites-available/
export NCONF=/usr/local/etc/nginx


#ZSH_THEME="aussiegeek"
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"
export CLICOLOR=1
export LSCOLORS=Fxbxaxdxcxegedabagacad

################提示符配置######################
# get the colors
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY; do
   eval C_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval C_L_$color='%{$fg[${(L)color}]%}'
done
C_OFF="%{$terminfo[sgr0]%}"

# set the prompt
set_prompt() {
   mypath="$C_OFF$C_L_GREEN%~"
   myjobs=()
   for a (${(k)jobstates}) {
       j=$jobstates[$a];i="${${(@s,:,)j}[2]}"
       myjobs+=($a${i//[^+-]/})
   }
   myjobs=${(j:,:)myjobs}
   ((MAXMID=$COLUMNS / 2)) # truncate to this value
   RPS1="$RPSL$C_L_GREEN%$MAXMID<...<$mypath$RPSR"
   rehash
}
RPSL=$'$C_OFF'
RPSR=$'$C_OFF$C_L_RED%(0?.$C_L_GREEN. (%?%))$C_OFF'
RPS2='%^'

# load prompt functions
setopt promptsubst
unsetopt transient_rprompt # leave the pwd

precmd()  {
   set_prompt
   print -Pn "\e]0;%n@$__IP:%l\a"
}
PS1=$'$C_L_BLUE%(1j.[$myjobs]% $C_OFF .$C_OFF)%m.%B%n%b$C_OFF$C_L_RED%#$C_OFF'
################end of prompt setting##########################

export HISTSIZE=10000

# # number of lines saved in the history after logout
export SAVEHIST=10000
# location of history
export HISTFILE=~/.zhistory
# # append command to history file once executed
setopt INC_APPEND_HISTORY

#自动补全功能
setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

#alias
alias vi='vim'
alias ll='ls -al'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias nginx.start='launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx.stop='launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'
alias nginx.restart='nginx.stop && nginx.start'
alias php-fpm.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist"
alias php-fpm.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist"
alias php-fpm.restart='php-fpm.stop && php-fpm.start'
alias redis.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias redis.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias redis.restart='redis.stop && redis.start'
alias memcached.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
alias memcached.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
alias memcached.restart='memcached.stop && memcached.start'

#alias ls='ls -F --color=auto'
alias grep='grep --color=auto'
alias ee='emacsclient -t'

#WWW
export AWW=/Library/WebServer/Documents
export WWW=/var/www
export NLOG=/usr/local/var/logs/nginx
#DOWNLOAD
export DOWN=/Users/liujianlong/Downloads
#JAVA PROJECT
export JPRJ=/Users/liujianlong/Desktop/javaprj
export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
export M2_HOME=/opt/maven
#TOMCAT
export CATALINA_BASE=/opt/tomcat
export CATALINA_HOME=/opt/tomcat
export CATALINA_TMPDIR=/opt/tomcat/temp
export TOMCAT=/opt/tomcat
#BACKUP
export BAK='/Users/liujianlong/360云盘/TOOLS/BACKUP'
export EXT=/Library/WebServer/Documents/ext
export ZF=/Users/liujianlong/Desktop/javaprj/TransmitProject/WebContent
export LIB='/Users/liujianlong/360云盘/PHP/lib'
export YP='/Users/liujianlong/360云盘'
export DOCKER_HOST=tcp://

#Folders
export DOC=/var/www/documents
export PY=/Users/liujianlong/python


#export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/mysql/bin:/bin:$JAVA_HOME/bin"
#export PATH="$(brew --prefix php55)/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/mysql/bin:/bin:$JAVA_HOME/bin:/usr/local/opt/php55/bin:/usr/local/Cellar/composer/1.0.0-alpha9/bin:/usr/local/opt/python/bin:/usr/local/opt/python3/bin:/usr/local/opt/thrift/bin:/Users/liujianlong/.composer/vendor/bin:$PATH":$M2_HOME/bin
#export PATH="$(brew --prefix composer)/bin:$PATH"
#export PATH="$(brew --prefix python)/bin:$PATH"
#export PATH="$(brew --prefix python3)/bin:$PATH"
#export PATH="$(brew --prefix thrift)/bin:$PATH"
#export PATH=/var/www/sport/vendor/bin:$PATH
#export PATH=/Users/liujianlong/.composer/vendor/bin:$PATH
export PHPINI="/usr/local/etc/php/5.5"
export GPSRC="/Users/liujianlong/360云盘/GPS/src-now/bsh"

export PYPRJ=/Users/liujianlong/python

export PRJ=/Users/liujianlong/project






