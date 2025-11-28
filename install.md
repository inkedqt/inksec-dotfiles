# 1. Clone dotfiles
git clone git@github.com:inkedqt/inksec-dotfiles.git ~/INKSEC.IO/inksec-dotfiles

# InkSec Kali Post-Install
1. Run ./install.sh
2. Run ./tools.sh
3. Run ./link.sh
4. sudo systemctl enable --now docker
5. sudo usermod -aG docker $USER
6. Log out/in

chsh -s $(which zsh)
