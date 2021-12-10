#! /bin/bash

pacman -S networkmanager grub

systemctl enable NetworkManager

grub-install $DISK

grub-mkconfig -o /boot/grub/grub.cfg

echo "Add a root password: "

passwd

nano /etc/locale.conf

nano /etc/hostname

ln -sf /usr/share/zoneinfo/Europe/Budapest etc/localtime

read -p "Add a username:" USER

useradd -mg wheel $USER

echo "Add password for the user:"

passwd $USER
