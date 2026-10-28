# MacBook ve Windows Ortak Bağlantı

**Ne işe yarar?** Mac'in masaüstündeki **Ortak** klasörünü Windows bilgisayardan açmanı sağlar. Bir klasöre attığın dosya iki bilgisayarda da görünür.

**İndir:**
- 🍎 **Mac için:** [Ortak-Klasor-Kur-Mac.zip](https://github.com/m-salihyuksel/macbook-windows-ortak-baglanti/releases/latest/download/Ortak-Klasor-Kur-Mac.zip)
- 🪟 **Windows için:** [Mac-Ortak-Baglan.bat](https://github.com/m-salihyuksel/macbook-windows-ortak-baglanti/releases/latest/download/Mac-Ortak-Baglan.bat)

Önce Mac'tekini, sonra Windows'takini çalıştır. Ayrıntılı anlatım aşağıda.

---

## Kurulum

### 1. Mac

1. **Ortak-Klasor-Kur-Mac.zip** dosyasını indir ve çift tıklayıp aç.
2. Çıkan **Ortak-Klasor-Kur.command** dosyasına çift tıkla.
3. Uygulama masaüstünde **Ortak** klasörünü oluşturur ve Paylaşma ayarlarını açar. Ekranda yazan 3 adımı yap:
   - **Dosya Paylaşma**'yı aç, yanındaki ⓘ simgesine tıkla.
   - **+** ile masaüstündeki **Ortak** klasörünü ekle.
   - **Seçenekler…** → **Windows Dosya Paylaşma** altında kendi adını işaretle, Mac şifreni gir.
4. **Kontrol Et**'e bas. Uygulama Windows'ta gireceğin **adresi** ve **kullanıcı adını** gösterir.

> **"Açılamıyor" / "Apple doğrulayamadı" uyarısı çıkarsa:** Sistem Ayarları → Gizlilik ve Güvenlik → en altta **Yine de Aç**'a tıkla.
> Ya da Terminal'i açıp şunu çalıştır: `bash ~/Downloads/Ortak-Klasor-Kur.command`

### 2. Windows

1. **Mac-Ortak-Baglan.bat** dosyasını indirip çift tıkla.
2. Mac'teki uygulamanın gösterdiği **adresi**, **kullanıcı adını** ve **Mac şifreni** gir.
3. Klasör bir sürücü olarak bağlanır (M:, N: …) ve masaüstüne **Mac Ortak** kısayolu eklenir.

> **"Windows bilgisayarınızı korudu" uyarısı çıkarsa:** **Ek bilgi** → **Yine de çalıştır**.

## Bilmen gerekenler

- İki bilgisayar **aynı Wi-Fi / modem** üzerinde olmalı.
- Mac **kapalıyken ya da uykudayken** Windows klasöre ulaşamaz.
- Mac'in adresi değişirse Mac'teki uygulamayı tekrar aç, yeni adresi görüp Windows'taki dosyayı yeniden çalıştır. Eski bağlantıyı kendisi temizler.
- Mac uygulaması sistem ayarlarını **kendisi değiştirmez**; sadece doğru ekranı açar ve durumu kontrol eder.
- Windows tarafında şifre, Windows'un kendi **Kimlik Bilgileri Yöneticisi**'ne kaydedilir; dosyada saklanmaz.

## Sorun giderme

| Sorun | Çözüm |
|---|---|
| Windows "Bağlanılamadı" diyor | Mac açık ve uyanık mı, aynı ağda mı? Mac'te uygulamayı açıp "eksik görünenler" listesine bak. |
| Şifre kabul edilmiyor | Mac'e giriş şifreni kullan. Mac'te **Windows Dosya Paylaşma** altında adının işaretli olduğundan emin ol. |
| Adres bulunamıyor | Mac'te Sistem Ayarları → Ağ bölümünden IP adresine bak (ör. 192.168.1.30). |
