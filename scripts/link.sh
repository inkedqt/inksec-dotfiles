#!/usr/bin/env bash
set -e

echo "[ InkSec Kali Setup ] Linking dotfiles..."

DOTROOT="$HOME/INKSEC.IO/inksec-dotfiles"
COMMON="$DOTROOT/common"

# ZSH
echo "  - Linking .zshrc"
ln -sf "$COMMON/zsh/.zshrc" "$HOME/.zshrc"

# Tmux
echo "  - Linking .tmux.conf"
ln -sf "$COMMON/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Kitty
echo "  - Linking kitty.conf"
mkdir -p "$HOME/.config/kitty"
ln -sf "$COMMON/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Fastfetch
echo "  - Linking fastfetch config"
mkdir -p "$HOME/.config/fastfetch"
ln -sf "$COMMON/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

echo "[ InkSec Kali Setup ] Linking complete."
echo "Next steps:"
echo "  1) chsh -s \$(which zsh)"
echo "  2) log out and back in"
