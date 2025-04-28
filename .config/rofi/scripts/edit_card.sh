#!/bin/bash

dir="$HOME/zettelkasten/current"
cards=$(ls "$dir/cards" | grep .tex | sort -V)

if [[ "$1" ]]
then
    killall rofi
    card=$(echo "$1" | awk '{print $1}')
    alacritty -e nvim "$dir/cards/$card.tex" &
    exit 0
else
    for i in $cards
    do
        title=$(sed -n '0,/^%%% /s/^%%% //p' "$dir/cards/$i")
        tags=$(grep "^%% tags:" "$dir/cards/$i" | sed -E 's/^.*tags:[[:space:]]*//')
        printf "%-8s %s %59s\n" "${i%.tex}" "$title" "$tags"
    done
    exit 0
fi
