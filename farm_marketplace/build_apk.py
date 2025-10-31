#!/usr/bin/env python3
"""
Автоматическая сборка APK для Фермерского Маркетплейса
"""

import os
import subprocess
import sys
import urllib.request
import zipfile
import shutil

def download_flutter():
    """Скачивает и устанавливает Flutter SDK"""
    print("📥 Скачиваем Flutter SDK...")
    try:
        url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.5-stable.zip"
        urllib.request.urlretrieve(url, "flutter.zip")
        print("✅ Flutter SDK скачан!")
        
        print("📦 Распаковываем Flutter...")
        with zipfile.ZipFile("flutter.zip", 'r') as zip_ref:
            zip_ref.extractall("C:\\")
        os.remove("flutter.zip")
        
        print("✅ Flutter SDK установлен!")
        return True
    except Exception as e:
        print(f"❌ Ошибка установки Flutter: {e}")
        return False

def check_flutter():
    """Проверяет наличие Flutter"""
    try:
        result = subprocess.run(["flutter", "--version"], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ Flutter найден!")
            return True
    except FileNotFoundError:
        pass
    
    print("❌ Flutter не найден!")
    return False

def build_apk():
    """Собирает APK файл"""
    print("🔨 Собираем APK...")
    
    try:
        # Устанавливаем зависимости
        print("📦 Устанавливаем зависимости...")
        subprocess.run(["flutter", "pub", "get"], check=True)
        
        # Собираем APK
        print("🏗️ Собираем APK...")
        subprocess.run(["flutter", "build", "apk", "--release"], check=True)
        
        print("✅ APK собран успешно!")
        print("📱 Файл: build/app/outputs/flutter-apk/app-release.apk")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Ошибка сборки: {e}")
        return False

def main():
    print("🌱 ФЕРМЕРСКИЙ МАРКЕТПЛЕЙС - АВТОМАТИЧЕСКАЯ СБОРКА APK")
    print("=" * 60)
    
    # Проверяем Flutter
    if not check_flutter():
        print("🔧 Устанавливаем Flutter...")
        if not download_flutter():
            print("❌ Не удалось установить Flutter")
            print("💡 Используйте онлайн сервис: https://replit.com/")
            return
    
    # Собираем APK
    if build_apk():
        print("\n🎉 ГОТОВО!")
        print("📱 APK файл создан и готов к установке!")
        print("📏 Размер: ~15-20 MB")
        print("📱 Совместимость: Android 5.0+")
    else:
        print("\n❌ Ошибка сборки")
        print("💡 Попробуйте онлайн сервис: https://replit.com/")

if __name__ == "__main__":
    main()
