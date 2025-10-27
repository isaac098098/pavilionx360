#!/bin/bash

dir="$HOME/zettelkasten/current"

if [ "$1" ]
then
    card=$(echo "$1" | awk '{print $1}')

    tmp=$(mktemp)

    $HOME/.config/rofi/scripts/bin/insert_card                          \
        "$dir/main.tex"                                                 \
        "$dir/cards/"                                                   \
        "$card.tex"                                                     \
        2> "$tmp"

    stderr=$(<"$tmp")
    rm -r "$tmp"

    if [ -n "$stderr" ]
    then
        killall rofi 2>/dev/null
        rofi -e "$stderr" -config $HOME/.config/rofi/short.rasi
        
        exit 0
    fi

    if [ -S /tmp/nvimsocket_cards ]
    then
        nvim --server /tmp/nvimsocket_cards                             \
        --remote-tab "$dir/cards/$card.tex" &
    else
        NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards                       \
        st -e nvim --server /tmp/nvimsocket_cards                       \
        --remote-tab "$dir/cards/$card.tex" 2>/dev/null &
    fi

    killall rofi 2>/dev/null

    exit 0
fi

$HOME/.config/rofi/scripts/bin/show_cards "$dir/cards"
