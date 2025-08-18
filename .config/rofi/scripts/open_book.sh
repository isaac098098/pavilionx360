#!/bin/bash

dir="/home/shurik/documents/books/languages"

if [[ -n "$1" ]]; then
    killall rofi 2>/dev/null
    book=$(find "$dir" -type f -name "$1" | head -n 1)
    if [[ "$book" ]]
    then
        zathura "$book" 2>/dev/null &
        exit 0
    else
        rofi -e "No such file \"$1\""
        exit 1
    fi
fi

find "$dir" -type f \( -iname "*.pdf" -o -iname "*.djvu" -o -iname "*.cbr" -o -iname "*.epub" \) | awk -F/ '!seen[$NF]++ {print $NF}' | sort -df

exit 0
