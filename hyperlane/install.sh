#!/bin/bash

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

# Меню
    echo -e "${YELLOW}Выберите действие:${NC}"
    echo -e "${CYAN}1) Установка ноды${NC}"
    echo -e "${CYAN}2) Обновление ноды${NC}"
    echo -e "${CYAN}3) Просмотр логов${NC}"
    echo -e "${CYAN}4) Удаление ноды${NC}"

    echo -e "${YELLOW}Введите номер:${NC} "
    read choice

    case $choice in
        1)
            echo -e "${BLUE}Установка ноды Hyperlane...${NC}"
            
            # Проверка наличия Docker
            if ! command -v docker &> /dev/null; then
                echo -e "${YELLOW}Docker не установлен. Устанавливаем Docker...${NC}"
                sudo apt install docker.io -y
            else
                echo -e "${GREEN}Docker уже установлен. Пропускаем установку.${NC}"
            fi

            # Загрузка Docker образа
            docker pull --platform linux/amd64 gcr.io/abacus-labs-dev/hyperlane-agent:agents-v1.0.0

            # Ввод данных от пользователя
            echo -e "${YELLOW}Введите имя валидатора:${NC}"
            read NAME
            echo -e "${YELLOW}Введите приватный ключ от EVM кошелька начиная с 0x:${NC}"
            read PRIVATE_KEY

            # Создание директории
            mkdir -p /root/hyperlane_db_base && chmod -R 777 /root/hyperlane_db_base

            # Запуск Docker контейнера
            docker run -d -it \
            --name hyperlane \
            --mount type=bind,source=/root/hyperlane_db_base,target=/hyperlane_db_base \
            gcr.io/abacus-labs-dev/hyperlane-agent:agents-v1.0.0 \
            ./validator \
            --db /hyperlane_db_base \
            --originChainName base \
            --reorgPeriod 1 \
            --validator.id "$NAME" \
            --checkpointSyncer.type localStorage \
            --checkpointSyncer.folder base  \
            --checkpointSyncer.path /hyperlane_db_base/base_checkpoints \
            --validator.key "$PRIVATE_KEY" \
            --chains.base.signer.key "$PRIVATE_KEY" \
            --chains.base.customRpcUrls https://base.llamarpc.com

            # Заключительное сообщение
            echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
            echo -e "${YELLOW}Команда для проверки логов:${NC}"
            echo "docker logs --tail 100 -f hyperlane"
            echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
            ;;

        2)
            echo -e "${BLUE}Обновление ноды Hyperlane...${NC}"
            echo -e "${GREEN}Установлена актуальная версия ноды!${NC}"
            ;;

        3)
            echo -e "${BLUE}Просмотр логов...${NC}"
            docker logs --tail 100 -f hyperlane
            ;;

        4)
            echo -e "${BLUE}Удаление ноды Hyperlane...${NC}"

            # Остановка и удаление контейнера
            docker stop hyperlane
            docker rm hyperlane

            # Удаление папки
            if [ -d "/root/hyperlane_db_base" ]; then
                rm -rf /root/hyperlane_db_base
                echo -e "${GREEN}Директория ноды удалена.${NC}"
            else
                echo -e "${RED}Директория ноды не найдена.${NC}"
            fi

            echo -e "${GREEN}Нода Hyperlane успешно удалена!${NC}"

            # Завершающий вывод
            echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
            sleep 1
            ;;

        *)
            echo -e "${RED}Неверный выбор. Пожалуйста, введите номер от 1 до 4.${NC}"
            ;;
    esac
