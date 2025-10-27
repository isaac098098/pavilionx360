#!/bin/bash

if [[ "$1" ]]
then
    case $1 in
        "Networking")
            dir="$HOME/documents/books/networking"
        ;;
        "OS")
            dir="$HOME/documents/books/os"
        ;;
        "Reverse Engineering")
            dir="$HOME/documents/books/reversing"
        ;;
        "Pentesting")
            dir="$HOME/documents/books/pentesting"
        ;;
        "Graphics")
            dir="$HOME/documents/books/graphics"
        ;;
        "Languages")
            dir="$HOME/documents/books/languages"
        ;;
        "Diagrams")
            dir="$HOME/code/diagrams"
        ;;
        *)
            rofi -e "No directory for \"$1\"" 2>/dev/null
            exit 1
        ;;
    esac

    sed -i "3s|.*|dir=\"$dir\"|" $HOME/.config/rofi/scripts/open_book.sh

    exit 0
else
    echo "Networking"
    echo "OS"
    echo "Reverse Engineering"
    echo "Pentesting"
    echo "Graphics"
    echo "Languages"
    echo "Diagrams"
    
    exit 0
fi
