#!/bin/sh

#Author: Stephen Marks
#Date: 11/7/21
#Description: This is for my own personal use as a reinstallation script 
#from a previously used Arch based Linux distribution that used a seperate
#home partition and SystemD
#Must manually create user and remount home directory after installation

if [[ ! -d $XDG_CONFIG_HOME/arch_bootstrap ]]; then
	mkdir -p $XDG_CONFIG_HOME/arch_bootstrap 
fi
pacman -Qe | awk '{print $1}' > $XDG_CONFIG_HOME/arch_bootstrap/explicitly_installed.txt
pacman -Qm | awk '{print $1}'> $XDG_CONFIG_HOME/arch_bootstrap/aur_installed.txt
cp -f /etc/pacman.conf $XDG_CONFIG_HOME/arch_bootstrap/pacman.conf.backup 
cp -f /etc/X11/xorg.conf $XDG_CONFIG_HOME/arch_bootstrap/xorg.conf.backup
cp -f /etc/doas.conf $XDG_CONFIG_HOME/arch_bootstrap/doas.conf.backup
cp -f /etc/sudoers $XDG_CONFIG_HOME/arch_bootstrap/sudoers.backup
chown steve:steve $XDG_CONFIG_HOME/arch_bootstrap/sudoers.backup
grep "swap\|books\|films\|games\|tv" /etc/fstab > \
$XDG_CONFIG_HOME/arch_bootstrap/fstab.backup 
echo "Completed Reinstallation Preparation..."
