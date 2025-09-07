#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

read -p "Enter your URL RPC Sepolia: " RPC
read -p "Enter your URL Beacon Sepolia: " CONSENSUS
read -p "Enter your private key (0x…): " PRIVATE_KEY
read -p "Enter your EVM address (0x…): " WALLET

echo -e "${BLUE}Installing dependencies...${NC}"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip -y

if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  sudo usermod -aG docker $USER
  rm get-docker.sh
fi

sudo groupadd -f docker
sudo usermod -aG docker $USER

if [ -S /var/run/docker.sock ]; then
  sudo chmod 666 /var/run/docker.sock
else
  sudo systemctl start docker
  sudo chmod 666 /var/run/docker.sock
fi

sudo iptables -I INPUT -p tcp --dport 40400 -j ACCEPT
sudo iptables -I INPUT -p udp --dport 40400 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables/rules.v4"

mkdir -p "$HOME/aztec-sequencer/node"
cd "$HOME/aztec-sequencer"

docker pull aztecprotocol/aztec:1.2.1

SERVER_IP=$(curl -s https://api.ipify.org)

cat > .evm <<EOF
ETHEREUM_HOSTS=$RPC
L1_CONSENSUS_HOST_URLS=$CONSENSUS
VALIDATOR_PRIVATE_KEY=$PRIVATE_KEY
P2P_IP=$SERVER_IP
WALLET=$WALLET
GOVERNANCE_PROPOSER_PAYLOAD_ADDRESS=0x54F7fe24E349993b363A5Fa1bccdAe2589D5E5Ef
EOF

# -------------------------------
# Добавляем L2 snapshot
# -------------------------------
SNAPSHOT_URL="https://files5.blacknodes.net/aztec/aztec-alpha-testnet.tar.lz4"
echo -e "${BLUE}Downloading L2 snapshot...${NC}"
wget -q $SNAPSHOT_URL -O aztec-alpha-testnet.tar.lz4

echo -e "${BLUE}Extracting L2 snapshot...${NC}"
lz4 -d aztec-alpha-testnet.tar.lz4 | tar -xf - -C node
rm aztec-alpha-testnet.tar.lz4

# -------------------------------
# Запуск контейнера
# -------------------------------
if [ -n "$1" ]; then
  PORT="$1"
  sudo iptables -I INPUT -p tcp --dport $PORT -j ACCEPT

  docker run -d \
    --name aztec-sequencer \
    --restart unless-stopped \
    --network host \
    --entrypoint /bin/sh \
    --env-file "$HOME/aztec-sequencer/.evm" \
    -e DATA_DIRECTORY=/data \
    -e LOG_LEVEL=debug \
    -v "$HOME/aztec-sequencer/node":/data \
    aztecprotocol/aztec:1.2.1 \
    -c "node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js \
     start --network alpha-testnet --node --archiver --sequencer --port $PORT"
else
  docker run -d \
    --name aztec-sequencer \
    --restart unless-stopped \
    --network host \
    --entrypoint /bin/sh \
    --env-file "$HOME/aztec-sequencer/.evm" \
    -e DATA_DIRECTORY=/data \
    -e LOG_LEVEL=debug \
    -v "$HOME/aztec-sequencer/node":/data \
    aztecprotocol/aztec:1.2.1 \
    -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js \
      start --network alpha-testnet --node --archiver --sequencer'
fi

cd ~

echo -e "${PURPLE}-------------------------------------------------------------${NC}"
echo "docker logs --tail 100 -f aztec-sequencer"
echo -e "${PURPLE}-------------------------------------------------------------${NC}"
