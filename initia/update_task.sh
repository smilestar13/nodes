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

function update {
  cd && rm -rf initia
  git clone https://github.com/initia-labs/initia
  cd initia
  git checkout v0.2.15
  make install
}

function main {
    colors
    line
    logo
    line
    output "Welcome to the Initia update script"
    line
    install_tools
    line
    update
    line
    sudo systemctl restart initiad
    line
    output "From Smilestar with love ^_^"
}

main
