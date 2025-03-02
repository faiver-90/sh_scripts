#!/bin/bash

case "$1" in
    up)
        echo "🚀 Запуск Docker Compose..."
        docker-compose up -d
        ;;

    down)
        echo "🛑 Остановка контейнеров..."
        docker-compose down
        ;;

    restart)
        if [ -z "$2" ]; then
            echo "⚠ Использование: ./docker.sh restart <container>"
        else
            echo "🔄 Перезапуск контейнера $2..."
            docker-compose restart "$2"
        fi
        ;;

    a_restart)
        echo "🔄 Перезапуск всех контейнеров..."
        docker-compose restart
        ;;

    logs)
        echo "📜 Логи..."
        docker-compose logs -f
        ;;

    stats)
        echo "📊 Мониторинг Docker..."
        docker stats
        ;;

    ps)
        echo "📋 Запущенные контейнеры:"
        docker ps --format "table {{.Names}}\t{{.Status}}"
        ;;

    exec)
        if [ -z "$2" ]; then
            echo "⚠ Использование: ./docker.sh exec <container>"
        else
            echo "🐚 Вход в контейнер $2..."
			docker exec -it "$2" bash
        fi
        ;;

	rebuild)
		echo "🔄 Полная очистка, пересборка и запуск..."
		docker-compose down --rmi all --volumes --remove-orphans && \
		docker volume prune -f && \
		docker-compose pull && \
		docker-compose build && \
		docker-compose up -d
		;;


    upbuild)
        echo "🚀 Запуск с пересборкой..."
        docker-compose up --build -d
        ;;

    build)
        echo "🔨 Пересборка образов..."
        docker-compose build
        ;;

    *)
        echo "❓ Использование: ./docker.sh {up|down|restart|a_restart|logs|stats|ps|exec|rebuild|upbuild|build}"
        exit 1
        ;;
esac
