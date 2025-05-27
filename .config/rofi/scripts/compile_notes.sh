#!/bin/bash

lecs=$(grep 'lec' $HOME/notes/current-notes/main.tex | sed -n 's/.*lec_\([0-9]\{2\}\).tex.*/\1/p')
last=$(echo "$lecs" | sort -nr | head -n1)

# open last lecture note pdf

case "$1" in 
    "Last")
        # compile last lecture
        killall rofi
        for (( i=1; i<=$((10#$last-1)); i++ ))
        do
            sed -i "s/^\\\\\input{lecs/lec_$(printf '%02d' $i).tex}/% \\\\\input{lecs/lec_$(printf '%02d' $i).tex}/g" $HOME/notes/current-notes/main.tex
        done
        sed -i "s/^% \\\\\input{lecs/lec_${last}.tex}/\\\\\input{lecs/lec_${last}.tex}/g" "$HOME/notes/current-notes/main.tex"
        pdflatex -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
        zathura $HOME/notes/current-notes/main.pdf
    ;;
        # compile whole document
    "All")
        killall rofi
        sed -i "s/% //g" $HOME/notes/current-notes/main.tex
        sed -i 's/^% \\/\\/g' $HOME/notes/eof.tex
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
            sed -i "s/^\\\\\input{lecs/lec/% \\\\\input{lecs/lec/g" "$HOME/notes/current-notes/main.tex"
            IFS=',' read -r -a ints <<< "$1"
            for s in "${ints[@]}"
            do
                if [[ $s == *-* ]]
                then
                    start=${s%-*}
                    end=${s#*-}
                for i in $(seq "$start" "$end")
                do
                    if  [ "1" -le "$((i))" ] && [ "$((i))" -le "$((10#$last))" ]
                    then
                        sed -i "s/^% \\\\\input{lecs/lec_$(printf '%02d' $i).tex}/\\\\\input{lecs/lec_$(printf '%02d' $i).tex}/g" $HOME/notes/current-notes/main.tex
                    fi
                done
            else
                if [ "1" -le "$((s))" ] && [ "$((s))" -le "$((10#$last))" ]
                then
                    sed -i "s/^% \\\\\input{lecs/lec_$(printf '%02d' $s).tex}/\\\\\input{lecs/lec_$(printf '%02d' $s).tex}/g" $HOME/notes/current-notes/main.tex
                fi
                fi
            done
            pdflatex -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
            zathura $HOME/notes/current-notes/main.pdf
        fi
        ;;
esac

# compile and open single lecture

for i in $lecs
do
    title=$(sed -n '0,/^%%% /s/^%%% //p' $HOME/notes/current-notes/lecs/lec_"$i".tex)
    date=$(sed -n '1,/.*lecture{.*}{\(.*\)}/s/.*lecture{.*}{\(.*\)}/\1/p' $HOME/notes/current-notes/lecs/lec_"$i".tex)
    if [[  "$1" == "$(printf "%-30s %44s\n" "$i. $title" "$date")" ]]
    then
        killall rofi
        sed -i "s/^% \\\\\input{lecs/lec_$(printf '%02d' $i).tex}/\\\\\input{lecs/lec_$(printf '%02d' $i).tex}/g" $HOME/notes/current-notes/main.tex
        for (( j=1 ; j <= $((10#$last)) ; j++))
        do
            if [[ "$((j))" -ne "$((10#$i))" ]]
            then
                sed -i "s/^\\\\\input{lecs/lec_$(printf '%02d' $j).tex}/% \\\\\input{lecs/lec_$(printf '%02d' $j).tex}/g" $HOME/notes/current-notes/main.tex
            fi
        done
        pdflatex -output-directory="$HOME/notes/current-notes/" "$HOME/notes/current-notes/main.tex" > /dev/null
        zathura $HOME/notes/current-notes/main.pdf
        break
    fi
done

# rofi menu

echo "Last"
echo "All"
for i in $lecs
do
    cur=$(printf '%02d' $((10#$last-10#$i+1)))
    title=$(sed -n '0,/^%%% /s/^%%% //p' $HOME/notes/current-notes/lecs/lec_"$cur".tex)
    date=$(sed -n '1,/.*lecture{.*}{\(.*\)}/s/.*lecture{.*}{\(.*\)}/\1/p' $HOME/notes/current-notes/lecs/lec_"$cur".tex)
    printf "%-30s %44s\n" "$cur. $title" "$date"
done
