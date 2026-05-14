case $- in *i*) ;; *) return;; esac

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT='%F %T '
shopt -s histappend checkwinsize

if [ "$EUID" -eq 0 ]; then
    PS1='\[\e[01;31m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]# '
else
    PS1='\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '
fi

alias ll='ls -alF'
alias grep='grep --color=auto'
alias ls='ls --color=auto'

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
