# arch-install-script
A script that automatically installs Arch Linux
# Instructions
1. Update Repos 
```
pacman -Sy
```
2. Install git
```
pacman -S git
```
3. Clone repo
```
git clone https://github.com/MatanRaf/arch-install-script.git
```
4. Run script
```
arch-install-script/install-arch.sh
```
5. After entering chroot, run part 2 of the script
```
./install-arch-2.sh
```