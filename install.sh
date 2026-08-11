#!/bin/bash

check_yay(){
echo "Vérification de $1"
which $1
if [ $? -ne 0 ]
then
    echo -e "\033[33m$1 n'est pas installé mais est essentiel à l'installation de LoinafOS\033[0m"
    read -p "Voulez-vous installer $1 (o/n)?" response
    if [ $response == "o" ] || [ $response == "O" ]
    then
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        makepkg -D yay -si
    else
        #echo "Annulation de l'installation..."
        echo -e "\033[31mInstallation annulée\033[0m"
        exit
    fi
else
    echo -e "\033[32mOK\033[0m"

fi
}

check_which(){
echo "Vérification de which"
pacman -Ql which
if [ $? -ne 0 ]
then
    echo -e "\033[33mwhich n'est pas installé mais est essentiel à l'installation de LoinafOS\033[0m"
    read -p "Voulez-vous installer which (o/n)?" response
    if [ $response == "o" ] || [ $response == "O" ]
    then
        sudo pacman -S --noconfirm which
    else
        #echo "Annulation de l'installation..."
        echo -e "\033[31mInstallation annulée\033[0m"
        exit
    fi
else
    echo -e "\033[32mOK\033[0m"

fi
}


check_important_bin(){
yay -Q $1
if [ $? -ne 0 ]
then
    echo -e "\033[33m$1 n'est pas installé mais est essentiel à l'installation de LoinafOS\033[0m"
    read -p "Voulez-vous installer $1 (o/n)?" response
    if [ $response == "o" ] || [ $response == "O" ]
    then
        if [ $npackages -eq 0 ]
        then
            npackages=1
            packages[0]=$1
        else
            packages+=($1)
        fi
    else
        #echo "Annulation de l'installation..."
        echo -e "\033[31mInstallation annulée\033[0m"
        exit
    fi
else
    echo -e "\033[32mOK\033[0m"
fi
}

npackages=0
declare -a packages

if [ $(id -u) -ne 0 ]
then
    echo "\$\$\                \$\$\                      \$\$\$\$\$\$\   \$\$\$\$\$\$\   \$\$\$\$\$\$\  ";
    echo "\$\$ |               \__|                    \$\$  __\$\$\ \$\$  __\$\$\ \$\$  __\$\$\ ";
    echo "\$\$ |      \$\$\$\$\$\$\  \$\$\ \$\$\$\$\$\$\$\   \$\$\$\$\$\$\  \$\$ /  \__|\$\$ /  \$\$ |\$\$ /  \__|";
    echo "\$\$ |     \$\$  __\$\$\ \$\$ |\$\$  __\$\$\  \____\$\$\ \$\$\$\$\     \$\$ |  \$\$ |\\$\$\$\$\$\$\  ";
    echo "\$\$ |     \$\$ /  \$\$ |\$\$ |\$\$ |  \$\$ | \$\$\$\$\$\$\$ |\$\$  _|    \$\$ |  \$\$ | \____\$\$\ ";
    echo "\$\$ |     \$\$ |  \$\$ |\$\$ |\$\$ |  \$\$ |\$\$  __\$\$ |\$\$ |      \$\$ |  \$\$ |\$\$\   \$\$ |";
    echo "\$\$\$\$\$\$\$\$\\\\$\$\$\$\$\$  |\$\$ |\$\$ |  \$\$ |\\$\$\$\$\$\$\$ |\$\$ |       \$\$\$\$\$\$  |\\$\$\$\$\$\$  |";
    echo "\________|\______/ \__|\__|  \__| \_______|\__|       \______/  \______/ ";
    echo ""
    echo ""
    echo ""
    echo "Bienvenue sur l'installateur officiel de LoinafOS"
else
    echo "Il n'est pas possible d'exécuter cette installateur avec sudo, veuillez lancer ce programme avec votre utilisateur!"
    exit
