@echo off
echo ========================================
echo  ФЕРМЕРСКИЙ МАРКЕТПЛЕЙС - ЗАПУСК
echo ========================================
echo.

echo Запускаем веб-приложение...
echo.

REM Проверяем наличие Python
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Используем Python для запуска сервера...
    python -m http.server 8000
) else (
    REM Проверяем наличие Node.js
    node --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo Используем Node.js для запуска сервера...
        npx http-server -p 8000
    ) else (
        echo Python и Node.js не найдены.
        echo Откройте файл index.html в браузере напрямую.
        echo.
        echo Или установите Python: https://python.org
        echo Или установите Node.js: https://nodejs.org
        pause
        exit
    )
)
