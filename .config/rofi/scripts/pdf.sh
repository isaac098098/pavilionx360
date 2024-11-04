#!/bin/bash

lecs=$(grep 'lec' $HOME/notes/current-notes/main.tex | sed -n 's/.*lec_\([0-9]\{2\}\).tex.*/\1/p')
last=$(echo "$lecs" | sort -nr | head -n1)

# open last lecture note pdf

case "$1" in 
    "Last")
        # compile last lecture
        killall rofi
        for (( i=1; i<=$last-1; i++ ))
        do
            sed -i "s/^\\\\\input{lec_$(printf '%02d' $i).tex}/% \\\\\input{lec_$(printf '%02d' $i).tex}/g" $HOME/notes/current-notes/main.tex
        done
        sed -i "s/^% \\\\\input{lec_${last}.tex}/\\\\\input{lec_${last}.tex}/g" "$HOME/notes/current-notes/main.tex"
        latexmk -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
        pdflatex -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
        zathura $HOME/notes/current-notes/main.pdf
    ;;
        # compile whole document
    "All")
        killall rofi
        sed -i "s/% //g" $HOME/notes/current-notes/main.tex
        sed -i 's/^% \\/\\/g' $HOME/notes/eof.tex
        latexmk -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
        pdflatex -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null

        # comment title pages, toc and bibliography again
        sed -i '7,13 s/^/% /' $HOME/notes/current-notes/main.tex
        sed -i 's/^\\/% \\/g' $HOME/notes/eof.tex
        zathura $HOME/notes/current-notes/main.pdf
    ;;
    *)
        # compile and open lecture interval or specific lectures
        if [[ "$1" =~ ^([0-9]+(-[0-9]+)?)(,[0-9]+(-[0-9]+)?)*$ ]]
        then
            killall rofi
            sed -i "s/^\\\\\input{lec/% \\\\\input{lec/g" "$HOME/notes/current-notes/main.tex"
            IFS=',' read -r -a ints <<< "$1"
            for s in "${ints[@]}"
            do
                if [[ $s == *-* ]]
                then
                    start=${s%-*}
                    end=${s#*-}
                for i in $(seq "$start" "$end")
                do
                    if  [ "1" -le "$((i))" ] && [ "$((i))" -le "$((last))" ]
                    then
                        sed -i "s/^% \\\\\input{lec_$(printf '%02d' $i).tex}/\\\\\input{lec_$(printf '%02d' $i).tex}/g" $HOME/notes/current-notes/main.tex
                    fi
                done
            else
                if [ "1" -le "$((s))" ] && [ "$((s))" -le "$((last))" ]
                then
                    sed -i "s/^% \\\\\input{lec_$(printf '%02d' $s).tex}/\\\\\input{lec_$(printf '%02d' $s).tex}/g" $HOME/notes/current-notes/main.tex
                fi
                fi
            done
            latexmk -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
            pdflatex -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
            zathura $HOME/notes/current-notes/main.pdf
        fi
        ;;
esac

# compile and open single lecture

for i in $lecs
do
    title=$(sed -n 's/^%%% //p' $HOME/notes/current-notes/lec_"$i".tex)
    date=$(sed -n 's/.*lecture{.*}{\(.*\)}/\1/p' $HOME/notes/current-notes/lec_"$i".tex)
    if [[  "$1" == "$(printf "%-30s %24s\n" "$i. $title" "$date")" ]]
    then
        killall rofi
        sed -i "s/^% \\\\\input{lec_$(printf '%02d' $i).tex}/\\\\\input{lec_$(printf '%02d' $i).tex}/g" $HOME/notes/current-notes/main.tex
        for (( j=1 ; j <= $last ; j++))
        do
            if [[ $((i)) -ne $j ]]
            then
                sed -i "s/^\\\\\input{lec_$(printf '%02d' $j).tex}/% \\\\\input{lec_$(printf '%02d' $j).tex}/g" $HOME/notes/current-notes/main.tex
            fi
        done
        latexmk -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
        pdflatex -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
        zathura $HOME/notes/current-notes/main.pdf
    fi
done

# rofi menu

echo "Last"
echo "All"
for i in $lecs
do
    title=$(sed -n 's/^%%% //p' $HOME/notes/current-notes/lec_"$i".tex)
    date=$(sed -n 's/.*lecture{.*}{\(.*\)}/\1/p' $HOME/notes/current-notes/lec_"$i".tex)
    printf "%-30s %24s\n" "$i. $title" "$date"

done
