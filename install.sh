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

dir="$(dirname "$(realpath "$0")")"
start="$dir/start.sh"

clear && sleep 1

printf "${cyan}**${end} Pre install script...\n   Need to install some packages first, installing those...\n" && sleep 2

packages=(
    git
    gum
)

for pkg in "${packages[@]}"; do

    if command -v pacman &> /dev/null; then
        if sudo pacman -Q "$pkg" &> /dev/null; then
            printf "${magenta}[ Skip ] ${end} Skipping $pkg, it's already installed...\n"
        else
            printf "${green}=>${end} Installing $pkg...\n"
            if sudo pacman -S --noconfirm "$pkg" &> /dev/null; then
                printf "${cyan}::${end} Successfully installed ${cyan}$pkg${end}...\n"
            fi
        fi
    elif command -v apt &> /dev/null; then

        if command -v "$pkg" &> /dev/null; then
            printf "${magenta}[ Skip ]${end} Skipping $pkg, it's already installed...\n"
        else
            printf "${green}=>${end} Installing $pkg...\n"
            if sudo apt install -y "$pkg" &> /dev/null; then
                printf "${cyan}::${end} Successfully installed ${cyan}$pkg${end}...\n"
            fi
        fi
    fi

done

sleep 1

chmod +x "$start"
"$start"
