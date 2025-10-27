#!/bin/bash

dir="$HOME/zettelkasten/current"

if [ "$1" ]
then
    card_1=$(echo "$1" | awk -F- '{print $1}')
    card_2=$(echo "$1" | awk -F- '{print $2}')

    if [ -z "$card_1" ]
    then
        killall rofi 2>/dev/null
        rofi -e "missing card" -config $HOME/.config/rofi/short.rasi
        exit 0
    fi

    if [ -z "$card_2" ]
    then
        killall rofi 2>/dev/null
        rofi -e "missing card" -config $HOME/.config/rofi/short.rasi
        exit 0
    fi

    tmp=$(mktemp)

    $HOME/.config/rofi/scripts/bin/swap_cards                           \
        "$dir/cards/"                                                   \
        "$card_1.tex"                                                   \
        "$card_2.tex"                                                   \
        2> "$tmp"

    stderr=$(<"$tmp")

    if [ -n "$stderr" ]
    then
        killall rofi 2>/dev/null
        rofi -e "$stderr" -config $HOME/.config/rofi/short.rasi

        exit 0
    fi

    killall rofi 2>/dev/null

    exit 0
fi

$HOME/.config/rofi/scripts/bin/show_cards "$dir/cards"
