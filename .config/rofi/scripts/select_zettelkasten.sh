#!/bin/bash

z=$(ls $HOME/zettelkasten)

# select current zettelcasten

for i in $z
do
    j=$(echo "$i" | tr '_' ' ' | awk '{for (i=1; i<=NF; ++i) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    if [ "$1" == "$j" ]
    then
        if [ -d "$HOME/zettelkasten/current" ]
            then
                rm $HOME/zettelkasten/current
        fi

        ln -s $HOME/zettelkasten/"$i" $HOME/zettelkasten/current
        exit 0
    fi
done

# rofi menu

for i in $z
do
    if [ "$i" != "current" ] && [ "$i" != "preamble.tex" ]
    then
        echo "$i" | tr '_' ' ' | awk '{for (i=1; i<=NF; ++i) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
    fi
done
