#!/bin/bash

#dir="$HOME/documents/books"
#dir="$HOME/documents/books/manuals/drawing"
dir="$HOME/documents/academic/cinvestav/semestre_1"

if [[ -n "$1" ]]; then
    killall rofi
    book=$(find "$dir" -type f -name "$1")
    zathura "$book" &
    exit 0
fi

find "$dir" -type f -printf "%f\n"
