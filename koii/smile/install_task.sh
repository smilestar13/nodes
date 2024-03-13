#!/bin/bash

function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function logo {
  curl -s https://raw.githubusercontent.com/smilestar13/nodes/main/tools/logo/smilestar.sh | bash
}

function line_1 {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}

function line_2 {
  echo -e "${RED}##############################################################################${NORMAL}"
}

function choose_language {
    echo "Choose your language / Оберіть вашу мову / Выберите ваш язык:"
    echo "1 - English"
    echo "2 - Українська"
    echo "3 - Русский"
    read LANG_CHOICE
    
    case $LANG_CHOICE in
        1)
            echo "You have selected English."
            LANGUAGE="EN"
            ;;
        2)
            echo "Ви обрали Українську."
            LANGUAGE="UA"
            ;;
        3)
            echo "Вы выбрали Русский."
            LANGUAGE="RU"
            ;;
        *)
            echo "Incorrect choice, defaulting to English."
            LANGUAGE="EN"
            ;;
    esac
}

function install_tools {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Updating system tools...${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Оновлення системних інструментів...${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Обновление системных инструментов...${NORMAL}"
            ;;
        *)
            # Default to English if language is not set or recognized
            echo -e "${GREEN}Updating system tools...${NORMAL}"
            ;;
    esac
    
    sudo apt update && sudo apt dist-upgrade -y
}

function install_npm {
  sudo npm install -g npm@10.5.0
}

function clone_repo {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Clone VPS-Task Repo from git...${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Клонування репозиторію VPS-Task з гіта...${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Клонирование репозитория VPS-Task с гита...${NORMAL}"
            ;;
        *)
            # Default message if language is not set or recognized
            echo -e "${GREEN}Clone VPS-Task Repo from git...${NORMAL}"
            ;;
    esac
    
    git clone https://github.com/koii-network/VPS-task
    cd VPS-task
}

function env {
  sudo tee <<EOF >/dev/null $HOME/VPS-task/.env-local
######################################################
################## DO NOT EDIT BELOW #################
######################################################
# Location of main wallet Do not change this, it mounts the ~/.config/koii:/app/config if you want to change, u>
WALLET_LOCATION="/app/config/id.json"
# Node Mode
NODE_MODE="service"
# The nodes address
SERVICE_URL="http://localhost:8080"
# Intial balance for the distribution wallet which will be used to hold the distribution list. 
INITIAL_DISTRIBUTION_WALLET_BALANCE= 2
# Global timers which track the round time, submission window and audit window and call those functions
GLOBAL_TIMERS="true"
# HAVE_STATIC_IP is flag to indicate you can run tasks that host APIs
# HAVE_STATIC_IP=true
# To be used when developing your tasks locally and don't want them to be whitelisted by koii team yet
RUN_NON_WHITELISTED_TASKS=true
# The address of the main trusted node
# TRUSTED_SERVICE_URL="https://k2-tasknet.koii.live"
######################################################
################ DO NOT EDIT ABOVE ###################
######################################################

# For the purpose of automating the staking wallet creation, the value must be greater 
# than the sum of all TASK_STAKES, the wallet will only be created and staking on task 
# will be done if it doesn't already exist
INITIAL_STAKING_WALLET_BALANCE=3

# environment
ENVIRONMENT="production"

# Location of K2 node
K2_NODE_URL="https://testnet.koii.live"

# Tasks to run and their stakes. This is the varaible you can add your Task ID to after
# registering with the crete-task-cli. This variable supports a comma separated list:
# TASKS="id1,id2,id3"
# TASK_STAKES="1,1,1
TASKS="4ipWnABntsvJPsAkwyMF7Re4z39ZUMs2S2dfEm5aa2is"
TASK_STAKES=2

# User can enter as many environment variables as they like below. These can be task
# specific variables that are needed for the task to perform it's job. Some examples:
WEB3_STORAGE_KEY=""
SCRAPING_URL=""
EOF
}

function install_cli {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Install Koii CLI...${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Встановлюємо Koii CLI...${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Устанавливаем Koii CLI...${NORMAL}"
            ;;
        *)
            echo -e "${GREEN}Install Koii CLI...${NORMAL}"
            ;;
    esac
  sh -c "$(curl -sSfL https://raw.githubusercontent.com/koii-network/k2-release/master/k2-install-init.sh)"
  export PATH="/root/.local/share/koii/install/active_release/bin:$PATH"
}

function generate_wallet {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Generate Koii wallet...${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Створюємо Koii гаманець...${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Создам Koii кошелек...${NORMAL}"
            ;;
        *)
            echo -e "${GREEN}Generate Koii wallet...${NORMAL}"
            ;;
    esac
    
  koii config set --url https://testnet.koii.live
  koii-keygen new -o /root/.config/koii/id.json --no-bip39-passphrase >> $HOME/koii_wallet.txt
}

function koii_addr {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Download the Finnie extension in your browser and import the wallet via the file ("/root/.config/koii/id.json"). Carefully check that your KOII address matches in your wallet:${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Завантажте розширення Finnie у вашому браузері та імпортуйте гаманець через файл ("/root/.config/koii/id.json"). Уважно перевірте щоб Ваша адреса KOII збігалася в гаманці:${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Скачайте расширении Finnie в вашем браузере и импортируйте кошелек через файл ("/root/.config/koii/id.json"). Внимательно проверьте чтобы Ваш адресс KOII совпадал в кошельке:${NORMAL}"
            ;;
        *)
            echo -e "${GREEN}Download the Finnie extension in your browser and import the wallet via the file ("/root/.config/koii/id.json"). Carefully check that your KOII address matches in your wallet:${NORMAL}"
            ;;
    esac
  koii address 
}

function stop_w8_coin {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Go to the faucet and complete tasks to get test coins for launch (minimum 4KOII)\n\t https://faucet.koii.network/ \n\t IMPORTANT: using the referral link “xxx” you will immediately receive 5KOII for free and without tasks!!!\nComplete all tasks on the tap and enter |koii| to continue the script.${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Переходимо в кран і виконуємо завдання щоб отримати тестові монети для запуску (мінімум 4KOII)\n\t https://faucet.koii.network/ \n\tВАЖЛИВО: за реферальним посиланням «ХХХ» ви відразу отримаєте 5KOII безкоштовно і без завдань!!! \nВиконайте всі завдання на крані та введіть |koii| продовження роботи скрипта.${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Переходим в кран и выполняем задания чтобы получить тестовые монеты для запуска (минимум 4KOII)\n\t https://faucet.koii.network/ \n\tВАЖНО: по реферальной ссылке «ххх» вы сразу получите 5KOII бесплатно и без заданий!!!\nВыполните все задания на кране и введите |koii| для продолжения работы скрипта.${NORMAL}"
            ;;
        *)
            echo -e "${GREEN}Go to the faucet and complete tasks to get test coins for launch (minimum 4KOII)\n\t https://faucet.koii.network/ \n\t IMPORTANT: using the referral link “xxx” you will immediately receive 5KOII for free and without tasks!!!\nComplete all tasks on the tap and enter |koii| to continue the script.${NORMAL}"
            ;;
    esac
  
    while true; do
    read input
    if [ "$input" = "koii" ]; then
            case $LANGUAGE in
                EN)
                    echo "Continuing script execution..."
                    ;;
                UA)
                    echo "Продовжуємо виконання скрипта..."
                    ;;
                RU)
                    echo "Продолжаем выполнение скрипта..."
                    ;;
                *)
                    echo "Continuing script execution..."
                    ;;
            esac
        break
    else
            case $LANGUAGE in
                EN)
                    echo "Incorrect input. Please, enter 'koii' to continue..."
                    ;;
                UA)
                    echo "Невірний ввід. Будь ласка, введіть 'koii' для продовження..."
                    ;;
                RU)
                    echo "Неверный ввод. Пожалуйста, введите 'koii' для продолжения..."
                    ;;
                *)
                    echo "Incorrect input. Please, enter 'koii' to continue..."
                    ;;
            esac
        fi
