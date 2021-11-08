#!/bin/sh

#Author: Stephen Marks
#Date: 11/7/21
#Description: This is for my own personal use as a reinstallation script 
#from a previously used Arch based Linux distribution that used a seperate
#home partition and SystemD
#Must manually create user and remount home directory after installation

install_explicit() {
	pacman -Syu
	echo "Installing all explicit packages"
	for pkgName in $(/home/steve/scr/arch_bootstrap/configs/explicitly_installed.txt)
	do
  	pacman -S --force --noconfirm $pkgName
	done
	echo "Reinstalled all explicit packages."
}

install_gits() {
	echo "Installing all git dependencies"
	/home/steve/dl/gh_cl/font_stuff/nerd-fonts/install.sh &&
	( cd /home/steve/dl/gh_cl/yay && makepkg -si ) &&
	echo "Installed Git dependencies"
}

sym_link() {
	echo "Creating binary sym links"
	cd /usr/bin &&
	ln -s /home/steve/dl/gh_cl/suckless/dwm/dwm dwm
	ln -s /home/steve/dl/gh_cl/suckless/"st-0.8.4"/st st
	ln -s /home/steve/dl/gh_cl/suckless/dwmblocks-distrotube/dwmblocks
	ln -s /home/steve/dl/gh_cl/suckless/tabbed/tabbed tabbed
	ln -s /home/steve/dl/gh_cl/suckless/surf-dsitrotube/surf surf
	ln -s /home/steve/dl/gh_cl/suckless/dmenu-distrotube/dmenu dmenu
	echo "Created binary sym links"
}

install_aur() {
	echo "Installing aur packages"
	for pkgName in $(cat /home/steve/scr/arch_bootstrap/aur_installed.txt)
	do
	yay -S --force --noconfirm $pkgName
	done
	echo "Reinstalled aur packages"
}

configs() {
	cp -f ./configs/fstab.backup /etc/fstab
	cp -f ./configs/doas.conf.backup /etc/doas.conf
	cp -f ./configs/sudoers.backup /etc/sudoers
	cp -f ./configs/pacman.conf.backup /etc/pacman.conf
	cp -f ./configs/xorg.conf.backup /etc/X11/xorg.conf
	cp -rf ./configs/xsessions.backup /usr/share/xsessions
}

services() {
	systemctl enable sshd ly.service
}

configs
install_git
install_explicit
install_aur
sym_link
services
