#!/bin/bash
set -euo pipefail

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

# Проверка наличия curl и установка, если не установлен
if ! command -v curl &> /dev/null; then
    sudo apt update
    sudo apt install curl -y
fi
sleep 1

# Путь к проекту
PROJECT_DIR="$HOME/drosera"

# Переходим в папку проекта
cd "$PROJECT_DIR"

# Запрашиваем Discord-юзернейм
echo -e "${YELLOW}Введите ваш Discord-юзернейм:${NC}"
read DISCORD
export DISCORD

# Генерируем файл src/Trap.sol с подстановкой Discord-имени
cat > src/Trap.sol <<EOF
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IMockResponse {
    function isActive() external view returns (bool);
}

contract Trap is ITrap {
    address public constant RESPONSE_CONTRACT = 0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608;
    string constant DISCORD_NAME = "${DISCORD}";

    function collect() external view returns (bytes memory) {
        bool active = IMockResponse(RESPONSE_CONTRACT).isActive();
        bytes memory payload = abi.encode(active, DISCORD_NAME);
        return abi.encode(uint16(1), payload); // ABI-кортеж (uint16, bytes)
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        // take the latest block data from collect
        (bool active, string memory name) = abi.decode(data[0], (bool, string));
        // will not run if the contract is not active or the discord name is not set
        if (!active || bytes(name).length == 0) {
            return (false, bytes(""));
        }

        return (true, abi.encode(name));
    }
}
EOF

# Обновляем в drosera.toml нужные поля
sed -i 's|^path = .*|path = "out/Trap.sol/Trap.json"|' drosera.toml
sed -i 's|^response_contract = .*|response_contract = "0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608"|' drosera.toml
sed -i 's|^response_function = .*|response_function = "respondWithDiscordName(string)"|' drosera.toml
sed -i 's/^\[traps\..*\]/[traps.mytrap]/' drosera.toml

# Собираем контракт
echo -e "${BLUE}Чистим и собираем...${NC}"
forge clean && rm -rf out cache && forge build

# Запускаем пробный прогон
echo -e "${BLUE}Запускаем drosera dryrun...${NC}"
drosera dryrun

# Запрашиваем приватный ключ
echo -e "${YELLOW}Введите ваш приватный ключ от EVM-кошелька:${NC}"
read PRIV_KEY

# Экспортируем в переменную окружения
export DROSERA_PRIVATE_KEY="$PRIV_KEY"

# Применяем изменения
echo -e "${BLUE}Выполняем drosera apply...${NC}"
drosera apply

