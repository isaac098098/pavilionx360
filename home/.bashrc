#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD

alias nsxiv='nsxiv -b'
alias tty-clock='tty-clock -c -s -C 4 -S -n'
alias pipes.sh='pipes.sh'

TOP="$HOME/documents/academic/cinvestav/semestre_1/topologia"
VAR="$HOME/documents/academic/cinvestav/semestre_1/variable_compleja"
AUX="$HOME/documents/academic/cinvestav/semestre_1/aux_bib"
