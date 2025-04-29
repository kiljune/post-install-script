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
    _____             __
   / __(_)___  ____ _/ /
  / /_/ / __ \/ __ `/ / 
 / __/ / / / / /_/ / /  
/_/ /_/_/ /_/\__,_/_/   

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

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/8-final_checkup-$(date +%d-%m-%y).log"

if [[ ! -f "$log" ]]; then
    mkdir -p "$log_dir"
    touch "$log"
fi

etc_env="/etc/environment"
sudo mv $etc_env $HOME/environment.bak
sudo touch $etc_env
echo "VISUAL=nvim" 2>&1 | sudo tee -a $etc_env &> /dev/null
echo "EDITOR=nvim" 2>&1 | sudo tee -a $etc_env &> /dev/null
echo "" 2>&1 | sudo tee -a $etc_env &> /dev/null
echo "GTK_IM_MODULE=ibus" 2>&1 | sudo tee -a $etc_env &> /dev/null
echo "QT_IM_MODULE=ibus" 2>&1 | sudo tee -a $etc_env &> /dev/null
echo "XMODIFIERS=@im=ibus" 2>&1 | sudo tee -a $etc_env &> /dev/null

chsh -s "$(which zsh)"
if [[ ! -f /usr/local/bin/bat ]]; then
    sudo ln -s /usr/bin/batcat /usr/local/bin/bat
fi
sudo systemctl enable --now ufw
sudo ufw enable
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo apt autoremove
sudo apt clean

sleep 1
