#!/bin/bash

cd /usr/local/
rm -rf sbin
rm -rf /usr/bin/enc
cd
mkdir /usr/local/sbin

# Ambil tanggal saat ini dari server Google
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=$(date +"%Y-%m-%d" -d "$dateFromServer")

# Fungsi untuk mencetak teks dalam warna merah
red() { 
    echo -e "\\033[32;1m${*}\\033[0m"
}

# Fungsi untuk menampilkan bar pemrosesan
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

# Fungsi untuk mengunduh, mengekstrak, dan memindahkan file
res1() {
    wget --no-check-certificate https://konohagakure.klmpk.me:81/limit/menu.zip
    wget -q -O /usr/bin/enc "https://raw.githubusercontent.com/myvpn1/vip/main/limit/epro/epro" ; chmod +x /usr/bin/enc
    7z e -paskyandy123 x menu.zip
    unzip menu.zip
    chmod +x menu/*
    enc menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu
    rm -rf menu.zip
    rm -rf update.sh
}

# Ambil Config Server
get_config_server() {
    REPO="https://raw.githubusercontent.com/myvpn1/vip/main/"
    wget -O /etc/xray/vmess.json "${REPO}limit/vmess.json" >/dev/null 2>&1
    wget -O /etc/xray/vless.json "${REPO}limit/vless.json" >/dev/null 2>&1
    wget -O /etc/xray/trojan.json "${REPO}limit/trojan.json" >/dev/null 2>&1
    wget -O /etc/xray/shadowsocks.json "${REPO}limit/shadowsocks.json" >/dev/null 2>&1
    wget -O /etc/systemd/system/runn.service "${REPO}limit/runn.service" >/dev/null 2>&1
}

# Buat layanan sistemd untuk VMESS
configure_vmess_service() {
    rm -rf /etc/systemd/system/vmess.service.d
    cat >/etc/systemd/system/vmess.service <<EOF
[Unit]
Description=Xray Vmess Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/vmess.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF
    echo "Konfigurasi Vmess"
    systemctl daemon-reload
    systemctl restart vmess
}

# Buat layanan sistemd untuk VLESS
configure_vless_service() {
    rm -rf /etc/systemd/system/vless.service.d
    cat >/etc/systemd/system/vless.service <<EOF
[Unit]
Description=Xray Vless Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/vless.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF
    echo "Konfigurasi Vless"
    systemctl daemon-reload
    systemctl restart vless
}

# Buat layanan sistemd untuk Trojan
configure_trojan_service() {
    rm -rf /etc/systemd/system/trojan.service.d
    cat >/etc/systemd/system/trojan.service <<EOF
[Unit]
Description=Xray Trojan Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/trojan.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF
    echo "Konfigurasi Trojan"
    systemctl daemon-reload
    systemctl restart trojan
}

# Buat layanan sistemd untuk Shadowsocks
configure_shadowsocks_service() {
    rm -rf /etc/systemd/system/shadowsocks.service.d
    cat >/etc/systemd/system/shadowsocks.service <<EOF
[Unit]
Description=Xray Shadowsocks Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/shadowsocks.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF
    echo "Konfigurasi Shadowsocks"
    systemctl daemon-reload
    systemctl restart shadowsocks
}

# Pastikan netfilter-persistent berjalan
netfilter-persistent

# Bersihkan layar
clear

# Tampilkan informasi pembaruan
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

# Jalankan fungsi pembaruan dengan bar pemrosesan
fun_bar 'res1'

# Ambil konfigurasi server
get_config_server

# Konfigurasi layanan sistemd dan restart layanan
configure_vmess_service
configure_vless_service
configure_trojan_service
configure_shadowsocks_service

# Bersihkan layar dengan informasi akhir
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
