#!/bin/bash

# Проверка на наличие аргумента
if [ -z "$1" ]; then
  echo "Укажите имя ветки как аргумент!"
  echo "Пример: ./git_rebase.sh <branch-name>"
  exit 1
fi

# Название ветки из аргумента
BRANCH_NAME=$1

# Определяем текущую ветку
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Выполняем fetch всех изменений..."
git fetch origin

# Проверка, существует ли удаленная ветка
if ! git show-ref --verify --quiet refs/remotes/origin/$BRANCH_NAME; then
  echo "Удалённая ветка '$BRANCH_NAME' не найдена!"
  exit 1
fi

echo "Выполняем rebase '$CURRENT_BRANCH' на 'origin/$BRANCH_NAME'..."
if git rebase origin/$BRANCH_NAME; then
  echo "✅ Rebase успешно завершён!"
else
  echo "❌ Возникли конфликты. Решите их и продолжите ребейз:"
  echo "  - Отредактируйте конфликтные файлы"
  echo "  - Выполните: git add <файл>"
  echo "  - Продолжите ребейз: git rebase --continue"
  echo "  - Чтобы отменить ребейз: git rebase --abort"
  echo "  - Если пушил до ребейза, использовать push --force-with-lease "
  exit 1
fi

# Завершение
echo "🎉 Rebase завершен для ветки '$CURRENT_BRANCH' на основе '$BRANCH_NAME'."
exit 0
