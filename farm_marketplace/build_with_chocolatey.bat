@echo off
echo Установка Flutter и сборка APK через Chocolatey...
echo.

REM Проверяем, установлен ли Chocolatey
where choco >nul 2>nul
if %errorlevel% neq 0 (
    echo Устанавливаем Chocolatey...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    echo Chocolatey установлен!
) else (
    echo Chocolatey уже установлен.
)

echo.
echo Устанавливаем Flutter через Chocolatey...
choco install flutter -y

echo.
echo Обновляем PATH...
refreshenv

echo.
echo Проверяем Flutter...
flutter --version

echo.
echo Устанавливаем зависимости...
flutter pub get

echo.
echo Собираем APK...
flutter build apk --release

echo.
echo APK файл создан в папке build\app\outputs\flutter-apk\
echo Файл: app-release.apk
echo.
pause
