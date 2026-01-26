#!/bin/bash

# 1. Update system and install Git
echo "Updating system and installing Git..."
sudo pacman -Syu --noconfirm git

# 2. Run the official dots-hyprland installer
# This command fetches and executes the official illogical-impulse setup script
echo "Starting end-4 dotfiles installation..."
bash <(curl -s https://ii.clsty.link/get)

# Append UK keyboard layout to hyprland.conf
echo "Configuring keyboard layout to GB..."

cat <<EOF >> ~/.config/hypr/hyprland.conf

# Personal overrides
input {
    kb_layout = gb
}
EOF