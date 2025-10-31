@echo off
echo Установка Flutter SDK и сборка APK...
echo.

REM Проверяем, есть ли Flutter
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo Flutter не найден. Скачиваем Flutter SDK...
    
    REM Создаем папку для Flutter
    if not exist "C:\flutter" mkdir "C:\flutter"
    
    REM Скачиваем Flutter
    echo Скачиваем Flutter SDK...
    powershell -Command "Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.5-stable.zip' -OutFile 'C:\flutter.zip'"
    
    REM Распаковываем Flutter
    echo Распаковываем Flutter SDK...
    powershell -Command "Expand-Archive -Path 'C:\flutter.zip' -DestinationPath 'C:\' -Force"
    
    REM Добавляем Flutter в PATH
    echo Добавляем Flutter в PATH...
    setx PATH "%PATH%;C:\flutter\bin" /M
    
    REM Удаляем архив
    del "C:\flutter.zip"
    
    echo Flutter SDK установлен!
) else (
    echo Flutter уже установлен.
)

echo.
echo Проверяем Flutter...
C:\flutter\bin\flutter --version

echo.
echo Устанавливаем зависимости...
C:\flutter\bin\flutter pub get

echo.
echo Собираем APK...
C:\flutter\bin\flutter build apk --release

echo.
echo APK файл создан в папке build\app\outputs\flutter-apk\
echo Файл: app-release.apk
echo.
pause
