#!/bin/bash
# =============================================================
# Jephthah's Arch Linux Post-Install Script
# Run this after a fresh base Arch install as your user
# =============================================================

set -e  # Exit on any error

echo "======================================"
echo " Jephthah's Arch Post-Install Script"
echo "======================================"
echo ""

# -------------------------------------------------------
# 1. SYSTEM UPDATE
# -------------------------------------------------------
echo "[1/12] Updating system..."
sudo pacman -Syu --noconfirm

# -------------------------------------------------------
# 3. DISPLAY MANAGER (SDDM)
# -------------------------------------------------------
echo "[3/12] Installing SDDM..."
sudo pacman -S --noconfirm sddm
sudo systemctl enable sddm

# -------------------------------------------------------
# 4. COMPOSITOR (Hyprland + essentials)
# -------------------------------------------------------
echo "[4/12] Installing Hyprland..."
sudo pacman -S --noconfirm \
    hyprland \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    wayland-protocols \
    xorg-xwayland

# -------------------------------------------------------
# 5. AUDIO (PipeWire + SOF firmware for Intel Alder Lake)
# -------------------------------------------------------
echo "[5/12] Installing audio..."
sudo pacman -S --noconfirm \
    pipewire \
    pipewire-pulse \
    wireplumber \
    sof-firmware \
    alsa-firmware

# -------------------------------------------------------
# 6. GPU (Intel drivers)
# -------------------------------------------------------
echo "[6/12] Installing Intel GPU drivers..."
sudo pacman -S --noconfirm \
    mesa \
    vulkan-intel \
    intel-media-driver \
    lib32-mesa \
    lib32-vulkan-intel

# -------------------------------------------------------
# 7. TERMINAL + SHELL
# -------------------------------------------------------
echo "[7/12] Installing terminal and shell..."
sudo pacman -S --noconfirm alacritty zsh

# Set zsh as default shell
chsh -s /usr/bin/zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set theme in .zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Useful zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Enable plugins in .zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# -------------------------------------------------------
# 8. EDITOR (Neovim + LazyVim)
# -------------------------------------------------------
echo "[8/12] Installing Neovim + LazyVim..."
sudo pacman -S --noconfirm neovim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# -------------------------------------------------------
# 9. APPS
# -------------------------------------------------------
echo "[9/12] Installing apps..."
sudo pacman -S --noconfirm \
    firefox \
    thunar \
    waybar \
    wofi \
    dunst \
    grim \
    slurp \
    swww \
    ttf-jetbrains-mono-nerd \
    networkmanager \
    nm-connection-editor

sudo systemctl enable NetworkManager

# -------------------------------------------------------
# 10. DISTROBOX (Pentesting isolation)
# -------------------------------------------------------
echo "[10/12] Installing Distrobox + Podman..."
sudo pacman -S --noconfirm distrobox podman

# -------------------------------------------------------
# 11. FONTS + ICONS
# -------------------------------------------------------
echo "[11/12] Installing fonts and icons..."
sudo pacman -S --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-nerd-fonts-symbols \
    papirus-icon-theme

# -------------------------------------------------------
# 12. DOTFILES (end-4/dots-hyprland)
# -------------------------------------------------------
echo "[12/12] Cloning dotfiles..."
git clone --depth 1 https://github.com/end-4/dots-hyprland.git ~/dotfiles
echo ""
echo "Dotfiles cloned to ~/dotfiles"
echo "Review and selectively copy configs from ~/dotfiles/.config/"
echo "to ~/.config/ — don't run the install script blindly."

# -------------------------------------------------------
# ALIASES
# -------------------------------------------------------
echo "" >> ~/.zshrc
echo "# Custom aliases" >> ~/.zshrc
echo "alias ls='ls -la --color=auto'" >> ~/.zshrc
echo "alias update='sudo pacman -Syu'" >> ~/.zshrc
echo "alias cleanup='sudo pacman -Sc && sudo pacman -Rns \$(pacman -Qdtq) 2>/dev/null'" >> ~/.zshrc
echo "alias myip='curl ifconfig.me'" >> ~/.zshrc
echo "alias ports='ss -tulpn'" >> ~/.zshrc

# -------------------------------------------------------
# DONE
# -------------------------------------------------------
echo ""
echo "======================================"
echo " Install complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Reboot into your new environment"
echo "  2. Log in via SDDM and select Hyprland"
echo "  3. Run 'p10k configure' to set up your prompt"
echo "  4. Selectively apply dotfiles from ~/dotfiles"
echo "  5. Set up your Distrobox pentesting environment"
echo ""
echo "Reboot now? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    reboot
fi
