FROM ubuntu:20.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Установка Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:${PATH}"

# Установка Android SDK
RUN mkdir -p /android-sdk/cmdline-tools
RUN curl -o /tmp/cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN unzip /tmp/cmdline-tools.zip -d /android-sdk/cmdline-tools
RUN mv /android-sdk/cmdline-tools/cmdline-tools /android-sdk/cmdline-tools/latest
RUN rm /tmp/cmdline-tools.zip

ENV ANDROID_HOME=/android-sdk
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"

# Принятие лицензий
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Рабочая директория
WORKDIR /app

# Копирование файлов проекта
COPY . .

# Установка зависимостей Flutter
RUN flutter pub get

# Сборка APK
RUN flutter build apk --release

# Команда по умолчанию
CMD ["cp", "build/app/outputs/flutter-apk/app-release.apk", "/output/"]
