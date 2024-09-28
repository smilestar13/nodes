#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nillion/install.sh)

function colors {
  GREEN="\e[32m"
  YELLOW="\e[33m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function install_docker {
    if ! type "docker" > /dev/null; then
        echo -e "${YELLOW}Устанавливаем докер${NORMAL}"
        bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
    else
        echo -e "${YELLOW}Докер уже установлен. Переходим на следующий шаг${NORMAL}"
    fi
}

# Обновление системы и установка необходимых пакетов
sudo apt update 
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Установка Docker
install_docker
docker --version

# Загрузка образа докера Nillion
docker pull nillion/verifier:v1.0.1

# Создание каталога для Nillion под root
mkdir -p /root/nillion/verifier

# Инициализация Nillion Verifier
docker run -v /root/nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise

# Создание бэкапов в директории /root
mkdir -p /root/nillion_backups
cp /root/nillion/verifier/credentials.json /root/nillion_backups/credentials.json
cat /root/nillion_backups/credentials.json

# Запуск Docker контейнера с использованием /root в качестве домашней директории
docker run -d --name nillion -v /root/nillion/accuser:/var/tmp nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"

# Копирование и перезапуск Docker-контейнера
docker cp /root/nillion/verifier/credentials.json nillion:/var/tmp/credentials.json
docker restart nillion
