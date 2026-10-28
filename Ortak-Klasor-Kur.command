#!/bin/bash
# ------------------------------------------------------------------
#  Ortak Klasör Kur (Mac)
#  Çift tıkla. Masaüstünde "Ortak" klasörünü oluşturur, paylaşımın
#  açık olup olmadığını kontrol eder, gerekiyorsa Paylaşma ayarlarını
#  açar ve Windows'ta girilecek bilgileri gösterir.
#  Sistem ayarlarını kendisi değiştirmez; açma işini sen yaparsın.
# ------------------------------------------------------------------

FOLDER="$HOME/Desktop/Ortak"
ME="$(id -un)"

# Pencere göster. Kullanım: ask "mesaj" "Buton1" ["Buton2" ...]
# Son buton varsayılandır; basılan butonun adını yazdırır.
ask() {
  osascript - "$@" <<'APPLESCRIPT' 2>/dev/null
on run argv
	set msg to item 1 of argv
	set btns to items 2 thru -1 of argv
	activate
	set r to display dialog msg with title "Ortak Klasör" buttons btns default button (count of btns) with icon note
	return button returned of r
end run
APPLESCRIPT
}

get_ip() {
  local ifc ip=""
  ifc=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')
  case "$ifc" in en*) ip=$(ipconfig getifaddr "$ifc" 2>/dev/null) ;; esac
  if [ -z "$ip" ]; then
    for ifc in en0 en1 en2 en3 en4 en5; do
      ip=$(ipconfig getifaddr "$ifc" 2>/dev/null)
      [ -n "$ip" ] && break
    done
  fi
  echo "$ip"
}

smb_on()        { nc -z -G 2 127.0.0.1 445 >/dev/null 2>&1; }
folder_shared() { dscl . -search /SharePoints directory_path "$FOLDER" 2>/dev/null | grep -q .; }
win_user_on()   { dscl . -read "/Users/$ME" AuthenticationAuthority 2>/dev/null | grep -q "SMB-NT"; }

open_settings() {
  local major
  major=$(sw_vers -productVersion 2>/dev/null | cut -d. -f1)
  if [ "${major:-0}" -ge 13 ]; then
    open "x-apple.systempreferences:com.apple.Sharing-Settings.extension"
  else
    open "x-apple.systempreferences:com.apple.preferences.sharing"
  fi
}

echo "Ortak Klasör kurulumu başlıyor..."

# 1) Klasör
if ! mkdir -p "$FOLDER"; then
  ask "Masaüstünde \"Ortak\" klasörü oluşturulamadı. Terminal masaüstüne erişim izni isterse \"İzin Ver\"i seçip bu uygulamayı tekrar aç." "Tamam" >/dev/null
  exit 1
fi
echo "Klasör hazır: $FOLDER"

# 2) Paylaşım kontrolü
read -r -d '' STEPS <<'EOF'
Mac'te tek seferlik birkaç tıklama gerekiyor. "Ayarları Aç"a bas, Paylaşma ekranı açılacak:

1) "Dosya Paylaşma"yı aç ve yanındaki ⓘ simgesine tıkla.

2) Paylaşılan Klasörler listesinin altındaki + ile masaüstündeki "Ortak" klasörünü seç.

3) "Seçenekler…" düğmesine tıkla. "Windows Dosya Paylaşma" altında kendi adını işaretle, Mac şifreni gir ve "Bitti"ye bas.

Bitince bu pencereye dönüp "Kontrol Et"e bas.
EOF

tries=0
while true; do
  missing=""
  smb_on        || missing="$missing
• Dosya Paylaşma kapalı"
  folder_shared || missing="$missing
• \"Ortak\" klasörü paylaşılanlara eklenmemiş"
  win_user_on   || missing="$missing
• Windows Dosya Paylaşma'da kullanıcın işaretli değil"

  [ -z "$missing" ] && break

  choice=$(ask "$STEPS

Şu an eksik görünenler:$missing" "Vazgeç" "Kontrol Et" "Ayarları Aç")

  case "$choice" in
    "Ayarları Aç")
      open_settings
      ;;
    "Kontrol Et")
      tries=$((tries + 1))
      if [ "$tries" -ge 2 ]; then
        smb_on && folder_shared && win_user_on && break
        again=$(ask "Ayarları hâlâ algılayamadım. Adımları yaptığından eminsen devam edebilirsin." "Geri Dön" "Devam Et")
        [ "$again" = "Devam Et" ] && break
      fi
      ;;
    *)
      echo "Kurulum iptal edildi."
      exit 0
      ;;
  esac
done

# 3) Bağlantı bilgileri
IP=$(get_ip)
if [ -n "$IP" ]; then
  ADDR="$IP"
else
  LHN=$(scutil --get LocalHostName 2>/dev/null)
  ADDR="${LHN}.local"
fi

INFO="Hazır!

Windows bilgisayarında \"Mac-Ortak-Baglan.bat\" dosyasını çalıştır ve şunları gir:

Mac'in adresi:   $ADDR
Kullanıcı adı:   $ME
Şifre:   Mac'e girerken kullandığın şifre

İki bilgisayar aynı Wi-Fi'de olmalı. Mac uykudayken Windows klasöre ulaşamaz. Adres değişirse bu uygulamayı açıp yeni adresi Windows'taki dosyaya girmen yeter."

echo
echo "$INFO"
echo
choice=$(ask "$INFO" "Klasörü Aç" "Tamam")
[ "$choice" = "Klasörü Aç" ] && open "$FOLDER"

echo "Bu pencereyi kapatabilirsin."
