#!/bin/bash

# This script will be run in chroot

echo "In Chroot"
ls
ln -sf /usr/share/zoneinfo/Israel /etc/localtime
hwclock --systohc

sed -i s/"#en_US.UTF-8"/"en_US.UTF-8"/ /etc/locale.gen
locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

echo "Enter hostname"
read myhostname

echo $myhostname > /etc/hostname

echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$myhostname.localdomain	$myhostnamet" >> /etc/hosts

passwd

pacman -S grub
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S networkmanager
systemctl enable NetworkManager


echo "Do you want to install larbs?"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) curl -LO larbs.xyz/larbs.sh; sh larbs.sh; break;;
        No ) break;;
    esac
done
