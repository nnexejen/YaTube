#!/bin/bash
# run-act.sh — локальный запуск тестов из GitHub Actions

set -e  # Выход при ошибке

# Проверка: установлен ли act?
if ! command -v act &> /dev/null; then
    echo "act not found. Install: https://github.com/nektos/act"
    exit 1
fi

# Проверка: запущен ли Docker?
if ! docker info &> /dev/null; then
    echo "Docker daemon not running. Start Docker Desktop."
    exit 1
fi

echo "Running tests with act..."

act -j test \
  -P ubuntu-latest=catthehacker/ubuntu:act-latest \
  -s DB_NAME=yatube \
  -s POSTGRES_PASSWORD=postgres \
  -s SECRET_KEY=test123 \
  -s DB_HOST=localhost \
  -s POSTGRES_USER=postgres \
  -s DB_PORT=5432 \
  -s DEBUG=false