#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####


# --------------- color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

# --------------- color defination (hex for gum)
red_hex="#FF0000"       # Bright red
green_hex="#00FF00"     # Bright green
yellow_hex="#FFFF00"    # Bright yellow
blue_hex="#0000FF"      # Bright blue
magenta_hex="#FF00FF"   # Bright magenta (corrected spelling)
cyan_hex="#00FFFF"      # Bright cyan
orange_hex="#FFAF00"    # Approximation for color code 214 in ANSI (orange)

# -------------- log directory
dir="$(dirname "$(realpath "$0")")"
source "$dir/interaction_fn.sh"
log_dir="$dir/Logs"
log="$log_dir"/1-install-$(date +%d-%m-%y).log
mkdir -p "$log_dir"
touch "$log"

# ---------------- creating a cache directory..
cache_dir="$dir/.cache"
cache_file="$cache_dir/user-cache"
pkgman_cache="$cache_dir/pkgman"

# --------------- sourcing the interaction prompts
if [[  "$dir/interaction_fn.sh" ]]; then
    source "$dir/interaction_fn.sh"
fi

if [[ ! -d "$cache_dir" ]]; then
    mkdir -p "$cache_dir"
fi

display_text() {
    gum style \
	--border rounded \
	--align center \
	--width 70 \
	--margin "1" \
	--padding "1" \
'
   __  ___     _        ____        _      __
  /  |/  /__ _(_)__    / __/_______(_)__  / /_
 / /|_/ / _ `/ / _ \  _\ \/ __/ __/ / _ \/ __/
/_/  /_/\_,_/_/_//_/ /___/\__/_/ /_/ .__/\__/
                                  /_/
'
}

clear && display_text && sleep 1

# ================================================== #
# =========  checking the package manager  ========= #
# ================================================== #

check_pkgman() {
    if command -v pacman &> /dev/null; then
        pkgman="pacman"
        echo "pkgman=$pkgman" >> "$pkgman_cache" 2>&1 | tee -a "$log"

    elif command -v apt &> /dev/null; then
        pkgman="apt"
        echo "pkgman=$pkgman" >> "$pkgman_cache" 2>&1 | tee -a "$log"

    else
        fn_exit "Sorry, the script won't work with your package manager for now..."
    fi
}

check_pkgman
#clear && fn_welcome && sleep 0.3

# starting the main script prompt...
. /etc/os-release
msg act "Starting the main scripts for ${cyan}$NAME${end}..." && sleep 2

if [[ ! -f "$cache_file" ]]; then
    touch "$cache_file"

    # Write initial options to the cache file
    initialize_cache_file() {
        > "$cache_file"
        for key in "${!options[@]}"; do
            echo "$key=''" >> "$cache_file"
        done
    }

    initialize_cache_file
fi

source "$cache_file"

# ====================================== #
# =========  script execution  ========= #
# ====================================== #

scripts_dir="$dir/${pkgman}-scripts"

execute_script() {
    local script="$1"
    local script_path="$scripts_dir/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            env "$script_path"
        else
            echo "Failed to make script '$script' executable." | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
        fi
    else
        echo "Script '$script' not found in '$scripts_dir'." | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    fi
}


# ================================= #
# =========  run scripts  ========= #
# ================================= #

# -------------- AUR helper and other repositories.
if [[ "$pkgman" == "pacman" ]]; then

    aur=$(command -v yay || command -v paru)
    if [[ -n "$aur" ]]; then
        msg dn "AUR helper $aur was located... Moving on" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
        sleep 1
    else
        touch "$cache_dir/aur"
        msg ask "Which AUR helper would you like to install?"
        choice=$(gum choose \
            --cursor.foreground "#00FFFF" \
            --item.foreground "#fff" \
            --selected.foreground "#00FF00" \
            "paru" "yay"
        )

        if [[ "$choice" == "paru" ]]; then
            echo "paru" > "$cache_dir/aur"
        elif [[ "$choice" == "yay" ]]; then
            echo "yay" > "$cache_dir/aur"
        fi

	execute_script 00-repo.sh
    fi
fi

execute_script 2-packages.sh

execute_script 2.1-hyprpackages.sh

execute_script 3-fonts.sh

execute_script 4-devtools.sh

execute_script 5-virtmanager.sh

execute_script 6-themes.sh

execute_script 7-dotfiles.sh

# =================================== #
# =========  final checkup  ========= #
# =================================== #

gum spin --spinner dot \
         --title "Starting final checkup.." \
         sleep 3
clear

execute_script 8-final.sh

# =================================== #
# =========  system reboot  ========= #
# =================================== #

msg dn "Congratulations! The script completes here." && sleep 2
msg att "Need to reboot the system."

fn_ask "Would you like to reboot now?" "Reboot" "No, skip"
if [[ $? -eq 0 ]]; then
    clear
    # rebooting the system in 3 seconds
    for second in 3 2 1; do
        printf ":: Rebooting the system in ${second}s\n" && sleep 1 && clear
    done
        systemctl reboot --now
else
    msg nt "Ok, but make sure to reboot the system." && sleep 1
    msg dn "Happy coding..."
    exit 0
fi

# =========______  Script ends here  ______========= #
