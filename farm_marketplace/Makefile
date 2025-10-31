# Makefile для автоматической сборки APK Фермерского Маркетплейса

.PHONY: all clean install-flutter build-apk check-flutter

all: check-flutter build-apk

check-flutter:
	@echo "🔍 Проверяем наличие Flutter..."
	@if ! command -v flutter >/dev/null 2>&1; then \
		echo "❌ Flutter не найден!"; \
		echo "🔧 Устанавливаем Flutter..."; \
		$(MAKE) install-flutter; \
	else \
		echo "✅ Flutter найден!"; \
	fi

install-flutter:
	@echo "📥 Скачиваем Flutter SDK..."
	@if [ ! -d "flutter" ]; then \
		wget -O flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz"; \
		tar -xf flutter.tar.xz; \
		rm flutter.tar.xz; \
		echo "✅ Flutter SDK установлен!"; \
	else \
		echo "✅ Flutter уже установлен!"; \
	fi

build-apk: check-flutter
	@echo "📦 Устанавливаем зависимости..."
	@flutter pub get
	@echo "🏗️ Собираем APK..."
	@flutter build apk --release
	@echo "✅ APK собран успешно!"
	@echo "📱 Файл: build/app/outputs/flutter-apk/app-release.apk"
	@echo "📏 Размер: ~15-20 MB"
	@echo "📱 Совместимость: Android 5.0+"

clean:
	@echo "🧹 Очищаем временные файлы..."
	@flutter clean
	@rm -rf build/
	@echo "✅ Очистка завершена!"

help:
	@echo "🌱 ФЕРМЕРСКИЙ МАРКЕТПЛЕЙС - АВТОМАТИЧЕСКАЯ СБОРКА APK"
	@echo "============================================================"
	@echo "Доступные команды:"
	@echo "  make all          - Проверить Flutter и собрать APK"
	@echo "  make build-apk     - Собрать APK (требует Flutter)"
	@echo "  make install-flutter - Установить Flutter SDK"
	@echo "  make check-flutter - Проверить наличие Flutter"
	@echo "  make clean         - Очистить временные файлы"
	@echo "  make help          - Показать эту справку"
	@echo ""
	@echo "💡 Альтернатива: используйте онлайн сервис https://replit.com/"
