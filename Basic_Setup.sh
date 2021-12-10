#! /bin/bash

pacman -S networkmanager grub

systemctl enable NetworkManager

grub-install $DISK

grub-mkconfig -o /boot/grub/grub.cfg

echo "Add a root password: "

passwd

sed -i 's/#es_US.UTF-8/es_US.UTF-8/' /etc/locale.gen
sed -i 's/#es_US ISO-8859-1/es_US ISO-8859-1/' /etc/locale.gen
Locale-gen

echo "LANG=en-US.UTF-8" | cat > /etc/loacle.conf

read -p "choose a hostname:" HOSTNAME

echo $HOSTNAME | cat > /etc/hostname

ln -sf /usr/share/zoneinfo/Europe/Budapest etc/localtime

read -p "Add a username:" USER

useradd -mg wheel $USER

echo "Add password for the user:"

sed -i 's/# %wheel	ALL=(ALL) ALL/%wheel     ALL=(ALL) ALL/' > /etc/sudoers

passwd $USER
