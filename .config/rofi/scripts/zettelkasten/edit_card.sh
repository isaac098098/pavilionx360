#!/bin/bash

dir="$HOME/zettelkasten/current/"

if [ "$1" ]
then
    card=$(echo "$1" | awk '{print $1}')

    if [ ! -f "$dir/cards/$card.tex" ]
    then
        killall rofi 2>/dev/null
        rofi -e "card $card does not exists" -config $HOME/.config/rofi/short.rasi &
        
        exit 0
    fi

    if [ -S /tmp/nvimsocket_cards ]
    then
        nvim --server /tmp/nvimsocket_cards                 \
        --remote-tab "$dir/cards/$card.tex" &
    else
        NVIM_LISTEN_ADDRESS=/tmp/nvimsocket_cards           \
        st -e nvim --server /tmp/nvimsocket_cards           \
        --remote-tab "$dir/cards/$card.tex" 2>/dev/null &
    fi

    # srv_lst=$(vim --serverlist)
    # if [[ "$srv_lst" =~ "VIMCARDS" ]]
    # then
        # vim --servername VIMCARDS --remote-tab "$dir/cards/$card.tex" &
    # else
        # st -e vim --servername VIMCARDS "$dir/cards/$card.tex" 2>/dev/null &
    # fi

    killall rofi 2>/dev/null
    exit 0
fi

$HOME/.config/rofi/scripts/bin/show_cards "$dir/cards"
