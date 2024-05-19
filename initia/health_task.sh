#!/bin/bash

function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function logo {
  curl -s https://raw.githubusercontent.com/smilestar13/nodes/main/tools/logo/smilestar.sh | bash
}

function line {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}

function output {
  echo -e "${YELLOW}$1${NORMAL}"
}

function install_tools {
  sudo apt update
  sudo apt install -y tmux
}

function index_off {
  sed -i "s/indexer = \"kv\"/indexer = \"null\"/" /root/.initia/config/config.toml
}

function snap {
  systemctl stop initia && curl -L https://snapshots.polkachu.com/testnet-snapshots/initia/initia_202803.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia && systemctl start initia
}

function main {
    colors
    line
    logo
    line
    output "Welcome to the Initia health script"
    line
    install_tools
    line
    snap
    line
    line
    index_off
    line
    output "From Smilestar with love ^_^"
}

main
