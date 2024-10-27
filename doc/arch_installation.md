## wlan

```
iwctl
device list
device DEVICE set-property Powered off
device DEVICE set-property Powered on
station DEVICE scan
station DEVICE get-networks
station DEVICE connect SSID
exit
```

## Partitions

* EFI (1GB)
* root  (32GB)
* swap (4GB)

```
fdisk -l
cfdisk
```

```
mkfs.ext4 /dev/root_partition
mkswap /dev/swap_partition
mkfs.fat -F 32 /dev/efi_system_partition

```

## Mount partitions (1/2)
```
mount /dev/root_partition /mnt
swapon /dev/swap_partition
```

## Packages
```
pacstrap -K /mnt base base-devel linux linux-firmware networkmanager wpa_supplicant grub
```

## Fstab
```
genfstab -U /mnt >> /mnt/etc/fstab
```

## Change to `/mnt`
```
arch-chroot /mnt
```

## Passwords
```
passwd
useradd -m username
passwd username
usermod -aG wheel username
```

```
/etc/sudoers

%wheel ALL=(ALL:ALL) ALL
```

## Localization

```
/etc/locale.gen

en_US
```

```
locale-gen
```

## Mount partitions (2/2)
```
mount --mkdir /dev/efi_system_partition /mnt/boot
grub-install --target=x86_64-efi --efi-directory=/mnt/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

## Hosts
```
echo username > /etc/hostname
```

```
/etc/hosts

127.0.0.1       localhost
::1             localhost
127.0.0.1       username.localhost username
```

## Network

```
systemctl start NetworkManager.service
systemctl enable NetworkManager.service
```

```
systemctl start wpa_supplicant.service
systemctl enable wpa_supplicant.service
```

## wlan
```
nmcli radio wifi
nmcli radio wifi on
nmcli dev wifi list
sudo nmcli --ask dev wifi connect SSID
```

## More packages

```
pacman -S git sudo vim neofetch
```

## AUR

Make sure to clone the repository and run the following with user logged.
```
mkdir repos
cd repos
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin/
makepkg -si
```
