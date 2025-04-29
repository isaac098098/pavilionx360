#!/bin/bash

cs=$(ls $HOME/notes)

# select current working notes

for i in $cs
do
    j=$(echo "$i" | tr '_' ' ' | awk '{for (i=1; i<=NF; ++i) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    if [ "$1" == "$j" ]
    then
        if [ -d "$HOME/notes/current-notes" ]
        then
            rm $HOME/notes/current-notes
        fi
        ln -sf $HOME/notes/"$i" $HOME/notes/current-notes
        exit 0
    fi
done

# rofi menu

for i in $cs
do
    if [ "$i" != "current-notes" ] && [ "$i" != "pream.tex" ] && [ "$i" != "eof.tex" ] && [ "$i" != "ws" ] && [ "$i" != "name" ]
    then
        echo "$i" | tr '_' ' ' | awk '{for (i=1; i<=NF; ++i) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
    fi
done
