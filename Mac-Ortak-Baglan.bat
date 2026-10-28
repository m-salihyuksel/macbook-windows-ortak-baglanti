@echo off
chcp 65001 >nul
setlocal EnableExtensions
title Mac Ortak Klasöre Bağlan

rem ------------------------------------------------------------------
rem  Mac Ortak Bağlan (Windows)
rem  Mac'teki "Ortak" klasörünü sürücü olarak bağlar, şifreyi Windows
rem  Kimlik Bilgileri Yöneticisi'ne kaydeder, masaüstüne kısayol koyar.
rem  Windows her açıldığında otomatik yeniden bağlanır.
rem ------------------------------------------------------------------

set "SHARE=Ortak"
set "CFG=%APPDATA%\MacOrtak"
if not exist "%CFG%" mkdir "%CFG%"

set "MACIP="
set "MACUSER="
set "OLDDRV="
if exist "%CFG%\ip.txt"    set /p MACIP=<"%CFG%\ip.txt"
if exist "%CFG%\user.txt"  set /p MACUSER=<"%CFG%\user.txt"
if exist "%CFG%\drive.txt" set /p OLDDRV=<"%CFG%\drive.txt"

cls
echo.
echo   ==============================================
echo     Mac'teki "Ortak" klasörüne bağlan
echo   ==============================================
echo.
echo   Mac'teki "Ortak-Klasor-Kur" uygulamasının gösterdiği bilgileri gir.
echo   Köşeli parantezdeki değeri kullanmak için sadece Enter'a bas.
echo.

:askip
set "IN="
set /p "IN=  Mac'in adresi [%MACIP%]: "
if defined IN set "MACIP=%IN%"
if not defined MACIP goto askip
rem Kullanıcı \\192.168.1.30\Ortak ya da smb://... yazdıysa temizle
set "MACIP=%MACIP:smb://=%"
set "MACIP=%MACIP:\Ortak=%"
set "MACIP=%MACIP:/Ortak=%"
set "MACIP=%MACIP:\=%"
set "MACIP=%MACIP:/=%"
set "MACIP=%MACIP: =%"
if not defined MACIP goto askip

:askuser
set "IN="
set /p "IN=  Mac kullanıcı adın [%MACUSER%]: "
if defined IN set "MACUSER=%IN%"
if not defined MACUSER goto askuser

echo.
echo   Eski bağlantılar temizleniyor...
if defined OLDDRV net use %OLDDRV%: /delete /y >nul 2>&1
net use \\%MACIP%\%SHARE% /delete /y >nul 2>&1
net use \\%MACIP%\IPC$ /delete /y >nul 2>&1
cmdkey /delete:%MACIP% >nul 2>&1

echo.
echo   Şimdi Mac şifreni gir. Yazarken ekranda görünmez, bu normal.
cmdkey /add:%MACIP% /user:%MACUSER% /pass
if errorlevel 1 goto fail

rem Boş bir sürücü harfi bul (M'den başlayarak)
set "DRV="
for %%L in (M N O P Q R S T U V W X Y Z) do call :tryletter %%L
if not defined DRV goto fail

echo.
echo   Bağlanılıyor: \\%MACIP%\%SHARE%
net use %DRV%: \\%MACIP%\%SHARE% /persistent:yes
if errorlevel 1 goto fail

>"%CFG%\ip.txt" echo %MACIP%
>"%CFG%\user.txt" echo %MACUSER%
>"%CFG%\drive.txt" echo %DRV%

powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=[Environment]::GetFolderPath('Desktop'); $s=(New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $d 'Mac Ortak.lnk')); $s.TargetPath='%DRV%:\'; $s.Save()" >nul 2>&1

echo.
echo   ==============================================
echo     Bağlandı!
echo   ==============================================
echo   Masaüstünde "Mac Ortak" kısayolu var. Klasör ayrıca %DRV%: sürücüsü olarak görünür.
echo   Windows her açıldığında otomatik bağlanır.
echo   Mac kapalıyken ya da uykudayken klasöre ulaşılamaz.
echo.
start "" explorer %DRV%:\
pause
exit /b 0

:fail
echo.
echo   Bağlanılamadı. En sık nedenler:
echo     1. Mac kapalı, uykuda ya da farklı bir Wi-Fi ağında.
echo     2. Mac'te Dosya Paylaşma kapalı ya da "Ortak" klasörü eklenmemiş.
echo     3. Mac'te "Windows Dosya Paylaşma" altında kullanıcın işaretli değil.
echo     4. Adres, kullanıcı adı ya da şifre yanlış.
echo   Mac'te "Ortak-Klasor-Kur" uygulamasını açıp bilgileri kontrol et, sonra bu dosyayı tekrar çalıştır.
echo.
pause
exit /b 1

:tryletter
if defined DRV goto :eof
if exist %1:\ goto :eof
net use %1: >nul 2>&1
if not errorlevel 1 goto :eof
set "DRV=%1"
goto :eof
