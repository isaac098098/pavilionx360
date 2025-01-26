#!/bin/bash

#dir="$HOME/documents/books/sciences"
dir="$HOME/documents/academic/esfm/tesis/tesis_bib/books"

if [[ -n "$1" ]]; then
    killall rofi
    book=$(find "$dir" -type f -name "$1")
    zathura "$book" &
    exit 0
fi

find "$dir" -type f -printf "%f\n"
