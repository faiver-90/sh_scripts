#!/bin/bash

# Проверка наличия аргумента
if [ -z "$1" ]; then
  echo "Ошибка: Не указан комментарий для коммита."
  echo "Использование: $0 'комментарий для коммита'"
  exit 1
fi

COMMENT=$1

# Проверка и установка pre-commit, если не установлен
if ! git config --get core.hooksPath > /dev/null; then
    pre-commit install
    pre-commit autoupdate
fi

# Запуск pre-commit перед коммитом
echo "Запускаем pre-commit..."
pre-commit run --all-files
if [ $? -ne 0 ]; then
  echo "Ошибка: pre-commit нашел ошибки. Коммит прерван."
  exit 1
fi

# Добавляем изменения в индекс
echo "Добавляем изменения в индекс..."
git add .
if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось добавить изменения в индекс."
  exit 1
fi

# Выполняем коммит с указанным комментарием
echo "Выполняем коммит с комментарием: $COMMENT"
git commit -m "$COMMENT"
if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось выполнить коммит."
  exit 1
fi