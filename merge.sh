#!/bin/bash

# Проверяем, указан ли аргумент ветки
if [ -z "$1" ]; then
  echo "Укажите имя ветки в качестве первого аргумента!"
  echo "Пример: ./git_merge.sh <branch-name>"
  exit 1
fi

# Название ветки из первого аргумента
BRANCH_NAME=$1

# Получаем имя текущей ветки
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Выполняем fetch всех изменений..."
git fetch origin

# Проверка, существует ли удалённая ветка
if ! git show-ref --verify --quiet refs/remotes/origin/$BRANCH_NAME; then
  echo "Удалённая ветка '$BRANCH_NAME' не найдена!"
  exit 1
fi

echo "Выполняем merge 'origin/$BRANCH_NAME' в '$CURRENT_BRANCH' с опцией -X ours..."
if git merge origin/$BRANCH_NAME; then
  echo "Merge успешно завершён!"
else
  echo "Во время слияния возникли конфликты. Пожалуйста, разрешите их вручную:"
  echo "  - Отредактируйте конфликтные файлы"
  echo "  - Выполните: git add <файл>"
  echo "  - Завершите слияние: git commit"
  exit 1
fi

echo "Merge завершён для ветки '$CURRENT_BRANCH', изменения из '$BRANCH_NAME' успешно включены."
exit 0
