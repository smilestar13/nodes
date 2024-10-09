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

function tools {
  echo "Installing tools..."
  curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh | bash &>/dev/null
  curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/ufw.sh | bash &>/dev/null
  curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/go.sh | bash &>/dev/null
}

function node_setup {
  echo "Installing Hemi node"
  cd /root
  wget https://github.com/hemilabs/heminetwork/releases/download/v0.4.4/heminetwork_v0.4.4_linux_amd64.tar.gz
  tar -xvf heminetwork_v0.4.4_linux_amd64.tar.gz && rm heminetwork_v0.4.4_linux_amd64.tar.gz
  mv heminetwork_v0.4.4_linux_amd64 heminetwork
  rm -rf /root/heminetwork_v0.4.4_linux_amd64
}

function new_wallet {
  echo "Create new wallet for Hemi"
  cd /root/heminetwork
  ./keygen -secp256k1 -json -net="testnet" > /root/heminetwork/popm-address.json
  PRIVATE_KEY=$(cat /root/heminetwork/popm-address.json | jq ".private_key")
}

function start_mainer {
  echo "Mainer setup"
  sudo tee /etc/systemd/system/hemi.service > /dev/null <<EOF
[Unit]
Description=Hemi miner
After=network.target

[Service]
User=root
Environment="POPM_BTC_PRIVKEY=$PRIVATE_KEY"
Environment="POPM_STATIC_FEE=250"
Environment="POPM_BFG_URL=wss://testnet.rpc.hemi.network/v1/ws/public"
WorkingDirectory=/root/heminetwork
ExecStart=/root/heminetwork/popmd
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
  sudo systemctl enable hemi &>/dev/null
  sudo systemctl daemon-reload
  sudo systemctl start hemi

  sleep 15
}

colors
line_1
logo
line_2
tools
line_1
node_setup
line_1
new_wallet
line_2
start_mainer
line_2