done
}

function install_docker {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Installing Docker...${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Встановлення Docker...${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Установка Docker...${NORMAL}"
            ;;
        *)
            echo -e "${GREEN}Installing Docker...${NORMAL}"
            ;;
    esac
    sudo apt install docker
}

function install_docker_compose {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Installing Docker Compose...${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Встановлення Docker Compose...${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Установка Docker Compose...${NORMAL}"
            ;;
        *)
            echo -e "${GREEN}Installing Docker Compose...${NORMAL}"
            ;;
    esac
    sudo apt install docker-compose
}

function update_docker_compose {
  CURRENT_VERSION=$(docker-compose --version | grep -o '[0-9]*\.[0-9]*\.[0-9]*')
  REQUIRED_VERSION="1.29"

  if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$CURRENT_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    case $LANGUAGE in
      EN)
        echo "Docker Compose needs to be updated to version $REQUIRED_VERSION or higher. Current version: $CURRENT_VERSION."
        ;;
      UA)
        echo "Потрібне оновлення Docker Compose до версії $REQUIRED_VERSION або вище. Поточна версія: $CURRENT_VERSION."
        ;;
      RU)
        echo "Требуется обновление Docker Compose до версии $REQUIRED_VERSION или выше. Текущая версия: $CURRENT_VERSION."
        ;;
      *)
        echo "Docker Compose needs to be updated to version $REQUIRED_VERSION or higher. Current version: $CURRENT_VERSION."
        ;;
    esac

    DOCKER_COMPOSE_PATH=$(which docker-compose)

    case $LANGUAGE in
      EN)
        echo "Updating Docker Compose..."
        ;;
      UA)
        echo "Оновлюємо Docker Compose..."
        ;;
      RU)
        echo "Обновляем Docker Compose..."
        ;;
      *)
        echo "Updating Docker Compose..."
        ;;
    esac

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o $DOCKER_COMPOSE_PATH
    
    sudo chmod +x $DOCKER_COMPOSE_PATH
    
    NEW_VERSION=$(docker-compose --version | grep -o '[0-9]*\.[0-9]*\.[0-9]*')

    case $LANGUAGE in
      EN)
        echo "Docker Compose has been updated to version $NEW_VERSION."
        ;;
      UA)
        echo "Docker Compose оновлено до версії $NEW_VERSION."
        ;;
      RU)
        echo "Docker Compose обновлен до версии $NEW_VERSION."
        ;;
      *)
        echo "Docker Compose has been updated to version $NEW_VERSION."
        ;;
    esac
  else
    case $LANGUAGE in
      EN)
        echo "The current version of Docker Compose $CURRENT_VERSION meets the requirements."
        ;;
      UA)
        echo "Поточна версія Docker Compose $CURRENT_VERSION відповідає вимогам."
        ;;
      RU)
        echo "Текущая версия Docker Compose $CURRENT_VERSION удовлетворяет требованиям."
        ;;
      *)
        echo "The current version of Docker Compose $CURRENT_VERSION meets the requirements."
        ;;
    esac
  fi
}

