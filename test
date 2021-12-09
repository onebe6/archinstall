#! /bin/bash

lsblk -f

read -p "which drive do you want to partition?: (exemple: /dev/sda/)" DISK

cfdisk $DISK

lsblk -f

read -p "which partition is your main partition? (exemple: /dev/sda1)" PARTITION

mksf.ext4 $PARTITION

mount $PARTITON /mnt

read -p "which partition is your boot partition? (exemple: /dev/sda1)" BOOT

mkfs.ext4 $BOOT
mkdir /mnt/boot
mount /mnt/boot

pacstrap /mnt base base-devel linux linux-firmware vim nano terminator 
tft-inconsolata

genfstab -U /mnt

arch-chroot /mnt /bin/bash

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

exit

umount /mnt
