# hp-1018-printer-setup
HP LaserJet 1018 için iki seçenek sundum:
Adım Adım sekmesi → her komutu tek tek çalıştırmak için, her birinin yanında kopyala butonu var.
Tek Script sekmesi → tüm süreci otomatikleştiren install_hp1018.sh dosyası. İndir butonuyla direkt kaydedebilirsin, sonra:

>bashchmod +x install_hp1018.sh && sudo ./install_hp1018.sh


Önemli notlar:

HP 1018 normal HPLIP sürücüsüyle çalışmaz; foo2zjs + getweb 1018 ile firmware dosyası şarttır.
Kurulum sırasında yazıcı USB'ye bağlı olmalı.

>Script yazıcıyı otomatik algılamazsa sudo hp-setup -i komutuyla elle kurabilirsin.

Grup değişikliği (lpadmin) için oturumu kapatıp açman gerekebilir.
