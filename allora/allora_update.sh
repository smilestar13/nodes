#!/bin/bash

echo "-----------------------------------------------------------------------------"
sudo curl -s https://raw.githubusercontent.com/smilestar13/nodes/main/tools/logo/smilestar.sh | bash
echo "-----------------------------------------------------------------------------"

sudo curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh | bash &>/dev/null
sudo curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/ufw.sh | bash &>/dev/null
sudo curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh | bash &>/dev/null
sudo curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/go.sh | bash &>/dev/null

echo "-----------------------------------------------------------------------------"
echo "Обновление Allora CLI"
echo "-----------------------------------------------------------------------------"

source .profile

cd basic-coin-prediction-node
sudo docker compose down -v
cd $HOME
sudo rm -rf allora-chain/ basic-coin-prediction-node/

cd $HOME && sudo git clone https://github.com/allora-network/allora-chain.git
cd allora-chain && sudo make all
cd $HOME && source .profile
sudo allorad version

echo "-----------------------------------------------------------------------------"
echo "Восстановление кошелька Allora"
echo "-----------------------------------------------------------------------------"

sudo allorad keys add testkey --recover

echo "-----------------------------------------------------------------------------"
echo "Установка воркера Allora"
echo "-----------------------------------------------------------------------------"

echo "Введите сид фразу от кошелька, который будет использоваться для воркера"
read WALLET_SEED_PHRASE

cd $HOME
sudo git clone https://github.com/allora-network/basic-coin-prediction-node
cd basic-coin-prediction-node
sudo rm -rf config.json

sudo wget https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/allora/config.json
sudo sed -i "s|SeedPhrase|$WALLET_SEED_PHRASE|" $HOME/basic-coin-prediction-node/config.json

sudo chmod +x init.config
sudo ./init.config

sudo sed -i "s|8000:8000|18000:8000|" $HOME/basic-coin-prediction-node/docker-compose.yml
sudo sed -i "s|intervals = [\"1d\"]|intervals = [\"10m\", \"20m\", \"1h\", \"1d\"]|" $HOME/basic-coin-prediction-node/model.py

sudo docker compose up -d --build

echo "-----------------------------------------------------------------------------"
echo "Wish lifechange case with SmileStar"
echo "-----------------------------------------------------------------------------"
