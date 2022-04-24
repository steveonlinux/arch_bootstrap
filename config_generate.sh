#!/bin/sh

#Author: Stephen Marks
#Date: 11/7/21
#Description: This is for my own personal use as a reinstallation script 
#from a previously used Arch based Linux distribution that used a seperate
#home partition and SystemD
#Must manually create user and remount home directory after installation

if [[ ! -d /home/steve/.config/arch_bootstrap ]]; then
	mkdir -p /home/steve/.config/arch_bootstrap 
fi
pacman -Qe | awk '{print $1}' > /home/steve/.config/arch_bootstrap/explicitly_installed.txt
pacman -Qm | awk '{print $1}'> /home/steve/.config/arch_bootstrap/aur_installed.txt
cp -f /etc/pacman.conf /home/steve/.config/arch_bootstrap/pacman.conf.backup 
cp -f /etc/X11/xorg.conf /home/steve/.config/arch_bootstrap/xorg.conf.backup
cp -f /etc/doas.conf /home/steve/.config/arch_bootstrap/doas.conf.backup
cp -f /etc/sudoers /home/steve/.config/arch_bootstrap/sudoers.backup
chown steve:steve /home/steve/.config/arch_bootstrap/sudoers.backup
cp -r /usr/share/xsessions /home/steve/.config/arch_bootstrap/xsessions
cp -r /usr/share/wayland-sessions home/steve/.config/arch_bootstrap/wayland-sessions
cp /etc/mkinitcpio.conf /home/steve/.config/arch_bootstrap/mkinitcpio.conf.backup
cp /etc/pacman.d/hooks/nvidia.hook /home/steve/.config/arch_bootstrap/nvidia.hook.backup
cp /etc/default/grub /home/steve/.config/arch_bootstrap/grub.backup
grep "swap\|books\|films\|games\|tv" /etc/fstab > \
/home/steve/.config/arch_bootstrap/fstab.backup 
echo "Completed Reinstallation Preparation..."
