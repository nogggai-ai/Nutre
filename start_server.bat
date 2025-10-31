@echo off
title Local static server (Python) — http://localhost:8000
echo Starting local server on http://localhost:8000
echo Press Ctrl+C to stop.
python -m http.server 8000
pause

@echo off
echo.
echo ==================================================================
echo   ЗАПУСК ЛОКАЛЬНОГО ВЕБ-СЕРВЕРА
echo ==================================================================
echo.
echo Сервер запускается на порту 8000...
echo.
echo Откройте в браузере: http://localhost:8000
echo.
echo Для остановки сервера нажмите Ctrl+C
echo.
echo ==================================================================
echo.

python -m http.server 8000

pause
