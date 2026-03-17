#!/bin/bash

# ==============================================================================
# Title       : ZeroTier Auto-Installer & Fixer for Debian
# Author      : Muhammad Razan Rizqullah
# Description : Script otomatis untuk mempersiapkan dan menginstal ZeroTier 
#               tanpa kendala GPG error atau dependensi yang hilang di Debian.
# ==============================================================================

echo "=============================================================================="
echo "          Memulai Instalasi ZeroTier - by Muhammad Razan Rizqullah          "
echo "=============================================================================="

# 1. Pastikan script dijalankan sebagai Root
if [ "$EUID" -ne 0 ]; then
  echo "[Error] Tolong jalankan script ini sebagai root!"
  echo "Ketik 'su -' lalu masukkan password root Anda sebelum menjalankan script ini."
  exit 1
fi

# 2. Update sistem dan instal paket pendukung wajib
echo -e "\n[1/5] Memperbarui sistem & menginstal paket pendukung (curl, gnupg, dll)..."
apt update -y
apt install -y curl wget gnupg ca-certificates apt-transport-https lsb-release sudo

# 3. Bersihkan sisa error sebelumnya (jika ada) dan unduh GPG Key dengan benar
echo -e "\n[2/5] Mengunduh dan memproses GPG Key ZeroTier..."
rm -f /usr/share/keyrings/zerotier.gpg
rm -f /etc/apt/sources.list.d/zerotier.list
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/main/doc/contact%40zerotier.com.gpg' | gpg --dearmor -o /usr/share/keyrings/zerotier.gpg

# 4. Tambahkan Repositori sesuai versi Debian yang dipakai
echo -e "\n[3/5] Menambahkan repositori ZeroTier..."
OS_CODENAME=$(lsb_release -cs) # Mendapatkan nama OS otomatis (contoh: bookworm)
echo "deb [signed-by=/usr/share/keyrings/zerotier.gpg] http://download.zerotier.com/debian/$OS_CODENAME $OS_CODENAME main" > /etc/apt/sources.list.d/zerotier.list

# 5. Instal ZeroTier One
echo -e "\n[4/5] Menginstal ZeroTier One..."
apt update -y
apt install -y zerotier-one

# 6. Aktifkan dan jalankan Service
echo -e "\n[5/5] Mengaktifkan layanan ZeroTier..."
systemctl enable zerotier-one
systemctl start zerotier-one

# 7. Selesai dan tampilkan status
echo -e "\n=============================================================================="
echo " Instalasi Selesai! Menguji status ZeroTier..."
echo "=============================================================================="
sleep 2
zerotier-cli status

echo -e "\n=============================================================================="
echo "Jika status di atas adalah 'ONLINE', Anda siap bergabung ke jaringan!"
echo "Gunakan perintah berikut untuk join:"
echo "zerotier-cli join <Network_ID>"
echo "=============================================================================="
