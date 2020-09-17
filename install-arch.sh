#!/bin/bash

timedatectl status
echo "Is the time correct?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "Continuing Installation"; break;;
        No ) echo "Please fix the problem"; exit;;
    esac
done

clear

# ask the user which drive to partition
fdisk -l
echo "\nEnter drive name (for example sda)\n"
read driveToPartition

# confirmation
echo "Are you sure you want to partition /dev/$driveToPartition (THIS WILL ERASE ALL DATA STORED ON THE DRIVE)"

select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "Continuing Installation"; break;;
        No ) echo "Please fix the problem and rerun"; exit;;
    esac
done


# Partitioning the drive
echo "\nEnter desired swap size (Example: 4G)"
read swapSize


sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/$driveToPartition
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
  +$swapSize
  t # change partition type
  82 # swap partition
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  2 # bootable partition is partition 2 -- /dev/sda2
  p # print the in-memory partition table
  w # write the partition table
EOF

# Format the partitions
mkfs.ext4 /dev/${driveToPartition}2 # root partition

mkswap /dev/${driveToPartition}1 # swap partition

# Mount the file systems
mount /dev/${driveToPartition}2 /mnt

swapon /dev/${driveToPartition}1

pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

cp /root/arch-install-script/install-arch-2.sh /mnt
sed -i s/sdX/${driveToPartition}/ /mnt/install-arch-2.sh
chmod +x /mnt/install-arch-2.sh

clear

echo "Chrooting into the new system"
echo "Run ./install-arch-2.sh"
arch-chroot /mnt


