#!/bin/bash

echo "🚀 Starting Linux Mint Auto-Setup..."

# Ask for sudo password upfront so the script doesn't pause
sudo -v

echo "📦 1/6: Updating system and installing core packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git zsh stow curl wget build-essential

echo "🔑 2/6: Restoring SSH keys and fixing security permissions..."
if [ -f "$HOME/Credentials_Backup.tar.gz" ]; then
    tar -xzvf ~/Credentials_Backup.tar.gz -C ~/
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/id_* 2>/dev/null
    chmod 644 ~/.ssh/*.pub 2>/dev/null
    echo "✅ SSH Keys secured."
else
    echo "⚠️ Credentials_Backup.tar.gz not found in Home directory. Skipping."
fi

echo "📂 3/6: Restoring and stowing dotfiles..."
if [ -f "$HOME/Clean_Dotfiles.tar.gz" ]; then
    tar -xzvf ~/Clean_Dotfiles.tar.gz -C ~/
    cd ~/.dotfiles
    stow alacritty zellij nvim starship btop fastfetch git lazygit lazydocker mise zed zsh
    cd ~
    echo "✅ Dotfiles applied."
else
    echo "⚠️ Clean_Dotfiles.tar.gz not found in Home directory. Skipping."
fi

echo "⭐ 4/6: Installing Starship and Mise..."
curl -sS https://starship.rs/install.sh | sh -s -- -y
curl https://mise.run | sh

echo "🔊 5/6: Applying Realtek ALC294 Audio Fix..."
git clone https://github.com/goldarte/alc294_soundfix.git /tmp/alc294_soundfix
cd /tmp/alc294_soundfix
chmod +x install.sh
sudo ./install.sh
cd ~

echo "🐚 6/6: Changing default shell to Zsh..."
sudo chsh -s $(which zsh) $USER

echo "=============================================="
echo "🎉 SETUP COMPLETE! "
echo "Please type 'sudo reboot' to apply the audio fix and shell changes."
echo "=============================================="
