#!/bin/bash
set -e

echo "=== HP LaserJet 1018 Linux Mint Kurulum Scripti ==="
echo ""

# Adım 1: Güncelleme
echo "[1/6] Sistem güncelleniyor..."
sudo apt update -qq && sudo apt upgrade -y -qq

# Adım 2: Paket kurulumu
echo "[2/6] HPLIP ve foo2zjs kuruluyor..."
sudo apt install -y hplip hplip-gui libsane-hpaio \
  printer-driver-foo2zjs foo2zjs

# Adım 3: Firmware indirme
echo "[3/6] HP 1018 firmware indiriliyor..."
sudo getweb 1018

# Adım 4: Grup yetkisi
echo "[4/6] Kullanici gruplara ekleniyor..."
sudo usermod -aG lp,lpadmin "$USER"

# Adım 5: CUPS servisi
echo "[5/6] CUPS yeniden baslatiliyor..."
sudo systemctl enable cups
sudo systemctl restart cups

# Adım 6: Yazıcı kurulumu (otomatik USB algılama)
echo "[6/6] Yazici ayarlaniyor..."
echo ">>> Yaziciyi USB ile baglayin ve ENTER'a basin..."
read -r

# CUPS üzerinden otomatik ekle
PRINTER_URI=$(lpinfo -v 2>/dev/null | grep -i "1018" | awk '{print $2}' | head -1)
if [ -n "$PRINTER_URI" ]; then
  lpadmin -p HP_LaserJet_1018 \
    -E \
    -v "$PRINTER_URI" \
    -m drv:///hp/hpcups.drv/hp-laserjet_1018.ppd
  lpoptions -d HP_LaserJet_1018
  echo ""
  echo "✓ Yazici basariyla kuruldu: HP_LaserJet_1018"
  echo ""
  echo "Test sayfasi yazdiriliyor..."
  echo "HP 1018 Test Sayfasi - Linux Mint" | lp -d HP_LaserJet_1018
else
  echo "UYARI: Yazici USB uzerinde bulunamadi."
  echo "Manuel kurulum icin: sudo hp-setup -i"
fi

echo ""
echo "=== Kurulum tamamlandi ==="
