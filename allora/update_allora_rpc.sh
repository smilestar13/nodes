#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/smilestar13/nodes/main/tools/logo/smilestar.sh | bash
echo "-----------------------------------------------------------------------------"

echo "-----------------------------------------------------------------------------"
echo "Обновление Allora RPC"
echo "-----------------------------------------------------------------------------"

cd basic-coin-prediction-node
docker compose down -v

sudo sed -i "s|sentries|allora|" $HOME/basic-coin-prediction-node/model.py

sudo chmod +x init.config
sudo ./init.config

docker compose up -d

echo "-----------------------------------------------------------------------------"
echo "Wish lifechange case with SmileStar"
echo "-----------------------------------------------------------------------------"
