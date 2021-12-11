#! /bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

pacman -S gptfdisk

lsblk

read -p "which drive do you want to partition?: (exemple: /dev/sda/)" DISK

sgdisk -n 1::+1M --typecode=1:ef02 --change-name=1:'BIOSBOOT' ${DISK} # partition 1 (BIOS Boot Partition)
sgdisk -n 2::+100M --typecode=2:ef00 --change-name=2:'EFIBOOT' ${DISK} # partition 2 (UEFI Boot Partition)
sgdisk -n 3::-0 --typecode=3:8300 --change-name=3:'ROOT' ${DISK} # partition 3 (Root), default start, remaining
if [[ ! -d "/sys/firmware/efi" ]]; then
    sgdisk -A 1:set:2 ${DISK}
fi

mkfs.vfat -F32 -n "EFIBOOT" "${DISK}p2"
mkfs.ext4 -L "ROOT" "${DISK}p3" -f
mount -t ext4 "${DISK}p3" /mnt

#cfdisk $DISK

#lsblk -f

#read -p "which partition is your main partition? (exemple: /dev/sda1)" PARTITION

#mkfs.ext4 $PARTITION

#mount $PARTITION /mnt

#read -p "which partition is your boot partition? (exemple: /dev/sda1)" BOOT

#mkfs.vfat -F32 $BOOT
mkdir /mnt/boot
mount $BOOT /mnt/boot

mount -t vfat -L EFIBOOT /mnt/boot/

pacstrap /mnt base base-devel linux linux-firmware vim nano

genfstab -U /mnt >> /mnt/etc/fstab

cp -R ${SCRIPT_DIR} /mnt/root/archinstall
