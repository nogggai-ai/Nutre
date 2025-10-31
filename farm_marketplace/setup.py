#!/usr/bin/env python3
"""
Setup script для автоматической сборки APK Фермерского Маркетплейса
"""

from setuptools import setup, find_packages
import os

# Читаем README файл
def read_readme():
    with open("README_APK.md", "r", encoding="utf-8") as fh:
        return fh.read()

# Читаем requirements
def read_requirements():
    with open("requirements.txt", "r", encoding="utf-8") as fh:
        return [line.strip() for line in fh if line.strip() and not line.startswith("#")]

setup(
    name="farm-marketplace-apk-builder",
    version="1.0.0",
    author="Farm Marketplace Team",
    author_email="team@farmmarketplace.com",
    description="Автоматическая сборка APK для Фермерского Маркетплейса",
    long_description=read_readme(),
    long_description_content_type="text/markdown",
    url="https://github.com/farm-marketplace/apk-builder",
    packages=find_packages(),
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: Software Development :: Build Tools",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
    python_requires=">=3.8",
    install_requires=read_requirements(),
    entry_points={
        "console_scripts": [
            "farm-apk-builder=build_apk:main",
            "flutter-apk-builder=build_apk:main",
        ],
    },
    include_package_data=True,
    package_data={
        "": ["*.md", "*.txt", "*.yml", "*.yaml", "*.json", "*.bat", "*.ps1", "*.sh", "*.js", "*.py"],
    },
    keywords="flutter apk android farm marketplace mobile build automation",
    project_urls={
        "Bug Reports": "https://github.com/farm-marketplace/apk-builder/issues",
        "Source": "https://github.com/farm-marketplace/apk-builder",
        "Documentation": "https://github.com/farm-marketplace/apk-builder#readme",
    },
)
