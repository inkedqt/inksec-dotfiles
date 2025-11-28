#!/usr/bin/env bash
set -e

echo "[ InkSec Kali Setup ] Starting..."

# -------------------------------------------------------
# Helper: print step titles
# -------------------------------------------------------
step() {
    echo
    echo "┌────────────────────────────────────────────"
    echo "│ $1"
    echo "└────────────────────────────────────────────"
}

# -------------------------------------------------------
# Step 1: Update & install apt packages
# -------------------------------------------------------
step "Installing APT packages"
sudo apt update -y
sudo apt install -y $(grep -vE '^#' apt-packages.txt | tr '\n' ' ')
# -------------------------------------------------------
# Step X: Enable Docker + add user to docker group
# -------------------------------------------------------
step "Configuring Docker"

if command -v docker >/dev/null 2>&1; then
    echo "  - Enabling and starting Docker service"
    sudo systemctl enable --now docker || true

    echo "  - Adding user $USER to docker group"
    sudo usermod -aG docker "$USER" || true

    echo "  - NOTE: You must log out and log back in for docker group to apply."
else
    echo "  - Docker not installed? Check apt-packages.txt"
fi
# -------------------------------------------------------
# Step 2: Install pipx packages
# -------------------------------------------------------
step "Installing pipx packages"
while read -r pkg; do
    [[ -z "$pkg" ]] && continue
    echo "  -> $pkg"
    pipx install "$pkg" || true
done < pipx-packages.txt

# -------------------------------------------------------
# Step 3: Install Oh My Zsh
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
# Step 4: Install OMZ plugins
# -------------------------------------------------------
step "Installing ZSH plugins"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing() {
    local repo="$1"
    local dest="$2"
    if [ ! -d "$dest" ]; then
        git clone "$repo" "$dest"
    else
        echo "  - Already exists: $dest"
    fi
}

clone_if_missing https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

step "APT + PIPX + ZSH core setup completed."
echo "Run './tools.sh' next."
