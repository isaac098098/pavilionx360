#!/bin/bash
if [ $# == 1 ]; then
	num=1
	while read -u 3 name; do
		printf -v idx "%06d" $num
		read a <<< $name
		mv ./"$idx.png" ./"$a.png"
		((num++))		
	done 3< $1
	exit 1
fi
