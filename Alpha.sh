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

pacstrap /mnt base base-devel linux linux-firmware vim nano

genfstab -U /mnt >> /mnt/etc/fstab

exit
