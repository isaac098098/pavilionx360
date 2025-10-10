#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '
PS1='\[\e[38;2;129;162;190m\]\W \[\e[0m\]'

export PATH="$HOME/.local/bin:$PATH"

alias nsxiv='nsxiv -b'
alias tty-clock='tty-clock -c -s -C 3 -S -n'
alias pipes.sh='pipes.sh'
