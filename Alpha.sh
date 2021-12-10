#! /bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

lsblk -f

read -p "which drive do you want to partition?: (exemple: /dev/sda/)" DISK

cfdisk $DISK

lsblk -f

read -p "which partition is your main partition? (exemple: /dev/sda1)" PARTITION

mkfs.ext4 $PARTITION

mount $PARTITION /mnt

read -p "which partition is your boot partition? (exemple: /dev/sda1)" BOOT

mkfs.ext4 $BOOT
mkdir /mnt/boot
mount /mnt/boot

pacstrap /mnt base base-devel linux linux-firmware vim nano

genfstab -U /mnt >> /mnt/etc/fstab

cp -R ${SCRIPT_DIR} /mnt/root/ArchTitus
