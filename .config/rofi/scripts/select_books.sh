#!/bin/bash

if [[ "$1" ]]
then
    case "$1" in
    "Combinatorics")
        dir="$HOME/documents/academic/im/semestre_1/fundamentos_de_combinatoria/bib/"
    ;;
    "Graph Theory")
        dir="$HOME/documents/academic/im/semestre_1/teoria_de_las_graficas/bib/"
    ;;
    "Calculus")
        dir="$HOME/documents/academic/im/guias/bib/calculo/"
    ;;
    "Linear Algebra")
        dir="$HOME/documents/academic/im/guias/bib/algebra_lineal/"
    ;;
    "Guides")
        dir="$HOME/documents/academic/im/guias/guias/"
    ;;
    "Notes")
        dir="$HOME/notes/current-notes/bib"
    ;;
    "Drawing")
        dir="$HOME/documents/books/manuals/drawing"
    ;;
    "Reading")
        dir="$HOME/documents/reading/"
    ;;
    "General Mathematics")
        dir="$HOME/documents/books/sciences/math"
    ;;
    "All")
        dir="$HOME/documents/books/"
    ;;
    esac

    sed -i "3s|.*|dir=\"$dir\"|" $HOME/.config/rofi/scripts/search_books.sh

    exit 0
else
    echo "Combinatorics"
    echo "Graph Theory"
    echo "Calculus"
    echo "Linear Algebra"
    echo "Guides"
    echo "Notes"
    echo "Drawing"
    echo "Reading"
    echo "General Mathematics"
    echo "All"
    
    exit 0
fi
