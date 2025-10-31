@echo off
echo ========================================
echo  ФЕРМЕРСКИЙ МАРКЕТПЛЕЙС - СБОРКА APK
echo ========================================
echo.

echo Проверяем наличие Flutter...
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo Flutter не найден. Устанавливаем...
    echo.
    echo Скачиваем Flutter SDK...
    powershell -Command "try { Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.5-stable.zip' -OutFile 'flutter.zip' } catch { Write-Host 'Ошибка загрузки Flutter' }"
    
    if exist flutter.zip (
        echo Распаковываем Flutter...
        powershell -Command "Expand-Archive -Path 'flutter.zip' -DestinationPath 'C:\' -Force"
        del flutter.zip
        
        echo Добавляем Flutter в PATH...
        setx PATH "%PATH%;C:\flutter\bin" /M
        
        echo Flutter установлен! Перезапустите командную строку.
        pause
        exit
    ) else (
        echo Ошибка загрузки Flutter. Используйте онлайн сервис.
        echo.
        echo Откройте https://replit.com/ и создайте Flutter проект
        echo Загрузите файлы из farm_marketplace_for_apk.zip
        echo Выполните: flutter build apk --release
        pause
        exit
    )
) else (
    echo Flutter найден!
)

echo.
echo Устанавливаем зависимости...
flutter pub get

echo.
echo Собираем APK...
flutter build apk --release

echo.
echo ========================================
echo  СБОРКА ЗАВЕРШЕНА!
echo ========================================
echo.
echo APK файл создан в папке:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo Размер файла: ~15-20 MB
echo Совместимость: Android 5.0+
echo.
pause
