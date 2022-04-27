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
		password={$OPTARG} && pass_flag="TRUE";shift;;
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
	usermod -aG wheel,libvirt $user_name
}
install_explicit() {
	pacman -Syu
	echo "Installing all explicit packages"
	for pkgName in $(cat /home/steve/.config/arch_bootstrap/explicitly_installed.txt)
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
	for pkgName in $(cat /home/steve/.config/arch_bootstrap/aur_installed.txt)
	do
	sudo -u $user_name yay -S --force --noconfirm $pkgName
	done
	echo "Reinstalled aur packages"
}

configs() {
	cat /home/steve/.config/arch_bootstrap/fstab.backup >> /etc/fstab && mount -a > /dev/null
	cp -f /home/steve/.config/arch_bootstrap/doas.conf.backup /etc/doas.conf
	chown root:root /home/steve/.config/arch_bootstrap/sudoers.backup
	cp -f /home/steve/.config/arch_bootstrap/sudoers.backup /etc/sudoers
	cp -f /home/steve/.config/arch_bootstrap/pacman.conf.backup /etc/pacman.conf
	cp -f /home/steve/.config/arch_bootstrap/xorg.conf.backup /etc/X11/xorg.conf
	cp -f /home/steve/.config/arch_bootstrap/grub.backup /etc/default/grub
	grub mkconfig -o /boot/grub/grub.cfg
	cp -f /home/steve/.config/arch_bootstrap/nvidia.hook.backup
	cp -f /home/steve/.config/arch_bootstrap/mkinitcpio.conf.backup /etc/mkinitcpio.conf
}
configs2() {
	cp -r /home/steve/.config/arch_bootstrap/xsessions /usr/share/xsessions
	cp -r /home/steve/.config/arch_bootstrap/wayland-sessions /usr/share/wayland-sessions
}
services() {
	systemctl enable sshd ly.service clamav-freshclam.service cronie.service libvirtd
}

sym_links() {
	ln -s /usr/bin/dash /usr/bin/sh 
}
if [$pass_flag -eq "TRUE"];then mk_user;fi;configs;install_explicit;install_gits;install_aur;configs2;sym_links;services
