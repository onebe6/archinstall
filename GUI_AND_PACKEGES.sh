#!/bin/bash

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

for PKG in $(cat PKGS_BASIC.txt); do
    echo "DOWNLOADING: $PKG"
    sudo pacman -S $PKG --noconfirm --needed
done

# Remove no password rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
