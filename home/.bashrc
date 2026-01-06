#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '
PS1='\[\e[38;2;229;177;145m\]\W \[\e[0m\]'

export PATH="$HOME/.local/bin:$PATH"
export COMP_WORDBREAKS="${COMP_WORDBREAKS//:}"

alias nsxiv='nsxiv -b'
alias tty-clock='tty-clock -c -s -C 3 -S -n'
alias pipes.sh='pipes.sh'
alias glow='glow -t'
alias lsfonts="fc-list | awk -F: '{print $2}' | awk -F, '{print $1}' | sort -u"
alias neofetch="neofetch --stdout | column -L -t -s ':'"
