#!/bin/bash
# Автоматическая сборка APK для Фермерского Маркетплейса
# Запустите этот файл в Bash

echo "🌱 ФЕРМЕРСКИЙ МАРКЕТПЛЕЙС - АВТОМАТИЧЕСКАЯ СБОРКА APK"
echo "============================================================"

check_flutter() {
    if command -v flutter &> /dev/null; then
        echo "✅ Flutter найден!"
        return 0
    else
        echo "❌ Flutter не найден!"
        return 1
    fi
}

install_flutter() {
    echo "📥 Скачиваем Flutter SDK..."
    if wget -O flutter.zip "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz"; then
        echo "✅ Flutter SDK скачан!"
        
        echo "📦 Распаковываем Flutter..."
        tar -xf flutter.zip
        rm flutter.zip
        
        echo "✅ Flutter SDK установлен!"
        return 0
    else
        echo "❌ Ошибка установки Flutter"
        return 1
    fi
}

build_apk() {
    echo "📦 Устанавливаем зависимости..."
    if flutter pub get; then
        echo "🏗️ Собираем APK..."
        if flutter build apk --release; then
            echo "✅ APK собран успешно!"
            echo "📱 Файл: build/app/outputs/flutter-apk/app-release.apk"
            return 0
        else
            echo "❌ Ошибка сборки APK"
            return 1
        fi
    else
        echo "❌ Ошибка установки зависимостей"
        return 1
    fi
}

# Основная логика
if ! check_flutter; then
    echo "🔧 Устанавливаем Flutter..."
    if ! install_flutter; then
        echo "❌ Не удалось установить Flutter"
        echo "💡 Используйте онлайн сервис: https://replit.com/"
        exit 1
    fi
fi

if build_apk; then
    echo ""
    echo "🎉 ГОТОВО!"
    echo "📱 APK файл создан и готов к установке!"
    echo "📏 Размер: ~15-20 MB"
    echo "📱 Совместимость: Android 5.0+"
else
    echo ""
    echo "❌ Ошибка сборки"
    echo "💡 Попробуйте онлайн сервис: https://replit.com/"
fi
