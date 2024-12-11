#!/bin/bash

if [ $# == 1 ]; then
	while read -u 3 name; do
		read a <<< $name
		python3 inference_video.py --exp=1 --video="$a.mp4"
	done 3< $1
	exit 1
fi
