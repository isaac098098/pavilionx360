#!/usr/bin/bash

ROOT_DIR="$HOME/pavilionx360"
BACKUP_DIR="$ROOT_DIR/backup"
CONFIG_DIR="$ROOT_DIR/.config"
HOME_DIR="$ROOT_DIR/home"
LOCAL_DIR="$ROOT_DIR/.local"

# check required directories existence

REQUIRED_DIRS=(
    "$BACKUP_DIR/suckless/dwm"
    "$BACKUP_DIR/suckless/st"
    "$CONFIG_DIR/picom"
    "$CONFIG_DIR/sxhkd"
    "$CONFIG_DIR/zathura"
    "$HOME_DIR"
    "$LOCAL_DIR/share/"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "created directory $dir"
    fi
done

# backup public files

cp ~/repos/dwm/dwm.c            "$BACKUP_DIR/suckless/dwm/"
cp ~/repos/dwm/config.h         "$BACKUP_DIR/suckless/dwm/"
cp ~/repos/st/config.h          "$BACKUP_DIR/suckless/st/"

cp ~/.config/picom/picom.conf   "$CONFIG_DIR/picom/"
cp ~/.config/zathura/zathurarc  "$CONFIG_DIR/zathura/"

cp ~/.bash_profile              "$HOME_DIR/"
cp ~/.bashrc                    "$HOME_DIR/"
cp ~/.tmux.conf                 "$HOME_DIR/"
cp ~/.update_dotfiles.sh        "$HOME_DIR/"
cp ~/.vimrc                     "$HOME_DIR/"
cp ~/.xinitrc                   "$HOME_DIR/"
cp ~/.Xresources                "$HOME_DIR/"

# backup private files

if [ "$1" ]; then
    PASSWD="$1"

    7z a -t7z -mx=7 -mhe=on -p"$PASSWD" "$CONFIG_DIR/nvim.7z"               \
                                        ~/.config/nvim/
    7z a -t7z -mx=7 -mhe=on -p"$PASSWD" "$CONFIG_DIR/rofi.7z"               \
                                        ~/.config/rofi/
    7z a -t7z -mx=7 -mhe=on -p"$PASSWD" "$CONFIG_DIR/sxhkd/sxhkdrc.7z"      \
                                        ~/.config/sxhkd/sxhkdrc
    7z a -t7z -mx=7 -mhe=on -p"$PASSWD" "$HOME_DIR/code.7z"                 \
                                        ~/code/
    7z a -t7z -mx=7 -mhe=on -p"$PASSWD" "$LOCAL_DIR/bin.7z"                 \
                                        ~/.local/bin
    7z a -t7z -mx=7 -mhe=on -p"$PASSWD" "$LOCAL_DIR/share/zathura.7z"       \
                                        ~/.local/share/zathura
else
    echo "not creating private backups, provide a password as first argument"
    echo "it is recommended to run \`set +o history\` to temporary disable"
    echo "bash history and \`set -o history\` to re-enable it afterwards"
fi
