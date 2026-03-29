#!/bin/bash

# Pastikan curl sudah terinstal
if ! command -v curl &> /dev/null; then
    echo "Error: 'curl' tidak ditemukan. Harap instal curl terlebih dahulu sesuai distro Anda."
    exit 1
fi

echo "========================================"
echo "Memulai instalasi code-server..."
echo "========================================"

# 1. Menjalankan skrip instalasi universal resmi dari Coder
# Skrip ini akan mendeteksi OS (Debian, RedHat, Arch, dll) secara otomatis
curl -fsSL https://code-server.dev/install.sh | sh

echo "========================================"
echo "Mengonfigurasi systemd agar berjalan di latar belakang..."
echo "========================================"

# 2. Mengaktifkan code-server sebagai service untuk user saat ini (bukan root)
# Ini adalah praktik keamanan terbaik (best practice) untuk code-server
systemctl --user enable --now code-server

# 3. Memastikan service tetap berjalan meskipun user logout (Linger)
sudo loginctl enable-linger $USER

echo "========================================"
echo "Instalasi dan Konfigurasi Selesai!"
echo "========================================"
echo ""
echo "Code-server sekarang berjalan di http://127.0.0.1:8080"
echo ""
echo "Untuk melihat password default Anda, jalankan perintah ini:"
echo "cat ~/.config/code-server/config.yaml"
echo ""
echo "Jika Anda ingin mengaksesnya dari komputer lain, edit file config.yaml"
echo "dan ubah 'bind-addr: 127.0.0.1:8080' menjadi 'bind-addr: 0.0.0.0:8080',"
echo "lalu restart dengan perintah: systemctl --user restart code-server"
echo "========================================"
