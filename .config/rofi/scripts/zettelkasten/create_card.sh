#!/bin/bash

dir="$HOME/zettelkasten/current"

if [ "$1" ]
then
    if [ "$1" == "New root node" ]
    then
        tmp=$(mktemp)

        new_card=$($HOME/.config/rofi/scripts/bin/create_card               \
            "$dir/main.tex"                                                 \
            "$dir/cards/"                                                   \
            "root"                                                          \
            2> "$tmp")

        stderr=$(<"$tmp")
        rm -r "$tmp"

        if [ -n "$stderr" ]
        then
            killall rofi 2>/dev/null
            rofi -e "$stderr" -config $HOME/.config/rofi/short.rasi &
            exit 0
        fi

        if [ -S /tmp/nvimsocket_cards ]
        then
            nvim --server /tmp/nvimsocket_cards                             \
            --remote-tab "$dir/cards/$new_card.tex" &
        else
            NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards                       \
            st -e nvim --server /tmp/nvimsocket_cards                       \
            --remote-tab "$dir/cards/$new_card.tex" 2>/dev/null &
        fi

        killall rofi 2>/dev/null

        exit 0
    else
        card=$(echo "$1" | awk '{print $1}')

        tmp=$(mktemp)

        new_card=$($HOME/.config/rofi/scripts/bin/create_card               \
            "$dir/main.tex"                                                 \
            "$dir/cards/"                                                   \
            "$card.tex"                                                     \
            2> "$tmp")

        stderr=$(<"$tmp")
        rm -r "$tmp"

        if [ -n "$stderr" ]
        then
            killall rofi 2>/dev/null
            rofi -e "$stderr" -config $HOME/.config/rofi/short.rasi &
            exit 0
        fi

        if [ -S /tmp/nvimsocket_cards ]
        then
            nvim --server /tmp/nvimsocket_cards                             \
            --remote-tab "$dir/cards/$new_card.tex" &
        else
            NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards                       \
            st -e nvim --server /tmp/nvimsocket_cards                       \
            --remote-tab "$dir/cards/$new_card.tex" 2>/dev/null &
        fi

        killall rofi 2>/dev/null

        exit 0
    fi
fi

$HOME/.config/rofi/scripts/bin/show_cards "$dir/cards"
echo "New root node"
