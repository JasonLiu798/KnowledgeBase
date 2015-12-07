# .bashrc
#vi
alias vi='vim'
alias lvi="vim -c \"normal '0\"" #latest used
alias c='clear'
alias wl='ll | wc -l'
alias typea='type -a'
alias hg='history|grep'
alias netp='netstat -tulanp'
alias tf='tail -f '

#system
alias psg='ps aux | grep -v grep | grep -i --color'
alias psj='ps -ef|grep -v grep | grep --color java'
alias k9='kill -9'
psid() {
  [[ ! -n ${1} ]] && return;   # bail if no argument
  pro="[${1:0:1}]${1:1}";      # process-name –> [p]rocess-name (makes grep better)
  ps axo pid,user,command | grep -v grep |grep -i --color ${pro};   # show matching processes
  pids="$(ps axo pid,user,command | grep -v grep | grep -i ${pro} | awk '{print $1}')";   # get pids
  complete -W "${pids}" kill9     # make a completion list for kk
}

#file system
alias ls='ls -hF --color=tty'
alias ll='ls -lh --color'
alias la='ls -alh --color'
alias vdir='ls --color=auto --format=long'
alias p='pwd'
alias l='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
cdl() { cd "$@" && pwd ; ls -al; }
alias ..="cdl .."
alias ...="cd ../.."   # 快速进入上上层目录
alias .3="cd ../../.."
alias cd..='cdl ..'
mcd() { mkdir -p $1 && cd $1 && pwd ; } # mkdir -p + cd
alias df='df -h'
alias du='du -h'

#grep
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.lzma)      unlzma $1      ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x -ad $1 ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}

# 其它你自己的命令
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'


