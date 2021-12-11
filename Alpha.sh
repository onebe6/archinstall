#! /bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

pacman -S gptfdisk

lsblk

read -p "which drive do you want to partition?: (exemple: /dev/sda)" DISK

# disk prep
sgdisk -Z ${DISK} # zap all on disk
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

# creating partitions
if [[ -d "/sys/firmware/efi" ]]
then
    sgdisk -n 1::+200M --typecode=2:ef00 --change-name=2:'EFIBOOT' ${DISK} # partition 2 (UEFI Boot Partition)
    sgdisk -n 2::-0 --typecode=3:8300 --change-name=3:'ROOT' ${DISK} # partition 3 (Root), default start, remaining
else
    sgdisk -n 1::+128M --typecode=1:ef02 --change-name=1:'BIOSBOOT' ${DISK} # partition 1 (BIOS Boot Partition
    sgdisk -n 2::-0 --typecode=3:8300 --change-name=3:'ROOT' ${DISK} # partition 3 (Root), default start, remaining
fi

#if [[ ! -d "/sys/firmware/efi" ]]; then
#    sgdisk -A 1:set:2 ${DISK}
#xfi

#mkfs.vfat -F32 -n "EFIBOOT" "${DISK}p2"
#mkfs.ext4 -L "ROOT" "${DISK}p3" -f
#mount -t ext4 "${DISK}p3" /mnt

#cfdisk $DISK

lsblk

read -p "which partition is your main partition? (exemple: /dev/sda1)" PARTITION

mkfs.ext4 $PARTITION

mount $PARTITION /mnt

lsblk

read -p "which partition is your boot partition? (exemple: /dev/sda1)" BOOT

if [[ -d "/sys/firmware/efi" ]] then
    mkfs.vfat -F32 $BOOT
    mkdir /mnt/boot
    mount $BOOT /mnt/boot
else
    mkfs.ext4 $BOOT
    mkdir /mnt/boot
    mount $BOOT /mnt/boot
fi

#mount -t vfat -L EFIBOOT /mnt/boot/

pacstrap /mnt base base-devel linux linux-firmware vim nano

genfstab -U /mnt >> /mnt/etc/fstab

cp -R ${SCRIPT_DIR} /mnt/root/archinstall
