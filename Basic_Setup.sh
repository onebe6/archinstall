#! /bin/bash

pacman -S networkmanager grub efibootmgr os-prober --noconfirm

systemctl enable NetworkManager

echo "-- GRUB EFI Bootloader Install&Check--"
echo "--------------------------------------"

echo "KEYMAP=hu" | cat > /etc/vconsole.conf

read -p "which is your boot drive? (exemple: /dev/sda) " B_DRIVE

if [[ -d "/sys/firmware/efi" ]]
then
    grub-install --target=x86_64-efi  --efi-directory=/boot --bootloader-id=GRUB ${B_DRIVE}
else
    grub-install ${B_DRIVE}
fi


grub-mkconfig -o /boot/grub/grub.cfg

echo "Add a root password: "

passwd

sed -i 's/#es_US.UTF-8/es_US.UTF-8/' /etc/locale.gen
sed -i 's/#es_US ISO-8859-1/es_US ISO-8859-1/' /etc/locale.gen
locale-gen

echo "LANG=en-US.UTF-8" | cat > /etc/loacle.conf

read -p "choose a hostname:" HOSTNAME

echo $HOSTNAME | cat > /etc/hostname

ln -sf /usr/share/zoneinfo/Europe/Budapest etc/localtime

read -p "Add a username:" USER

useradd -mg wheel $USER

echo "Add password for the user:"

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

passwd $USER
