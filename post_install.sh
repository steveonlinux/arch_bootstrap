#!/bin/sh

#Author: Stephen Marks
#Date: 11/7/21
#Description: This is for my own personal use as a reinstallation script 
#from a previously used Arch based Linux distribution that used a seperate
#home partition and SystemD

opts=$(getopt -o p:u:h:t --long password:,home:,user:,test -- "$@")
[ $? -eq 0 ] || { echo "Incorrect options provided"; exit 1}
eval set -- "$opts"
unset "$opts"
while true; do
	case "$1" in 
	-p | --password)
		password={$OPTARG} && make_flag="TRUE";shift;;
	-u | --user )
		user_name={$OPTARG};
		mkdir -p /home/$user_name && export XDG_CONFIG_HOME=/home/$user_name
		shift;;
	-h | --home ) 
		home={$OPTARG} && echo "UUID=$home /home ext4 defaults 0 0" \
		>> /etc/fstab && mount -a > /dev/null ;shift;;
	-t | --test )
		echo "Switches work"
		exit;;
	-- )
		shift
		break;;
	* )
		break;
	esac
done
mk_user() {
	useradd --badnames --base-dir /home/$user_name -g $user_name --password $password $user_name
	usermod -aG libvirt $user_name
}
install_explicit() {
	pacman -Syu
	echo "Installing all explicit packages"
	for pkgName in $(cat $XDG_CONFIG_HOME/arch_bootstrap/explicitly_installed.txt)
	do
  	pacman -S --noconfirm $pkgName
	done
	echo "Reinstalled all explicit packages."
}

install_gits() {
	echo "Installing all git dependencies"
	sh /home/$user_name/dl/gh_cl/font_stuff/nerd-fonts/install.sh
	( cd /home/$user_name/dl/gh_cl/yay && sudo -u $user_name makepkg -si --noconfirm )
	echo "Installed Git dependencies"
}

install_aur() {
	echo "Installing aur packages"
	for pkgName in $(cat $XDG_CONFIG_HOME/arch_bootstrap/aur_installed.txt)
	do
	sudo -u $user_name yay -S --force --noconfirm $pkgName
	done
	echo "Reinstalled aur packages"
}

configs() {
	cat $XDG_CONFIG_HOME/arch_bootstrap/fstab.backup >> /etc/fstab && mount -a > /dev/null
	cp -f .$XDG_CONFIG_HOME/arch_bootstrap/doas.conf.backup /etc/doas.conf
	chown root:root $XDG_CONFIG_HOME/arch_bootstrap/sudoers.backup
	cp -f .$XDG_CONFIG_HOME/arch_bootstrap/sudoers.backup /etc/sudoers
	cp -f .$XDG_CONFIG_HOME/arch_bootstrap/pacman.conf.backup /etc/pacman.conf
	cp -f .$XDG_CONFIG_HOME/arch_bootstrap/xorg.conf.backup /etc/X11/xorg.conf
}

services() {
	systemctl enable sshd ly.service clamav-freshclam.service cronie.service libvirtd
}

sym_links() {
	ln -s /usr/bin/zsh /usr/bin/sh 
}
mk_user;configs;install_explicit;install_gits;install_aur;sym_links;services
