#!/bin/bash

#dir="$HOME/documents/books/sciences"
#dir="$HOME/documents/academic//tesis_bib/"
dir="$HOME/documents/academic/cinvestav/semestre_1/"

if [[ -n "$1" ]]; then
    killall rofi
    book=$(find "$dir" -type f -name "$1")
    zathura "$book" &
    exit 0
fi

find "$dir" -type f -printf "%f\n"
