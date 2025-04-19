#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

display_text() {
    gum style \
        --border rounded \
        --align center \
        --width 70 \
        --margin "1" \
        --padding "1" \
'
                      __                        
    ____  ____ ______/ /______ _____ ____  _____
   / __ \/ __ `/ ___/ //_/ __ `/ __ `/ _ \/ ___/
  / /_/ / /_/ / /__/ ,< / /_/ / /_/ /  __(__  ) 
 / .___/\__,_/\___/_/|_|\__,_/\__, /\___/____/  
/_/                          /____/             

'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# skip installed cache
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"

# log dir
log_dir="$parent_dir/Logs"
log="$log_dir/2-packages-$(date +%d-%m-%y).log"

# log directory
if [[ ! -f "$log" ]]; then
    mkdir -p "$log_dir"
    touch "$log"
fi

main_packages=(
  tumbler
  ffmpegthumbnailer
  brightnessctl
  network-manager-applet
  gtk4
  libadwaita
  fuse2
  imagemagick
  jq
  xclip
  kitty
  htop
  wallust
  pinta
  blueman
  grim
  slurp
  cliphist
  nwg-look
  nwg-display
  nwg-dock-hyprland
  qt6ct
  waybar
  rofi-wayland
  polkit-gnome
  pavucontrol
  breeze
  swaync
  gvfs
  wlogout
  hyprshade
  waypaper
  grimblast-git
  pacseek
  otf-font-awesome
  ttf-fira-sans
  ttf-fira-code
  ttf-firacode-nerd
  ttf-dejavu
  checkupdates-with-aur
  loupe
  power-profiles-daemon
  librewolf
)

# checking already installed packages 
for skipable in "${main_packages[@]}"; do
    skip_installed "$skipable"
done

to_install=($(printf "%s\n" "${main_packages[@]}" | grep -vxFf "$installed_cache"))

printf "\n\n"

# installing necessary packages
for packages in "${to_install[@]}"; do
  install_package "$packages"
  if command -v "$packages" &> /dev/null; then
    echo "[ DONE ] - $packages was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
  else
    echo "[ ERROR ] - Sorry, could not install '$packages'" 2>&1 | tee -a "$log" &> /dev/null
  fi
done

#sudo systemctl edit --full grub-btrfsd
#git config --global user.name "Kiljune Choi"
#git config --global user.email kiljune@gmail.com
#git config --global init.defaultBranch main

sleep 1
