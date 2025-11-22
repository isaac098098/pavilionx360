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
        "OpenGL")
            dir="$HOME/documents/books/graphics/opengl"
        ;;
        "Vulkan")
            dir="$HOME/documents/books/graphics/vulkan"
        ;;
        "Graphics")
            dir="$HOME/documents/books/graphics/theory"
        ;;
        "C")
            dir="$HOME/documents/books/languages/c"
        ;;
        "C++")
            dir="$HOME/documents/books/languages/cpp"
        ;;
        "Python")
            dir="$HOME/documents/books/languages/python"
        ;;
        "Algorithms")
            dir="$HOME/documents/books/languages/algorithms"
        ;;
        *)
            rofi -e "No directory for \"$1\"" 2>/dev/null
            exit 1
        ;;
    esac

    sed -i "3s|.*|dir=\"$dir\"|" $HOME/.config/rofi/scripts/books/open_book.sh

    exit 0
else
    echo "Networking"
    echo "OS"
    echo "Reverse Engineering"
    echo "Pentesting"
    echo "OpenGL"
    echo "Vulkan"
    echo "Graphics"
    echo "C"
    echo "C++"
    echo "Python"
    echo "Algorithms"
    
    exit 0
fi
