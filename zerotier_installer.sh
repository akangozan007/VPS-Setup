#!/bin/bash

# ==============================================================================
# Title       : ZeroTier Multi-Distro Auto-Installer
# Author      : Muhammad Razan Rizqullah (Revised)
# Description : Script otomatis untuk menginstal ZeroTier di berbagai distro Linux
#               (Debian, Ubuntu, CentOS, Fedora, RHEL, Arch Linux).
# ==============================================================================

echo "=============================================================================="
echo "          Memulai Instalasi ZeroTier - Multi-Distro Support                 "
echo "=============================================================================="

# 1. Pastikan script dijalankan sebagai Root
if [ "$EUID" -ne 0 ]; then
  echo "[Error] Tolong jalankan script ini sebagai root atau gunakan sudo!"
  exit 1
fi

# 2. Deteksi Distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "[Error] Tidak dapat mendeteksi jenis sistem operasi."
    exit 1
fi

echo "[Log] Sistem terdeteksi: $OS"

# 3. Proses Instalasi Berdasarkan Distro
case "$OS" in
    debian|ubuntu|linuxmint|kali)
        echo -e "\n[1/3] Menyiapkan repositori untuk keluarga Debian/Ubuntu..."
        apt-get update -y
        apt-get install -y curl gnupg ca-certificates lsb-release
        
        # Menggunakan script resmi ZeroTier untuk handling GPG & Repo yang lebih aman
        curl -s https://install.zerotier.com | bash
        ;;

    fedora|centos|rhel|almalinux|rocky)
        echo -e "\n[1/3] Menyiapkan repositori untuk keluarga RHEL/Fedora..."
        if [ "$OS" == "fedora" ]; then
            dnf install -y curl
        else
            yum install -y curl
        fi
        
        # Installer resmi otomatis mendeteksi konfigurasi YUM/DNF
        curl -s https://install.zerotier.com | bash
        ;;

    arch|manjaro)
        echo -e "\n[1/3] Menginstal via Pacman untuk Arch Linux..."
        pacman -Sy --noconfirm zerotier-one
        ;;

    *)
        echo "[Error] Distro '$OS' belum didukung secara otomatis oleh script ini."
        echo "Mencoba metode instalasi universal..."
        curl -s https://install.zerotier.com | bash
        ;;
esac

# 4. Aktifkan dan jalankan Service
echo -e "\n[2/3] Mengaktifkan layanan ZeroTier..."
systemctl enable zerotier-one
systemctl start zerotier-one

# 5. Selesai dan tampilkan status
echo -e "\n[3/3] Instalasi Selesai! Menguji status ZeroTier..."
echo "=============================================================================="
sleep 2

if command -v zerotier-cli >/dev/null 2>&1; then
    zerotier-cli status
else
    echo "[Error] Perintah 'zerotier-cli' tidak ditemukan. Cek log instalasi di atas."
fi

echo -e "\n=============================================================================="
echo "Gunakan perintah berikut untuk join ke network:"
echo "sudo zerotier-cli join <Network_ID>"
echo "=============================================================================="
