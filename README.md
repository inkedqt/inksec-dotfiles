1. Clone dotfiles

git clone git@github.com:inkedqt/inksec-dotfiles.git ~/INKSEC.IO/inksec-dotfiles cd ~/INKSEC.IO/inksec-dotfiles/kali

2. Install packages + OMZ + plugins

./install.sh
3. Setup tools + cheats + BloodHound helper

./tools.sh
4. Link configs

cd ../scripts ./link.sh
5. Make zsh your default shell (once per machine)
chsh -s $(which zsh)
