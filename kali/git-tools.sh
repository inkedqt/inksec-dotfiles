#!/usr/bin/env bash
set -e

TOOLS_DIR="$HOME/tools"
mkdir -p "$TOOLS_DIR"
cd "$TOOLS_DIR"

clone_if_missing() {
    local repo="$1"
    local name="$2"
    if [ ! -d "$name" ]; then
        echo "[+] Cloning $name"
        git clone "$repo" "$name"
    else
        echo "[*] $name already exists, skipping"
    fi
}

clone_if_missing https://github.com/dirkjanm/krbrelayx.git krbrelayx
clone_if_missing https://github.com/ticarpi/jwt_tool.git jwt_tool
# If you want the “raw” repos for these as well:
clone_if_missing https://github.com/dirkjanm/PetitPotam.git PetitPotam
clone_if_missing https://github.com/dirkjanm/PowerView.py.git powerview

echo "[*] Tools cloned under $TOOLS_DIR"
