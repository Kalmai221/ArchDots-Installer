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

# --- 4. WALLPAPER DOWNLOAD ---
WP_URL="https://4kwallpapers.com/images/wallpapers/blue-abstract-3840x2160-25121.jpg"
WP_DIR="$HOME/Pictures/Wallpapers"
WP_PATH="$WP_DIR/blue-abstract.jpg"

echo "Downloading wallpaper..."
mkdir -p "$WP_DIR"
# Spoof browser to avoid 403 Forbidden
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
     "$WP_URL" -o "$WP_PATH"

# --- 5. DEPLOY CONFIG FROM SUBFOLDER ---
# Path to your local file: ./illogical-impulse/config.json
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_CONFIG="$SCRIPT_DIR/illogical-impulse/config.json"
TARGET_DIR="$HOME/.config/illogical-impulse"

if [ -f "$LOCAL_CONFIG" ]; then
    echo "Applying custom config from $LOCAL_CONFIG..."
    mkdir -p "$TARGET_DIR"
    cp "$LOCAL_CONFIG" "$TARGET_DIR/config.json"
    
    # Update the JSON to use the new wallpaper path
    sed -i "s|\"wallpaperPath\": \".*\"|\"wallpaperPath\": \"$WP_PATH\"|" "$TARGET_DIR/config.json"
else
    echo "⚠️ Error: config.json not found in $LOCAL_CONFIG"
fi

# --- 6. APPLY VISUALLY ---
if command -v swww >/dev/null; then
    pgrep -x "swww-daemon" >/dev/null || swww-daemon & 
    sleep 1
    echo "🖼️ Setting wallpaper..."
    swww img "$WP_PATH" --transition-type grow
fi

echo "✨ Done! Config deployed and wallpaper applied."