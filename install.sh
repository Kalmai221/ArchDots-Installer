#!/bin/bash

# 1. Update system and install Core Dependencies
echo "Updating system and installing base dependencies..."
sudo pacman -Syu --noconfirm git base-devel

# Install yay (AUR Helper)
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# --- 1.5 INSTALL SPECIFIC APPS ---
echo "Installing btop, VS Code (OSS), and Microsoft Edge..."
# 'code' is the open-source version in official repos
# 'microsoft-edge-stable-bin' is from AUR
sudo pacman -S --noconfirm btop code
yay -S --noconfirm microsoft-edge-stable-bin

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
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
     "$WP_URL" -o "$WP_PATH"

# --- 5. DEPLOY CONFIG FROM SUBFOLDER ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_CONFIG="$SCRIPT_DIR/illogical-impulse/config.json"
TARGET_DIR="$HOME/.config/illogical-impulse"

if [ -f "$LOCAL_CONFIG" ]; then
    echo "Applying custom config from $LOCAL_CONFIG..."
    mkdir -p "$TARGET_DIR"
    cp "$LOCAL_CONFIG" "$TARGET_DIR/config.json"
    sed -i "s|\"wallpaperPath\": \".*\"|\"wallpaperPath\": \"$WP_PATH\"|" "$TARGET_DIR/config.json"
else
    echo "⚠️ Error: config.json not found in $LOCAL_CONFIG"
fi

# --- 6. SDDM SETUP ---
echo "Installing SilentSDDM..."
git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM
cd SilentSDDM || exit
chmod +x install.sh
sudo ./install.sh
cd ..

LOCAL_SDDM_CONF="$SCRIPT_DIR/sddm/default.conf"
TARGET_SDDM_CONF="/usr/share/sddm/themes/silent/configs/default.conf"

if [ -f "$LOCAL_SDDM_CONF" ]; then
    echo "Replacing SDDM theme config..."
    sudo cp "$LOCAL_SDDM_CONF" "$TARGET_SDDM_CONF"
else
    echo "⚠️ Error: Local SDDM config not found at $LOCAL_SDDM_CONF"
fi

sudo mkdir -p /usr/share/sddm/themes/silent/backgrounds/
sudo cp "$WP_PATH" /usr/share/sddm/themes/silent/backgrounds/

# --- 7. APPLY VISUALLY ---
if command -v swww >/dev/null; then
    pgrep -x "swww-daemon" >/dev/null || swww-daemon & 
    sleep 1
    echo "🖼️ Setting wallpaper..."
    swww img "$WP_PATH" --transition-type grow
fi

echo "✨ Done! btop, Code (OSS), Edge, and your configs are ready."