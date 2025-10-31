# Автоматическая сборка APK для Фермерского Маркетплейса
# Запустите этот файл в PowerShell

Write-Host "🌱 ФЕРМЕРСКИЙ МАРКЕТПЛЕЙС - АВТОМАТИЧЕСКАЯ СБОРКА APK" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Green

function Test-Flutter {
    try {
        flutter --version | Out-Null
        Write-Host "✅ Flutter найден!" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "❌ Flutter не найден!" -ForegroundColor Red
        return $false
    }
}

function Install-Flutter {
    Write-Host "📥 Скачиваем Flutter SDK..." -ForegroundColor Yellow
    try {
        $url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.5-stable.zip"
        $output = "flutter.zip"
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Host "✅ Flutter SDK скачан!" -ForegroundColor Green
        
        Write-Host "📦 Распаковываем Flutter..." -ForegroundColor Yellow
        Expand-Archive -Path $output -DestinationPath "C:\" -Force
        Remove-Item $output
        
        Write-Host "✅ Flutter SDK установлен!" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "❌ Ошибка установки Flutter: $_" -ForegroundColor Red
        return $false
    }
}

function Build-APK {
    try {
        Write-Host "📦 Устанавливаем зависимости..." -ForegroundColor Yellow
        flutter pub get
        
        Write-Host "🏗️ Собираем APK..." -ForegroundColor Yellow
        flutter build apk --release
        
        Write-Host "✅ APK собран успешно!" -ForegroundColor Green
        Write-Host "📱 Файл: build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor Cyan
        return $true
    } catch {
        Write-Host "❌ Ошибка сборки: $_" -ForegroundColor Red
        return $false
    }
}

# Основная логика
if (-not (Test-Flutter)) {
    Write-Host "🔧 Устанавливаем Flutter..." -ForegroundColor Yellow
    if (-not (Install-Flutter)) {
        Write-Host "❌ Не удалось установить Flutter" -ForegroundColor Red
        Write-Host "💡 Используйте онлайн сервис: https://replit.com/" -ForegroundColor Yellow
        exit 1
    }
}

if (Build-APK) {
    Write-Host ""
    Write-Host "🎉 ГОТОВО!" -ForegroundColor Green
    Write-Host "📱 APK файл создан и готов к установке!" -ForegroundColor Green
    Write-Host "📏 Размер: ~15-20 MB" -ForegroundColor Cyan
    Write-Host "📱 Совместимость: Android 5.0+" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Ошибка сборки" -ForegroundColor Red
    Write-Host "💡 Попробуйте онлайн сервис: https://replit.com/" -ForegroundColor Yellow
}
