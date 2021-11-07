#!/bin/sh

#Author: Stephen Marks
#Date: 11/7/21
#Description: This is for my own personal use as a reinstallation script 
#from a previously used Arch based Linux distribution that used a seperate
#home partition and SystemD
#Must manually create user and remount home directory after installation

if [[ -f ./configs ]]; then
	mkdir ./configs
fi
pacman -Qe > ./configs/explicitly_installed.txt; pacman -Qm > ./configs/aur_installed.txt
cp -f /etc/pacman.conf ./configs/pacman.conf.backup 
cp -f /etc/X11/xorg.conf ./configs/xorg.conf.backup
cp -rf /usr/share/xsessions ./configs/xsessions.backup
cp -f /etc/doas.conf ./configs/doas.conf.backup
cp -f /etc/sudoers ./configs/sudoers.backup
cp -f /etc/fstab ./configs/fstab.backup
echo "done"