function docker_compose_up {
    case $LANGUAGE in
        EN)
            echo -e "${GREEN}Starting Docker Compose...${NORMAL}"
            ;;
        RU)
            echo -e "${GREEN}Запускаем Docker Compose...${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Запускаємо Docker Compose...${NORMAL}"
            ;;
        *)
            echo -e "${GREEN}Starting Docker Compose...${NORMAL}"
            ;;
    esac

    docker-compose -f $HOME/VPS-task/docker-compose.yaml up -d
}

function echo_info {
    case $LANGUAGE in
        RU)
            echo -e "${GREEN}Для остановки ноды koii_task: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml down \n ${NORMAL}"
            echo -e "${GREEN}Для запуска ноды koii_task: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml up -d \n ${NORMAL}"
            echo -e "${GREEN}Для перезагрузки ноды koii_task: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml restart \n ${NORMAL}"
            echo -e "${GREEN}Для проверки логов ноды выполняем команду: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml logs -f --tail=100 \n ${NORMAL}"
            ;;
        UA)
            echo -e "${GREEN}Для зупинки вузла koii_task: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml down \n ${NORMAL}"
            echo -e "${GREEN}Для запуску вузла koii_task: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml up -d \n ${NORMAL}"
            echo -e "${GREEN}Для перезавантаження вузла koii_task: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml restart \n ${NORMAL}"
            echo -e "${GREEN}Для перевірки логів вузла виконуємо команду: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml logs -f --tail=100 \n ${NORMAL}"
            ;;
        *)
            echo -e "${GREEN}To stop the koii_task node: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml down \n ${NORMAL}"
            echo -e "${GREEN}To start the koii_task node: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml up -d \n ${NORMAL}"
            echo -e "${GREEN}To restart the koii_task node: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml restart \n ${NORMAL}"
            echo -e "${GREEN}To check the logs of the node, execute the command: ${NORMAL}"
            echo -e "${RED}   docker-compose -f $HOME/VPS-task/docker-compose.yaml logs -f --tail=100 \n ${NORMAL}"
            ;;
    esac
}

colors
line_1
logo
line_2
install_tools
install_node_npm
line_1
clone_repo
env
line_1
install_cli
generate_wallet
line_2
koii_addr
line_2
stop_w8_coin
line_1
install_docker
install_docker_compose
line_1
update_docker_compose
line_1
docker_compose_up
line_2
echo_info
line_2
