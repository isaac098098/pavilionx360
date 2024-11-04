# Packages

## Media

```
obs-studio
kdenlive
krita
mpv
4kvideodownloader
ffmpeg-thumbnailer
paleta
gpick
scrot
feh
vlc
shotwell
yt-dlp
```

## Gaming

```
steam
minecraft-launcher
mgba
wine
discord
```

## Productivity

```
obsidian
xournalpp
xournalpp-catppuccin
simple-scan
pdfarranger
texlive
zathura
zathura-pdf-mupdf
neovim
unclutter
```

## AI

```
stable-diffusion-webui
eccv2022-rife
```

## Browsers

```
brave
archive.org-downloader
dmenu
```

## System

```
xorg
xorg-xserver
xorg-xinit
xorg-xclipboard
xclip
i3-wm
i3status
picom
nvidia
neofetch
kitty
eww
papirus-folders
spotify
spotify-adblock (abba23)
spicetify-cli
spicetify-marketplcae-bin
bluez
bluez-utils
pulseaudio-bluetooth
tree-sitter-cli
nodejs
python
python-neovim
ripgrep
fd
wget
perl
luarocks
lua51
dunst
libnotify
tree
zenity
unzip
htop
xfce4-settings
rofi
```

## Themes
```
phinger-cursors
papirus-icon-theme
```

# Tips and tricks

## Open terminal from file manager

`ln -s /usr/bin/kitty /usr/bin/xdg-terminal-exec`

## Set system clock to local

```
timedatectl set-local-rtc 1 --adjust-system-clock
```

## Bluetooth

### Default adapter power state

```
/etc/bluetooth/main.conf

[Policy]
AutoEnable=false
```

### Unblock bluetooth

```
rfkill
rfkill unblock bluetooth
```

### Bluetooth headset

Install the `pulseaudio-bluetooth` package and run `pulseaudio -k`. If not activated, do `systemctl --user enable pulseaudio.service`, make sure to not use `sudo`.

### Pairing

```
bluetoothctl
[bluetooth]# default-agent
[bluetooth]# power on
[bluetooth]# scan on
[bluetooth]# pair [MAC]
[bluetooth]# trust [MAC]
[bluetooth]# connect [MAC]
```

## Test notifications

Requires `libnotify`. `nofity-send [title] [content]`.

## Fonts

Print installed fonts names with `fc-list | awk -F: '{print $2}' | awk -F, '{print $1}' | sort -u`.

## Utilities

### Unclutter

```
/etc/default/unclutter

START_UNCLUTTER="false"
```

## Themes

### Dark mode

```
$HOME/.config/gtk-3.0/settings.ini

[Settings]
gtk-application-prefer-dark-theme = true
```

### Custom theme

```
/etc/environment

GTK_THEME=Catppuccin-Mocha-Standard-Lavender-Dark
```

### Cursor

```
$HOME/.config/gtk-3.0/settings.ini

[Settings]
gtk-cursor-theme-name=phinger-cursors-light
```

### telescope.lua

```
local colors = require("catppuccin.palettes").get_palette()

local TelescopeColor = {
    TelescopeMatching = { fg = colors.flamingo },
    TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },
    TelescopePromptPrefix = { bg = colors.surface0 },
    TelescopePromptNormal = { bg = colors.surface0 },
    TelescopeResultsNormal = { bg = colors.mantle },
    TelescopePreviewNormal = { bg = colors.mantle },
    TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
    TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
    TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
    TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
    TelescopeResultsTitle = { fg = colors.mantle },
    TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
}

for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
end
```

## Media

### Nsxiv

Use `xrdb ~/.Xresources` to reload `.Xresources`.

### Menyoki

Requires packages `menyoki` and `slop`. Use LAlt-U to finish record, for consistent record size use `slop` first and pass to `--size` argument.

`menyoki record --root --action-keys LAlt-S,LAlt-U --cancel-keys LControl-D,LControl-F -c 5 --size $(slop) gif --fps 10`

### Screenkey

`screenkey --window -s small  -f "JetBrainsMono NF Bold" --font-color "#1e1e2e" --bg-color "#89b4fa" --opacity 1 --bak-mode normal`

## System

### Change file/directory owner

`chown [user] [filepath]`

## Printer

Run `rm -r /usr/lib/cups/driver/`. Discover printer with `avahi`, then run `lpinfo -v` and fill `cups` Connection field with the output.

## Picom

Disable opacity for hidden windows. Useful so that multiple stacked windows do not add opacity to a fixed background opacity.

```
opacity-rule = [
    "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
]
```

Disable tabbed windows title shadows in `i3`

```
opacity-rule = [
    "class_g = 'i3-frame'"
]
```

# Todo

- [ ] Buscar otro editor de texto mejor que gedit tipo bloc de notas. O usar solo vim o neovim.
- [ ] Buscar una calculadora mejor que gnome-calculator.
- [ ] Hacer documento guía para usar comandos como tesseract, menyoki, magick, ffmpeg, yt-dlp, etc.
- [ ] Documentos de workflows.
