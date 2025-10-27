#!/usr/bin/bash

cp -r ~/repos/dwm/config.h ~/pavilionx360/backup/dwm/
cp -r ~/repos/st/config.h ~/pavilionx360/backup/st/
cp -r ~/repos/dwm/dwm.c ~/pavilionx360/backup/dwm/
cp -r ~/.config/zathura ~/pavilionx360/.config/
cp -r ~/.config/rofi ~/pavilionx360/.config/
cp -r ~/.config/sxhkd ~/pavilionx360/.config/
cp -r ~/.config/picom ~/pavilionx360/.config/
rsync -aH --delete --itemize-changes --exclude 'lazy-lock.json' ~/.config/nvim/ ~/pavilionx360/.config/nvim/
cp -r ~/.local/share/zathura ~/pavilionx360/home/.local/share/

cp ~/.bash_profile ~/pavilionx360/home/
cp ~/.bashrc ~/pavilionx360/home/
cp ~/.tmux.conf ~/pavilionx360/home/
cp ~/.vimrc ~/pavilionx360/home/
cp ~/.xinitrc ~/pavilionx360/home/
cp ~/.Xresources ~/pavilionx360/home/
