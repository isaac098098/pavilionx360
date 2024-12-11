#!/bin/bash
find . -type f |
shuf |  # shuffle the input lines, i.e. apply a random permutation
nl -n rz |  # add line numbers 000001, …
while read -r number name; do
    ext=${name##*/}  # try to retain the file name extension
    case $ext in
    *.*) ext=.${ext##*.};;
    *) ext=;;
    esac
    mv "$name" "./randomized/${name%/*}/$number$ext"
done
