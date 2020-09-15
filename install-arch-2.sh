#!/bin/bash

# This script will be run in chroot

echo "In Chroot"
ls
ln -sf /usr/share/zoneinfo/Israel /etc/localtime
hwclock -systohc
# locale-gen
