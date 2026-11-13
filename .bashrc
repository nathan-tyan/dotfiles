[[ $- != *i* ]] && return

set -o vi

PS1=''
PS1+='
'
PS1+='\[\033[0;32m\][$(date +%k:%M:%S)]\[\033[00m\] '
PS1+='\[\033[0;33m\]\u@\h\[\033[00m\]:'
PS1+='\[\033[01;36m\]\w\[\033[00m\]'
PS1+='
$ '

HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=10000
