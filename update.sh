#!/bin/bash

cd /usr/local/
rm -rf sbin
rm -rf /usr/bin/enc
cd
mkdir /usr/local/sbin
# Get the current date from Google's server
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=$(date +"%Y-%m-%d" -d "$dateFromServer")

# Function to print text in red color
red() { 
    echo -e "\\033[32;1m${*}\\033[0m"
}

# Function to display a loading bar
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        if [[ -e $HOME/fim ]]; then
            rm $HOME/fim
            break
        fi
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}

# Function to download, extract, and move files
res1() {
    wget --no-check-certificate https://konohagakure.klmpk.me:81/limit/menu.zip
    unzip menu.zip
    chmod +x menu/*
    enc menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu
    rm -rf menu.zip
    rm -rf update.sh
}

# Ensure netfilter-persistent is running
netfilter-persistent

# Clear the screen
clear

# Display update information
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " \e[1;97;101m          UPDATE SCRIPT AndyYuda       \e[0m"
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "  \033[1;91m Fix Hitung Akun\033[1;37m"
echo -e "  \033[1;91m Fix Botssh\033[1;37m"
echo -e "  \033[1;91m Fix Backup\033[1;37m"
echo -e "  \033[1;91m Pembaruan Cek Login xray\033[1;37m"
echo -e "  \033[1;91m Penambahan Port UDP\033[1;37m"
echo -e "  \033[1;91m update script service\033[1;37m"
echo -e "----------------------------------------------------------------------"
echo -e "       Terima Kasih Telah Menggunakan     "
echo -e "            Premium Script                      "
echo -e "       Andyyuda Tunneling             "
echo -e "----------------------------------------------------------------------"

# Run the update function with a loading bar
fun_bar 'res1'

# Final clear screen with information
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
