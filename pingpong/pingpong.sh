#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo -e "\033[31mHarap jalankan script ini sebagai root.\033[0m"
  exit 1
fi

function info() {
  echo -e "\033[32m$1\033[0m"
}

function warning() {
  echo -e "\033[33m$1\033[0m"
}

function error() {
  echo -e "\033[31m$1\033[0m"
}

info "Memperbarui dan meng-upgrade sistem..."
sudo apt update && sudo apt upgrade -y

info "Menginstal Docker..."
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update && sudo apt install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker

if systemctl is-active --quiet docker; then
  DOCKER_VERSION=$(docker --version)
  info "Docker berhasil diinstal, diaktifkan, dan versi yang terpasang: $DOCKER_VERSION."
else
  error "Docker gagal dijalankan. Periksa konfigurasi dan coba lagi."
  exit 1
fi

info "Menginstal Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

if docker-compose --version > /dev/null 2>&1; then
  info "Docker Compose versi $DOCKER_COMPOSE_VERSION berhasil diinstal."
else
  error "Docker Compose gagal diinstal atau dijalankan. Periksa konfigurasi dan coba lagi."
  exit 1
fi

info "Mengunduh File Pingpong"
cd $HOME
wget https://pingpong-build.s3.ap-southeast-1.amazonaws.com/linux/latest/PINGPONG
chmod +x PINGPONG
info "File Pingpong berhasil diunduh."

info "Menginstal screen..."
sudo apt install -y screen
info "screen berhasil diinstal."

info ""
info "Buka tautan berikut untuk membuat Device ID:"
info "https://harvester.pingpong.build/devices"
info ""
info "Salin Device ID Anda dan jalankan aplikasi menggunakan langkah berikut:"
info "screen -S pingpong"
info "./PINGPONG --key DEVICE_ID_ANDA"
info ""

info "Script auto-installer-pingpong selesai"
