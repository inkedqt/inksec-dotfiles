#!/usr/bin/env bash
set -e

echo "[ InkSec Arch Setup ] Starting..."

step() {
    echo
    echo "┌────────────────────────────────────────────"
    echo "│ $1"
    echo "└────────────────────────────────────────────"
}

clone_if_missing () {
    local repo="$1"
    local target="$2"
    if [ -d "$target" ]; then
        echo "  - $target already exists, skipping"
    else
        echo "  - cloning $repo -> $target"
        git clone "$repo" "$target"
    fi
}

# -------------------------------------------------------
# Step 1: Update system & install core packages
# -------------------------------------------------------
step "Installing base packages with pacman"

sudo pacman -Syu --needed \
  zsh \
  kitty \
  fastfetch \
  git \
  eza \
  grc \
  bat \
  python-pygments \
  tmux \
  fzf \
  fd

# -------------------------------------------------------
# Step 2: Install Oh My Zsh
# -------------------------------------------------------
step "Installing Oh My Zsh"

export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "  - Oh My Zsh already installed."
fi

# -------------------------------------------------------
# Step 3: Install ZSH plugins
# -------------------------------------------------------
step "Installing ZSH plugins"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

step "Arch base + OMZ + plugins complete."
echo "Next: run ../scripts/link.sh then 'chsh -s \$(which zsh)'."
