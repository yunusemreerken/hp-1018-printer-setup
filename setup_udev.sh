#!/bin/bash
# HP LaserJet 1018 — Firmware Otomatik Yükleme Kurulumu
# Yazıcı her açıldığında veya USB'ye takıldığında sihp1018.dl otomatik yüklenir.

set -e

RULE_FILE="/etc/udev/rules.d/99-hp1018-firmware.rules"
SCRIPT_FILE="/usr/local/bin/hp1018-firmware-load.sh"
FIRMWARE="/lib/firmware/hp/sihp1018.dl"

echo ">>> HP 1018 firmware otomatikleştirme kuruluyor..."

# Firmware dosyası var mı kontrol et
if [ ! -f "$FIRMWARE" ]; then
    echo "HATA: $FIRMWARE bulunamadı."
    echo "Önce 'sudo getweb 1018' komutunu çalıştırın."
    exit 1
fi

# Firmware yükleyici script oluştur
cat > "$SCRIPT_FILE" << 'INNERSCRIPT'
#!/bin/bash
# HP LaserJet 1018 firmware yükleyici
# udev tarafından yazıcı takıldığında otomatik çalıştırılır.

FIRMWARE="/lib/firmware/hp/sihp1018.dl"
DEVICE="/dev/usb/lp0"

sleep 3  # Cihazın hazır olması için bekle

if [ -f "$FIRMWARE" ] && [ -c "$DEVICE" ]; then
    cat "$FIRMWARE" > "$DEVICE" && logger "HP 1018: firmware yüklendi." || logger "HP 1018: firmware yükleme başarısız."
else
    logger "HP 1018: firmware veya cihaz bulunamadı ($FIRMWARE / $DEVICE)."
fi
INNERSCRIPT

chmod +x "$SCRIPT_FILE"
echo ">>> Yükleyici script oluşturuldu: $SCRIPT_FILE"

# udev rule oluştur
# HP LaserJet 1018 USB ID: Vendor=03f0, Product=4117
cat > "$RULE_FILE" << 'RULE'
# HP LaserJet 1018 — Firmware otomatik yükleme
# Yazıcı USB'ye takıldığında veya açıldığında tetiklenir.
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="4117", RUN+="/usr/local/bin/hp1018-firmware-load.sh"
RULE

echo ">>> udev kuralı oluşturuldu: $RULE_FILE"

# udev kurallarını yenile
udevadm control --reload-rules
udevadm trigger

echo ""
echo "Kurulum tamamlandı."
echo "Artık yazıcıyı açtığınızda veya USB'ye taktığınızda firmware otomatik yüklenir."
echo "Test etmek için yazıcıyı kapatıp açın."
