#!/bin/bash

dir="$HOME/zettelkasten/current"

if [ "$1" ]
then
    card=$(echo "$1" | awk '{print $1}')
    killall rofi 2>/dev/null
    NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards st -e nvim --server /tmp/nvimsocket_cards --remote-tab "$dir/cards/$card.tex" &
    exit 0
fi

$HOME/.config/rofi/scripts/c/sort_cards "$dir/cards"
