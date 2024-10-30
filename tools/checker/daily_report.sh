#!/bin/bash
LOG_FILE="/root/checker/daily/$(date '+%d-%m-%Y')_daily_reports.log"

function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function logo {
  curl -s https://raw.githubusercontent.com/smilestar13/nodes/main/tools/logo/smilestar.sh | bash | tee -a $LOG_FILE
}

function line_1 {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}" | tee -a $LOG_FILE
}

function line_2 {
  echo -e "${RED}##############################################################################${NORMAL}" | tee -a $LOG_FILE
}

function start_work {
  echo "Запуск всех отчетов в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  cd /root/vprofile/node
}

function allora_worker { 
  echo "Запуск проверки allora_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory allora_checker.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "allora_checker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении allora_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function waku_worker { 
  echo "Запуск проверки waku_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory waku_peers.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "waku_peers.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении waku_peers.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function og_worker { 
  echo "Запуск проверки og_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory og_check_sync.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "og_checker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении og_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function dawn_worker { 
  echo "Запуск проверки dawn_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory dawn_checker.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "dawn_worker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении dawn_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function elixir_worker { 
  echo "Запуск проверки elixir_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory elixir_checker.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "elixir_worker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении elixir_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function rivalz_worker { 
  echo "Запуск проверки rivalz_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory rivalz_checker.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "rivalz_worker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении rivalz_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function hemi_worker { 
  echo "Запуск проверки hemi_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory hemi-checker.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "hemi_worker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении hemi_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function nesa_worker { 
  echo "Запуск проверки nesa_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory nesa_checker.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "nesa_worker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении nesa_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function nillion_worker { 
  echo "Запуск проверки nillion_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory nillion_checker.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "nillion_worker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении nillion_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function system_worker { 
  echo "Запуск проверки system_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory server-health.yml -f 1 >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "system_worker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении system_worker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function nesa_health { 
  echo "Запуск nesa_health.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory nesa_auto_restart.yml >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "nesa_health.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении nesa_health.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function end_work {
  echo "Период отчетов успешно окончен в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  cd /root/vprofile/node
}

colors
line_1
logo
line_2
start_work
line_2
allora_worker
line_1
waku_worker
line_1
og_worker
line_1
dawn_worker
line_1
elixir_worker
line_1
rivalz_worker
line_1
hemi_worker
line_1
nesa_worker
line_1
nillion_worker
line_1
system_worker
line_1
nesa_health
line_2
end_work
line_2
