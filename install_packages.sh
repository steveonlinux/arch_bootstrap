#!/bin/sh

# Author: Stephen Marks
# Date: 11/7/21
# Description: Install packages from lists for explicitly installed packages (pacman) and AUR packages (yay).

# Variables for paths (modify paths if necessary)
USER_HOME="/home/steve"
CONFIG_PATH="$USER_HOME/.config/arch_bootstrap"
AUR_LIST="$CONFIG_PATH/aur_installed.txt"
EXPLICIT_LIST="$CONFIG_PATH/explicitly_installed.txt"

# Update system and install explicitly installed packages using pacman
echo "Updating system and installing explicitly installed packages..."
sudo pacman -Syu --noconfirm

for pkgName in $(cat "$EXPLICIT_LIST"); do
    sudo pacman -S --noconfirm "$pkgName"
done

# Install AUR packages using yay as a non-root user
echo "Installing AUR packages..."
for pkgName in $(cat "$AUR_LIST"); do
    sudo -u "$USER" yay -S --noconfirm "$pkgName"
done

echo "Package installation completed."
