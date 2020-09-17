#!/bin/bash

# This script will be run in chroot


ln -sf /usr/share/zoneinfo/Israel /etc/localtime
hwclock --systohc

sed -i s/"#en_US.UTF-8"/"en_US.UTF-8"/ /etc/locale.gen
sed -i s/"#he_IL.UTF-8"/"he_IL.UTF-8"/ /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

echo "Enter hostname"
read myhostname

echo $myhostname > /etc/hostname

echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$myhostname.localdomain	$myhostnamet" >> /etc/hosts

echo "\nSetting up root password"
passwd

pacman -S --noconfirm grub
grub-install /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S --noconfirm networkmanager
systemctl enable NetworkManager.service

function install_base(){
    pacman -S --noconfirm xorg base-devel
    echo "Enter a username"
    read user
    useradd -m ${user}
    passwd ${user}
    sed "s/root ALL=(ALL) ALL/root ALL=(ALL) ALL\n${user} ALL=(ALL) ALL/g" -i /etc/sudoers

}

function install_kde(){
    install_base
    pacman -S --noconfirm plasma plasma-wayland-session kde-applications
    systemctl enable sddm.service 
}

function install_gnome(){
    install_base
    pacman -S --noconfirm gnome
    systemctl enable gdm.service
}

function install_larbs(){
    curl -LO larbs.xyz/larbs.sh
    sh larbs.sh
}

clear
echo "What do you want to install?"

select de in "gnome" "kde" "larbs" "base install" "Nothing, I can install it myself"; do
    case $de in
        "gnome" ) install_gnome; break;;
        "kde" ) install_kde; break;;
        "larbs" ) install_larbs; break;;
        "base install" ) install_base; break;;
        "Nothing, I can install it myself" ) break;;
    esac
done

clear
echo "Thank you for using this Arch Linux install script!"
echo "You may now restart the computer after removing iso"