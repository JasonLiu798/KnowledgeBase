# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

export SRV=x
export SRV_LOG=user


export BASE=/data
export SRV_PATH=$BASE/$SRV
export LOG=$BASE/logs
export SLOG=$LOG/$SRVALIAS

export OPBIN=$SRV_PATH/opbin

alias op="cd $OPBIN"
alias srv="cd $SRV_PATH"
alias log="cd $SRV_LOG"


alias vi='vim'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias whence='type -a'
#grep
alias grep='grep --color'
#ps
alias psj='ps -ef|grep java'
#df du
alias df='df -h'
alias du='du -h'








