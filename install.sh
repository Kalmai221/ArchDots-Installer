#!/bin/bash

# 1. Update system and install Git
echo "Updating system and installing Git..."
sudo pacman -Syu --noconfirm git

# 2. Run the official dots-hyprland installer
echo "Starting end-4 dotfiles installation..."
bash <(curl -s https://ii.clsty.link/get)

# 3. Configure keyboard layout to GB
echo "Configuring keyboard layout to GB..."
mkdir -p ~/.config/hypr
cat <<EOF >> ~/.config/hypr/hyprland.conf

input {
    kb_layout = gb
}
EOF

# --- 4. WALLPAPER INTEGRATION ---
WP_URL="https://4kwallpapers.com/images/wallpapers/blue-abstract-3840x2160-25121.jpg"
WP_DIR="$HOME/Pictures/Wallpapers"
WP_PATH="$WP_DIR/blue-abstract.jpg"
CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"

echo "Downloading wallpaper..."
mkdir -p "$WP_DIR"

# Use a browser User-Agent to prevent 403 Forbidden errors
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
     "$WP_URL" -o "$WP_PATH"

# Update the JSON config so the UI and colors match the new wallpaper
if [ -f "$CONFIG_FILE" ]; then
    echo "Updating dotfiles config..."
    sed -i "s|\"wallpaperPath\": \".*\"|\"wallpaperPath\": \"$WP_PATH\"|" "$CONFIG_FILE"
fi

# Ensure swww-daemon is running and apply immediately
if command -v swww >/dev/null; then
    swww-daemon & sleep 1
    swww img "$WP_PATH" --transition-type grow
fi

echo "Installation and wallpaper setup complete!"