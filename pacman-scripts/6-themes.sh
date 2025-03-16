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
   __  __                            
  / /_/ /_  ___  ____ ___  ___  _____
 / __/ __ \/ _ \/ __ `__ \/ _ \/ ___/
/ /_/ / / /  __/ / / / / /  __(__  ) 
\__/_/ /_/\___/_/ /_/ /_/\___/____/  

'
}

clear && display_text
printf " \n \n"

printf " \n"

###------ Startup ------###

# finding the presend directory and log file
# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# skip installed cache
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/6-themes-$(date +%d-%m-%y).log"

if [[ -f "$log" ]]; then
    errors=$(grep "ERROR" "$log")
    last_installed=$(grep "fonts-firacode" "$log" | awk {'print $2'})
    if [[ -z "$errors" && "$last_installed" == "DONE" ]]; then
        msg skp "Skipping this script. No need to run it again..."
        sleep 1
        exit 0
    fi
else
    mkdir -p "$log_dir"
    touch "$log"
fi

# installable themes will be here
themes=(
    bibata-cursor-theme
    papirus-icon-theme
)

# checking already installed packages 
for skipable in "${themes[@]}"; do
    skip_installed "$skipable"
done

to_install=($(printf "%s\n" "${themes[@]}" | grep -vxFf "$installed_cache"))

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

sleep 1 && clear
