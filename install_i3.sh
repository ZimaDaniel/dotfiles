#!/bin/bash

# Aktualizace systému
echo "Aktualizuji systém..."
sudo apt update && sudo apt upgrade -y

# Přidání repozitářů non-free a contrib pro ovladače nVidia
echo "Přidávám repozitáře non-free a contrib pro ovladače nVidia..."
echo "deb http://deb.debian.org/debian/ stable main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ stable main contrib non-free" | sudo tee -a /etc/apt/sources.list

# Přidání repozitáře pro Brave
echo "Přidávám repozitář pro Brave..."
sudo apt install -y apt-transport-https curl
curl -fsS https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo tee /etc/apt/trusted.gpg.d/brave.asc
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Aktualizace seznamu balíčků po přidání nových repozitářů
echo "Aktualizuji seznam balíčků..."
sudo apt update

# Instalace základních nástrojů
echo "Instaluji základní nástroje..."
sudo apt install -y \
    sudo \
    curl \
    wget \
    git \
    vim \
    xorg \
    alsa-utils \
    pulseaudio \
    cups \
    printer-driver-all \
    lxappearance \
    rofi \
    geany \
    geany-plugins \
    alacritty \
    nitrogen \
    picom \
    brave-browser \
    gthumb \
    thunar \
    thunar-archive-plugin \
    vlc \
    vlc-plugin-* \
    mc \
    xinit \
    htop \
    zsh \
    xsel \
    xclip \
    zip \
    unzip \
    p7zip-full \
    p7zip-rar \
    lightdm \
    lightdm-gtk-greeter

# Instalace a nastavení i3
echo "Instaluji a konfigurace i3..."
sudo apt install -y i3 i3status i3lock

# Instalace a nastavení Picom pro kompozici
echo "Instaluji Picom..."
sudo apt install -y picom

# Instalace a nastavení Nitrogen pro pozadí
echo "Instaluji Nitrogen..."
sudo apt install -y nitrogen

# Konfigurace i3 pro automatické spuštění Picom a Nitrogen
echo "Nastavuji konfigurace i3..."
mkdir -p ~/.config/i3
cat <<EOL > ~/.config/i3/config
# Konfigurace i3

# Spuštění Picom při startu
exec --no-startup-id picom

# Spuštění Nitrogen pro pozadí
exec --no-startup-id nitrogen --restore

# Další základní nastavení i3
set $mod Mod4
bindsym $mod+Return exec alacritty
bindsym $mod+d exec rofi -show run
bindsym $mod+q kill
bindsym $mod+Shift+e exit
EOL

# Instalace a nastavení LXAppearance pro změnu vzhledu
echo "Instaluji a nastavím LXAppearance..."
sudo apt install -y lxappearance

# Instalace a nastavení Thunar pro správu souborů
echo "Instaluji a nastavím Thunar..."
sudo apt install -y thunar thunar-archive-plugin

# Instalace Geany s pluginy
echo "Instaluji Geany a pluginy..."
sudo apt install -y geany geany-plugins

# Instalace VLC s kodeky
echo "Instaluji VLC s kodeky..."
sudo apt install -y vlc vlc-plugin-* 

# Instalace Midnight Commander
echo "Instaluji Midnight Commander..."
sudo apt install -y mc

# Instalace fontu Meslo
echo "Stahuji a instalují font Meslo..."
mkdir -p ~/.fonts
curl -L https://github.com/andreberg/Meslo-Font/archive/refs/heads/master.zip -o /tmp/meslo-font.zip
unzip /tmp/meslo-font.zip -d ~/.fonts
rm /tmp/meslo-font.zip
fc-cache -fv

# Nastavení LightDM jako výchozí display manager
echo "Nastavuji LightDM jako výchozí display manager..."
sudo systemctl enable lightdm.service

# Instalace nVidia ovladačů (probíhá na konci)
echo "Kontrola grafické karty a instalace ovladačů..."
if lspci | grep -i nvidia; then
    echo "nVidia grafická karta detekována, instalace ovladačů..."
    sudo apt install -y nvidia-driver nvidia-settings
else
    echo "nVidia grafická karta nenalezena, pokračuji s instalací Intel ovladačů..."
    sudo apt install -y xserver-xorg-video-intel
fi

# Restart systému pro zavedení změn
echo "Instalace dokončena, restartuji systém..."
sudo reboot
