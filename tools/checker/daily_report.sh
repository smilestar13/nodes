#!/bin/bash
LOG_FILE="/root/checker/daily/$(date '+%d-%m-%Y')_daily_reports.log"

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

function start_work {
  echo "Запуск всех отчетов в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  cd /root/vprofile/node
}

function allora_worker { 
  echo "Запуск проверки allora_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory allora_checker.yml >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "allora_checker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении allora_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function waku_worker { 
  echo "Запуск проверки waku_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory waku_peers.yml >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "waku_peers.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении waku_peers.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}


function og_worker { 
  echo "Запуск проверки og_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory og_check_sync.yml >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "og_checker.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении og_checker.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
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
line_2
end_work
line_2
