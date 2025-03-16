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
   ___       __  ____ __      
  / _ \___  / /_/ _(_) /__ ___
 / // / _ \/ __/ _/ / / -_|_-<
/____/\___/\__/_//_/_/\__/___/

'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/7-dotfiles-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# Clone the repository and log the output
if [[ ! -d "$HOME/dotfiles" ]] then
    if [[ ! -d "$parent_dir/.cache/dotfiles" ]]; then
        #git clone --depth=1 https://github.com/shell-ninja/hyprconf.git "$parent_dir/.cache/dotfiles" 2>&1 | tee -a "$log" &> /dev/null
        echo "TODO: git clone my dotfiles"
    fi
fi
sleep 1

# if repo clonned successfully, then setting up the config
if [[ -d "$parent_dir/.cache/dotfiles" ]]; then
  cd "$parent_dir/.cache/dotfiles" || { msg err "Could not changed directory to $parent_dir/.cache/dotfiles" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

  mkdir -p $HOME/dotfiles || { msg err "Could not make directory to $HOME/dotfiles" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1;}
  sleep 0.3

  cp * $HOME/dotfiles || { msg err "Could not copy directory to $HOME/dotfiles" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1;}
fi

if [[ -f "$HOME/dotfiles/.stowrc" ]]; then
  msg dn "Dotfiles setup was successful..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  cd $HOME/dotfiles
  stow . || { msg err "Could not stow $HOME/dotfiles" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1;}
else
  msg err "Could not setup dotfiles.." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  exit 1
fi

sleep 1 && clear
