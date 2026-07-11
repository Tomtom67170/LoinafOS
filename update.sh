config="$HOME/.config"

cp -r asset "$config"
cp -r hypr "$config"
cp -r waybar "$config"
cp -r wofi "$config"
sudo cp -r "sddm.conf.d" "/etc/"
sudo cp -r "elegant-archlinux" "/usr/share/sddm/themes/"
#cp .zshrc .p10k.zsh "$HOME"