fi
echo "Vous êtes sur le point d'installer LoinafOS sur votre installation Arch"
read -p "Êtes vous prêts à procéder à l'installlation?(o/n)" response
if [ "$response" != "o" ] && [ "$response" != "O" ]; then exit
fi
echo "Vérification de votre connexion à Internet..."
ping ping.archlinux.org -c 1 -W 2
if [ $? -ne 0 ]
then
    echo "\033[31mInstallation annulée en raison d'une anomalie dans votre connexion Internet\033[0m"
fi

echo "Vous serez à plusieurs reprises invités à entrer votre mot de passe afin de réaliser certaines tâches de l'installation en tant que root"
check_which
check_yay "yay"
check_important_bin "hyprland"
check_important_bin "kitty"
check_important_bin "wlogout"
check_important_bin "inter-font"
check_important_bin "ttf-noto-nerd"
check_important_bin "waybar"
check_important_bin "wofi"
check_important_bin "hyprpaper"
check_important_bin "thunar"
check_important_bin "otf-font-awesome"
check_important_bin "hyprlock"
check_important_bin "neovim"
check_important_bin "zsh"
check_important_bin "oh-my-zsh-git"
check_important_bin "slurp"
check_important_bin "wl-clipboard"
check_important_bin "swappy"
check_important_bin "grim"
check_important_bin "zsh-syntax-highlighting"
check_important_bin "zsh-autosuggestions"
check_important_bin "ripgrep"
check_important_bin "ttf-fira-code"
check_important_bin "fastfetch"
check_important_bin "sddm"
check_important_bin "flatpak"
check_important_bin "python"
check_important_bin "python-requests"
check_important_bin "wget"
check_important_bin "hyprpaper"
check_important_bin "hypridle"

echo "Installation des packets manquant"
yay -S --noconfirm --needed --answerclean None --answerdiff None "${packages[@]}"

echo "Copie des fichiers de configuration"
cp wofi ~/.config/ -r
cp waybar ~/.config/ -r
cp hypr ~/.config/ -r
sudo cp -r "sddm.conf.d" "/etc/"
sudo cp -r "elegant-archlinux" "/usr/share/sddm/themes/"

echo "Installation du panneau de configuration de LoinafOS"
wget https://loinaf.fr/loinafos/loinafsuper/latest.flatpak
flatpak install --user --reinstall -y latest.flatpak
flatpak override --user --socket=session-bus fr.loinaf.loinafsuper
flatpak override --user --talk-name=org.freedesktop.Flatpak fr.loinaf.loinafsuper
flatpak override --user --filesystem=~/.config/hypr fr.loinaf.loinafsuper
rm latest.flatpak

mkdir ~/.local/bin/
touch ~/.local/bin/loinafctl
echo "#!/usr/bin/env zsh\nexec flatpak run fr.loinaf.loinafsuper \"\$@\"" > ~/.local/bin/loinafctl

mkdir ~/.config/hypr/settings

sudo systemctl enable sddm

echo "Vous devez choisir une disposition de clavier qui sera appliqué à Hyprland et sddm"
echo "Ne répondez que si vous êtes sûr, dans le cas contraire, appuyez sur entrée et la disposition AZERTY sera sélectionnée"
read -p "Disposition de clavier (us pour QWERTY par exemple): " language

if [ "$language" == "" ]; then language="fr"
fi

sudo localectl set-x11-keymap "$language"
echo "hl.config({input = {kb_layout = \"${language}\", kb_variant = \"\", kb_model = \"\", kb_options = \"\", kb_rules = \"\", follow_mouse = 1, sensitivity = 0, repeat_rate = 50, repeat_delay = 200, numlock_by_default = true, touchpad = { natural_scroll = true, }, }, })" > ~/.config/hypr/input.lua

echo "Installation terminée!"
echo "Il est fortement recommandé de redémarrer votre appareil avant de poursuivre!"
read -p "Redémarrer(o/n)?" response
if [ $response == "o" ] || [ $response == "O" ]
then
    sudo reboot
fi
